import SwiftUI
import SwiftData

struct WeeklyCourseView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var table: Table
    @State var course: Course
    var courseWidth: CGFloat
    var courseHeight: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(colorScheme == .dark ? .black : .white)
            RoundedRectangle(cornerRadius: 12)
                .fill(course.getSelectedColor().opacity(0.75))
                .shadow(color: colorScheme == .dark ? .black : .gray, radius: 3, x: 3, y: 3)
                .overlay(
                    table.toDoList.filter({ $0.isCompleted == false && $0.courseId == course.id.uuidString }).count > 0
                    ? Text(String(table.toDoList.filter({ $0.isCompleted == false && $0.courseId == course.id.uuidString }).count))
                        .font(.system(size: 12))
                        .bold()
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Color.red)
                        .clipShape(Circle())
                        .offset(x: 6, y: -6)
                    : nil,
                    alignment: .topTrailing
                )
            VStack {
                titleView()
                classroomView()
            }
        }
        .frame(width: courseWidth, height: courseHeight)
    }
    
    func titleView() -> some View {
        return (
            Text(!course.name.isEmpty ? course.name : "-")
                .foregroundColor(.white)
                .font(.system(size: 12))
                .bold()
                .frame(width: courseWidth - 10, height: courseHeight * 0.45, alignment: .top)
                .lineLimit(3)
                .minimumScaleFactor(0.5)
        )
    }
    
    func classroomView() -> some View {
        return (
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(.white, lineWidth: 1)
                
                Text(!course.classroom.isEmpty ? course.classroom : "-")
                    .foregroundColor(.white)
                    .font(.system(size: 10))
                    .bold()
                    .minimumScaleFactor(0.5)
                    .frame(width: courseWidth - 14, height: 15)
            }
                .frame(width: courseWidth - 10, height: 15)
        )
    }
}
