import SwiftUI
import SwiftData

struct DailyCourseView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State var table: Table
    @State var course: Course
    @State var currentTime: Date
    var courseWidth: CGFloat
    let courseInfoHeight: CGFloat = 76
    let insideFrameWidth: CGFloat = 10
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(colorScheme == .dark ? .black : .white)

                RoundedRectangle(cornerRadius: 10)
                    .fill(table.isNowInLectureTime(index: course.period, currentTime: currentTime) ? course.getSelectedColor().opacity(0.35) : course.getSelectedColor().opacity(0.75))
                    .shadow(color: colorScheme == .dark ? .clear : .gray, radius: 3, x: 3, y: 3)

                Text(String(course.period + 1))
                    .font(.system(size: 12))
                    .bold()
            }
            .frame(width: 20, height: courseInfoHeight + 18 + 3 * insideFrameWidth)

            NavigationLink(destination: {
                CourseView(table: table, course: course)
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(colorScheme == .dark ? .black : .white)

                    RoundedRectangle(cornerRadius: 10)
                        .fill(table.isNowInLectureTime(index: course.period, currentTime: currentTime) ? course.getSelectedColor().opacity(0.35) : course.getSelectedColor().opacity(0.75))
                        .shadow(color: colorScheme == .dark ? .clear : .gray, radius: 3, x: 3, y: 3)

                    VStack(spacing: 0) {
                        Spacer().frame(height: insideFrameWidth)
                        titleView()
                        Spacer().frame(height: insideFrameWidth)
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(table.isNowInLectureTime(index: course.period, currentTime: currentTime) ? .white.opacity(0.5) : .white, lineWidth: 1)
                            VStack {
                                timeView()
                                classroomView()
                                teacherView()
                            }
                        }
                        .frame(width: courseWidth - 2 * insideFrameWidth, height: courseInfoHeight)
                        Spacer().frame(height: insideFrameWidth)
                    }
                }
                .frame(width: courseWidth, height: courseInfoHeight + 18 + 3 * insideFrameWidth)
            })
        }
        .foregroundColor(table.isNowInLectureTime(index: course.period, currentTime: currentTime) ? .white.opacity(0.5) : .white)
        .onAppear {
            currentTime = getCurrentTime()
        }
        .onReceive(timer) { _ in
            currentTime = getCurrentTime()
        }
    }

    func titleView() -> some View {
        return (
            Text(course.name)
                .font(.system(size: 18))
                .bold()
                .frame(width: courseWidth - 2 * insideFrameWidth, height: 18, alignment: .leading)
                .lineLimit(nil)
                .padding(.leading, 18)
        )
    }

    func timeView() -> some View {
        let startTimeText = table.getPeriod(index: course.period).getStartTimeText()
        let endTimeText = table.getPeriod(index: course.period).getEndTimeText()
        return (
            HStack {
                Image(systemName: "clock.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 14, height: 14)
                    .padding(.leading, 14)

                Text(startTimeText + " ~ " + endTimeText)
                    .font(.system(size: 14))
                    .bold()
            }
                .frame(width: courseWidth - 2 * insideFrameWidth, height: 14, alignment: .leading)
        )
    }

    func classroomView() -> some View {
        return (
            HStack {
                Image(systemName: "mappin.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 14, height: 14)
                    .padding(.leading, 14)

                Text(course.classroom)
                    .font(.system(size: 14))
                    .bold()
            }
                .frame(width: courseWidth - 2 * insideFrameWidth, height: 14, alignment: .leading)
        )
    }

    func teacherView() -> some View {
        return (
            HStack {
                Image(systemName: "person.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 14, height: 14)
                    .padding(.leading, 14)

                Text(course.teacher)
                    .font(.system(size: 14))
                    .bold()
            }
                .frame(width: courseWidth - 2 * insideFrameWidth, height: 14, alignment: .leading)
        )
    }
}
