import SwiftUI
import SwiftData

struct WelcomeView: View {
    @AppStorage(wrappedValue: 0, "appearanceMode") var appearanceMode
    @Environment(\.modelContext) private var modelContext
    @Binding var selectedTableId: String
    @Query private var tables: [Table]
    
    @State var title: String = ""
    @State var colorName: String = "blue"
    @State var selectedColor: Color = .blue
    @State var selectedNumOfDays: Int = 5
    @State var selectedNumOfPeriods: Int = 5
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Title of Timetable")) {
                    TextField("Title of Timetable", text: $title)
                }
                
                Section(header: Text("Appearance mode")) {
                    Picker("Appearance Setting", selection: $appearanceMode) {
                        Text("System")
                            .tag(0)
                        Text("Light")
                            .tag(1)
                        Text("Dark")
                            .tag(2)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Theme")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(ThemeColors.allCases, id: \.self) { color in
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
                
                Section(header: Text("Days of the Week")) {
                    Picker("Days Count", selection: $selectedNumOfDays) {
                        Text(String(localized: "MON") + " ~ " + String(localized: "FRI")).tag(5)
                        Text(String(localized: "MON") + " ~ " + String(localized: "SAT")).tag(6)
                        Text(String(localized: "MON") + " ~ " + String(localized: "SUN")).tag(7)
                    }
                    .pickerStyle(SegmentedPickerStyle())
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
                }
                
                Section {
                    Button(action: {
                        addTable()
                    }, label: {
                        Text("Create a New Timetable")
                    }).disabled(title.isEmpty)
                }
            }
            .navigationBarTitle("Welcome")
        }
    }
    
    private func addTable() {
        let newTable = Table(title: title, colorName: colorName, numOfDays: selectedNumOfDays, numOfPeriods: selectedNumOfPeriods)
        modelContext.insert(newTable)
        selectedTableId = newTable.id.uuidString
    }
}
