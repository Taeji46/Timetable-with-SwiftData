import SwiftUI
import SwiftData

@Model
final class Table {
    var id = UUID()
    var title: String
    var numOfDays: Int
    var numOfPeriods: Int
    
    init() {
        title = "TIMETABLE"
        numOfDays = 5
        numOfPeriods = 6
    }
}
