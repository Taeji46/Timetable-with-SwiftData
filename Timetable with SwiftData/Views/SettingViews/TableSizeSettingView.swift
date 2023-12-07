import SwiftUI

struct TableSizeSettingView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var table: Table
    @State var numOfDays: Int
    @State var numOfPeriods: Int
    @State var isShowingAlert: Bool
    
    init(table: Table) {
        self._table = State(initialValue: table)
        _numOfDays = State(initialValue: table.numOfDays)
        _numOfPeriods = State(initialValue: table.numOfPeriods)
        _isShowingAlert = State(initialValue: false)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Days of the Week")) {
                Picker("Days Count", selection: $numOfDays) {
                    Text(String(localized: "MON") + " ~ " + String(localized: "FRI")).tag(5)
                    Text(String(localized: "MON") + " ~ " + String(localized: "SAT")).tag(6)
                    Text(String(localized: "MON") + " ~ " + String(localized: "SUN")).tag(7)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Section(header: Text("Number of periods")) {
                Picker("Periods Count", selection: $numOfPeriods) {
                    Text("5").tag(5)
                    Text("6").tag(6)
                    Text("7").tag(7)
                    Text("8").tag(8)
                    Text("9").tag(9)
                    Text("10").tag(10)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            if willAnyCoursesBeDeleted() {
                Section(header: Text("These courses will be deleted")) {
                    ForEach (table.courses.filter { $0.day > numOfDays - 1 || $0.getLastPeriod() > numOfPeriods }.sorted { ($0.day, $0.period) < ($1.day, $1.period) }) { course in
                        Text(course.name)
                    }
                }
            }
            
            Section {
                Button(action: {
                    if willAnyCoursesBeDeleted() {
                        isShowingAlert = true
                    } else {
                        table.numOfDays = numOfDays
                        table.numOfPeriods = numOfPeriods
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Apply Changes")
                        .foregroundColor(.blue)
                }
            }
        }
        .alert(isPresented: $isShowingAlert) {
            return Alert(
                title: Text("Caution"),
                message: Text("Courses outside the range of the table will be deleted"),
                primaryButton: .destructive(Text("OK")) {
                    delete()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    func willAnyCoursesBeDeleted() -> Bool {
        return table.courses.contains { $0.day > numOfDays - 1 || $0.getLastPeriod() > numOfPeriods }
    }
    
    func delete() {
        for course in table.courses.filter({ $0.day > numOfDays - 1 || $0.getLastPeriod() > numOfPeriods }) {
            table.deleteCourse(course: course)
            table.numOfDays = numOfDays
            table.numOfPeriods = numOfPeriods
            presentationMode.wrappedValue.dismiss()
        }
    }
}
