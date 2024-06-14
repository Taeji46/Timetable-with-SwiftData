import SwiftUI
import SwiftData

@Model
final class Table {
    var id = UUID()
    var title: String
    var colorName: String
    var selectedDays: [Int]
    var numOfPeriods: Int
    @Relationship(deleteRule: .cascade, inverse: \Course.table) var courses: [Course]
    @Relationship(deleteRule: .cascade, inverse: \Period.table) var periods: [Period]
    @Relationship(deleteRule: .cascade, inverse: \ToDo.table) var toDoList: [ToDo]
    var isCourseNotificationScheduled: Bool
    var notificationTime: Int
    var scheduledToBeDeleted: Bool
    
    init(title: String, colorName: String, numOfPeriods: Int) {
        self.title = title
        self.colorName = colorName
        self.numOfPeriods = numOfPeriods
        selectedDays = []
        courses = []
        periods = []
        toDoList = []
        isCourseNotificationScheduled = false
        notificationTime = 5
        scheduledToBeDeleted = false
    }
    
    func getSelectedColor() -> Color {
        for color in ThemeColors.allCases {
            if color.rawValue == colorName {
                return color.colorData
            }
        }
        return Color.clear
    }
    
    func getPeriod(index: Int) -> Period { // periodsからindex限の情報を取得
        return periods.first { $0.index == index } ?? Period(index: -1)
    }
    
    func isNowInLectureTime(index: Int, currentTime: Date) -> Bool { // 現在が講義時間内か
        return getPeriod(index: index).startTime <= currentTime && currentTime < getPeriod(index: index).endTime
    }
    
    func getStartTimeText(index: Int) -> String { // 講義開始時刻 H:mm
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm"
        return dateFormatter.string(from: getPeriod(index: index).startTime)
    }
    
    func getEndTimeText(index: Int) -> String { // 講義終了時刻 H:mm
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm"
        return dateFormatter.string(from: getPeriod(index: index).endTime)
    }
    
    func isCourseExistToday() -> Bool { // 今日講義があるか
        return courses.contains { $0.day == getCurrentDayOfWeekIndex() }
    }
    
    func isAllCourseFinishedToday() -> Bool { // 今日の講義が全て終了したか
        var isAllCourseFinished: Bool = false
        if let lastCourseOfToday = courses.filter({ $0.day == getCurrentDayOfWeekIndex() }).max(by: { $0.period < $1.period }) {
            if getPeriod(index: lastCourseOfToday.period + lastCourseOfToday.duration - 1).endTime <= getCurrentTime() {
                isAllCourseFinished = true
            }
        }
        return isAllCourseFinished
    }
    
    func getTotalCredits() -> Int {
        var total = 0
        for course in courses {
            total += course.credits
        }
        return total
    }

    func updateNotificationSetting() {
        if isCourseNotificationScheduled {
            for course in courses.filter({ $0.day != 7}) {
                scheduleWeeklyCourseNotification(table: self, course: course)
            }
        } else {
            for course in courses.filter({ $0.day != 7}) {
                cancelScheduledCourseNotification(course: course)
            }
        }
        
        for toDo in toDoList {
            if !toDo.isCompleted && Calendar.current.date(byAdding: .minute, value: -toDo.notificationTime, to: toDo.dueDate) ?? Date() > Date() {
                scheduleToDoNotification(toDo: toDo)
            } else {
                cancelScheduledToDoNotification(toDo: toDo)
            }
        }
    }
    
    func cancelAllScheduledNotification() {
        courses.forEach(cancelScheduledCourseNotification)
        toDoList.forEach(cancelScheduledToDoNotification)
    }
    
    func deleteCourse(course: Course) {
        cancelScheduledCourseNotification(course: course)
        for toDo in toDoList.filter({ $0.getCourse() == course }) {
            cancelScheduledToDoNotification(toDo: toDo)
        }
        toDoList.removeAll(where: { $0.courseId == course.id.uuidString })
        courses.removeAll(where: { $0 == course })
    }
}
