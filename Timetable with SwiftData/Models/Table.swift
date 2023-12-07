import SwiftUI
import SwiftData

@Model
final class Table {
    var id = UUID()
    var title: String
    var colorName: String
    var numOfDays: Int
    var numOfPeriods: Int
    @Relationship(deleteRule: .cascade, inverse: \Course.table) var courses: [Course]
    @Relationship(deleteRule: .cascade, inverse: \Period.table) var periods: [Period]
    @Relationship(deleteRule: .cascade, inverse: \Todo.table) var todoList: [Todo]
    var notificationTime: Int
    var scheduledToBeDeleted: Bool
    
    init(title: String, colorName: String, numOfDays: Int, numOfPeriods: Int) {
        self.title = title
        self.colorName = colorName
        self.numOfDays = numOfDays
        self.numOfPeriods = numOfPeriods
        courses = []
        periods = []
        todoList = []
        notificationTime = 5
        scheduledToBeDeleted = false
    }
    
    func initPeriods() {
        if periods.count == 0 {
            periods = (1...10).map { Period(index: $0) }
        }
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

    func updateNotificationSetting() { // isNotificationScheduledに応じて通知を設定
        for course in courses {
            if course.isNotificationScheduled {
                scheduleWeeklyNotification(table: self, course: course)
            } else {
                cancelScheduledNotification(course: course)
            }
        }
    }
    
    func isAllCoursesNotificationScheduled(value: Bool) -> Bool { // courses[].isNotificationScheduledがすべてvalueかどうか
        if value {
            return courses.allSatisfy { $0.isNotificationScheduled }
        } else {
            return !courses.contains { $0.isNotificationScheduled }
        }
    }
    
    func setAllCoursesNotification(value: Bool) {
        courses.forEach { $0.isNotificationScheduled = value }
    }
}
