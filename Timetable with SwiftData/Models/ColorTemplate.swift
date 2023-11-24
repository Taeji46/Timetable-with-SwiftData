import SwiftUI

enum ThemeColors: String, CaseIterable {
    case blue = "blue"
    case red = "red"
    case orange = "orange"
    case green = "green"
    case mint = "mint"
    case purple = "purple"
    case pink = "pink"
    
    var colorData: Color {
        switch self {
        case .blue:
            return .blue
        case .red:
            return .red
        case .orange:
            return .orange
        case .green:
            return .green
        case .mint:
            return .mint
        case .purple:
            return .purple
        case .pink:
            return .pink
        }
    }
}

enum CourseColors: String, CaseIterable {
    case blue = "blue"
    case red = "red"
    case orange = "orange"
    case green = "green"
    case mint = "mint"
    case purple = "purple"
    case pink = "pink"
    
    var colorData: Color {
        switch self {
        case .blue:
            return .blue
        case .red:
            return .red
        case .orange:
            return .orange
        case .green:
            return .green
        case .mint:
            return .mint
        case .purple:
            return .purple
        case .pink:
            return .pink
        }
    }
}
