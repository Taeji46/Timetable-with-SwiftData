import SwiftUI

struct AddNewCourseView: View {
    @Environment(\.dismiss) var dismiss
    @State var table: Table
    @State var name: String
    @State var classroom: String
    @State var teacher: String
    @State var colorName: String
    @State var selectedColor: Color
    @State var day: Int
    @State var period: Int
    
    init(table: Table, day: Int, period: Int) {
        self._table = State(initialValue: table)
        self._name = State(initialValue: "")
        self._classroom = State(initialValue: "")
        self._teacher = State(initialValue: "")
        self._colorName = State(initialValue: "Blue")
        self._selectedColor = State(initialValue: .blue)
        self._day = State(initialValue: day)
        self._period = State(initialValue: period)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Course Name")) {
                TextField("Course Name", text: $name)
            }
            Section(header: Text("Classroom")) {
                TextField("Classroom", text: $classroom)
            }
            Section(header: Text("Teacher")) {
                TextField("Teacher", text: $teacher)
            }
            Section(header: Text("Color")) {
                HStack {
                    ForEach(courseColorTemplates) { colorTemplate in
                        Button(action: {}) {
                            Circle()
                                .fill(colorTemplate.color.opacity(0.4))
                                .frame(width: 30, height: 30)
                        }
                        .overlay(
                            Circle()
                                .stroke(selectedColor == colorTemplate.color ? Color.blue : Color.clear, lineWidth: 2)
                        )
                        .onTapGesture {
                            selectedColor = colorTemplate.color
                            colorName = colorTemplate.name
                        }
                        .padding(.horizontal, 5)
                    }
                }
            }
            Section {
                Button(action: {
                    addCourse()
                    dismiss()
                }, label: {
                    Text("Add a new course")
                }).disabled(name.isEmpty)
            }
        }
        .navigationBarTitle("Add a new course")
    }
    
    private func addCourse() {
        let newCourse = Course(name: name, classroom: classroom, teacher: teacher, day: day, period: period, colorName: colorName)
        table.courses.append(newCourse)
    }
}
