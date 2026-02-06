import SwiftUI
import StoreKit

struct SettingsView: View {
    let onBack: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold))
                        .padding(10)
                }
                Spacer()
                Text("SETTINGS")
                    .font(.system(size: 24, weight: .bold, design: .monospaced))
                    .foregroundColor(.sunFiber)
                Spacer()
                Color.clear.frame(width: 40, height: 40)
            }
            .padding()
            
            VStack(spacing: 20) {
                SettingsButton(title: "RATE US", icon: "star.fill") {
                    rateApp()
                }
                
                SettingsButton(title: "PRIVACY POLICY", icon: "shield.fill") {
                    openURL("https://www.termsfeed.com/live/061414f9-b831-4574-9b21-32ae43d50e9c")
                }
                
                SettingsButton(title: "TERMS OF USE", icon: "doc.text.fill") {
                    openURL("https://www.termsfeed.com/live/ad5f15d0-229f-4ec3-9f0c-67d4f1f2f2a5")
                }
                
                Spacer()
                
                Text("VERSION 1.0.0")
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.bottom, 20)
            }
            .padding(20)
        }
        .background(Color.synthBackground.ignoresSafeArea())
    }
    
    private func rateApp() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.sunFiber)
                    .frame(width: 30)
                
                Text(title)
                    .font(.system(size: 16, weight: .medium, design: .monospaced))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.3))
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 20)
            .background(Color.white.opacity(0.05))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
        }
    }
}
