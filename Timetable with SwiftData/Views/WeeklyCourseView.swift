import SwiftUI
import SwiftData

struct WeeklyCourseView: View {
    @State var course: Course
    var courseWidth: CGFloat
    var courseHeight: CGFloat
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.white)
                .frame(width: courseWidth, height: courseHeight).cornerRadius(12)
            Rectangle()
                .fill(course.getSelectedColor().opacity(0.4))
                .frame(width: courseWidth, height: courseHeight)
                .cornerRadius(12)
            VStack {
                titleView()
                classroomView()
            }
        }
        .frame(width: courseWidth, height: courseHeight)
    }
    
    func titleView() -> some View {
        return (
            Text(course.name)
                .foregroundColor(Color.black)
                .font(.system(size: 12))
                .frame(width: courseWidth - 10, height: courseHeight * 0.45, alignment: .top)
                .lineLimit(nil)
        )
    }
    
    func classroomView() -> some View {
        return (
            ZStack {
                Rectangle()
                    .fill(course.getSelectedColor())
                    .cornerRadius(4)
                
                Text(course.classroom)
                    .foregroundColor(Color.white)
                    .font(.system(size: 10))
            }
                .frame(width: courseWidth - 10, height: 15)
        )
    }
}
