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
    @State var repeating: Bool = false
    @State var repeatInterval: Int = 7

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
                Picker("", selection: $courseId) {
                    Text("Unselected2").tag("")
                    ForEach(table.courses.sorted { ($0.day, $0.period) < ($1.day, $1.period) }) { course in
                        Text(!course.name.isEmpty ? course.name : "-").tag(course.id.uuidString)
                    }
                }
                .pickerStyle(.menu)
                .labelsHidden()
                .disabled(cameFromCourseView)
            }
            
            Section(header: Text("Due Date")) {
                DatePicker("Due Date", selection: $dueDate)
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
                Toggle("Repetition", isOn: $repeating)
            }
            
            if repeating {
                Section(header: Text("Repetition Interval")) {
                    Picker("", selection: $repeatInterval) {
                        Text("Daily").tag(1)
                        Text("Every 3 days").tag(3)
                        Text("Weekly").tag(7)
                        Text("Every 2 weeks").tag(14)
                        Text("Monthly (30 days)").tag(30)
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
                }).disabled(title.isEmpty)
            }
        }
        .background(colorScheme == .dark ? .indigo.opacity(0.15) : .indigo.opacity(0.15))
        .scrollContentBackground(.hidden)
        .accentColor(colorScheme == .dark ? .indigo : .indigo)
        .navigationBarTitle("New ToDo")
    }
    
    func addToDo() {
        let newToDo = ToDo(table: table, title: title, courseId: courseId, dueDate: dueDate, repeating: repeating, repeatInterval: repeatInterval, isNotificationScheduled: isNotificationScheduled, notificationTime: notificationTime)
        table.toDoList.append(newToDo)
        table.updateNotificationSetting()
    }
}
