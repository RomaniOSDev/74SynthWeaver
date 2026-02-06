import SwiftUI
import Combine

class GridManager: ObservableObject {
    @Published var nodes: [WeaveNode] = []
    @Published var connections: [WeaveConnection] = []
    @Published var energyBudget: Int = 100
    @Published var isLevelCompleted: Bool = false
    @Published var currentLevel: Int = 1
    @Published var dragStartNode: WeaveNode?
    @Published var currentDragPoint: CGPoint?
    
    let gridSize: Int = 8
    
    init() {
        loadLevel(currentLevel)
    }
    
    func loadLevel(_ level: Int) {
        currentLevel = level
        connections = []
        isLevelCompleted = false
        energyBudget = 100
        
        switch level {
        case 1:
            nodes = [
                WeaveNode(type: .solarHeart, position: GridPosition(x: 1, y: 1), connectionCapacity: 2, isActive: true),
                WeaveNode(type: .solarHeart, position: GridPosition(x: 6, y: 1), connectionCapacity: 2, isActive: true),
                WeaveNode(type: .auraReceiver, position: GridPosition(x: 1, y: 6), connectionCapacity: 1),
                WeaveNode(type: .auraReceiver, position: GridPosition(x: 6, y: 6), connectionCapacity: 1),
                WeaveNode(type: .auraReceiver, position: GridPosition(x: 3, y: 3), connectionCapacity: 2)
            ]
        case 2: // Introduction of Obstacles
            nodes = [
                WeaveNode(type: .solarHeart, position: GridPosition(x: 0, y: 0), connectionCapacity: 3, isActive: true),
                WeaveNode(type: .auraReceiver, position: GridPosition(x: 7, y: 7), connectionCapacity: 3),
                WeaveNode(type: .obstacle, position: GridPosition(x: 3, y: 3), connectionCapacity: 0),
                WeaveNode(type: .obstacle, position: GridPosition(x: 4, y: 4), connectionCapacity: 0)
            ]
        case 3: // Symmetry
            nodes = [
                WeaveNode(type: .solarHeart, position: GridPosition(x: 3, y: 0), connectionCapacity: 2, isActive: true),
                WeaveNode(type: .solarHeart, position: GridPosition(x: 4, y: 0), connectionCapacity: 2, isActive: true),
                WeaveNode(type: .auraReceiver, position: GridPosition(x: 0, y: 7), connectionCapacity: 2),
                WeaveNode(type: .auraReceiver, position: GridPosition(x: 7, y: 7), connectionCapacity: 2)
            ]
        case 4: // The Cross
            nodes = [
                WeaveNode(type: .solarHeart, position: GridPosition(x: 3, y: 3), connectionCapacity: 4, isActive: true),
                WeaveNode(type: .auraReceiver, position: GridPosition(x: 3, y: 0), connectionCapacity: 1),
                WeaveNode(type: .auraReceiver, position: GridPosition(x: 3, y: 7), connectionCapacity: 1),
                WeaveNode(type: .auraReceiver, position: GridPosition(x: 0, y: 3), connectionCapacity: 1),
                WeaveNode(type: .auraReceiver, position: GridPosition(x: 7, y: 3), connectionCapacity: 1)
            ]
        case 5: // Introduction of Amplifiers
            nodes = [
                WeaveNode(type: .solarHeart, position: GridPosition(x: 0, y: 3), connectionCapacity: 1, isActive: true),
                WeaveNode(type: .amplifier, position: GridPosition(x: 3, y: 3), connectionCapacity: 4),
                WeaveNode(type: .auraReceiver, position: GridPosition(x: 7, y: 1), connectionCapacity: 1),
                WeaveNode(type: .auraReceiver, position: GridPosition(x: 7, y: 5), connectionCapacity: 1)
            ]
        case 6: // Zig Zag
            nodes = [
                WeaveNode(type: .solarHeart, position: GridPosition(x: 0, y: 0), connectionCapacity: 1, isActive: true),
                WeaveNode(type: .auraReceiver, position: GridPosition(x: 2, y: 2), connectionCapacity: 2),
                WeaveNode(type: .auraReceiver, position: GridPosition(x: 0, y: 4), connectionCapacity: 2),
                WeaveNode(type: .auraReceiver, position: GridPosition(x: 2, y: 6), connectionCapacity: 1)
            ]
        case 7: // The Wall
            nodes = [
                WeaveNode(type: .solarHeart, position: GridPosition(x: 1, y: 3), connectionCapacity: 3, isActive: true),
                WeaveNode(type: .obstacle, position: GridPosition(x: 3, y: 1), connectionCapacity: 0),
                WeaveNode(type: .obstacle, position: GridPosition(x: 3, y: 2), connectionCapacity: 0),
                WeaveNode(type: .obstacle, position: GridPosition(x: 3, y: 3), connectionCapacity: 0),
                WeaveNode(type: .obstacle, position: GridPosition(x: 3, y: 4), connectionCapacity: 0),
                WeaveNode(type: .obstacle, position: GridPosition(x: 3, y: 5), connectionCapacity: 0),
                WeaveNode(type: .auraReceiver, position: GridPosition(x: 5, y: 3), connectionCapacity: 3)
            ]
        case 8: // Diamond
            nodes = [
                WeaveNode(type: .solarHeart, position: GridPosition(x: 3, y: 1), connectionCapacity: 2, isActive: true),
                WeaveNode(type: .solarHeart, position: GridPosition(x: 3, y: 6), connectionCapacity: 2, isActive: true),
                WeaveNode(type: .auraReceiver, position: GridPosition(x: 1, y: 3), connectionCapacity: 2),
                WeaveNode(type: .auraReceiver, position: GridPosition(x: 6, y: 3), connectionCapacity: 2)
            ]
        case 9: // Splitter
            nodes = [
                WeaveNode(type: .solarHeart, position: GridPosition(x: 0, y: 0), connectionCapacity: 1, isActive: true),
                WeaveNode(type: .amplifier, position: GridPosition(x: 2, y: 2), connectionCapacity: 3),
                WeaveNode(type: .auraReceiver, position: GridPosition(x: 4, y: 0), connectionCapacity: 1),
                WeaveNode(type: .auraReceiver, position: GridPosition(x: 0, y: 4), connectionCapacity: 1)
            ]
        case 10: // Complex Maze
            nodes = [
                WeaveNode(type: .solarHeart, position: GridPosition(x: 0, y: 0), connectionCapacity: 2, isActive: true),
                WeaveNode(type: .obstacle, position: GridPosition(x: 1, y: 0), connectionCapacity: 0),
                WeaveNode(type: .obstacle, position: GridPosition(x: 1, y: 1), connectionCapacity: 0),
                WeaveNode(type: .obstacle, position: GridPosition(x: 0, y: 2), connectionCapacity: 0),
                WeaveNode(type: .auraReceiver, position: GridPosition(x: 2, y: 2), connectionCapacity: 2)
            ]
        case 11: // Twin Hearts
            nodes = [
                WeaveNode(type: .solarHeart, position: GridPosition(x: 2, y: 2), connectionCapacity: 2, isActive: true),
                WeaveNode(type: .solarHeart, position: GridPosition(x: 5, y: 5), connectionCapacity: 2, isActive: true),
                WeaveNode(type: .auraReceiver, position: GridPosition(x: 2, y: 5), connectionCapacity: 2),
                WeaveNode(type: .auraReceiver, position: GridPosition(x: 5, y: 2), connectionCapacity: 2)
            ]
        case 12: // The Ring
            nodes = [
                WeaveNode(type: .solarHeart, position: GridPosition(x: 3, y: 3), connectionCapacity: 4, isActive: true),
                WeaveNode(type: .auraReceiver, position: GridPosition(x: 2, y: 2), connectionCapacity: 1),
                WeaveNode(type: .auraReceiver, position: GridPosition(x: 4, y: 2), connectionCapacity: 1),
                WeaveNode(type: .auraReceiver, position: GridPosition(x: 2, y: 4), connectionCapacity: 1),
                WeaveNode(type: .auraReceiver, position: GridPosition(x: 4, y: 4), connectionCapacity: 1)
            ]
        case 13: // Energy Flow
            nodes = [
                WeaveNode(type: .solarHeart, position: GridPosition(x: 0, y: 3), connectionCapacity: 1, isActive: true),
                WeaveNode(type: .amplifier, position: GridPosition(x: 2, y: 3), connectionCapacity: 2),
                WeaveNode(type: .amplifier, position: GridPosition(x: 4, y: 3), connectionCapacity: 2),
                WeaveNode(type: .auraReceiver, position: GridPosition(x: 7, y: 3), connectionCapacity: 1)
            ]
        case 14: // Chaos
            nodes = [
                WeaveNode(type: .solarHeart, position: GridPosition(x: 1, y: 1), connectionCapacity: 2, isActive: true),
                WeaveNode(type: .obstacle, position: GridPosition(x: 2, y: 2), connectionCapacity: 0),
                WeaveNode(type: .amplifier, position: GridPosition(x: 3, y: 3), connectionCapacity: 2),
                WeaveNode(type: .auraReceiver, position: GridPosition(x: 5, y: 5), connectionCapacity: 2)
            ]
        case 15: // Final Weave
            nodes = [
                WeaveNode(type: .solarHeart, position: GridPosition(x: 0, y: 0), connectionCapacity: 2, isActive: true),
                WeaveNode(type: .solarHeart, position: GridPosition(x: 7, y: 0), connectionCapacity: 2, isActive: true),
                WeaveNode(type: .solarHeart, position: GridPosition(x: 0, y: 7), connectionCapacity: 2, isActive: true),
                WeaveNode(type: .solarHeart, position: GridPosition(x: 7, y: 7), connectionCapacity: 2, isActive: true),
                WeaveNode(type: .auraReceiver, position: GridPosition(x: 3, y: 3), connectionCapacity: 4),
                WeaveNode(type: .auraReceiver, position: GridPosition(x: 4, y: 4), connectionCapacity: 4)
            ]
        case 16: // Ultimate Balance
            nodes = [
                WeaveNode(type: .solarHeart, position: GridPosition(x: 3, y: 0), connectionCapacity: 3, isActive: true),
                WeaveNode(type: .solarHeart, position: GridPosition(x: 4, y: 7), connectionCapacity: 3, isActive: true),
                WeaveNode(type: .auraReceiver, position: GridPosition(x: 0, y: 3), connectionCapacity: 2),
                WeaveNode(type: .auraReceiver, position: GridPosition(x: 7, y: 4), connectionCapacity: 2),
                WeaveNode(type: .amplifier, position: GridPosition(x: 3, y: 3), connectionCapacity: 4),
                WeaveNode(type: .amplifier, position: GridPosition(x: 4, y: 4), connectionCapacity: 4)
            ]
        default:
            loadLevel(1)
        }
    }
    
    func nextLevel() {
        if currentLevel < 16 {
            loadLevel(currentLevel + 1)
        }
    }
    
    func checkCompletion() {
        let receivers = nodes.filter { $0.type == .auraReceiver }
        let allFilled = receivers.allSatisfy { $0.currentConnections >= $0.connectionCapacity }
        
        if allFilled && !receivers.isEmpty {
            withAnimation(.easeInOut(duration: 1.0)) {
                isLevelCompleted = true
            }
        }
    }
    
    @Published var dragPath: [CGPoint] = []
    
    func startDragging(from node: WeaveNode, startPoint: CGPoint) {
        if isLevelCompleted { return }
        if node.type == .solarHeart || node.type == .amplifier || node.currentConnections < node.connectionCapacity {
            dragStartNode = node
            dragPath = [startPoint]
        }
    }
    
    func updateDrag(to point: CGPoint) {
        if isLevelCompleted { return }
        currentDragPoint = point
        
        // Add point to path if it's far enough from the last point to create a smooth curve
        if let lastPoint = dragPath.last {
            let dist = sqrt(pow(point.x - lastPoint.x, 2) + pow(point.y - lastPoint.y, 2))
            if dist > 10 {
                dragPath.append(point)
            }
        }
    }
    
    func endDragging(at point: CGPoint, cellSize: CGFloat) {
        guard let startNode = dragStartNode else { return }
        
        let gridX = Int(point.x / cellSize)
        let gridY = Int(point.y / cellSize)
        let dropPos = GridPosition(x: gridX, y: gridY)
        
        if let targetNode = nodes.first(where: { $0.position == dropPos }),
           targetNode.id != startNode.id {
            
            if (targetNode.type == .auraReceiver || targetNode.type == .amplifier) && targetNode.currentConnections < targetNode.connectionCapacity {
                addConnection(from: startNode, to: targetNode, path: dragPath)
                checkCompletion()
            }
        }
        
        dragStartNode = nil
        currentDragPoint = nil
        dragPath = []
    }
    
    func addConnection(from: WeaveNode, to: WeaveNode, path: [CGPoint]) {
        let newConnection = WeaveConnection(
            fromNodeID: from.id,
            toNodeID: to.id,
            pathPoints: path,
            strength: 1.0
        )
        connections.append(newConnection)
        
        if let index = nodes.firstIndex(where: { $0.id == from.id }) {
            nodes[index].currentConnections += 1
        }
        if let index = nodes.firstIndex(where: { $0.id == to.id }) {
            nodes[index].currentConnections += 1
        }
    }
}
