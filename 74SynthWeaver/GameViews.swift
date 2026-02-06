import SwiftUI

struct NodeView: View {
    let node: WeaveNode
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            switch node.type {
            case .solarHeart:
                solarHeartView
            case .auraReceiver:
                auraReceiverView
            case .obstacle:
                obstacleView
            case .amplifier:
                amplifierView
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
    
    private var solarHeartView: some View {
        ZStack {
            // Deep Glow
            Circle()
                .fill(Color.sunFiber.opacity(0.15))
                .frame(width: 60, height: 60)
                .blur(radius: isAnimating ? 15 : 5)
                .scaleEffect(isAnimating ? 1.2 : 0.8)
                .animation(Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
            
            // Outer Ring with Depth
            Circle()
                .stroke(
                    LinearGradient(colors: [Color.sunFiber.opacity(0.6), Color.sunFiber.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing),
                    lineWidth: 2
                )
                .frame(width: 32, height: 32)
                .shadow(color: Color.sunFiber.opacity(0.5), radius: 4, x: 2, y: 2)
            
            // Core Node with Inner Shadow Effect
            Circle()
                .fill(
                    RadialGradient(gradient: Gradient(colors: [.white, Color.sunFiber]), center: .center, startRadius: 2, endRadius: 12)
                )
                .frame(width: 20, height: 20)
                .shadow(color: .black.opacity(0.8), radius: 4, x: 2, y: 3)
                .shadow(color: Color.sunFiber.opacity(0.8), radius: 10)
        }
    }
    
    private var auraReceiverView: some View {
        ZStack {
            // Aura Glow
            Circle()
                .fill(Color.auraFiber.opacity(0.1))
                .frame(width: 50, height: 50)
                .blur(radius: isAnimating ? 10 : 5)
            
            // Beveled Ring
            Circle()
                .stroke(
                    LinearGradient(colors: [Color.auraFiber, Color.auraFiber.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing),
                    lineWidth: 3
                )
                .frame(width: 34, height: 34)
                .shadow(color: .black.opacity(0.5), radius: 3, x: 1, y: 2)
            
            // Core
            Circle()
                .fill(
                    RadialGradient(gradient: Gradient(colors: [Color.auraFiber.opacity(0.8), Color.auraFiber]), center: .center, startRadius: 0, endRadius: 10)
                )
                .frame(width: 18, height: 18)
                .shadow(color: .black.opacity(0.6), radius: 2, x: 1, y: 1)
            
            Text("\(node.currentConnections)/\(node.connectionCapacity)")
                .font(.system(size: 9, weight: .black, design: .monospaced))
                .foregroundColor(.white)
                .shadow(color: .black, radius: 1)
                .offset(y: 24)
        }
    }
    
    private var obstacleView: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(
                LinearGradient(colors: [Color.black.opacity(0.8), Color(hex: "100820")], startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .frame(width: 26, height: 26)
            .shadow(color: .black, radius: 5, x: 3, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(
                        LinearGradient(colors: [Color.red.opacity(0.4), .clear], startPoint: .topLeading, endPoint: .bottomTrailing),
                        lineWidth: 1
                    )
            )
            .rotationEffect(.degrees(isAnimating ? 90 : 0))
            .animation(Animation.linear(duration: 5.0).repeatForever(autoreverses: false), value: isAnimating)
    }
    
    private var amplifierView: some View {
        ZStack {
            // Crystal Effect
            Rectangle()
                .fill(
                    LinearGradient(colors: [.white, .white.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .frame(width: 22, height: 22)
                .rotationEffect(.degrees(45))
                .shadow(color: .white.opacity(0.5), radius: 8)
            
            Rectangle()
                .stroke(Color.white.opacity(0.6), lineWidth: 1.5)
                .frame(width: 28, height: 28)
                .rotationEffect(.degrees(45))
                .scaleEffect(isAnimating ? 1.15 : 0.85)
                .animation(Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: isAnimating)
        }
    }
}

struct GridView: View {
    @ObservedObject var manager: GridManager
    
    var body: some View {
        GeometryReader { geometry in
            let cellSize = geometry.size.width / CGFloat(manager.gridSize)
            
            ZStack {
                // Grid lines
                Path { path in
                    for i in 0...manager.gridSize {
                        let pos = CGFloat(i) * cellSize
                        path.move(to: CGPoint(x: pos, y: 0))
                        path.addLine(to: CGPoint(x: pos, y: geometry.size.height))
                        path.move(to: CGPoint(x: 0, y: pos))
                        path.addLine(to: CGPoint(x: geometry.size.width, y: pos))
                    }
                }
                .stroke(Color.auraFiber.opacity(0.1), lineWidth: 1)
                
                // Connections
                ForEach(manager.connections) { connection in
                    if let fromNode = manager.nodes.first(where: { $0.id == connection.fromNodeID }),
                       let toNode = manager.nodes.first(where: { $0.id == connection.toNodeID }) {
                        
                        LineView(
                            points: connection.pathPoints,
                            fallbackFrom: position(for: fromNode.position, in: cellSize),
                            fallbackTo: position(for: toNode.position, in: cellSize),
                            fromColor: fromNode.type == .solarHeart ? .sunFiber : .auraFiber,
                            toColor: toNode.type == .solarHeart ? .sunFiber : .auraFiber
                        )
                    }
                }
                
                // Nodes
                ForEach(manager.nodes) { node in
                    NodeView(node: node)
                        .position(position(for: node.position, in: cellSize))
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    if manager.dragStartNode == nil {
                                        manager.startDragging(from: node, startPoint: value.location)
                                    }
                                    manager.updateDrag(to: value.location)
                                }
                                .onEnded { value in
                                    manager.endDragging(at: value.location, cellSize: cellSize)
                                }
                        )
                }
                
                // Active drag line
                if let startNode = manager.dragStartNode {
                    LineView(
                        points: manager.dragPath,
                        fallbackFrom: position(for: startNode.position, in: cellSize),
                        fallbackTo: manager.currentDragPoint ?? position(for: startNode.position, in: cellSize),
                        fromColor: startNode.type == .solarHeart ? .sunFiber : .auraFiber,
                        toColor: .white.opacity(0.5)
                    )
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    private func position(for gridPos: GridPosition, in cellSize: CGFloat) -> CGPoint {
        CGPoint(
            x: CGFloat(gridPos.x) * cellSize + cellSize / 2,
            y: CGFloat(gridPos.y) * cellSize + cellSize / 2
        )
    }
}

struct LineView: View {
    let points: [CGPoint]
    let fallbackFrom: CGPoint
    let fallbackTo: CGPoint
    let fromColor: Color
    let toColor: Color
    @State private var phase: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Shadow under the line for depth
            linePath
                .stroke(Color.black.opacity(0.4), lineWidth: 4)
                .offset(x: 2, y: 3)
                .blur(radius: 2)
            
            // Deep Glow
            linePath
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [fromColor.opacity(0.4), toColor.opacity(0.4)]),
                        startPoint: .init(x: 0, y: 0),
                        endPoint: .init(x: 1, y: 1)
                    ),
                    lineWidth: 8
                )
                .blur(radius: 6)
            
            // Main line with bevel effect (two lines on top of each other)
            linePath
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [fromColor, toColor]),
                        startPoint: .init(x: 0, y: 0),
                        endPoint: .init(x: 1, y: 1)
                    ),
                    style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round, dash: [12, 6], dashPhase: phase)
                )
            
            // Highlight core for 3D look
            linePath
                .stroke(
                    Color.white.opacity(0.4),
                    style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round, dash: [12, 6], dashPhase: phase)
                )
        }
        .onAppear {
            withAnimation(Animation.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                phase -= 18
            }
        }
    }
    
    private var linePath: Path {
        Path { path in
            if points.isEmpty {
                path.move(to: fallbackFrom)
                path.addLine(to: fallbackTo)
            } else {
                path.move(to: points[0])
                for i in 1..<points.count {
                    path.addLine(to: points[i])
                }
                // If we are drawing a completed connection, we don't have a "fallbackTo", 
                // but if we are dragging, we should ensure it connects to the current point
                if let last = points.last, last != fallbackTo && points.count > 1 {
                    path.addLine(to: fallbackTo)
                }
            }
        }
    }
}
