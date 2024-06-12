import SwiftUI
import SwiftData

@Model
final class ToDo {
    var table: Table? // Parent
    
    var id = UUID()
    var title: String
    var courseId: String
    var dueDate: Date
    var priority: Int // Unimplemented
    var isCompleted: Bool
    var repeating: Bool // Unimplemented
    var repeatInterval: Int // Unimplemented
    var isNotificationScheduled: Bool
    var notificationTime: Int
    
    init(table: Table, title: String, courseId: String, dueDate: Date, repeating: Bool, repeatInterval: Int, isNotificationScheduled: Bool, notificationTime: Int) {
        self.title = title
        self.courseId = courseId
        self.dueDate = dueDate
        self.priority = 0
        self.isCompleted = false
        self.repeating = repeating
        self.repeatInterval = repeatInterval == 0 ? 1 : repeatInterval // 0の場合は1に設定 (アプデ対応)
        self.isNotificationScheduled = isNotificationScheduled
        self.notificationTime = notificationTime
        self.table = table // Relationは最後に書かないとエラー
    }
    
    func getCourse() -> Course? {
        return table?.courses.first(where: { $0.id.uuidString == courseId })
    }
    
    func getDueDateText() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd H:mm"
        return dateFormatter.string(from: dueDate)
    }
}
