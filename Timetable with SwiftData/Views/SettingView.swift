import SwiftUI
import SwiftData

struct SettingView: View {
    @Environment(\.modelContext) private var modelContext
    @State var table: Table
    @State var selectedColor: Color
    @State var selectedNumOfDays: Int
    @State var selectedNumOfPeriods: Int
    @State var isShowingAlert: Bool
    
    init(table: Table) {
        self.table = table
        selectedColor = table.getSelectedColor()
        selectedNumOfDays = table.numOfDays
        selectedNumOfPeriods = table.numOfPeriods
        isShowingAlert = false
    }
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Title")) {
                    TextField("Title", text: $table.title)
                }
                Section(header: Text("Theme")) {
                    HStack {
                        ForEach(themeColorTemplates) { colorTemplate in
                            Button(action: {}) {
                                Circle()
                                    .fill(colorTemplate.color.opacity(0.75))
                                    .frame(width: 30, height: 30)
                            }
                            .overlay(
                                Circle()
                                    .stroke(selectedColor == colorTemplate.color ? Color.blue : Color.clear, lineWidth: 2)
                            )
                            .onTapGesture {
                                selectedColor = colorTemplate.color
                                table.colorName = colorTemplate.name
                            }
                            .padding(.horizontal, 5)
                        }
                    }
                }
                Section(header: Text("Days of the Week")) {
                    Picker("Days Count", selection: $selectedNumOfDays) {
                        Text(String(localized: "MON") + " ~ " + String(localized: "FRI")).tag(5)
                        Text(String(localized: "MON") + " ~ " + String(localized: "SAT")).tag(6)
                        Text(String(localized: "MON") + " ~ " + String(localized: "SUN")).tag(7)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: selectedNumOfDays, initial: true) { oldValue, newValue in
                        table.numOfDays = newValue
                    }
                }
                Section(header: Text("Number of periods")) {
                    Picker("Periods Count", selection: $selectedNumOfPeriods) {
                        Text("5").tag(5)
                        Text("6").tag(6)
                        Text("7").tag(7)
                        Text("8").tag(8)
                        Text("9").tag(9)
                        Text("10").tag(10)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: selectedNumOfPeriods, initial: true) { oldValue, newValue in
                        table.numOfPeriods = newValue
                    }
                }
                Section() {
                    Button(action: {
                        isShowingAlert = true
                    }) {
                        Text("Reset the timetable")
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(
                title: Text("Confirm Reset"),
                message: Text("Are you sure you want to reset this timetable?"),
                primaryButton: .destructive(Text("Reset")) {
                    modelContext.delete(table)
                    resetSetting()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    func resetSetting() {
    }
}
