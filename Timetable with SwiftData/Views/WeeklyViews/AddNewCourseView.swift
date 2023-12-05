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
    @State var duration: Int
    
    init(table: Table, day: Int, period: Int) {
        self._table = State(initialValue: table)
        self._name = State(initialValue: "")
        self._classroom = State(initialValue: "")
        self._teacher = State(initialValue: "")
        self._colorName = State(initialValue: "blue")
        self._selectedColor = State(initialValue: .blue)
        self._day = State(initialValue: day)
        self._period = State(initialValue: period)
        self._duration = State(initialValue: 1)
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
            Section(header: Text("Duration")) {
                Picker("Periods Count", selection: $duration) {
                    ForEach(1..<11) { index in
                        if (index <= getMaxAvailablePeriod() - period) {
                            Text("\(index)").tag(index)
                        }
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
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
                                        .stroke(selectedColor == color.colorData ? Color.blue : Color.clear, lineWidth: 2)
                                )
                                .onTapGesture {
                                    selectedColor = color.colorData
                                    colorName = color.rawValue
                                }
                                .padding(.horizontal, 5)
                        }
                    }
                    .frame(height: 34)
                }
            }
            Section {
                Button(action: {
                    addCourse()
                    dismiss()
                }, label: {
                    Text("Add to Timetable")
                }).disabled(name.isEmpty)
            }
        }
        .navigationBarTitle("Add a New Course")
    }
    
    private func addCourse() {
        let newCourse = Course(name: name, classroom: classroom, teacher: teacher, day: day, period: period, duration: duration, colorName: colorName)
        table.courses.append(newCourse)
    }
    
    private func getMaxAvailablePeriod() -> Int { // durationの最大の決定に利用
        return table.courses.filter { $0.day == day && $0.period > period }.map { $0.period }.min() ?? table.numOfPeriods
    }
}
