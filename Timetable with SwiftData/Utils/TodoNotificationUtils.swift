import SwiftUI

func scheduleToDoNotification(toDo: ToDo) {
    let notificationDate = Calendar.current.date(byAdding: .minute, value: -toDo.notificationTime, to: toDo.dueDate) ?? Date()
    
    let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: notificationDate)
    
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    
    let content = UNMutableNotificationContent()
    content.title = String(localized: "ToDo: ") + toDo.title
    content.body = String(localized: "Course: ") + toDo.getCourse()!.name + "\n" + String(localized: "Due Date: ") + toDo.getDueDateText()
    content.sound = UNNotificationSound.default
    
    let request = UNNotificationRequest(identifier: createToDoNotificationIdentifier(toDo: toDo), content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("Failed to schedule notification: \(error.localizedDescription)")
        } else {
            print("Notification ON: " + createToDoNotificationIdentifier(toDo: toDo) + ", " + String("Task") + ": " + toDo.title + ", " + String("Course") + ": " + toDo.getCourse()!.name + ", " + String("Before") + ": " + String(toDo.notificationTime))
        }
    }
}

func cancelScheduledToDoNotification(toDo: ToDo) {
    let center = UNUserNotificationCenter.current()
    center.removePendingNotificationRequests(withIdentifiers: [createToDoNotificationIdentifier(toDo: toDo)])
    print("Notification OFF: " + createToDoNotificationIdentifier(toDo: toDo))
}

func createToDoNotificationIdentifier(toDo: ToDo) -> String {
    return "NI-" + String(toDo.id.uuidString)
}
