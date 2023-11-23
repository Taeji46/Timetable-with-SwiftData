import SwiftUI

enum ThemeColors: String, CaseIterable {
    case blue = "blue"
    case red = "red"
    case orange = "orange"
    case yellow = "yellow"
    case green = "green"
    case mint = "mint"
    case purple = "purple"
    
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
        case .mint:
            return .mint
        case .purple:
            return .purple
        }
    }
}

enum CourseColors: String, CaseIterable {
    case blue = "blue"
    case red = "red"
    case orange = "orange"
    case yellow = "yellow"
    case green = "green"
    case mint = "mint"
    case purple = "purple"
    
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
        case .mint:
            return .mint
        case .purple:
            return .purple
        }
    }
}
