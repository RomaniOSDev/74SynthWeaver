import SwiftUI
import Combine

struct Achievement: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let iconName: String
    var isUnlocked: Bool
    var progress: Double // 0.0 to 1.0
}

class AchievementManager: ObservableObject {
    @Published var achievements: [Achievement] = []
    private let saveKey = "SynthWeaver_Achievements"
    
    init() {
        setupInitialAchievements()
        loadAchievements()
    }
    
    private func setupInitialAchievements() {
        achievements = [
            Achievement(id: "first_weave", title: "FIRST THREAD", description: "Complete your first level", iconName: "sparkles", isUnlocked: false, progress: 0),
            Achievement(id: "symmetry_master", title: "SYMMETRY MASTER", description: "Complete level 3 with perfect balance", iconName: "circle.grid.2x2", isUnlocked: false, progress: 0),
            Achievement(id: "energy_saver", title: "ENERGY ECONOMIST", description: "Complete a level using minimum path lengths", iconName: "bolt.shield", isUnlocked: false, progress: 0),
            Achievement(id: "amplifier_pro", title: "RESONANCE EXPERT", description: "Use an amplifier to connect 3 nodes", iconName: "waveform.path", isUnlocked: false, progress: 0),
            Achievement(id: "maze_runner", title: "MAZE RUNNER", description: "Navigate through a complex obstacle course", iconName: "map", isUnlocked: false, progress: 0),
            Achievement(id: "weaver_grandmaster", title: "GRANDMASTER", description: "Complete all 16 levels", iconName: "crown", isUnlocked: false, progress: 0)
        ]
    }
    
    func unlockAchievement(id: String) {
        if let index = achievements.firstIndex(where: { $0.id == id }), !achievements[index].isUnlocked {
            withAnimation(.spring()) {
                achievements[index].isUnlocked = true
                achievements[index].progress = 1.0
            }
            saveAchievements()
        }
    }
    
    func updateProgress(id: String, progress: Double) {
        if let index = achievements.firstIndex(where: { $0.id == id }), !achievements[index].isUnlocked {
            achievements[index].progress = min(progress, 1.0)
            if achievements[index].progress >= 1.0 {
                unlockAchievement(id: id)
            }
            saveAchievements()
        }
    }
    
    private func saveAchievements() {
        if let encoded = try? JSONEncoder().encode(achievements) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadAchievements() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Achievement].self, from: data) {
            // Merge decoded with initial to handle new achievements in updates
            for decodedAchievement in decoded {
                if let index = achievements.firstIndex(where: { $0.id == decodedAchievement.id }) {
                    achievements[index].isUnlocked = decodedAchievement.isUnlocked
                    achievements[index].progress = decodedAchievement.progress
                }
            }
        }
    }
}
