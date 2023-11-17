import SwiftUI
import SwiftData

enum AttendanceStatus: String, Codable {
    case attend = "Attend"
    case absent = "Absent"
    case late = "Late"
    case canceled = "Canceled"
    
    var localizedString: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

@Model
final class Attendance {
    var id = UUID()
    var status: AttendanceStatus
    var date: Date
    
    init(id: UUID = UUID(), status: AttendanceStatus, date: Date) {
        self.id = id
        self.status = status
        self.date = date
    }
}
