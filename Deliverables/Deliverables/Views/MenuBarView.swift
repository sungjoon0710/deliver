import SwiftUI

struct MenuBarView: View {
    @ObservedObject var dataStore: DataStore
    
    @State private var showCreateSheet = false
    
    private var sortedDeliverables: [Deliverable] {
        dataStore.sortedDeliverables
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Deliverables")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color(white: 0.1))
                
                Spacer()
                
                // Add button
                Button(action: { showCreateSheet = true }) {
                    Image(systemName: "plus")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(white: 0.4))
                }
                .buttonStyle(.plain)
                .frame(width: 24, height: 24)
                .background(Color(white: 0.95))
                .cornerRadius(4)
                .help("Add new deliverable")
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            Divider()
                .padding(.horizontal, 16)
            
            // Content
            if showCreateSheet {
                CreateDeliverableView(
                    isPresented: $showCreateSheet,
                    onCreate: { deliverable in
                        dataStore.add(deliverable)
                    }
                )
                .padding(12)
            } else if sortedDeliverables.isEmpty {
                // Empty state
                VStack(spacing: 8) {
                    Image(systemName: "checkmark.circle")
                        .font(.system(size: 32, weight: .light))
                        .foregroundColor(Color(white: 0.7))
                    
                    Text("No deliverables")
                        .font(.system(size: 12))
                        .foregroundColor(Color(white: 0.5))
                    
                    Text("Click + to add one")
                        .font(.system(size: 10))
                        .foregroundColor(Color(white: 0.6))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                // Scrollable deliverables list
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(sortedDeliverables) { deliverable in
                            DeliverableRow(
                                deliverable: deliverable,
                                onComplete: {
                                    dataStore.complete(deliverable)
                                },
                                onEdit: { updated in
                                    dataStore.update(updated)
                                },
                                onDelete: {
                                    dataStore.delete(deliverable)
                                }
                            )
                        }
                    }
                    .padding(12)
                }
                .frame(maxHeight: 400)
            }
        }
        .frame(width: 320)
        .background(Color.white)
        .onReceive(NotificationCenter.default.publisher(for: .showCreateDeliverable)) { _ in
            showCreateSheet = true
        }
    }
}

#Preview {
    let store = DataStore.shared
    return MenuBarView(dataStore: store)
}
