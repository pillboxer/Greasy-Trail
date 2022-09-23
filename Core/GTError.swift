public struct GTError: Error, Equatable {
    public let error: NSError
    
    public init(_ error: Error) {
        self.error = error as NSError
    }
}
