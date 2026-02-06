import SwiftUI

struct ArchiveView: View {
    @ObservedObject var achievementManager: AchievementManager
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
                Text("ARCHIVE")
                    .font(.system(size: 24, weight: .bold, design: .monospaced))
                    .foregroundColor(.sunFiber)
                Spacer()
                Color.clear.frame(width: 40, height: 40)
            }
            .padding()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Stats Summary
                    HStack(spacing: 20) {
                        StatBox(title: "UNLOCKED", value: "\(achievementManager.achievements.filter { $0.isUnlocked }.count)/\(achievementManager.achievements.count)")
                        StatBox(title: "MASTERY", value: "\(Int((Double(achievementManager.achievements.filter { $0.isUnlocked }.count) / Double(achievementManager.achievements.count)) * 100))%")
                    }
                    .padding(.horizontal)
                    
                    Text("SYSTEM ACHIEVEMENTS")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(.auraFiber)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 10)
                    
                    ForEach(achievementManager.achievements) { achievement in
                        AchievementRow(achievement: achievement)
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .background(Color.synthBackground.ignoresSafeArea())
    }
}

struct StatBox: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: 10, weight: .light, design: .monospaced))
                .foregroundColor(.white.opacity(0.6))
            Text(value)
                .font(.system(size: 24, weight: .bold, design: .monospaced))
                .foregroundColor(.sunFiber)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
        .background(Color.white.opacity(0.05))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.sunFiber.opacity(0.2), lineWidth: 1)
        )
    }
}

struct AchievementRow: View {
    let achievement: Achievement
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? Color.auraFiber.opacity(0.2) : Color.black.opacity(0.3))
                    .frame(width: 50, height: 50)
                
                Image(systemName: achievement.iconName)
                    .font(.system(size: 20))
                    .foregroundColor(achievement.isUnlocked ? .sunFiber : .white.opacity(0.2))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .foregroundColor(achievement.isUnlocked ? .white : .white.opacity(0.4))
                
                Text(achievement.description)
                    .font(.system(size: 12, weight: .light, design: .monospaced))
                    .foregroundColor(.white.opacity(0.5))
                
                if !achievement.isUnlocked && achievement.progress > 0 {
                    ProgressView(value: achievement.progress)
                        .accentColor(.auraFiber)
                        .scaleEffect(x: 1, y: 0.5, anchor: .center)
                }
            }
            
            Spacer()
            
            if achievement.isUnlocked {
                Image(systemName: "checkmark.shield.fill")
                    .foregroundColor(.sunFiber)
                    .font(.system(size: 20))
            }
        }
        .padding()
        .background(Color.white.opacity(achievement.isUnlocked ? 0.08 : 0.03))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
