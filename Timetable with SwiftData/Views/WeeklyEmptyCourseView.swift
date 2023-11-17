import SwiftUI

struct WeeklyEmptyCourseView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var courseWidth: CGFloat
    var courseHeight: CGFloat
    
    var body: some View {
        Rectangle()
            .fill(colorScheme == .dark ? Color.white.opacity(0.25) : Color.white.opacity(0.5))
            .frame(width: courseWidth, height: courseHeight)
            .cornerRadius(12)
        .frame(width: courseWidth, height: courseHeight)
    }
}
