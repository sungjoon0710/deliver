import SwiftUI

// Global version constant
let APP_VERSION = "1.0.0"

struct SettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    
    // Adaptive muted color
    private var mutedColor: Color {
        colorScheme == .dark ? Color(white: 0.5) : Color(white: 0.6)
    }
    
    private var backgroundColor: Color {
        Color(NSColor.windowBackgroundColor)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // App icon
            Image(systemName: "checklist")
                .font(.system(size: 40))
                .foregroundColor(mutedColor)
            
            // App name
            Text("Deliverables")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(mutedColor)
            
            // Version
            Text("Version \(APP_VERSION)")
                .font(.system(size: 11))
                .foregroundColor(mutedColor)
            
            Divider()
                .padding(.horizontal, 50)
            
            // Developer credit
            Text("Developed by Sungjoon Park")
                .font(.system(size: 11))
                .foregroundColor(mutedColor)
            
            Spacer()
        }
        .padding(.top, 50)
        .padding(.bottom, 20)
        .frame(width: 280, height: 220)
        .background(backgroundColor)
    }
}

#Preview {
    SettingsView()
}
