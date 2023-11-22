import SwiftUI

enum AppearanceModeSetting: Int {
    case followSystem = 0
    case lightMode = 1
    case darkMode = 2
    
    var colorScheme: ColorScheme? {
        switch self {
        case .followSystem:
            return .none
        case .lightMode:
            return .light
        case .darkMode:
            return .dark
        }
    }
}
