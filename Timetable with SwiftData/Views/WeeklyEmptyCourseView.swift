import SwiftUI
import SwiftData

struct WeeklyEmptyCourseView: View {
    var courseWidth: CGFloat
    var courseHeight: CGFloat
    
    var body: some View {
        Rectangle()
            .fill(.gray.opacity(0.5))
            .frame(width: courseWidth, height: courseHeight)
            .cornerRadius(12)
        .frame(width: courseWidth, height: courseHeight)
    }
}
