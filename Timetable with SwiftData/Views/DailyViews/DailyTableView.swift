import SwiftUI
import Colorful

struct DailyTableView: View {
    @State var table: Table
    @State var currentTime: Date
    @State private var counter = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [table.getSelectedColor().opacity(0.1), table.getSelectedColor().opacity(0.05)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            ColorfulView()
                .ignoresSafeArea()
            VStack {
                Text(getCurrentInfoText())
                ScrollView {
                    courseTableView()
                }
            }
            .onAppear {
                currentTime = getCurrentTime()
            }
            .onReceive(timer) { _ in
                currentTime = getCurrentTime()
            }
        }
    }
    
    func courseTableView() -> some View {
        return (
            VStack {
                ForEach(0..<table.numOfPeriods, id: \.self) { period in
                    if let course = table.courses.first(where: { $0.day == getCurrentDayOfWeekIndex() && $0.period == period }) {
                        if currentTime < table.getPeriod(index: course.period).endTime {
                            DailyCourseView(table: table, course: course, currentTime: getCurrentTime(), courseWidth: getCourseWidth(), courseHeight: getCourseHeight())
                        }
                    }
                }
                if !table.isCourseExistToday() {
                    Text("No lecture today.")
                        .frame(height: UIScreen.main.bounds.height * 0.6, alignment: .center)
                }
                if table.isAllCourseFinishedToday() {
                    Text("All lectures of today were finished.")
                        .frame(height: UIScreen.main.bounds.height * 0.6, alignment: .center)
                }
            }
        )
    }
    
    func getCourseHeight() -> CGFloat {
        return UIScreen.main.bounds.height / 4.0 * 0.6
    }
    
    func getCourseWidth() -> CGFloat {
        return UIScreen.main.bounds.width * 0.85
    }
}
