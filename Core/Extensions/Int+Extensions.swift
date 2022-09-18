public extension Int {
    
    private func urlString(for lbNumber: Int) -> String {
         let formatter = NumberFormatter()
         formatter.minimumIntegerDigits = 5
         formatter.maximumIntegerDigits = 5
         let number = NSNumber(value: lbNumber)
         let formatted = formatter.string(from: number)!
         return "LB-\(formatted)"
     }
     
    func lbURL() -> URL {
         let url = URL(string: "http://losslessbob.wonderingwhattochoose.com/detail/\(urlString(for: self)).html")!
         return url
     }
    
}
