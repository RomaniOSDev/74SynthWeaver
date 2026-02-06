import SwiftUI

struct OnboardingStep {
    let title: String
    let description: String
    let icon: String
    let color: Color
}

struct OnboardingView: View {
    @State private var currentStep = 0
    let onFinish: () -> Void
    
    let steps = [
        OnboardingStep(
            title: "WEAVE THE LIGHT",
            description: "Connect Solar Hearts to Aura Receivers to create energetic threads.",
            icon: "sparkles",
            color: .sunFiber
        ),
        OnboardingStep(
            title: "BALANCE THE GRID",
            description: "Each receiver has a specific capacity. Fill them all to stabilize the system.",
            icon: "circle.grid.2x2.fill",
            color: .auraFiber
        ),
        OnboardingStep(
            title: "ARCHIVE MASTERY",
            description: "Save your unique patterns to the gallery and unlock system achievements.",
            icon: "archivebox.fill",
            color: .white
        )
    ]
    
    var body: some View {
        ZStack {
            Color.synthBackground.ignoresSafeArea()
            
            VStack(spacing: 40) {
                HStack {
                    Spacer()
                    Button("SKIP") {
                        onFinish()
                    }
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundColor(.white.opacity(0.4))
                }
                .padding()
                
                TabView(selection: $currentStep) {
                    ForEach(0..<steps.count, id: \.self) { index in
                        VStack(spacing: 30) {
                            ZStack {
                                Circle()
                                    .fill(steps[index].color.opacity(0.1))
                                    .frame(width: 200, height: 200)
                                
                                Image(systemName: steps[index].icon)
                                    .font(.system(size: 80))
                                    .foregroundColor(steps[index].color)
                                    .shadow(color: steps[index].color.opacity(0.5), radius: 20)
                            }
                            
                            VStack(spacing: 15) {
                                Text(steps[index].title)
                                    .font(.system(size: 28, weight: .bold, design: .monospaced))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                
                                Text(steps[index].description)
                                    .font(.system(size: 16, weight: .light, design: .monospaced))
                                    .foregroundColor(.white.opacity(0.7))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                            }
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // Indicators
                HStack(spacing: 8) {
                    ForEach(0..<steps.count, id: \.self) { index in
                        Capsule()
                            .fill(currentStep == index ? Color.sunFiber : Color.white.opacity(0.2))
                            .frame(width: currentStep == index ? 24 : 8, height: 8)
                            .animation(.spring(), value: currentStep)
                    }
                }
                
                Button(action: {
                    if currentStep < steps.count - 1 {
                        withAnimation {
                            currentStep += 1
                        }
                    } else {
                        onFinish()
                    }
                }) {
                    Text(currentStep == steps.count - 1 ? "BEGIN" : "NEXT")
                        .font(.system(size: 18, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 2)
                                .stroke(steps[currentStep].color, lineWidth: 2)
                                .background(steps[currentStep].color.opacity(0.1))
                        )
                        .padding(.horizontal, 40)
                }
                .padding(.bottom, 40)
            }
        }
    }
}
