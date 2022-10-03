import ComposableArchitecture
import GTCloudKit
import Core
import StoreKit

public let paymentsFeatureReducer: Reducer<PaymentsState, PaymentsFeatureAction, CloudKitEnvironment> =
Reducer.combine(
    paymentsReducer.pullback(
        state: \.self,
        action: /.self,
        environment: { _ in () }),
    cloudKitReducer.pullback(
        state: \.cloudKit,
        action: /PaymentsFeatureAction.cloudKit,
        environment: { $0 })
)

public let paymentsReducer = Reducer<PaymentsState, PaymentsFeatureAction, Void> { state, action, _ in
    switch action {
    case .payments(let paymentsAction):
        switch paymentsAction {
        case .throwPaymentError(let error):
            state.cloudKit.mode = .operationFailed(error)
        case .start:
            return .run(operation: { send in
                await send(.payments(.fetchIAPs))
                for await result in Transaction.updates {
                    let transaction = try verify(result)
                    await transaction.finish()
                }
            }, catch: { error, send in
                await send(.payments(.throwPaymentError(GTError.init(error))))
            })
        case .fetchIAPs:
            return .run(operation: { send in
                let products = try await Product.products(for: Set(InAppPurchase.allCases.map { $0.rawValue }))
                logger.log("Fetched \(products.count, privacy: .public) products for sale")
                await send(.payments(.completeIAPFetch(products.sorted { $0.price <  $1.price })))
            }, catch: { error, _ in
                let errorString = String(describing: error)
                logger.log("Could not fetch in app purchases. Error: \(errorString, privacy: .public)")
            })
        case .completeIAPFetch(let products):
            state.products = products
        case .purchase(let product, let type):
            return .run(operation: { send in
                let result = try await product.purchase()
                switch result {
                case .success(let verification):
                    let transaction = try verify(verification)
                    await send(.cloudKit(.uploadPurchase(product, type)))
                    await transaction.finish()
                case .pending:
                    logger.log("Transaction pending...")
                case .userCancelled:
                    logger.log("Transaction cancelled :(")
                @unknown default:
                    logger.log("Transaction received unknown case")
                }
            }, catch: { error, send in
                let errorString = String(describing: error)
                logger.log("Could not complete app purchases. Error: \(errorString, privacy: .public)")
                if let error = error as? StoreKitError {
                    switch error {
                    case .userCancelled:
                        return
                    default:
                        break
                    }
                }
                await send(.payments(.throwPaymentError(.init(error))))
                
            })
        case .persistPurchase(let product, let type):
            return Effect(value: .cloudKit(.uploadPurchase(product, type)))
        }
    default:
        // CloudKit reducer handles these.
        break
    }
    return .none
}
    
private func verify(_ result: VerificationResult<StoreKit.Transaction>) throws -> StoreKit.Transaction {
    switch result {
    case .unverified:
        logger.log(level: .error, "Received an unverified transaction")
        throw PaymentError.unverifiedError
    case .verified(let safe):
        logger.log("Received a verified transaction. Finishing")
        return safe
    }
}
