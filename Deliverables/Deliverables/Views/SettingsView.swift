import SwiftUI

// Global version constant
let APP_VERSION = "1.0.0"

struct SettingsView: View {
    // Consistent muted grey for all elements
    private let mutedGrey = Color(white: 0.6)
    
    var body: some View {
        VStack(spacing: 16) {
            // App icon
            Image(systemName: "checklist")
                .font(.system(size: 40))
                .foregroundColor(mutedGrey)
            
            // App name
            Text("Deliverables")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(mutedGrey)
            
            // Version
            Text("Version \(APP_VERSION)")
                .font(.system(size: 11))
                .foregroundColor(mutedGrey)
            
            Divider()
                .padding(.horizontal, 50)
            
            // Developer credit
            Text("Developed by Sungjoon Park")
                .font(.system(size: 11))
                .foregroundColor(mutedGrey)
            
            Spacer()
        }
        .padding(.top, 50)
        .padding(.bottom, 20)
        .frame(width: 280, height: 220)
        .background(Color.white)
    }
}

#Preview {
    SettingsView()
}
