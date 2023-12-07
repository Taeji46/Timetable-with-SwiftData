import SwiftUI
import SwiftData

struct AddNewTodoView: View {
    @Environment(\.dismiss) var dismiss
    @State var table: Table
    
    @State var task: String = ""
    @State var courseId: String = ""
    @State var date: Date = Date()
    @State var isNotificationScheduled: Bool = false
    
    var body: some View {
        Form {
            Section(header: Text("Task")) {
                TextField("Task", text: $task)
            }
            
            Section(header: Text("Course")) {
                if table.courses.isEmpty {
                    Text("No Courses on the Timetable")
                        .foregroundColor(.red)
                } else {
                    Picker("Select a Course", selection: $courseId) {
                        Text("Unselected").tag("")
                        ForEach(table.courses.sorted { ($0.day, $0.period) < ($1.day, $1.period) }) { course in
                            Text(course.name).tag(course.id.uuidString)
                        }
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                }
            }
            
            Section(header: Text("Date")) {
                DatePicker("Date", selection: $date)
                    .labelsHidden()
            }
            
            Section() {
                Toggle("Notification", isOn: $isNotificationScheduled)
            }
            
            Section {
                Button(action: {
                    addTodo()
                    dismiss()
                }, label: {
                    Text("Add to Todo List")
                }).disabled(task.isEmpty || courseId.isEmpty)
            }
        }
        .navigationBarTitle("Add a New Todo")
    }
    
    func addTodo() {
        table.todoList.append(Todo(task: task, courseId: courseId, date: date, isNotificationScheduled: isNotificationScheduled))
    }
}
