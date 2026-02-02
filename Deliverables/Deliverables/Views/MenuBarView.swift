import SwiftUI

struct MenuBarView: View {
    @ObservedObject var dataStore: DataStore
    
    @State private var showCreateSheet = false
    @State private var currentPage = 0
    
    private let itemsPerPage = 5
    
    private var sortedDeliverables: [Deliverable] {
        dataStore.sortedDeliverables
    }
    
    private var totalPages: Int {
        max(1, Int(ceil(Double(sortedDeliverables.count) / Double(itemsPerPage))))
    }
    
    private var currentPageDeliverables: [Deliverable] {
        let start = currentPage * itemsPerPage
        let end = min(start + itemsPerPage, sortedDeliverables.count)
        guard start < sortedDeliverables.count else { return [] }
        return Array(sortedDeliverables[start..<end])
    }
    
    private var hasMorePages: Bool {
        currentPage < totalPages - 1
    }
    
    private var hasPreviousPages: Bool {
        currentPage > 0
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
                // Deliverables list
                VStack(spacing: 8) {
                    ForEach(currentPageDeliverables) { deliverable in
                        DeliverableRow(
                            deliverable: deliverable,
                            onComplete: {
                                dataStore.complete(deliverable)
                                adjustPageIfNeeded()
                            },
                            onDelete: {
                                dataStore.delete(deliverable)
                                adjustPageIfNeeded()
                            }
                        )
                    }
                }
                .padding(12)
                
                // Pagination
                if totalPages > 1 {
                    Divider()
                        .padding(.horizontal, 16)
                    
                    HStack {
                        // Previous page button
                        if hasPreviousPages {
                            Button(action: { currentPage -= 1 }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "chevron.up")
                                        .font(.system(size: 10, weight: .medium))
                                    Text("Previous")
                                        .font(.system(size: 10))
                                }
                                .foregroundColor(Color(white: 0.5))
                            }
                            .buttonStyle(.plain)
                        }
                        
                        Spacer()
                        
                        // Page indicator
                        Text("\(currentPage + 1) / \(totalPages)")
                            .font(.system(size: 10))
                            .foregroundColor(Color(white: 0.5))
                        
                        Spacer()
                        
                        // Next page button
                        if hasMorePages {
                            Button(action: { currentPage += 1 }) {
                                HStack(spacing: 4) {
                                    Text("More")
                                        .font(.system(size: 10))
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 10, weight: .medium))
                                }
                                .foregroundColor(Color(white: 0.5))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
            }
        }
        .frame(width: 320)
        .background(Color.white)
    }
    
    private func adjustPageIfNeeded() {
        let newTotalPages = max(1, Int(ceil(Double(sortedDeliverables.count) / Double(itemsPerPage))))
        if currentPage >= newTotalPages {
            currentPage = max(0, newTotalPages - 1)
        }
    }
}

#Preview {
    let store = DataStore.shared
    return MenuBarView(dataStore: store)
}
