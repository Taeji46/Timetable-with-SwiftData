import SwiftUI
import SwiftData

@Model
final class Course {
    var id = UUID()
    var name: String
    var classroom: String
    var teacher: String
    var day: Int
    var period: Int
    var attendanceRecords: [Attendance]
    var colorName: String
    var isNotificationScheduled: Bool
    
    init(name: String, classroom: String, teacher: String, day: Int, period: Int, colorName: String) {
        self.name = name
        self.classroom = classroom
        self.teacher = teacher
        self.day = day
        self.period = period
        attendanceRecords = []
        self.colorName = colorName
        self.isNotificationScheduled = false
    }
    
    func isCourseEmpty() -> Bool {
        return name.isEmpty && classroom.isEmpty && teacher.isEmpty
    }
    
    func getSelectedColor() -> Color { // 講義の色を取得
        for colorTemplate in courseColorTemplates {
            if colorTemplate.name == colorName {
                return colorTemplate.color
            }
        }
        return Color.clear
    }
    
    func getPeriodInfoText() -> String { // 講義が何限目か
        var periodInfoText: String
        let periodNum = period + 1
        switch(periodNum) {
        case 1:
            periodInfoText = String(periodNum) + String(localized: "st period")
        case 2:
            periodInfoText = String(periodNum) + String(localized: "nd period")
        case 3:
            periodInfoText = String(periodNum) + String(localized: "rd period")
        default:
            periodInfoText = String(periodNum) + String(localized: "th period")
        }
        return periodInfoText
    }
    
    func countAttendance(status: AttendanceStatus) -> Int { // statusを引数として受け取りattendanceRecords内から数え上げる
        let filteredAttendance = attendanceRecords.filter { $0.status == status }
        return filteredAttendance.count
    }
}
