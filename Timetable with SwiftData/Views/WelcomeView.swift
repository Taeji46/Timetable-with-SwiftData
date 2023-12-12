import SwiftUI
import SwiftData

struct WelcomeView: View {
    @AppStorage(wrappedValue: 0, "appearanceMode") var appearanceMode
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Binding var selectedTableId: String
    @Query private var tables: [Table]
    
    @State var title: String = ""
    @State var colorName: String = "blue"
    @State var selectedColor: Color = .blue
    @State var selectedDays: [Int] = [0, 1, 2, 3, 4]
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
                        Text("Create")
                    }).disabled(title.isEmpty || selectedDays.isEmpty)
                }
            }
            .navigationBarTitle("Welcome!")
            .background(colorScheme == .dark ? .indigo.opacity(0.15) : .indigo.opacity(0.15))
            .scrollContentBackground(.hidden)
            .accentColor(colorScheme == .dark ? .indigo : .indigo)
        }
    }
    
    private func addTable() {
        let newTable = Table(title: title, colorName: colorName, numOfPeriods: selectedNumOfPeriods)
        newTable.periods = (1...10).map { Period(index: $0) }
        newTable.selectedDays = selectedDays
        modelContext.insert(newTable)
        selectedTableId = newTable.id.uuidString
    }
}
