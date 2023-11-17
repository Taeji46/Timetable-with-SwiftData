import SwiftUI
import SwiftData

@Model
class Course {
    var id = UUID()
    var name: String
    var classroom: String
    var teacher: String
    var day: Int
    var period: Int
    
    init(name: String, classroom: String, teacher: String, day: Int, period: Int) {
        self.name = name
        self.classroom = classroom
        self.teacher = teacher
        self.day = day
        self.period = period
    }
    
    func isCourseEmpty() -> Bool {
        return name.isEmpty && classroom.isEmpty && teacher.isEmpty
    }
}
