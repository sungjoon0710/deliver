import SwiftUI

struct DeliverableRow: View {
    let deliverable: Deliverable
    let onComplete: () -> Void
    let onEdit: (Deliverable) -> Void
    let onDelete: () -> Void
    
    @Environment(\.colorScheme) var colorScheme
    @State private var showDeleteConfirmation = false
    @State private var showEditSheet = false
    @State private var isHoveringProgress = false
    @State private var currentTime = Date()
    
    // Timer for real-time countdown updates
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // Adaptive colors
    private var cardBackgroundColor: Color {
        colorScheme == .dark ? Color(white: 0.18) : Color.white
    }
    
    private var primaryTextColor: Color {
        Color(NSColor.labelColor)
    }
    
    private var secondaryTextColor: Color {
        Color(NSColor.secondaryLabelColor)
    }
    
    private var buttonBackgroundColor: Color {
        colorScheme == .dark ? Color(white: 0.25) : Color(white: 0.95)
    }
    
    private var buttonForegroundColor: Color {
        Color(NSColor.secondaryLabelColor)
    }
    
    private var progress: Double {
        ProgressCalculator.calculateProgress(
            createdAt: deliverable.createdAt,
            dueAt: deliverable.dueAt,
            currentDate: currentTime
        )
    }
    
    private var isOverdue: Bool {
        currentTime >= deliverable.dueAt
    }
    
    /// Formatted remaining time (e.g., "2d 5h 30m 15s") - uses currentTime for real-time updates
    private var remainingTimeDisplay: String {
        let remaining = deliverable.dueAt.timeIntervalSince(currentTime)
        
        if remaining <= 0 {
            return "Overdue!"
        }
        
        let days = Int(remaining) / 86400
        let hours = (Int(remaining) % 86400) / 3600
        let minutes = (Int(remaining) % 3600) / 60
        let seconds = Int(remaining) % 60
        
        var parts: [String] = []
        if days > 0 { parts.append("\(days)d") }
        if hours > 0 { parts.append("\(hours)h") }
        if minutes > 0 { parts.append("\(minutes)m") }
        if seconds > 0 || parts.isEmpty { parts.append("\(seconds)s") }
        
        return "Time remaining: " + parts.joined(separator: " ")
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                // Title
                Text(deliverable.title)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(primaryTextColor)
                    .lineLimit(1)
                
                Spacer()
                
                // Action buttons
                HStack(spacing: 4) {
                    // Edit button
                    Button(action: { showEditSheet = true }) {
                        Image(systemName: "pencil")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(buttonForegroundColor)
                    }
                    .buttonStyle(.plain)
                    .frame(width: 24, height: 24)
                    .background(buttonBackgroundColor)
                    .cornerRadius(4)
                    .help("Edit")
                    
                    // Complete button
                    Button(action: onComplete) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(buttonForegroundColor)
                    }
                    .buttonStyle(.plain)
                    .frame(width: 24, height: 24)
                    .background(buttonBackgroundColor)
                    .cornerRadius(4)
                    .help("Mark as complete")
                    
                    // Delete button
                    Button(action: { showDeleteConfirmation = true }) {
                        Image(systemName: "trash")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(buttonForegroundColor)
                    }
                    .buttonStyle(.plain)
                    .frame(width: 24, height: 24)
                    .background(buttonBackgroundColor)
                    .cornerRadius(4)
                    .help("Delete")
                }
            }
            
            // Progress bar - updates in real-time, hover to see exact remaining time
            ProgressBar(progress: progress, isOverdue: isOverdue)
                .animation(.linear(duration: 1), value: progress)
                .onHover { hovering in
                    isHoveringProgress = hovering
                }
            
            // Due date (shows real-time remaining countdown on hover)
            Text(isHoveringProgress ? remainingTimeDisplay : deliverable.formattedDueDate)
                .font(.system(size: 10, weight: .light))
                .foregroundColor(isOverdue ? Color.red : secondaryTextColor)
                .animation(.easeInOut(duration: 0.15), value: isHoveringProgress)
                .onReceive(timer) { time in
                    currentTime = time
                }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(cardBackgroundColor)
        .cornerRadius(8)
        .alert("Delete Deliverable?", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to permanently delete \"\(deliverable.title)\"? This action cannot be undone.")
        }
        .sheet(isPresented: $showEditSheet) {
            EditDeliverableView(
                isPresented: $showEditSheet,
                deliverable: deliverable,
                onSave: { updated in
                    onEdit(updated)
                }
            )
            .frame(width: 300)
        }
    }
}

#Preview {
    VStack {
        DeliverableRow(
            deliverable: Deliverable(
                title: "CS Assignment 3",
                dueAt: Date().addingTimeInterval(86400 * 3)
            ),
            onComplete: {},
            onEdit: { _ in },
            onDelete: {}
        )
        
        DeliverableRow(
            deliverable: Deliverable(
                title: "Overdue Task",
                createdAt: Date().addingTimeInterval(-86400 * 2),
                dueAt: Date().addingTimeInterval(-3600)
            ),
            onComplete: {},
            onEdit: { _ in },
            onDelete: {}
        )
    }
    .padding()
    .background(Color(white: 0.95))
    .frame(width: 320)
}
