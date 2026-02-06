import SwiftUI

struct GalleryView: View {
    @ObservedObject var galleryManager: GalleryManager
    let onBack: () -> Void
    
    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
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
                Text("GALLERY")
                    .font(.system(size: 24, weight: .bold, design: .monospaced))
                    .foregroundColor(.sunFiber)
                Spacer()
                // Empty view to balance HStack
                Color.clear.frame(width: 40, height: 40)
            }
            .padding()
            
            if galleryManager.savedPatterns.isEmpty {
                Spacer()
                VStack(spacing: 20) {
                    Image(systemName: "square.stack.3d.up.slash")
                        .font(.system(size: 60))
                        .foregroundColor(.auraFiber.opacity(0.5))
                    Text("NO WEAVES ARCHIVED YET")
                        .font(.system(size: 14, weight: .light, design: .monospaced))
                        .foregroundColor(.white.opacity(0.6))
                }
                Spacer()
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(galleryManager.savedPatterns) { pattern in
                            ZStack(alignment: .topTrailing) {
                                PatternThumbnailView(pattern: pattern)
                                
                                Button(action: {
                                    withAnimation {
                                        galleryManager.deletePattern(id: pattern.id)
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 22))
                                        .foregroundColor(.red.opacity(0.8))
                                        .background(Circle().fill(Color.white).frame(width: 18, height: 18))
                                        .padding(8)
                                }
                            }
                        }
                    }
                    .padding(20)
                }
            }
        }
        .background(Color.synthBackground.ignoresSafeArea())
    }
}

struct PatternThumbnailView: View {
    let pattern: SavedPattern
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.black.opacity(0.3))
                    .aspectRatio(1, contentMode: .fit)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.auraFiber.opacity(0.3), lineWidth: 1)
                    )
                
                // Mini preview of the weave
                GeometryReader { geo in
                    ForEach(0..<pattern.connections.count, id: \.self) { i in
                        let conn = pattern.connections[i]
                        Path { path in
                            if let first = conn.points.first {
                                path.move(to: CGPoint(x: first.x * (geo.size.width / 400), y: first.y * (geo.size.height / 400))) // Scaling approx
                                for p in conn.points.dropFirst() {
                                    path.addLine(to: CGPoint(x: p.x * (geo.size.width / 400), y: p.y * (geo.size.height / 400)))
                                }
                            }
                        }
                        .stroke(
                            LinearGradient(
                                colors: [.sunFiber, .auraFiber],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                    }
                }
                .padding(10)
            }
            
            HStack {
                Text("LEVEL \(pattern.levelNumber)")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundColor(.sunFiber)
                Spacer()
                Text(pattern.date, style: .date)
                    .font(.system(size: 8, design: .monospaced))
                    .foregroundColor(.white.opacity(0.4))
            }
            .padding(.horizontal, 4)
        }
    }
}
