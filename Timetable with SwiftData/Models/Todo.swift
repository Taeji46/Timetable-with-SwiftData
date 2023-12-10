import SwiftUI
import SwiftData

@Model
final class ToDo {
    var table: Table? // Parent
    
    var id = UUID()
    var title: String
    var courseId: String
    var dueDate: Date
    var isCompleted: Bool
    var isNotificationScheduled: Bool
    var notificationTime: Int
    
    init(table: Table, title: String, courseId: String, dueDate: Date, isNotificationScheduled: Bool, notificationTime: Int) {
        self.title = title
        self.courseId = courseId
        self.dueDate = dueDate
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
        return dateFormatter.string(from: dueDate)
    }
}
