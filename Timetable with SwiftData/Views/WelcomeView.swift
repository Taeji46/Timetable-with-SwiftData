import SwiftUI
import SwiftData

struct WelcomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var tables: [Table]
    
    @State var title: String = "TIMETABLE"
    @State var selectedNumOfDays: Int = 5
    @State var selectedNumOfPeriods: Int = 5
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Title of timetable")) {
                    TextField("Title of Timetable", text: $title)
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
                    })
                }
            }
            .navigationBarTitle("Welcome!")
        }
    }
    
    private func addTable() {
        let newTable = Table(title: title, numOfDays: selectedNumOfDays, numOfPeriods: selectedNumOfPeriods)
        modelContext.insert(newTable)
    }
}
