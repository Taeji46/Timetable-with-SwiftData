import SwiftUI
import SwiftData

struct DailyCourseView: View {
    @State var table: Table
    @State var course: Course
    @State var currentTime: Date
    var courseWidth: CGFloat
    let courseInfoHeight: CGFloat = 76
    let insideFrameWidth: CGFloat = 12
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(table.isNowInLectureTime(index: course.period, currentTime: currentTime) ? .clear : .white)
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(table.isNowInLectureTime(index: course.period, currentTime: currentTime) ? course.getSelectedColor().opacity(0.4) : course.getSelectedColor().opacity(0.75))
                
                Text(String(course.period + 1))
                    .foregroundColor(Color.white)
                    .font(.system(size: 12))
                    .bold()
            }
            .frame(width: 20, height: courseInfoHeight + 18 + 3 * insideFrameWidth)
            
            NavigationLink(destination: {
                CourseView(table: table, course: course)
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(table.isNowInLectureTime(index: course.period, currentTime: currentTime) ? .clear : .white)
                    RoundedRectangle(cornerRadius: 10)
                        .fill(table.isNowInLectureTime(index: course.period, currentTime: currentTime) ? course.getSelectedColor().opacity(0.4) : course.getSelectedColor().opacity(0.75))
                    
                    VStack(spacing: 0) {
                        Spacer().frame(height: insideFrameWidth)
                        titleView()
                        Spacer().frame(height: insideFrameWidth)
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white.opacity(0.75))
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
                .fontWeight(.heavy)
                .frame(width: courseWidth - 2 * insideFrameWidth, height: 18, alignment: .leading)
                .foregroundColor(Color.white)
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
                    .foregroundColor(table.isNowInLectureTime(index: course.period, currentTime: currentTime) ? course.getSelectedColor().opacity(0.4) : course.getSelectedColor().opacity(0.75))
                    .padding(.leading, 14)
                
                Text(startTimeText + " ~ " + endTimeText)
                    .foregroundColor(table.isNowInLectureTime(index: course.period, currentTime: currentTime) ? Color.black.opacity(0.4) : Color.black)
                    .font(.system(size: 14))
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
                    .foregroundColor(table.isNowInLectureTime(index: course.period, currentTime: currentTime) ? course.getSelectedColor().opacity(0.4) : course.getSelectedColor().opacity(0.75))
                    .padding(.leading, 14)
                
                Text(course.classroom)
                    .foregroundColor(table.isNowInLectureTime(index: course.period, currentTime: currentTime) ? Color.black.opacity(0.4) : Color.black)
                    .font(.system(size: 14))
            }
                .frame(width: courseWidth - 2 * insideFrameWidth, height: 15, alignment: .leading)
        )
    }
    
    func teacherView() -> some View {
        return (
            HStack {
                Image(systemName: "person.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 14, height: 14)
                    .foregroundColor(table.isNowInLectureTime(index: course.period, currentTime: currentTime) ? course.getSelectedColor().opacity(0.4) : course.getSelectedColor().opacity(0.75))
                    .padding(.leading, 14)
                
                Text(course.teacher)
                    .foregroundColor(table.isNowInLectureTime(index: course.period, currentTime: currentTime) ? Color.black.opacity(0.4) : Color.black)
                    .font(.system(size: 14))
            }
                .frame(width: courseWidth - 2 * insideFrameWidth, height: 15, alignment: .leading)
        )
    }
}
