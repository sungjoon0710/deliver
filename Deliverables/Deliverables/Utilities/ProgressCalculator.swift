import Foundation

struct ProgressCalculator {
    /// Calculates logarithmic progress from 100% (at creation) to 0% (at due date)
    /// Formula: ln(1 + remaining) / ln(1 + total)
    /// - Parameters:
    ///   - createdAt: When the deliverable was created
    ///   - dueAt: When the deliverable is due
    ///   - currentDate: The current date (defaults to now)
    /// - Returns: Progress value between 0.0 and 1.0
    static func calculateProgress(createdAt: Date, dueAt: Date, currentDate: Date = Date()) -> Double {
        let total = dueAt.timeIntervalSince(createdAt)
        let remaining = dueAt.timeIntervalSince(currentDate)
        
        // If overdue or at deadline, return 0
        guard remaining > 0, total > 0 else {
            return 0.0
        }
        
        // If current time is before creation (edge case), return 1
        if remaining >= total {
            return 1.0
        }
        
        // Logarithmic progress: ln(1 + remaining) / ln(1 + total)
        // Adding 1 to avoid log(0) issues
        let progress = log(1 + remaining) / log(1 + total)
        
        return min(max(progress, 0.0), 1.0)
    }
    
    /// Returns the progress for a deliverable
    static func progress(for deliverable: Deliverable) -> Double {
        return calculateProgress(createdAt: deliverable.createdAt, dueAt: deliverable.dueAt)
    }
}
