import SwiftUI

struct CourseEditView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @State var course: Course
    @State var isShowingAlert = false
    @State var selectedColor: Color
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Course Name")) {
                    TextField("Course Name", text: $course.name)
                }
                Section(header: Text("Classroom")) {
                    TextField("Classroom", text: $course.classroom)
                }
                Section(header: Text("Teacher")) {
                    TextField("Teacher", text: $course.teacher)
                }
                Section() {
                    if !course.isCourseEmpty() {
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
        .alert(isPresented: $isShowingAlert) {
            Alert(
                title: Text("Confirm Deletion"),
                message: Text("Are you sure you want to delete this course?"),
                primaryButton: .destructive(Text("Delete")) {
                    modelContext.delete(course)
                    dismiss()
                },
                secondaryButton: .cancel()
            )
        }
    }
}
