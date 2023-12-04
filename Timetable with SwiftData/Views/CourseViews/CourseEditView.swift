import SwiftUI

struct CourseEditView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @State var table: Table
    @State var course: Course
    @State var selectedColor: Color
    
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
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(CourseColors.allCases, id: \.self) { color in
                                Circle()
                                    .fill(color.colorData.opacity(0.75))
                                    .frame(width: 30, height: 30)
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
                        .frame(height: 34)
                    }
                }
                Section() {
                    Toggle("Notification", isOn: $course.isNotificationScheduled)
                        .onChange(of: course.isNotificationScheduled) {
                            table.updateNotificationSetting()
                        }
                }
            }
            .background(colorScheme == .dark ? course.getSelectedColor().opacity(0.05) : course.getSelectedColor().opacity(0.15))
            .scrollContentBackground(.hidden)
        }
    }
}
