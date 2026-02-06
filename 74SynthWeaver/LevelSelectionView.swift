import SwiftUI
import Combine

struct LevelSelectionView: View {
    @ObservedObject var levelManager: LevelManager
    let onSelectLevel: (Int) -> Void
    let onBack: () -> Void
    
    let columns = [
        GridItem(.adaptive(minimum: 70), spacing: 20)
    ]
    
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
                Text("SELECT LEVEL")
                    .font(.system(size: 24, weight: .bold, design: .monospaced))
                    .foregroundColor(.sunFiber)
                Spacer()
                Color.clear.frame(width: 40, height: 40)
            }
            .padding()
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 25) {
                    ForEach(1...levelManager.totalLevels, id: \.self) { level in
                        LevelButton(
                            level: level,
                            isUnlocked: levelManager.isLevelUnlocked(level),
                            action: {
                                if levelManager.isLevelUnlocked(level) {
                                    onSelectLevel(level)
                                }
                            }
                        )
                    }
                }
                .padding(30)
            }
            
            Spacer()
        }
        .background(Color.synthBackground.ignoresSafeArea())
    }
}

struct LevelButton: View {
    let level: Int
    let isUnlocked: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isUnlocked ? Color.auraFiber.opacity(0.2) : Color.black.opacity(0.4))
                    .frame(width: 70, height: 70)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isUnlocked ? Color.sunFiber.opacity(0.5) : Color.white.opacity(0.1), lineWidth: 2)
                    )
                
                if isUnlocked {
                    Text("\(level)")
                        .font(.system(size: 24, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                } else {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white.opacity(0.2))
                }
            }
        }
        .disabled(!isUnlocked)
    }
}
