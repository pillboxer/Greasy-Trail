import SwiftUI
import UI
import Core

public struct MissingLBsView: View {
    
    private let lbNumbers: [Int]
    
    public init(lbNumbers: [Int]) {
        self.lbNumbers = lbNumbers
    }
    
    public var body: some View {
        List(lbNumbers, id: \.self) { lb in
            OnTapButton(text: "LB-\(String(lb))") {
                NSWorkspace.shared.open(lb.lbURL())
            }
            .buttonStyle(.link)
        }
    }
}
