import SwiftUI

struct EditDeliverableView: View {
    @Binding var isPresented: Bool
    let deliverable: Deliverable
    let onSave: (Deliverable) -> Void
    
    @Environment(\.colorScheme) var colorScheme
    @State private var title: String = ""
    @State private var dueDate: Date = Date()
    
    private var isValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // Adaptive colors
    private var backgroundColor: Color {
        colorScheme == .dark ? Color(white: 0.2) : Color.white
    }
    
    private var primaryTextColor: Color {
        Color(NSColor.labelColor)
    }
    
    private var secondaryTextColor: Color {
        Color(NSColor.secondaryLabelColor)
    }
    
    private var inputBackgroundColor: Color {
        colorScheme == .dark ? Color(white: 0.15) : Color(white: 0.97)
    }
    
    private var buttonBackgroundColor: Color {
        colorScheme == .dark ? Color(white: 0.25) : Color(white: 0.95)
    }
    
    // Cypress green for primary action
    private var accentColor: Color {
        Color(red: 0.290, green: 0.486, blue: 0.349)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Text("Edit Deliverable")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(primaryTextColor)
                
                Spacer()
                
                Button(action: { isPresented = false }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(secondaryTextColor)
                }
                .buttonStyle(.plain)
                .frame(width: 20, height: 20)
                .background(buttonBackgroundColor)
                .cornerRadius(10)
            }
            
            Divider()
            
            // Title input
            VStack(alignment: .leading, spacing: 4) {
                Text("Title")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(secondaryTextColor)
                
                TextField("Enter deliverable name...", text: $title)
                    .textFieldStyle(.plain)
                    .font(.system(size: 12))
                    .padding(8)
                    .background(inputBackgroundColor)
                    .cornerRadius(6)
                    .onSubmit {
                        if isValid {
                            saveDeliverable()
                        }
                    }
            }
            
            // Due date picker
            VStack(alignment: .leading, spacing: 4) {
                Text("Due Date")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(secondaryTextColor)
                
                DatePicker(
                    "",
                    selection: $dueDate,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.compact)
                .labelsHidden()
            }
            
            Divider()
            
            // Action buttons
            HStack {
                Spacer()
                
                Button("Cancel") {
                    isPresented = false
                }
                .buttonStyle(.plain)
                .font(.system(size: 11))
                .foregroundColor(secondaryTextColor)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(buttonBackgroundColor)
                .cornerRadius(4)
                
                Button("Save") {
                    saveDeliverable()
                }
                .buttonStyle(.plain)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isValid ? accentColor : Color.gray)
                .cornerRadius(4)
                .disabled(!isValid)
            }
        }
        .padding(16)
        .background(backgroundColor)
        .cornerRadius(10)
        .onAppear {
            // Pre-populate with existing values
            title = deliverable.title
            dueDate = deliverable.dueAt
        }
    }
    
    private func saveDeliverable() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }
        
        // Create updated deliverable, preserving original id and createdAt
        let updated = Deliverable(
            id: deliverable.id,
            title: trimmedTitle,
            createdAt: deliverable.createdAt,
            dueAt: dueDate
        )
        
        onSave(updated)
        isPresented = false
    }
}

#Preview {
    EditDeliverableView(
        isPresented: .constant(true),
        deliverable: Deliverable(
            title: "CS Assignment 3",
            dueAt: Date().addingTimeInterval(86400 * 3)
        ),
        onSave: { _ in }
    )
    .frame(width: 300)
    .padding()
    .background(Color(white: 0.9))
}
