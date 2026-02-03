import SwiftUI

struct MenuBarView: View {
    @ObservedObject var dataStore: DataStore
    @Environment(\.colorScheme) var colorScheme
    
    @State private var showCreateSheet = false
    
    private var sortedDeliverables: [Deliverable] {
        dataStore.sortedDeliverables
    }
    
    // Adaptive colors
    private var backgroundColor: Color {
        Color(NSColor.windowBackgroundColor)
    }
    
    private var primaryTextColor: Color {
        Color(NSColor.labelColor)
    }
    
    private var secondaryTextColor: Color {
        Color(NSColor.secondaryLabelColor)
    }
    
    private var tertiaryTextColor: Color {
        Color(NSColor.tertiaryLabelColor)
    }
    
    private var buttonBackgroundColor: Color {
        Color(NSColor.controlBackgroundColor)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Deliverables")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(primaryTextColor)
                
                Spacer()
                
                // Add button
                Button(action: { showCreateSheet = true }) {
                    Image(systemName: "plus")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(secondaryTextColor)
                }
                .buttonStyle(.plain)
                .frame(width: 24, height: 24)
                .background(buttonBackgroundColor)
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
                        .foregroundColor(tertiaryTextColor)
                    
                    Text("No deliverables")
                        .font(.system(size: 12))
                        .foregroundColor(secondaryTextColor)
                    
                    Text("Click + to add one")
                        .font(.system(size: 10))
                        .foregroundColor(tertiaryTextColor)
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
        .background(backgroundColor)
        .onReceive(NotificationCenter.default.publisher(for: .showCreateDeliverable)) { _ in
            showCreateSheet = true
        }
    }
}

#Preview {
    let store = DataStore.shared
    return MenuBarView(dataStore: store)
}
