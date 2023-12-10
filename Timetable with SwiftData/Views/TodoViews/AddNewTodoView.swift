import SwiftUI
import SwiftData

struct AddNewToDoView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State var table: Table
    
    @State var title: String
    @State var courseId: String
    @State var dueDate: Date
    @State var isNotificationScheduled: Bool
    @State var notificationTime: Int
    @State private var cameFromCourseView: Bool
    
    init(table: Table) {
        _table = State(initialValue: table)
        _title = State(initialValue: "")
        _courseId = State(initialValue: "")
        _dueDate = State(initialValue: Date())
        _isNotificationScheduled = State(initialValue: false)
        _notificationTime = State(initialValue: 0)
        _cameFromCourseView = State(initialValue: false)
    }
    
    init(table: Table, course: Course) {
        _table = State(initialValue: table)
        _title = State(initialValue: "")
        _courseId = State(initialValue: course.id.uuidString)
        _dueDate = State(initialValue: Date())
        _isNotificationScheduled = State(initialValue: false)
        _notificationTime = State(initialValue: 0)
        _cameFromCourseView = State(initialValue: true)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Title")) {
                TextField("Title", text: $title)
            }
            
            Section(header: Text("Course")) {
                if table.courses.isEmpty {
                    Text("No courses on the timetable")
                        .foregroundColor(.red)
                } else {
                    Picker("", selection: $courseId) {
                        Text("Unselected").tag("")
                        ForEach(table.courses.sorted { ($0.day, $0.period) < ($1.day, $1.period) }) { course in
                            Text(course.name).tag(course.id.uuidString)
                        }
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    .disabled(cameFromCourseView)
                }
            }
            
            Section(header: Text("Due")) {
//                DatePicker("Date", selection: $dueDate, in: Date()...) // 実装
                DatePicker("Due", selection: $dueDate) // テスト用
                    .labelsHidden()
            }
            
            Section() {
                Toggle("Notification", isOn: $isNotificationScheduled)
            }
            
            if isNotificationScheduled {
                Section(header: Text("Notification time")) {
                    Picker("", selection: $notificationTime) {
                        Text("At the due time").tag(0)
                        Text("15 mins before").tag(15)
                        Text("30 mins before").tag(30)
                        Text("1 hour before").tag(60)
                        Text("3 hours before").tag(180)
                        Text("12 hours before").tag(720)
                        Text("1 day before").tag(1440)
                        Text("3 days before").tag(4320)
                        Text("1 week before").tag(10080)
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                }
            }
            
            Section {
                Button(action: {
                    addToDo()
                    dismiss()
                }, label: {
                    Text("Create")
                }).disabled(title.isEmpty || courseId.isEmpty)
            }
        }
        .background(colorScheme == .dark ? .indigo.opacity(0.15) : .indigo.opacity(0.15))
        .scrollContentBackground(.hidden)
        .accentColor(colorScheme == .dark ? .indigo : .indigo)
        .navigationBarTitle("New ToDo")
    }
    
    func addToDo() {
        let newToDo = ToDo(table: table, title: title, courseId: courseId, dueDate: dueDate, isNotificationScheduled: isNotificationScheduled, notificationTime: notificationTime)
        table.toDoList.append(newToDo)
        table.updateNotificationSetting()
    }
}
