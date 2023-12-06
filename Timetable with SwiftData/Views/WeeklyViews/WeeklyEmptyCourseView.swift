import SwiftUI

struct WeeklyEmptyCourseView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var courseWidth: CGFloat
    var courseHeight: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(colorScheme == .dark ? Color.white.opacity(0.25) : Color.white.opacity(0.5))
                .frame(width: courseWidth, height: courseHeight)
            
            if colorScheme == .light {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(
                        .shadow(.inner(color: .gray, radius: 3, x:3, y: 3))
                        .shadow(.inner(color: .white, radius: 3, x: -3, y: -3))
                    )
                    .foregroundColor(.indigo.opacity(0.15))
                    .frame(width: courseWidth, height: courseHeight)
            }
        }
    }
}
