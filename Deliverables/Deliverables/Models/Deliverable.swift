import Foundation

struct Deliverable: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    let createdAt: Date
    var dueAt: Date
    
    init(id: UUID = UUID(), title: String, createdAt: Date = Date(), dueAt: Date) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
        self.dueAt = dueAt
    }
    
    /// Returns true if the deliverable is overdue
    var isOverdue: Bool {
        Date() >= dueAt
    }
    
    /// Formatted due date string
    var formattedDueDate: String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        
        if calendar.isDateInToday(dueAt) {
            formatter.dateFormat = "h:mm a"
            return "Today, \(formatter.string(from: dueAt))"
        } else if calendar.isDateInTomorrow(dueAt) {
            formatter.dateFormat = "h:mm a"
            return "Tomorrow, \(formatter.string(from: dueAt))"
        } else {
            formatter.dateFormat = "MMM d, h:mm a"
            return formatter.string(from: dueAt)
        }
    }
}
