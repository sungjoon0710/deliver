import Foundation
import Combine

class DataStore: ObservableObject {
    @Published private(set) var deliverables: [Deliverable] = []
    
    private let fileURL: URL
    
    static let shared = DataStore()
    
    private init() {
        // Set up storage directory
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let appDirectory = appSupport.appendingPathComponent("Deliverables", isDirectory: true)
        
        // Create directory if needed
        try? FileManager.default.createDirectory(at: appDirectory, withIntermediateDirectories: true)
        
        self.fileURL = appDirectory.appendingPathComponent("data.json")
        
        load()
    }
    
    /// Sorted deliverables by due date (soonest first)
    var sortedDeliverables: [Deliverable] {
        deliverables.sorted { $0.dueAt < $1.dueAt }
    }
    
    // MARK: - CRUD Operations
    
    func add(_ deliverable: Deliverable) {
        deliverables.append(deliverable)
        save()
    }
    
    func update(_ deliverable: Deliverable) {
        if let index = deliverables.firstIndex(where: { $0.id == deliverable.id }) {
            deliverables[index] = deliverable
            save()
        }
    }
    
    func delete(_ deliverable: Deliverable) {
        deliverables.removeAll { $0.id == deliverable.id }
        save()
    }
    
    func delete(at id: UUID) {
        deliverables.removeAll { $0.id == id }
        save()
    }
    
    func complete(_ deliverable: Deliverable) {
        // Since we hide completed items entirely, just delete it
        delete(deliverable)
    }
    
    // MARK: - Persistence
    
    private func save() {
        do {
            let data = try JSONEncoder().encode(deliverables)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("Failed to save deliverables: \(error)")
        }
    }
    
    private func load() {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            deliverables = []
            return
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            deliverables = try JSONDecoder().decode([Deliverable].self, from: data)
        } catch {
            print("Failed to load deliverables: \(error)")
            deliverables = []
        }
    }
    
    /// Force reload from disk
    func reload() {
        load()
    }
}
