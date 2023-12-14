import SwiftUI
import SwiftData

struct SelectTableView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Query private var tables: [Table]
    @Binding var selectedTableId: String
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(colorScheme == .dark ? .indigo.opacity(0.15) : .indigo.opacity(0.15))
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: true) {
                    VStack {
                        ForEach(tables) { table in
                            Button(action: {
                                selectedTableId = table.id.uuidString
                            }, label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(colorScheme == .dark ? .black : .white)
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(table.getSelectedColor().opacity(0.75))
                                        .shadow(color: colorScheme == .dark ? .black : .gray, radius: 3, x: 3, y: 3)
                                    
                                    Text(table.title)
                                        .bold()
                                        .padding()
                                        .foregroundColor(Color.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.925, height: 50)
                                .padding(.bottom, 4)
                            })
                        }
                    }
                    .padding(.top, UIScreen.main.bounds.width * (1.0 - 0.925) / 2.0)
                    .padding([.leading, .trailing], 8)
                }
            }
            .toolbar {
                ToolbarItem {
                    NavigationLink(destination: {
                        AddNewTableView(selectedTableId: $selectedTableId)
                    }, label: {
                        Label("Add Table", systemImage: "plus")
                    })
                }
            }
//            .toolbar {
//                ToolbarItem {
//                    Button (action: {
//                        addTestData()
//                    }, label: {
//                        Label("Add Table", systemImage: "minus")
//                    })
//                }
//            }
            .navigationBarTitle("Timetable List", displayMode: .inline)
        }
        .accentColor(colorScheme == .dark ? .white : .indigo)
    }
    
    func getTable() -> Table {
        return tables.first(where: { $0.id.uuidString == selectedTableId }) ?? tables[0]
    }
    
//    func addTestData() {
//        let newTable = Table(title: "2023年度後期", colorName: "indigo", numOfPeriods: 5)
//        newTable.periods = (1...10).map { Period(index: $0) }
//        newTable.selectedDays = [0, 1, 2, 3, 4]
//        modelContext.insert(newTable)
//        
//        let course02 = Course(name: "英語A", classroom: "F407", teacher: "大野誠", day: 0, period: 2, duration: 1, credits: 1, colorName: "red")
//        newTable.courses.append(course02)
//        let course03 = Course(name: "データベース基礎", classroom: "E202", teacher: "山田太郎", day: 0, period: 3, duration: 1, credits: 2, colorName: "mint")
//        newTable.courses.append(course03)
//        
//        let course04 = Course(name: "線形代数", classroom: "E203", teacher: "田中太郎", day: 0, period: 4, duration: 1, credits: 2, colorName: "blue")
//        newTable.courses.append(course04)
//        
//        let course11 = Course(name: "中国語A", classroom: "B103", teacher: "王小明", day: 1, period: 1, duration: 1, credits: 1, colorName: "red")
//        newTable.courses.append(course11)
//        
//        let course12 = Course(name: "微分積分", classroom: "D203", teacher: "高橋恵", day: 1, period: 2, duration: 1, credits: 2, colorName: "blue")
//        newTable.courses.append(course12)
//        
//        let course14 = Course(name: "プログラミング実習I", classroom: "O103", teacher: "森田理恵", day: 1, period: 4, duration: 2, credits: 2, colorName: "teal")
//        newTable.courses.append(course14)
//        
//        let course23 = Course(name: "情報セキュリティ", classroom: "E103", teacher: "鈴木一郎", day: 2, period: 3, duration: 1, credits: 2, colorName: "mint")
//        newTable.courses.append(course23)
//        
//        let course24 = Course(name: "化学実験I", classroom: "E103", teacher: "小林誠司", day: 2, period: 4, duration: 2, credits: 2, colorName: "pink")
//        newTable.courses.append(course24)
//        
//        let course32 = Course(name: "人工知能基礎", classroom: "B303", teacher: "竹内純一", day: 3, period: 2, duration: 1, credits: 2, colorName: "purple")
//        newTable.courses.append(course32)
//        
//        let course34 = Course(name: "英語B", classroom: "F408", teacher: "佐々木美和", day: 3, period: 4, duration: 1, credits: 1, colorName: "red")
//        newTable.courses.append(course34)
//        
//        let course35 = Course(name: "キリスト教", classroom: "Zoom", teacher: "佐藤花子", day: 3, period: 5, duration: 1, credits: 2, colorName: "orange")
//        newTable.courses.append(course35)
//        
//        let course42 = Course(name: "倫理学", classroom: "Zoom", teacher: "中村四郎", day: 4, period: 2, duration: 1, credits: 2, colorName: "orange")
//        newTable.courses.append(course42)
//        
//        let course43 = Course(name: "中国語", classroom: "Webex", teacher: "李麗華", day: 4, period: 3, duration: 1, credits: 1, colorName: "red")
//        newTable.courses.append(course43)
//        
//        let toDo111 = ToDo(table: newTable, title: "拼音のテスト勉強", courseId: course11.id.uuidString, dueDate: Calendar.current.date(from: DateComponents(year: 2023, month: 12, day: 13, hour: 17, minute: 0, second: 0)) ?? Date()
//, isNotificationScheduled: true, notificationTime: 60)
//        newTable.toDoList.append(toDo111)
//        
//        let toDo141 = ToDo(table: newTable, title: "Practice1~3 提出", courseId: course14.id.uuidString, dueDate: Calendar.current.date(from: DateComponents(year: 2023, month: 12, day: 14, hour: 22, minute: 0, second: 0)) ?? Date()
//, isNotificationScheduled: true, notificationTime: 60)
//        newTable.toDoList.append(toDo141)
//        
//        let toDo142 = ToDo(table: newTable, title: "Advance1~2 提出", courseId: course14.id.uuidString, dueDate: Calendar.current.date(from: DateComponents(year: 2023, month: 12, day: 18, hour: 22, minute: 0, second: 0)) ?? Date()
//, isNotificationScheduled: false, notificationTime: 60)
//        newTable.toDoList.append(toDo142)
//        
//        let toDo143 = ToDo(table: newTable, title: "小テスト勉強", courseId: course14.id.uuidString, dueDate: Calendar.current.date(from: DateComponents(year: 2023, month: 12, day: 14, hour: 9, minute: 0, second: 0)) ?? Date()
//, isNotificationScheduled: false, notificationTime: 60)
//        toDo143.isCompleted = true
//        newTable.toDoList.append(toDo143)
//        
//        let toDo241 = ToDo(table: newTable, title: "実験レポート提出", courseId: course24.id.uuidString, dueDate: Calendar.current.date(from: DateComponents(year: 2023, month: 12, day: 17, hour: 22, minute: 0, second: 0)) ?? Date()
//, isNotificationScheduled: true, notificationTime: 60)
//        newTable.toDoList.append(toDo241)
//        
//        let toDo351 = ToDo(table: newTable, title: "礼拝レポート提出", courseId: course35.id.uuidString, dueDate: Calendar.current.date(from: DateComponents(year: 2023, month: 12, day: 21, hour: 21, minute: 0, second: 0)) ?? Date()
//, isNotificationScheduled: true, notificationTime: 60)
//        newTable.toDoList.append(toDo351)
//        
//        let note141 = Note(course: course14, title: "テスト範囲", detail: "if-else文・for文")
//        course14.notes.append(note141)
//        
//        let note142 = Note(course: course14, title: "成績評価", detail: "課題提出：60%， 小テスト：20%，出席：20%")
//        course14.notes.append(note142)
//        
//        let ar141 = Attendance(status: .attend, date: Calendar.current.date(from: DateComponents(year: 2023, month: 12, day: 7, hour: 0, minute: 0, second: 0)) ?? Date())
//        course14.attendanceRecords.append(ar141)
//        
//        let ar142 = Attendance(status: .attend, date: Calendar.current.date(from: DateComponents(year: 2023, month: 11, day: 30, hour: 0, minute: 0, second: 0)) ?? Date())
//        course14.attendanceRecords.append(ar142)
//        
//        let ar143 = Attendance(status: .late, date: Calendar.current.date(from: DateComponents(year: 2023, month: 11, day: 23, hour: 0, minute: 0, second: 0)) ?? Date())
//        course14.attendanceRecords.append(ar143)
//        
//        let ar144 = Attendance(status: .attend, date: Calendar.current.date(from: DateComponents(year: 2023, month: 11, day: 16, hour: 0, minute: 0, second: 0)) ?? Date())
//        course14.attendanceRecords.append(ar144)
//        
//        let ar145 = Attendance(status: .absent, date: Calendar.current.date(from: DateComponents(year: 2023, month: 11, day: 9, hour: 0, minute: 0, second: 0)) ?? Date())
//        course14.attendanceRecords.append(ar145)
//        
//        let ar146 = Attendance(status: .absent, date: Calendar.current.date(from: DateComponents(year: 2023, month: 11, day: 2, hour: 0, minute: 0, second: 0)) ?? Date())
//        course14.attendanceRecords.append(ar146)
//        
//        let ar147 = Attendance(status: .attend, date: Calendar.current.date(from: DateComponents(year: 2023, month: 10, day: 26, hour: 0, minute: 0, second: 0)) ?? Date())
//        course14.attendanceRecords.append(ar147)
//        
//        let ar148 = Attendance(status: .attend, date: Calendar.current.date(from: DateComponents(year: 2023, month: 10, day: 19, hour: 0, minute: 0, second: 0)) ?? Date())
//        course14.attendanceRecords.append(ar148)
//        
//        let ar149 = Attendance(status: .attend, date: Calendar.current.date(from: DateComponents(year: 2023, month: 10, day: 12, hour: 0, minute: 0, second: 0)) ?? Date())
//        course14.attendanceRecords.append(ar149)
//        
//        let ar1410 = Attendance(status: .attend, date: Calendar.current.date(from: DateComponents(year: 2023, month: 10, day: 5, hour: 0, minute: 0, second: 0)) ?? Date())
//        course14.attendanceRecords.append(ar1410)
//        
//        newTable.periods.first(where: {$0.index == 1})?.startTime = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()
//        
//        newTable.periods.first(where: {$0.index == 1})?.endTime = Calendar.current.date(bySettingHour: 10, minute: 30, second: 0, of: Date()) ?? Date()
//        
//        newTable.periods.first(where: {$0.index == 2})?.startTime = Calendar.current.date(bySettingHour: 11, minute: 0, second: 0, of: Date()) ?? Date()
//        
//        newTable.periods.first(where: {$0.index == 2})?.endTime = Calendar.current.date(bySettingHour: 12, minute: 30, second: 0, of: Date()) ?? Date()
//        
//        newTable.periods.first(where: {$0.index == 3})?.startTime = Calendar.current.date(bySettingHour: 13, minute: 20, second: 0, of: Date()) ?? Date()
//        
//        newTable.periods.first(where: {$0.index == 3})?.endTime = Calendar.current.date(bySettingHour: 14, minute: 50, second: 0, of: Date()) ?? Date()
//        
//        newTable.periods.first(where: {$0.index == 4})?.startTime = Calendar.current.date(bySettingHour: 15, minute: 5, second: 0, of: Date()) ?? Date()
//        
//        newTable.periods.first(where: {$0.index == 4})?.endTime = Calendar.current.date(bySettingHour: 16, minute: 35, second: 0, of: Date()) ?? Date()
//        
//        newTable.periods.first(where: {$0.index == 5})?.startTime = Calendar.current.date(bySettingHour: 16, minute: 50, second: 0, of: Date()) ?? Date()
//        
//        newTable.periods.first(where: {$0.index == 5})?.endTime = Calendar.current.date(bySettingHour: 18, minute: 20, second: 0, of: Date()) ?? Date()
//    }
}
