import ComposableArchitecture
import SwiftUI
import UI
import Core

public struct DonationView: View {
    
    private let store: Store<PaymentsState, PaymentsFeatureAction>

    public init(store: Store<PaymentsState, PaymentsFeatureAction>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                HStack {
                    Spacer()
                    Text("donate_plea")
                    Spacer()
                }
                .padding()
                Spacer()
                HStack(spacing: 12) {
                    ForEach(viewStore.products) { product in
                        VStack {
                            Text(product.displayName)
                                .font(.system(size: 12, weight: .semibold, design: .serif))
                            OnTapButton(text: product.displayPrice) {
                                viewStore.send(.payments(.purchase(product, .donation)))
                            }
                            .buttonStyle(BuyButtonStyle())
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
     
                Spacer()
                if viewStore.amountDonated != 0, let amount = totalAmount(viewStore.amountDonated) {
                    let emoji = viewStore.amountDonated.emoji
                    Text(tr("donate_thanks", emoji, amount, emoji))
                        .padding()
                }
            }
            .font(.caption)
        }
    }
                         
    private func totalAmount(_ amount: Double) -> String? {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: amount))
    }
}

private extension Double {
    var emoji: String {
        if self > 100 {
            return "👑"
        } else if self > 60 {
            return "💫"
        } else if self > 40 {
            return "⚡️"
        } else if self > 20 {
            return "🏅"
        } else if self > 10 {
            return "😍"
        } else {
            return "👏"
        }
    }
}

struct BuyButtonStyle: SwiftUI.ButtonStyle {

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(width: 50)
            .padding(10)
            .opacity(configuration.isPressed ? 0.7 : 1)
            .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(.primary, lineWidth: 2))
            .contentShape(RoundedRectangle(cornerRadius: 8))
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}
