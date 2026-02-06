import Foundation
import CoreGraphics

enum NodeType {
    case solarHeart    // #FFB934
    case auraReceiver  // #8B48F5
    case obstacle      // Dark
    case amplifier     // Amplifier
}

struct GridPosition: Equatable, Hashable {
    let x: Int
    let y: Int
}

struct WeaveNode: Identifiable {
    let id = UUID()
    let type: NodeType
    var position: GridPosition
    var connectionCapacity: Int
    var currentConnections: Int = 0
    var isActive: Bool = false
}

struct WeaveConnection: Identifiable {
    let id = UUID()
    let fromNodeID: UUID
    let toNodeID: UUID
    let pathPoints: [CGPoint]
    var strength: Double // 0.0-1.0
    var isOptimal: Bool = false
}
