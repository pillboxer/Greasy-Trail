// DO NOT REORDER
public enum PurchaseType: Int {
    case donation
}

public struct PurchaseUploadModel {
    
    public let type: PurchaseType
    public let amount: Double
    
    public init(type: PurchaseType, amount: Double) {
        self.type = type
        self.amount = amount
    }
    
}
