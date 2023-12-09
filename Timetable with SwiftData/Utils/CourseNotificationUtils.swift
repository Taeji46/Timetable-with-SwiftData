import SwiftUI

func scheduleWeeklyCourseNotification(table: Table, course: Course) {
    var dateComponents = DateComponents()
    
    let startTime = Calendar.current.date(byAdding: .minute, value: -table.notificationTime, to: table.getPeriod(index: course.period).startTime) ?? Date()
    
    dateComponents.hour = Calendar.current.component(.hour, from: startTime)
    dateComponents.minute = Calendar.current.component(.minute, from: startTime)
    dateComponents.weekday = convertCourseDayToDCFormat(day: course.day)
    
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    
    let content = UNMutableNotificationContent()
    content.title = course.getPeriodInfoText() + ": " + course.name
    content.body = String(localized: "Classroom") + ": " + course.classroom + "\n" + String(localized: "Time") + ": " + table.getPeriod(index: course.period).getStartTimeText() + " ~ " + table.getPeriod(index: course.period).getEndTimeText()
    
    let request = UNNotificationRequest(identifier: createCourseNotificationIdentifier(course: course), content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("Failed to schedule notification: \(error.localizedDescription)")
        } else {
            print("Notification ON: " + createCourseNotificationIdentifier(course: course) + ", " + String("Name") + ": " + course.name + ", " + String("Classroom") + ": " + course.classroom + ", " + String("Time") + ": " + table.getPeriod(index: course.period).getStartTimeText() + " ~ " + table.getPeriod(index: course.period).getEndTimeText() + ", " + String("Before") + ": " + String(table.notificationTime))
        }
    }
}

func cancelScheduledCourseNotification(course: Course) {
    let center = UNUserNotificationCenter.current()
    center.removePendingNotificationRequests(withIdentifiers: [createCourseNotificationIdentifier(course: course)])
    print("Notification OFF: " + createCourseNotificationIdentifier(course: course))
}

func createCourseNotificationIdentifier(course: Course) -> String {
    return "NI" + String(course.day) + "-" + String(course.period)
}

func convertCourseDayToDCFormat(day: Int) -> Int {
    var result = (day + 2) % 7
    if result == 0 {
        result = 7
    }
    return result
}
