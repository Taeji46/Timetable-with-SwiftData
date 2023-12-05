import SwiftUI

struct TodoEditView: View {
    @State var table: Table
    @State var todo: Todo
    
    var body: some View {
        Form {
            Section(header: Text("Task")) {
                TextField("Task", text: $todo.task)
            }
            
            Section(header: Text("Course")) {
                Picker("Select a Course", selection: $todo.courseId) {
                    ForEach(table.courses) { course in
                        Text(course.name).tag(course.id.uuidString)
                    }
                }
                .pickerStyle(.menu)
                .labelsHidden()
            }
            
            Section(header: Text("Date")) {
                DatePicker("Date", selection: $todo.date)
                    .labelsHidden()
            }
            
            Section() {
                Toggle("Notification", isOn: $todo.isNotificationScheduled)
            }
        }
        .navigationBarTitle(todo.task)
    }
}
