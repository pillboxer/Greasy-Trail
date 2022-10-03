import StoreKit
import GTCloudKit
import os

enum PaymentError: Error {
    case unverifiedError
}

let logger = Logger(subsystem: .subsystem, category: "Payments")

enum InAppPurchase: String, CaseIterable {
    case tipSmall = "com.sixeye.Dylan.smallTip"
    case tipMedium = "com.sixeye.Dylan.mediumTip"
    case tipLarge = "com.sixeye.Dylan.largeTip"
    case tipExtraLarge = "com.sixeye.Dylan.extraLargeTip"
}

public struct PaymentsState: Equatable {
    public var products: [Product]
    public var cloudKit: CloudKitState
    public var amountDonated: Double
    
    public init(products: [Product], cloudKit: CloudKitState, amountDonated: Double) {
        self.products = products
        self.cloudKit = cloudKit
        self.amountDonated = amountDonated
    }
}
