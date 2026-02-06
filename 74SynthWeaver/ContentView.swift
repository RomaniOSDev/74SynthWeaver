import SwiftUI

struct ContentView: View {
    @State private var navigationState: NavigationState = .menu
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @StateObject private var galleryManager = GalleryManager()
    @StateObject private var achievementManager = AchievementManager()
    @StateObject private var levelManager = LevelManager()
    @State private var selectedLevel: Int = 1
    
    enum NavigationState {
        case onboarding
        case menu
        case levelSelection
        case game
        case gallery
        case archive
        case settings
    }
    
    var body: some View {
        ZStack {
            Color.synthBackground
                .ignoresSafeArea()
            
            if !hasCompletedOnboarding && navigationState != .onboarding {
                Color.clear.onAppear { navigationState = .onboarding }
            }
            
            switch navigationState {
            case .onboarding:
                OnboardingView(onFinish: {
                    hasCompletedOnboarding = true
                    withAnimation(.easeInOut(duration: 0.8)) {
                        navigationState = .menu
                    }
                })
            case .menu:
                MainMenuView(onStart: {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        navigationState = .levelSelection
                    }
                }, onOpenGallery: {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        navigationState = .gallery
                    }
                }, onOpenArchive: {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        navigationState = .archive
                    }
                }, onOpenSettings: {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        navigationState = .settings
                    }
                })
            case .levelSelection:
                LevelSelectionView(levelManager: levelManager, onSelectLevel: { level in
                    selectedLevel = level
                    withAnimation(.easeInOut(duration: 0.8)) {
                        navigationState = .game
                    }
                }, onBack: {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        navigationState = .menu
                    }
                })
                .transition(.opacity)
            case .game:
                GameView(levelManager: levelManager, galleryManager: galleryManager, achievementManager: achievementManager, initialLevel: selectedLevel, onBack: {
                    withAnimation(.easeInOut(duration: 0.8)) {
                        navigationState = .levelSelection
                    }
                })
                .transition(.opacity)
            case .gallery:
                GalleryView(galleryManager: galleryManager, onBack: {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        navigationState = .menu
                    }
                })
                .transition(.move(edge: .trailing))
            case .archive:
                ArchiveView(achievementManager: achievementManager, onBack: {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        navigationState = .menu
                    }
                })
                .transition(.move(edge: .bottom))
            case .settings:
                SettingsView(onBack: {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        navigationState = .menu
                    }
                })
                .transition(.move(edge: .leading))
            }
        }
    }
}

struct MainMenuView: View {
    let onStart: () -> Void
    let onOpenGallery: () -> Void
    let onOpenArchive: () -> Void
    let onOpenSettings: () -> Void
    
    var body: some View {
        VStack(spacing: 40) {
            VStack(spacing: 8) {
                Text("SYNTH WEAVER")
                    .font(.system(size: 48, weight: .bold, design: .monospaced))
                    .foregroundColor(.sunFiber)
                    .shadow(color: .sunFiber.opacity(0.5), radius: 10)
                
                Text("WEAVE THE LIGHT, BALANCE THE THREADS")
                    .font(.system(size: 14, weight: .light, design: .monospaced))
                    .foregroundColor(.auraFiber)
                    .tracking(2)
            }
            
            Spacer()
            
            Button(action: onStart) {
                Text("INITIATE WEAVING")
                    .font(.system(size: 20, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 18)
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(
                                    LinearGradient(colors: [Color.auraFiber.opacity(0.3), Color.auraFiber.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.auraFiber, lineWidth: 2)
                        }
                    )
                    .shadow(color: Color.auraFiber.opacity(0.5), radius: 15, x: 0, y: 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            .padding(1)
                    )
            }
            
            VStack(spacing: 12) {
                MenuButton(title: "GALLERY", action: onOpenGallery)
                MenuButton(title: "ARCHIVE", action: onOpenArchive)
                MenuButton(title: "SETTINGS", action: onOpenSettings)
            }
            
            Spacer()
        }
        .padding(.top, 100)
    }
}

struct MenuButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
                .frame(width: 220)
                .padding(.vertical, 14)
                .background(
                    ZStack {
                        // Base layer with depth shadow
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.05))
                            .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 4)
                        
                        // Glass effect gradient
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.12), Color.white.opacity(0.02)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        // Inner bevel highlight
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.3), .clear, Color.white.opacity(0.05)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    }
                )
                .overlay(
                    // Subtle glow matching the theme
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.auraFiber.opacity(0.2), lineWidth: 0.5)
                )
        }
        .buttonStyle(DepthButtonStyle())
    }
}

struct DepthButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .offset(y: configuration.isPressed ? 2 : 0)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct GameView: View {
    @StateObject private var manager = GridManager()
    let levelManager: LevelManager
    let galleryManager: GalleryManager
    let achievementManager: AchievementManager
    let initialLevel: Int
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
                Text("LEVEL \(String(format: "%02d", manager.currentLevel))")
                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                    .foregroundColor(.sunFiber)
                Spacer()
                Button(action: {
                    manager.loadLevel(manager.currentLevel)
                }) {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .padding(10)
                }
            }
            .padding()
            
            Spacer()
            
            // Game Grid
            ZStack {
                GridView(manager: manager)
                    .padding(20)
                
                if manager.isLevelCompleted {
                    VStack(spacing: 20) {
                        Text("LEVEL COMPLETE")
                            .font(.system(size: 32, weight: .bold, design: .monospaced))
                            .foregroundColor(.sunFiber)
                            .shadow(color: .sunFiber.opacity(0.5), radius: 10)
                        
                        Text("The threads are balanced")
                            .font(.system(size: 16, weight: .light, design: .monospaced))
                            .foregroundColor(.white)
                        
                        Button(action: {
                            // Save to gallery
                            galleryManager.savePattern(
                                level: manager.currentLevel,
                                nodes: manager.nodes,
                                connections: manager.connections
                            )
                            
                            // Unlock next level
                            levelManager.unlockNextLevel(after: manager.currentLevel)
                            
                            // Check achievements
                            checkAchievements()
                            
                            if manager.currentLevel < 16 {
                                manager.nextLevel()
                            } else {
                                onBack()
                            }
                        }) {
                            Text(manager.currentLevel < 16 ? "NEXT LEVEL" : "FINISH")
                                .font(.system(size: 18, weight: .medium, design: .monospaced))
                                .foregroundColor(.white)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 2)
                                        .stroke(Color.sunFiber, lineWidth: 2)
                                        .background(Color.sunFiber.opacity(0.2))
                                )
                        }
                    }
                    .padding(40)
                    .background(Color.synthBackground.opacity(0.9))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.sunFiber.opacity(0.5), lineWidth: 1)
                    )
                    .transition(.scale.combined(with: .opacity))
                }
            }
            
            Spacer()
            
            HStack(spacing: 30) {
                VStack {
                    Text("ENERGY")
                        .font(.caption)
                        .foregroundColor(.sunFiber)
                    Text("\(manager.energyBudget)%")
                        .font(.system(size: 20, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                }
                
                VStack {
                    Text("RESONANCE")
                        .font(.caption)
                        .foregroundColor(.auraFiber)
                    Text(manager.isLevelCompleted ? "1.0" : "0.0")
                        .font(.system(size: 20, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                }
            }
            .padding(.bottom, 50)
        }
        .onAppear {
            manager.loadLevel(initialLevel)
        }
    }
    
    private func checkAchievements() {
        // First weave
        achievementManager.unlockAchievement(id: "first_weave")
        
        // Level 3 symmetry
        if manager.currentLevel == 3 {
            achievementManager.unlockAchievement(id: "symmetry_master")
        }
        
        // Amplifiers
        if manager.nodes.contains(where: { $0.type == .amplifier && $0.currentConnections >= 3 }) {
            achievementManager.unlockAchievement(id: "amplifier_pro")
        }
        
        // Maze runner (levels with many obstacles)
        if manager.currentLevel == 10 || manager.currentLevel == 14 {
            achievementManager.unlockAchievement(id: "maze_runner")
        }
        
        // Grandmaster
        if manager.currentLevel == 16 {
            achievementManager.unlockAchievement(id: "weaver_grandmaster")
        }
    }
}
