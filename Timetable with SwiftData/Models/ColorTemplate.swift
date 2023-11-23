import SwiftUI

struct ColorTemplate: Identifiable {
    let id = UUID()
    let color: Color
    let name: String
}

enum ThemeColors: String, CaseIterable {
    case blue = "blue"
    case red = "red"
    case orange = "orange"
    case yellow = "yellow"
    case green = "green"
    
    var colorData: Color {
        switch self {
        case .blue:
            return .blue
        case .red:
            return .red
        case .orange:
            return .orange
        case .yellow:
            return .yellow
        case .green:
            return .green
        }
    }
}

enum CourseColors: String, CaseIterable {
    case blue = "blue"
    case red = "red"
    case orange = "orange"
    case yellow = "yellow"
    case green = "green"
    
    var colorData: Color {
        switch self {
        case .blue:
            return .blue
        case .red:
            return .red
        case .orange:
            return .orange
        case .yellow:
            return .yellow
        case .green:
            return .green
        }
    }
}
