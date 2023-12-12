import SwiftUI
import SwiftData

struct WeeklyTableView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.modelContext) private var modelContext
    @Binding var selectedTableId: String
    @Query private var tables: [Table]
    @State var table: Table
    @State var isShowingAddNewCourseView: Bool = false
    
    var body: some View {
        ZStack {
            Color(colorScheme == .dark ? .indigo.opacity(0.15) : .indigo.opacity(0.15))
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                weekView()
                    .padding(.top, 10)
                    .padding([.leading, .trailing], 8)
                ScrollView(showsIndicators: false) {
                    HStack() {
                        periodView()
                        courseTableView()
                    }
                    .padding([.leading, .trailing], 8)
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
        return (
            HStack {
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: 20, height: 20)
                
                ForEach(table.selectedDays.sorted(by: { $0 < $1 }), id: \.self) { day in
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(colorScheme == .dark ? .black : .white)
                        
                        RoundedRectangle(cornerRadius: 12)
                            .fill(table.getSelectedColor().opacity(0.75))
                            .shadow(color: colorScheme == .dark ? .black : .gray, radius: 3, x: 3, y: 3)
                        
                        Text(daysOfWeek[day])
                            .foregroundColor(Color.white)
                            .font(.system(size: 12))
                            .bold()
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .frame(width: getCourseWidth() - 10, height: 20)
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
                            .shadow(color: colorScheme == .dark ? .black : .gray, radius: 3, x: 3, y: 3)
                        
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
                ForEach(table.selectedDays.sorted(by: { $0 < $1 }), id: \.self) { day in
                    VStack {
                        ForEach(1...table.numOfPeriods, id: \.self) { period in
                            if let course = table.courses.first(where: { $0.day == day && $0.period <= period && period < $0.period + $0.duration }) {
                                NavigationLink(destination: {
                                    CourseView(table: table, course: course)
                                }, label: {
                                    WeeklyCourseView(table: table, course: course, courseWidth: getCourseWidth(), courseHeight: getCourseHeight())
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
                    .padding(.top, 2)
                }
            }
        )
    }
    
    func getCourseHeight() -> CGFloat {
        if table.numOfPeriods < 7 {
            return UIScreen.main.bounds.height / CGFloat(Float(table.numOfPeriods)) * 0.67
        } else {
            return UIScreen.main.bounds.height / CGFloat(Float(6)) * 0.65
        }
    }
    
    func getCourseWidth() -> CGFloat {
        return UIScreen.main.bounds.width / CGFloat(Float(table.selectedDays.count)) * 0.75
    }
    
    func getTable() -> Table {
        return tables.first(where: { $0.id.uuidString == selectedTableId }) ?? tables[0]
    }
}
