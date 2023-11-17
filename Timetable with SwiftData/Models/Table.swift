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
    
    init(title: String, numOfDays: Int, numOfPeriods: Int) {
        self.title = title
        colorName = "Blue"
        self.numOfDays = numOfDays
        self.numOfPeriods = numOfPeriods
        courses = []
    }
    
    func getSelectedColor() -> Color {
        for colorTemplate in themeColorTemplates {
            if colorTemplate.name == colorName {
                return colorTemplate.color
            }
        }
        return Color.clear
    }
}
