import SwiftUI

import UIKit

enum ThemeColors: String, CaseIterable {
    case red = "red"
    case orange = "orange"
    case green = "green"
    case mint = "mint"
    case cyan = "cyan"
    case teal = "teal"
    case blue = "blue"
    case indigo = "indigo"
    case purple = "purple"
    case pink = "pink"
    
    var colorData: Color {
        switch self {
        case .red:
            return .red
        case .orange:
            return .orange
        case .green:
            return .green
        case .mint:
            return .mint
        case .teal:
            return .teal
        case .blue:
            return .blue
        case .indigo:
            return .indigo
        case .purple:
            return .purple
        case .pink:
            return .pink
        case .cyan:
            return .cyan
        }
    }
}


enum CourseColors: String, CaseIterable {
    case red = "red"
    case orange = "orange"
    case green = "green"
    case mint = "mint"
    case cyan = "cyan"
    case teal = "teal"
    case blue = "blue"
    case indigo = "indigo"
    case purple = "purple"
    case pink = "pink"
    
    var colorData: Color {
        switch self {
        case .red:
            return .red
        case .orange:
            return .orange
        case .green:
            return .green
        case .mint:
            return .mint
        case .teal:
            return .teal
        case .blue:
            return .blue
        case .indigo:
            return .indigo
        case .purple:
            return .purple
        case .pink:
            return .pink
        case .cyan:
            return .cyan
        }
    }
}
