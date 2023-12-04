import SwiftUI
import SwiftData
import Colorful

struct WeeklyTableView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.modelContext) private var modelContext
    @Binding var selectedTableId: String
    @Query private var tables: [Table]
    @State var table: Table
    @State var isShowingAddNewCourseView: Bool = false
    @State var newCourseDay: Int = -1
    @State var newCoursePeriod: Int = -1
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: (colorScheme == .dark ?
                           Gradient(colors: [table.getSelectedColor().opacity(0.15), table.getSelectedColor().opacity(0.15)]):
                            Gradient(colors: [table.getSelectedColor().opacity(0.15), table.getSelectedColor().opacity(0.15)])),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                weekView()
                    .padding(.top, 10)
                ScrollView(showsIndicators: false) {
                    HStack() {
                        periodView()
                        courseTableView()
                    }
                }
                Spacer()
            }
        }
        .onChange(of: selectedTableId) {
            if !tables.isEmpty {
                table = getTable()
            }
        }
    }
    
    func weekView() -> some View {
        let daysOfWeek = [String(localized: "MON"),
                          String(localized: "TUE"),
                          String(localized: "WED"),
                          String(localized: "THU"),
                          String(localized: "FRI"),
                          String(localized: "SAT"),
                          String(localized: "SUN")].prefix(upTo: table.numOfDays)
        
        return (
            HStack {
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: 20, height: 20)
                
                ForEach(daysOfWeek, id: \.self) { day in
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(colorScheme == .dark ? .black : .white)
                        
                        RoundedRectangle(cornerRadius: 12)
                            .fill(table.getSelectedColor().opacity(0.75))
                        
                        Text(day)
                            .foregroundColor(Color.white)
                            .font(.system(size: 12))
                            .bold()
                    }
                    .frame(width: getCourseWidth(), height: 20)
                }
            }
        )
    }
    
    func periodView() -> some View {
        return (
            VStack {
                ForEach(1...table.numOfPeriods, id: \.self) { period in
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(colorScheme == .dark ? .black : .white)
                        
                        RoundedRectangle(cornerRadius: 12)
                            .fill(table.getSelectedColor().opacity(0.75))
                        
                        Text(String(period))
                            .foregroundColor(Color.white)
                            .font(.system(size: 12))
                            .bold()
                    }
                    .frame(width: 20, height: getCourseHeight())
                }
            }
        )
    }
    
    func courseTableView() -> some View {
        return (
            HStack {
                ForEach(0..<table.numOfDays, id: \.self) { day in
                    VStack {
                        ForEach(0..<table.numOfPeriods, id: \.self) { period in
                            if let course = table.courses.first(where: { $0.day == day && $0.period == period }) {
                                NavigationLink(destination: {
                                    CourseView(table: table, course: course)
                                }, label: {
                                    WeeklyCourseView(course: course, courseWidth: getCourseWidth(), courseHeight: getCourseHeight())
                                })
                            } else {
                                NavigationLink(destination: {
                                    AddNewCourseView(table: table, day: day, period: period)
                                }, label: {
                                    WeeklyEmptyCourseView(courseWidth: getCourseWidth(), courseHeight: getCourseHeight())
                                })
                            }
                        }
                    }
                }
            }
        )
    }
    
    func getCourseHeight() -> CGFloat {
        if table.numOfPeriods < 7 {
            return UIScreen.main.bounds.height / CGFloat(Float(table.numOfPeriods)) * 0.6
        } else {
            return UIScreen.main.bounds.height / CGFloat(Float(6)) * 0.6
        }
    }
    
    func getCourseWidth() -> CGFloat {
        return UIScreen.main.bounds.width / CGFloat(Float(table.numOfDays)) * 0.75
    }
    
    private func addCourse(day: Int, period: Int) {
        let newCourse = Course(name: "", classroom: "", teacher: "", day: day, period: period, colorName: "Blue")
        table.courses.append(newCourse)
    }
    
    private func saveContext() {
        try? modelContext.save()
    }
    
    func getTable() -> Table {
        return tables.first(where: { $0.id.uuidString == selectedTableId }) ?? tables[0]
    }
}
