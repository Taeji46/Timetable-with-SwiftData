import SwiftUI

struct CourseEditView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @State var table: Table
    @State var course: Course
    @State var selectedColor: Color
    @State var isShowingAlert = false
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Course Name")) {
                    TextField("Course Name", text: $course.name)
                        .onChange(of: course.name) {
                            table.updateNotificationSetting()
                        }
                }
                Section(header: Text("Classroom")) {
                    TextField("Classroom", text: $course.classroom)
                        .onChange(of: course.classroom) {
                            table.updateNotificationSetting()
                        }
                }
                Section(header: Text("Teacher")) {
                    TextField("Teacher", text: $course.teacher)
                        .onChange(of: course.teacher) {
                            table.updateNotificationSetting()
                        }
                }
                Section(header: Text("Color")) {
                    HStack {
                        ForEach(CourseColors.allCases, id: \.self) { color in
                            Button(action: {}) {
                                Circle()
                                    .fill(color.colorData.opacity(0.75))
                                    .frame(width: 30, height: 30)
                            }
                            .overlay(
                                Circle()
                                    .stroke(course.getSelectedColor() == color.colorData ? Color.blue : Color.clear, lineWidth: 2)
                            )
                            .onTapGesture {
                                course.colorName = color.rawValue
                            }
                            .padding(.horizontal, 5)
                        }
                    }
                }
                Section() {
                    Toggle("Notification", isOn: $course.isNotificationScheduled)
                        .onChange(of: course.isNotificationScheduled) {
                            table.updateNotificationSetting()
                        }
                }
                Section() {
                    Button(action: {
                        isShowingAlert = true
                    }) {
                        Text("Delete the course")
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
}
