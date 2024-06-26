import SwiftUI

struct ToDoEditView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.presentationMode) var presentationMode
    @State var table: Table
    @State var toDo: ToDo
    @State private var isShowingAlert = false
    
    var body: some View {
        Form {
            Section(header: Text("Title")) {
                TextField("Title", text: $toDo.title)
                    .onChange(of: toDo.title) {
                        table.updateNotificationSetting()
                    }
            }
            
            Section(header: Text("Course")) {
                Picker("Select a Course", selection: $toDo.courseId) {
                    Text("Unselected").tag("")
                    ForEach(table.courses.sorted { ($0.day, $0.period) < ($1.day, $1.period) }) { course in
                        Text(!course.name.isEmpty ? course.name : "-").tag(course.id.uuidString)
                    }
                }
                .pickerStyle(.menu)
                .labelsHidden()
                .onChange(of: toDo.courseId) {
                    table.updateNotificationSetting()
                }
            }
            
            Section(header: Text("Date")) {
                DatePicker("Date", selection: $toDo.dueDate)
                    .labelsHidden()
                    .onChange(of: toDo.dueDate) {
                        table.updateNotificationSetting()
                    }
            }
            
            Section {
                Toggle("Notification", isOn: $toDo.isNotificationScheduled)
                    .onChange(of: toDo.isNotificationScheduled) {
                        table.updateNotificationSetting()
                    }
                    .disabled(toDo.isCompleted)
            }
            
            if toDo.isNotificationScheduled {
                Section(header: Text("Notification time")) {
                    Picker("", selection: $toDo.notificationTime) {
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
                    .onChange(of: toDo.notificationTime) {
                        table.updateNotificationSetting()
                    }
                }
            }
            
            Section {
                Toggle("Repetition", isOn: $toDo.repeating)
                    .onChange(of: toDo.repeating) {
                        table.updateNotificationSetting()
                    }
            }
            
            if toDo.repeating {
                Section(header: Text("Repetition Interval")) {
                    Picker("", selection: $toDo.repeatInterval) {
                        Text("Daily").tag(1)
                        Text("Every 3 days").tag(3)
                        Text("Weekly").tag(7)
                        Text("Every 2 weeks").tag(14)
                        Text("Monthly (30 days)").tag(30)
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    .onChange(of: toDo.repeatInterval) {
                        table.updateNotificationSetting()
                    }
                }
            }
        }
        .background(colorScheme == .dark ? .indigo.opacity(0.15) : .indigo.opacity(0.15))
        .scrollContentBackground(.hidden)
        .accentColor(colorScheme == .dark ? .indigo : .indigo)
        .navigationBarTitle(!toDo.title.isEmpty ? toDo.title : "-")
        .navigationBarItems(trailing: Button(action: {
            isShowingAlert = true
        }) {
            Image(systemName: "trash")
        })
        .alert(isPresented: $isShowingAlert) {
            Alert(
                title: Text("Confirm Deletion"),
                message: Text("Are you sure you want to delete this ToDo?"),
                primaryButton: .destructive(Text("Delete")) {
                    cancelScheduledToDoNotification(toDo: toDo)
                    table.toDoList.removeAll(where: { $0 == toDo })
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
        }
    }
}
