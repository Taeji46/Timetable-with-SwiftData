import SwiftUI
import SwiftData

@Model
final class Todo {
    var table: Table? // Parent
    
    var id = UUID()
    var task: String
    var courseId: String
    var date: Date
    var isCompleted: Bool
    var isNotificationScheduled: Bool
    var notificationTime: Int
    
    init(table: Table, task: String, courseId: String, date: Date, isNotificationScheduled: Bool, notificationTime: Int) {
        self.task = task
        self.courseId = courseId
        self.date = date
        self.isCompleted = false
        self.isNotificationScheduled = isNotificationScheduled
        self.notificationTime = notificationTime
        self.table = table // Relationは最後に書かないとエラー
    }
    
    func getCourse() -> Course? {
        return table?.courses.first(where: { $0.id.uuidString == courseId })
    }
    
    func getDueDateText() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd H:mm"
        return dateFormatter.string(from: date)
    }
}
