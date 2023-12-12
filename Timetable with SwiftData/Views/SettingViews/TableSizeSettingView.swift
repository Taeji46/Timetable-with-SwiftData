import SwiftUI

struct TableSizeSettingView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State var table: Table
    @State var selectedDays: [Int]
    @State var numOfPeriods: Int
    @State var isShowingAlert: Bool
    
    init(table: Table) {
        self._table = State(initialValue: table)
        _selectedDays = State(initialValue: table.selectedDays)
        _numOfPeriods = State(initialValue: table.numOfPeriods)
        _isShowingAlert = State(initialValue: false)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Days of the Week")) {
                ForEach(0..<8, id: \.self) { index in
                    Button(action: {
                        if selectedDays.contains(index) {
                            selectedDays.removeAll { $0 == index }
                        } else {
                            selectedDays.append(index)
                        }
                    }) {
                        HStack {
                            if selectedDays.contains(index) {
                                Image(systemName: "checkmark")
                            } else {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.clear)
                            }

                            Text(daysOfWeekForSetting[index])
                                .foregroundColor(selectedDays.contains(index) ? (colorScheme == .dark ? .white : .black) : .gray)
                        }
                    }
                }
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
                    ForEach (table.courses.filter { !selectedDays.contains($0.day) || $0.getLastPeriod() > numOfPeriods }.sorted { ($0.day, $0.period) < ($1.day, $1.period) }) { course in
                        Text(course.name)
                    }
                }
            }
            
            Section {
                Button(action: {
                    if willAnyCoursesBeDeleted() {
                        isShowingAlert = true
                    } else {
                        table.selectedDays = selectedDays
                        table.numOfPeriods = numOfPeriods
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Apply Changes")
                }.disabled(selectedDays.isEmpty)
            }
        }
        .navigationBarTitle("Table Size")
        .background(colorScheme == .dark ? .indigo.opacity(0.15) : .indigo.opacity(0.15))
        .scrollContentBackground(.hidden)
        .accentColor(colorScheme == .dark ? .indigo : .indigo)
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
        return table.courses.contains { !selectedDays.contains($0.day) || $0.getLastPeriod() > numOfPeriods }
    }
    
    func delete() {
        for course in table.courses.filter({ !selectedDays.contains($0.day) || $0.getLastPeriod() > numOfPeriods }) {
            table.deleteCourse(course: course)
            table.selectedDays = selectedDays
            table.numOfPeriods = numOfPeriods
            presentationMode.wrappedValue.dismiss()
        }
    }
}
