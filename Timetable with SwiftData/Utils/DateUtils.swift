import SwiftUI

func getCurrentTime() -> Date {
    var calendar = Calendar.current
    calendar.timeZone = TimeZone.current
    let components = calendar.dateComponents([.hour, .minute], from: Date())
    return calendar.date(from: components) ?? Date()
}

func getCurrentDay() -> Date {
    var calendar = Calendar.current
    calendar.timeZone = TimeZone.current
    let components = calendar.dateComponents([.year, .month, .day], from: Date())
    return calendar.date(from: components) ?? Date()
}

func getCurrentDayOfWeekIndex() -> Int {
    return (Calendar.current.component(.weekday, from: Date()) + 5) % 7
}

func getCurrentInfoText() -> String {
    let dateFormatter = DateFormatter()
    let dateFormatKey =  "currentInfoText"
    let localizedFormat = NSLocalizedString(dateFormatKey, comment: "")
    dateFormatter.dateFormat = localizedFormat
    let date = Date()
    return dateFormatter.string(from: date)
}

func convertDatetoString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    let dateFormatKey =  "HH : mm"
    let localizedFormat = NSLocalizedString(dateFormatKey, comment: "")
    dateFormatter.dateFormat = localizedFormat
    return dateFormatter.string(from: date)
}
