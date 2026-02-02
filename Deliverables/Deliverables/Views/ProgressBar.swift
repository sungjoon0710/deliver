import SwiftUI

struct ProgressBar: View {
    let progress: Double
    let isOverdue: Bool
    
    // Colors
    private let cypressGreen = Color(red: 0.04, green: 0.21, blue: 0.13) // #0A3622
    private let overdueRed = Color(red: 0.83, green: 0.18, blue: 0.18)   // #D32F2F
    private let trackColor = Color(white: 0.9)                            // #E5E5E5
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background track
                RoundedRectangle(cornerRadius: 3)
                    .fill(trackColor)
                    .frame(height: 6)
                
                // Progress fill
                RoundedRectangle(cornerRadius: 3)
                    .fill(isOverdue ? overdueRed : cypressGreen)
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
