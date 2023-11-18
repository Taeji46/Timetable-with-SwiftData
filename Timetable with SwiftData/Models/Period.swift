import SwiftUI
import SwiftData

@Model
final class Period {
    var index: Int
    var startTime: Date
    var endTime: Date
    
    init(index: Int) {
        self.index = index
        startTime = Calendar.current.date(from: DateComponents(hour: 0, minute: 0)) ?? Date()
        endTime = Calendar.current.date(from: DateComponents(hour: 0, minute: 0)) ?? Date()
    }
}
