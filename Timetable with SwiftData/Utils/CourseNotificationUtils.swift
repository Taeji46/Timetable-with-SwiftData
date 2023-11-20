import SwiftUI

func scheduleWeeklyNotification(table: Table, course: Course) {
    var dateComponents = DateComponents()
    dateComponents.weekday = convertCourseDayToDCFormat(day: course.day)
    
    let startTime = Calendar.current.date(byAdding: .minute, value: -table.notificationTime, to: table.getPeriod(index: course.period).startTime) ?? Date()
    dateComponents.hour = Calendar.current.component(.hour, from: startTime)
    dateComponents.minute = Calendar.current.component(.minute, from: startTime)
    
    let calendar = Calendar.current
    if let nextWednesday = calendar.nextDate(after: Date(), matching: dateComponents, matchingPolicy: .nextTime) {
        let content = UNMutableNotificationContent()
        content.title = course.getPeriodInfoText() + ": " + course.name
        content.body = String(localized: "Classroom") + ": " + course.classroom + "\n" + String(localized: "Time") + ": " + table.getPeriod(index: course.period).getStartTimeText() + " ~ " + table.getPeriod(index: course.period).getEndTimeText()
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: calendar.dateComponents([.weekday, .hour, .minute], from: nextWednesday), repeats: true)
        
        let request = UNNotificationRequest(identifier: createNotificationIdentifier(course: course), content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            } else {
                print("Notification ON: " + createNotificationIdentifier(course: course) + ", " + String("Name") + ": " + course.name + ", " + String("Classroom") + ": " + course.classroom + ", " + String("Time") + ": " + table.getPeriod(index: course.period).getStartTimeText() + " ~ " + table.getPeriod(index: course.period).getEndTimeText() + ", " + String("Before") + ": " + String(table.notificationTime))
            }
        }
    } else {
        print("Notification could not be scheduled")
    }
}

func cancelScheduledNotification(course: Course) {
    let center = UNUserNotificationCenter.current()
    center.removePendingNotificationRequests(withIdentifiers: [createNotificationIdentifier(course: course)])
    print("Notification OFF: " + createNotificationIdentifier(course: course))
}

func createNotificationIdentifier(course: Course) -> String {
    return "NI" + String(course.day) + "-" + String(course.period)
}

func convertCourseDayToDCFormat(day: Int) -> Int {
    var result = (day + 2) % 7
    if result == 0 {
        result = 7
    }
    return result
}
