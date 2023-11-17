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
    
    init(name: String, classroom: String, teacher: String, day: Int, period: Int) {
        self.name = name
        self.classroom = classroom
        self.teacher = teacher
        self.day = day
        self.period = period
        attendanceRecords = []
    }
    
    func isCourseEmpty() -> Bool {
        return name.isEmpty && classroom.isEmpty && teacher.isEmpty
    }
    
    func countAttendance(status: AttendanceStatus) -> Int { // statusを引数として受け取りattendanceRecords内から数え上げる
        let filteredAttendance = attendanceRecords.filter { $0.status == status }
        return filteredAttendance.count
    }
}
