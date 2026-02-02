import Foundation

struct ICSExporter {
    /// Exports deliverables to ICS format
    /// - Parameter deliverables: Array of deliverables to export
    /// - Returns: ICS formatted string
    static func export(_ deliverables: [Deliverable]) -> String {
        var ics = """
        BEGIN:VCALENDAR
        VERSION:2.0
        PRODID:-//Deliverables App//EN
        CALSCALE:GREGORIAN
        METHOD:PUBLISH
        
        """
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withYear, .withMonth, .withDay, .withTime, .withTimeZone]
        
        for deliverable in deliverables {
            let uid = deliverable.id.uuidString
            let created = formatICSDate(deliverable.createdAt)
            let due = formatICSDate(deliverable.dueAt)
            let now = formatICSDate(Date())
            
            ics += """
            BEGIN:VEVENT
            UID:\(uid)@deliverables.app
            DTSTAMP:\(now)
            DTSTART:\(created)
            DUE:\(due)
            SUMMARY:\(escapeICSText(deliverable.title))
            STATUS:NEEDS-ACTION
            X-DELIVERABLE-CREATED:\(created)
            END:VEVENT
            
            """
        }
        
        ics += "END:VCALENDAR"
        
        return ics
    }
    
    /// Exports to a file
    /// - Parameters:
    ///   - deliverables: Deliverables to export
    ///   - url: Destination URL
    static func export(_ deliverables: [Deliverable], to url: URL) throws {
        let icsContent = export(deliverables)
        try icsContent.write(to: url, atomically: true, encoding: .utf8)
    }
    
    /// Export to default location in Application Support
    static func exportToDefaultLocation(_ deliverables: [Deliverable]) throws -> URL {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let exportsDir = appSupport.appendingPathComponent("Deliverables/exports", isDirectory: true)
        
        try FileManager.default.createDirectory(at: exportsDir, withIntermediateDirectories: true)
        
        let fileURL = exportsDir.appendingPathComponent("deliverables.ics")
        try export(deliverables, to: fileURL)
        
        return fileURL
    }
    
    // MARK: - Helpers
    
    private static func formatICSDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.string(from: date)
    }
    
    private static func escapeICSText(_ text: String) -> String {
        return text
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: ";", with: "\\;")
            .replacingOccurrences(of: ",", with: "\\,")
            .replacingOccurrences(of: "\n", with: "\\n")
    }
}
