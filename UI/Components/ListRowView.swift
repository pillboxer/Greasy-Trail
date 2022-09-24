import SwiftUI

public struct ListRowView: View {
    
    let headline: String
    var subheadline: String?
    private let buttons: [ListRowButton]?
    let onTap: (() -> Void)?
    let buttonTap: ((ListRowButton) -> Void)?
    
    public init(headline: String,
                subheadline: String? = nil,
                buttons: [ListRowButton]? = nil,
                onTap: (() -> Void)? = nil,
                buttonTap: ((ListRowButton) -> Void)? = nil) {
        self.headline = headline
        self.subheadline = subheadline
        self.buttons = buttons
        self.onTap = onTap
        self.buttonTap = buttonTap
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(headline).font(.headline)
                if let onTap = onTap {
                    PlainOnTapButton(systemImage: "arrow.forward.circle", onTap: onTap)
                }
            }
            if let subHeadline = subheadline {
                HStack(spacing: 8) {
                    Text(subHeadline).font(.subheadline)
                    if let buttons = buttons {
                        ForEach(buttons, id: \.self) { button in
                            PlainOnTapButton(systemImage: button.rawValue) {
                                buttonTap?(button)
                            }
                            
                        }
                    }
                }
            }
        }
    }
}

public enum ListRowButton: String {
    case speaker
    case globe
}
