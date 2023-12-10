import SwiftUI

struct TodoEditView: View {
    @State var table: Table
    @State var todo: Todo
    
    var body: some View {
        Form {
            Section(header: Text("Task")) {
                TextField("Task", text: $todo.task)
                    .onChange(of: todo.task) {
                        table.updateNotificationSetting()
                    }
            }
            
            Section(header: Text("Course")) {
                Picker("Select a Course", selection: $todo.courseId) {
                    ForEach(table.courses.sorted { ($0.day, $0.period) < ($1.day, $1.period) }) { course in
                        Text(course.name).tag(course.id.uuidString)
                    }
                }
                .pickerStyle(.menu)
                .labelsHidden()
                .onChange(of: todo.courseId) {
                    table.updateNotificationSetting()
                }
            }
            
            Section(header: Text("Date")) {
//                DatePicker("Date", selection: $todo.date, in: Date()...) // 実装用
                DatePicker("Date", selection: $todo.date) //テスト用
                    .labelsHidden()
                    .onChange(of: todo.date) {
                        table.updateNotificationSetting()
                    }
            }
            
            Section() {
                Toggle("Notification", isOn: $todo.isNotificationScheduled)
                    .onChange(of: todo.isNotificationScheduled) {
                        table.updateNotificationSetting()
                    }
            }
            
            if todo.isNotificationScheduled {
                Section(header: Text("Notification time")) {
                    Picker("", selection: $todo.notificationTime) {
                        Text("At the due time").tag(0)
                        Text("15 mins before").tag(15)
                        Text("30 mins before").tag(30)
                        Text("1 hour before ").tag(60)
                        Text("3 hours before").tag(180)
                        Text("12 hours before ").tag(720)
                        Text("1 day before").tag(1440)
                        Text("3 day before").tag(4320)
                        Text("1 week before").tag(10080)
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    .onChange(of: todo.notificationTime) {
                        table.updateNotificationSetting()
                    }
                }
            }
        }
        .navigationBarTitle(todo.task)
    }
}
