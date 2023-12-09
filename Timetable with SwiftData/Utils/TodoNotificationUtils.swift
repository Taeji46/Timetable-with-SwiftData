import SwiftUI

func scheduleTodoNotification(todo: Todo) {
    let notificationDate = Calendar.current.date(byAdding: .minute, value: -todo.notificationTime, to: todo.date) ?? Date()
    
    let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: notificationDate)
    
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    
    let content = UNMutableNotificationContent()
    content.title = String(localized: "Task") + ": " + todo.task
    content.body = String(localized: "Course") + ": " + todo.getCourse()!.name + "\n" + String(localized: "Deadline") + ": " + todo.getDueDateText()
    content.sound = UNNotificationSound.default
    
    let request = UNNotificationRequest(identifier: createTodoNotificationIdentifier(todo: todo), content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("Failed to schedule notification: \(error.localizedDescription)")
        } else {
            print("Notification ON: " + createTodoNotificationIdentifier(todo: todo) + ", " + String("Task") + ": " + todo.task + ", " + String("Course") + ": " + todo.getCourse()!.name + ", " + String("Before") + ": " + String(todo.notificationTime))
        }
    }
}

func cancelScheduledTodoNotification(todo: Todo) {
    let center = UNUserNotificationCenter.current()
    center.removePendingNotificationRequests(withIdentifiers: [createTodoNotificationIdentifier(todo: todo)])
    print("Notification OFF: " + createTodoNotificationIdentifier(todo: todo))
}

func createTodoNotificationIdentifier(todo: Todo) -> String {
    return "NI-" + String(todo.id.uuidString)
}
