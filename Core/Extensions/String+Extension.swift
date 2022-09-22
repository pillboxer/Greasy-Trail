import Foundation

public extension String {
    
    static let invalid = "INVALID UUID"
    static let subsystem = "com.Dylan"

    init(formatted: String, args: CVarArg...) {
        self.init(format: NSLocalizedString(formatted, comment: ""), args)
    }
    
}
