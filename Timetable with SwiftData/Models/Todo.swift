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
    
    init(task: String, courseId: String, date: Date, isNotificationScheduled: Bool) {
        self.task = task
        self.courseId = courseId
        self.date = date
        self.isCompleted = false
        self.isNotificationScheduled = isNotificationScheduled
    }
}
