import SwiftUI
import SwiftData

@Model
final class Table {
    var id = UUID()
    var title: String
    var colorName: String
    var numOfDays: Int
    var numOfPeriods: Int
    var courses: [Course]
    var periods: [Period]
    
    init(title: String, numOfDays: Int, numOfPeriods: Int) {
        self.title = title
        colorName = "Blue"
        self.numOfDays = numOfDays
        self.numOfPeriods = numOfPeriods
        courses = []
        periods = (0..<10).map { Period(index: $0) }
    }
    
    func getSelectedColor() -> Color {
        for colorTemplate in themeColorTemplates {
            if colorTemplate.name == colorName {
                return colorTemplate.color
            }
        }
        return Color.clear
    }
    
    func isNowInLectureTime(index: Int, currentTime: Date) -> Bool { // 現在が講義時間内か
        return getPeriod(index: index)!.startTime <= currentTime && currentTime < getPeriod(index: index)!.endTime
    }
    
    func isCourseExistToday() -> Bool { // 今日講義があるか
        return courses.contains { $0.day == getCurrentDayOfWeekIndex() }
    }
    
    
    func isAllCourseFinishedToday() -> Bool { // 今日の講義が全て終了したか
        var isAllCourseFinished: Bool = false
        if let todaysLastPeriod = courses.filter({ $0.day == getCurrentDayOfWeekIndex() }).max(by: { $0.period < $1.period }) {
            if getPeriod(index: todaysLastPeriod.period)!.endTime <= getCurrentTime() {
                isAllCourseFinished = true
            }
        }
        return isAllCourseFinished
    }
    
    func getPeriod(index: Int) -> Period? {
        return periods.first { $0.index == index }
    }
}
