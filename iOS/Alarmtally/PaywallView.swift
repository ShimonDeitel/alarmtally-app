import SwiftUI

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var purchases: PurchaseManager
    @EnvironmentObject var store: AlarmtallyStore

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                VStack(spacing: 20) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 50))
                        .foregroundStyle(Theme.accent)
                    Text("Alarmtally Pro")
                        .font(Theme.titleFont)
                        .foregroundStyle(Theme.textPrimary)
                    Text("Weekly snooze trend and streak-free-morning badges")
                        .font(Theme.bodyFont)
                        .foregroundStyle(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                    Text("You've reached the free limit of \(AlarmtallyStore.freeLimit) entries.")
                        .font(Theme.captionFont)
                        .foregroundStyle(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)

                    if let product = purchases.product {
                        Button {
                            Task {
                                await purchases.purchase()
                                if purchases.isPro { store.isPro = true; dismiss() }
                            }
                        } label: {
                            Text("Unlock — \(product.displayPrice)")
                                .font(Theme.headlineFont)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Theme.accent)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: Theme.cardCornerRadius))
                        }
                        .accessibilityIdentifier("purchaseButton")
                        .padding(.horizontal, 30)
                    } else {
                        ProgressView()
                    }

                    Button("Restore Purchases") {
                        Task {
                            await purchases.restore()
                            if purchases.isPro { store.isPro = true; dismiss() }
                        }
                    }
                    .accessibilityIdentifier("paywallRestoreButton")
                    .foregroundStyle(Theme.textSecondary)
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                        .accessibilityIdentifier("paywallCloseButton")
                }
            }
        }
    }
}
