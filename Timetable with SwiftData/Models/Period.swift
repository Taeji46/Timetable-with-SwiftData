import SwiftUI
import SwiftData

@Model
final class Period {
    var id = UUID()
    var index: Int
    var startTime: Date
    var endTime: Date
    
    init(index: Int) {
        self.index = index
        startTime = Calendar.current.date(from: DateComponents(hour: 0, minute: 0)) ?? Date()
        endTime = Calendar.current.date(from: DateComponents(hour: 0, minute: 0)) ?? Date()
    }

    func getStartTimeText() -> String { // 講義開始時刻 H:mm
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm"
        return dateFormatter.string(from: startTime)
    }

    func getEndTimeText() -> String { // 講義終了時刻 H:mm
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm"
        return dateFormatter.string(from: endTime)
    }
}
