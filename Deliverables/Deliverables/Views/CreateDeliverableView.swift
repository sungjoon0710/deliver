import SwiftUI

struct CreateDeliverableView: View {
    @Binding var isPresented: Bool
    let onCreate: (Deliverable) -> Void
    
    @State private var title: String = ""
    @State private var dueDate: Date = Date().addingTimeInterval(86400) // Default: tomorrow
    
    private var isValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Text("New Deliverable")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color(white: 0.1))
                
                Spacer()
                
                Button(action: { isPresented = false }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(Color(white: 0.4))
                }
                .buttonStyle(.plain)
                .frame(width: 20, height: 20)
                .background(Color(white: 0.95))
                .cornerRadius(10)
            }
            
            Divider()
            
            // Title input
            VStack(alignment: .leading, spacing: 4) {
                Text("Title")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(Color(white: 0.42))
                
                TextField("Enter deliverable name...", text: $title)
                    .textFieldStyle(.plain)
                    .font(.system(size: 12))
                    .padding(8)
                    .background(Color(white: 0.97))
                    .cornerRadius(6)
                    .onSubmit {
                        if isValid {
                            createDeliverable()
                        }
                    }
            }
            
            // Due date picker
            VStack(alignment: .leading, spacing: 4) {
                Text("Due Date")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(Color(white: 0.42))
                
                DatePicker(
                    "",
                    selection: $dueDate,
                    in: Date()...,
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
                .foregroundColor(Color(white: 0.4))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color(white: 0.95))
                .cornerRadius(4)
                
                Button("Create") {
                    createDeliverable()
                }
                .buttonStyle(.plain)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isValid ? Color(red: 0.04, green: 0.21, blue: 0.13) : Color.gray)
                .cornerRadius(4)
                .disabled(!isValid)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(10)
    }
    
    private func createDeliverable() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }
        
        let deliverable = Deliverable(
            title: trimmedTitle,
            dueAt: dueDate
        )
        
        onCreate(deliverable)
        isPresented = false
    }
}

#Preview {
    CreateDeliverableView(
        isPresented: .constant(true),
        onCreate: { _ in }
    )
    .frame(width: 300)
    .padding()
    .background(Color(white: 0.9))
}
