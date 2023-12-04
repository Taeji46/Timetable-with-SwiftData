import SwiftUI
import SwiftData
import Colorful

struct DailyTableView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State var table: Table
    @Binding var selectedTableId: String
    @Query private var tables: [Table]
    @State var currentTime: Date
    @State private var counter = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let courseWidth: CGFloat = UIScreen.main.bounds.width * 0.85
    
    var body: some View {
        ZStack {
            ColorfulView()
                .ignoresSafeArea()
            
            LinearGradient(
                gradient: (colorScheme == .dark ?
                           Gradient(colors: [table.getSelectedColor().opacity(0.15), table.getSelectedColor().opacity(0.15)]):
                            Gradient(colors: [table.getSelectedColor().opacity(0.15), table.getSelectedColor().opacity(0.15)])),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text(getCurrentInfoText())
                    .font(.title)
                    .padding([.top, .leading], 14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .bold()
                ScrollView(showsIndicators: false) {
                    courseTableView()
                }
                    .padding(.top, 14)
            }
            .onAppear {
                currentTime = getCurrentTime()
            }
            .onReceive(timer) { _ in
                currentTime = getCurrentTime()
            }
        }
        .onChange(of: selectedTableId) {
            if !tables.isEmpty {
                table = getTable()
            }
        }
    }
    
    func courseTableView() -> some View {
        return (
            VStack {
                ForEach(0..<table.numOfPeriods, id: \.self) { period in
                    if let course = table.courses.first(where: { $0.day == getCurrentDayOfWeekIndex() && $0.period == period }) {
                        if currentTime < table.getPeriod(index: course.period).endTime {
                            DailyCourseView(table: table, course: course, currentTime: getCurrentTime(), courseWidth: courseWidth)
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
    
    func getTable() -> Table {
        return tables.first(where: { $0.id.uuidString == selectedTableId }) ?? tables[0]
    }
}
