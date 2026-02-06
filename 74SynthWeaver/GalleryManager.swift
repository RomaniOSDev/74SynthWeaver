import SwiftUI
import Combine

struct SavedPattern: Identifiable, Codable {
    let id: UUID
    let levelNumber: Int
    let date: Date
    let connections: [ConnectionData]
    
    struct ConnectionData: Codable {
        let fromPos: GridPositionData
        let toPos: GridPositionData
        let points: [CGPointData]
    }
    
    struct GridPositionData: Codable {
        let x: Int
        let y: Int
    }
    
    struct CGPointData: Codable {
        let x: CGFloat
        let y: CGFloat
    }
}

class GalleryManager: ObservableObject {
    @Published var savedPatterns: [SavedPattern] = []
    private let saveKey = "SynthWeaver_SavedPatterns"
    
    init() {
        loadPatterns()
    }
    
    func savePattern(level: Int, nodes: [WeaveNode], connections: [WeaveConnection]) {
        let connectionData = connections.compactMap { conn -> SavedPattern.ConnectionData? in
            guard let fromNode = nodes.first(where: { $0.id == conn.fromNodeID }),
                  let toNode = nodes.first(where: { $0.id == conn.toNodeID }) else { return nil }
            
            return SavedPattern.ConnectionData(
                fromPos: .init(x: fromNode.position.x, y: fromNode.position.y),
                toPos: .init(x: toNode.position.x, y: toNode.position.y),
                points: conn.pathPoints.map { .init(x: $0.x, y: $0.y) }
            )
        }
        
        let newPattern = SavedPattern(
            id: UUID(),
            levelNumber: level,
            date: Date(),
            connections: connectionData
        )
        
        savedPatterns.insert(newPattern, at: 0)
        saveToUserDefaults()
    }
    
    func deletePattern(id: UUID) {
        savedPatterns.removeAll(where: { $0.id == id })
        saveToUserDefaults()
    }
    
    private func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(savedPatterns) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadPatterns() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([SavedPattern].self, from: data) {
            savedPatterns = decoded
        }
    }
}
