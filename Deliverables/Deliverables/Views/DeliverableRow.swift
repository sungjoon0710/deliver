import SwiftUI

struct DeliverableRow: View {
    let deliverable: Deliverable
    let onComplete: () -> Void
    let onDelete: () -> Void
    
    @State private var showDeleteConfirmation = false
    
    private var progress: Double {
        ProgressCalculator.progress(for: deliverable)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                // Title
                Text(deliverable.title)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Color(white: 0.1))
                    .lineLimit(1)
                
                Spacer()
                
                // Action buttons
                HStack(spacing: 4) {
                    // Complete button
                    Button(action: onComplete) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(Color(white: 0.4))
                    }
                    .buttonStyle(.plain)
                    .frame(width: 24, height: 24)
                    .background(Color(white: 0.95))
                    .cornerRadius(4)
                    .help("Mark as complete")
                    
                    // Delete button
                    Button(action: { showDeleteConfirmation = true }) {
                        Image(systemName: "trash")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(Color(white: 0.4))
                    }
                    .buttonStyle(.plain)
                    .frame(width: 24, height: 24)
                    .background(Color(white: 0.95))
                    .cornerRadius(4)
                    .help("Delete")
                }
            }
            
            // Progress bar
            ProgressBar(progress: progress, isOverdue: deliverable.isOverdue)
            
            // Due date
            Text(deliverable.formattedDueDate)
                .font(.system(size: 10, weight: .light))
                .foregroundColor(deliverable.isOverdue ? Color.red : Color(white: 0.42))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color.white)
        .cornerRadius(8)
        .alert("Delete Deliverable?", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to permanently delete \"\(deliverable.title)\"? This action cannot be undone.")
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
            onDelete: {}
        )
        
        DeliverableRow(
            deliverable: Deliverable(
                title: "Overdue Task",
                createdAt: Date().addingTimeInterval(-86400 * 2),
                dueAt: Date().addingTimeInterval(-3600)
            ),
            onComplete: {},
            onDelete: {}
        )
    }
    .padding()
    .background(Color(white: 0.95))
    .frame(width: 320)
}
