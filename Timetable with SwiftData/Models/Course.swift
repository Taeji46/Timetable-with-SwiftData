import SwiftUI
import SwiftData

@Model
final class Course {
    var table: Table? // parent
    
    var id = UUID()
    var name: String
    var classroom: String
    var teacher: String
    var day: Int
    var period: Int
    var duration: Int
    @Relationship(deleteRule: .cascade, inverse: \Attendance.course) var attendanceRecords: [Attendance]
    @Relationship(deleteRule: .cascade, inverse: \Note.course) var notes: [Note]
    var colorName: String
    
    init(name: String, classroom: String, teacher: String, day: Int, period: Int, duration: Int, colorName: String) {
        self.name = name
        self.classroom = classroom
        self.teacher = teacher
        self.day = day
        self.period = period
        self.duration = duration
        attendanceRecords = []
        notes = []
        self.colorName = colorName
    }

    func getSelectedColor() -> Color { // 講義の色を取得
        for color in CourseColors.allCases {
            if color.rawValue == colorName {
                return color.colorData
            }
        }
        return Color.clear
    }
    
    func getPeriodInfoText() -> String { // 講義が何限目かをテキストで取得
        var periodInfoText: String
        switch(period) {
        case 1:
            periodInfoText = String(period) + String(localized: "st period")
        case 2:
            periodInfoText = String(period) + String(localized: "nd period")
        case 3:
            periodInfoText = String(period) + String(localized: "rd period")
        default:
            periodInfoText = String(period) + String(localized: "th period")
        }
        return periodInfoText
    }
    
    func countAttendance(status: AttendanceStatus) -> Int { // statusを引数として受け取りattendanceRecords内から数え上げる
        let filteredAttendance = attendanceRecords.filter { $0.status == status }
        return filteredAttendance.count
    }
    
    func getLastPeriod() -> Int {
        return period + duration - 1
    }
}
