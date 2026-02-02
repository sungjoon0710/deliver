import SwiftUI

struct ProgressBar: View {
    let progress: Double
    let isOverdue: Bool
    
    private let trackColor = Color(white: 0.9) // #E5E5E5
    
    /// Inferno color scheme: dark purple (100%) → magenta → red → orange (0%)
    private var infernoColor: Color {
        let p = min(max(progress, 0), 1)
        
        let colors: [(r: Double, g: Double, b: Double)] = [
            (0.94, 0.33, 0.24),  // 0%:   #F05440 - Orange-red
            (0.78, 0.20, 0.35),  // 25%:  #C73359 - Red-coral
            (0.58, 0.15, 0.40),  // 50%:  #932667 - Magenta
            (0.33, 0.09, 0.47),  // 75%:  #541778 - Purple
            (0.07, 0.03, 0.17),  // 100%: #120829 - Dark indigo
        ]
        
        let scaledProgress = p * Double(colors.count - 1)
        let lowerIndex = Int(scaledProgress)
        let upperIndex = min(lowerIndex + 1, colors.count - 1)
        let fraction = scaledProgress - Double(lowerIndex)
        
        let c1 = colors[lowerIndex]
        let c2 = colors[upperIndex]
        
        let r = c1.r + (c2.r - c1.r) * fraction
        let g = c1.g + (c2.g - c1.g) * fraction
        let b = c1.b + (c2.b - c1.b) * fraction
        
        return Color(red: r, green: g, blue: b)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background track
                RoundedRectangle(cornerRadius: 3)
                    .fill(trackColor)
                    .frame(height: 6)
                
                // Progress fill (right-aligned)
                RoundedRectangle(cornerRadius: 3)
                    .fill(infernoColor)
                    .frame(width: max(0, geometry.size.width * progress), height: 6)
            }
        }
        .frame(height: 6)
    }
}

#Preview {
    VStack(spacing: 20) {
        ProgressBar(progress: 0.8, isOverdue: false)
        ProgressBar(progress: 0.5, isOverdue: false)
        ProgressBar(progress: 0.2, isOverdue: false)
        ProgressBar(progress: 0.0, isOverdue: true)
    }
    .padding()
    .frame(width: 300)
}
