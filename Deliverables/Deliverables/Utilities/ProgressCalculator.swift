import Foundation

struct ProgressCalculator {
    /// Calculates linear progress from 100% (at creation) to 0% (at due date)
    /// Formula: (dueAt - currentTime) / (dueAt - createdAt)
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
        
        // If current time is before creation (edge case), cap at 100%
        if remaining >= total {
            return 1.0
        }
        
        // Linear progress: remaining / total
        let progress = remaining / total
        
        return progress
    }
    
    /// Returns the progress for a deliverable
    static func progress(for deliverable: Deliverable) -> Double {
        return calculateProgress(createdAt: deliverable.createdAt, dueAt: deliverable.dueAt)
    }
}
