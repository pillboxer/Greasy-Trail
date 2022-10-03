import GTCloudKit
import StoreKit
import Model
import Core

public enum PaymentsFeatureAction {
    case payments(PaymentsAction)
    case cloudKit(CloudKitAction)
}

public enum PaymentsAction {
    case fetchIAPs
    case start
    case completeIAPFetch([Product])
    case purchase(Product, PurchaseType)
    case persistPurchase(Product, PurchaseType)
    case throwPaymentError(GTError)
}
