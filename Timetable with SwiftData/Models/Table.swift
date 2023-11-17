import SwiftUI
import SwiftData

@Model
final class Table {
    var id = UUID()
    var title: String
    var numOfDays: Int
    var numOfPeriods: Int
    var courses: [Course]
    
    init(title: String, numOfDays: Int, numOfPeriods: Int) {
        self.title = title
        self.numOfDays = numOfDays
        self.numOfPeriods = numOfPeriods
        courses = []
    }
}
