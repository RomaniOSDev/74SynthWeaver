import SwiftUI
import Combine

class LevelManager: ObservableObject {
    @Published var unlockedLevels: Int = 1
    private let saveKey = "SynthWeaver_UnlockedLevels"
    let totalLevels = 16
    
    init() {
        loadProgress()
    }
    
    func unlockNextLevel(after currentLevel: Int) {
        if currentLevel == unlockedLevels && unlockedLevels < totalLevels {
            withAnimation {
                unlockedLevels += 1
            }
            saveProgress()
        }
    }
    
    func isLevelUnlocked(_ level: Int) -> Bool {
        return level <= unlockedLevels
    }
    
    private func saveProgress() {
        UserDefaults.standard.set(unlockedLevels, forKey: saveKey)
    }
    
    private func loadProgress() {
        let saved = UserDefaults.standard.integer(forKey: saveKey)
        unlockedLevels = saved > 0 ? saved : 1
    }
    
    // For testing/resetting
    func resetProgress() {
        unlockedLevels = 1
        saveProgress()
    }
}
