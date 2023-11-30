import SwiftUI
import SwiftData

struct SettingView: View {
    enum AlertType {
        case showTableList
        case deleteTable
    }
    
    @Environment(\.presentationMode) var presentationMode
    @AppStorage(wrappedValue: 0, "appearanceMode") var appearanceMode
    @Query private var tables: [Table]
    @Binding var selectedTableId: String
    @State var table: Table
    @State var isShowingAlert: Bool = false
    @State var alertType: AlertType = .showTableList
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Title of Timetable")) {
                    TextField("Title of Timetable", text: $table.title)
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
                                            .stroke(table.getSelectedColor() == color.colorData ? Color.blue : Color.clear, lineWidth: 2)
                                    )
                                    .onTapGesture {
                                        table.colorName = color.rawValue
                                    }
                                    .padding(.horizontal, 5)
                            }
                        }
                        .frame(height: 34)
                    }
                }
                Section(header: Text("Days of the Week")) {
                    Picker("Days Count", selection: $table.numOfDays) {
                        Text(String(localized: "MON") + " ~ " + String(localized: "FRI")).tag(5)
                        Text(String(localized: "MON") + " ~ " + String(localized: "SAT")).tag(6)
                        Text(String(localized: "MON") + " ~ " + String(localized: "SUN")).tag(7)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Number of periods")) {
                    Picker("Periods Count", selection: $table.numOfPeriods) {
                        Text("5").tag(5)
                        Text("6").tag(6)
                        Text("7").tag(7)
                        Text("8").tag(8)
                        Text("9").tag(9)
                        Text("10").tag(10)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Time range of periods")) {
                    List {
                        ForEach(table.periods.sorted { $0.index < $1.index }, id: \.self) { period in // period[].indexの昇順に繰り返し
                            if period.index < table.numOfPeriods {
                                HStack {
                                    Text("\(period.index + 1)")
                                        .frame(width: 20)
                                    Divider()
                                    DatePicker("Start", selection: $table.periods[table.periods.firstIndex(of: period)!].startTime, in: getMinStartTime(period: period.index)..., displayedComponents: .hourAndMinute)
                                        .onChange(of: $table.periods[table.periods.firstIndex(of: period)!].startTime.wrappedValue) {
                                            table.updateNotificationSetting()
                                        }
                                    Divider()
                                    DatePicker("End", selection: $table.periods[table.periods.firstIndex(of: period)!].endTime, in: getMinEndTime(period: period.index)..., displayedComponents: .hourAndMinute)
                                        .onChange(of: $table.periods[table.periods.firstIndex(of: period)!].endTime.wrappedValue) {
                                            table.updateNotificationSetting()
                                        }
                                }
                            }
                        }
                    }
                }
                Section(header: Text("Notification time (minutes before)")) {
                    Picker("", selection: $table.notificationTime) {
                        Text("5").tag(5)
                        Text("10").tag(10)
                        Text("15").tag(15)
                        Text("20").tag(20)
                        Text("30").tag(30)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: $table.notificationTime.wrappedValue) {
                        table.updateNotificationSetting()
                    }
                }
                Section() {
                    if !table.isAllCoursesNotificationScheduled(value: true) {
                        Button(action: {
                            table.setAllCoursesNotification(value: true)
                            table.updateNotificationSetting()
                        }, label: {
                            Text("Turn on notifications for all courses")
                                .foregroundColor(.green)
                        })
                    }
                    if !table.isAllCoursesNotificationScheduled(value: false) {
                        Button(action: {
                            table.setAllCoursesNotification(value: false)
                            table.updateNotificationSetting()
                        }, label: {
                            Text("Turn off notifications for all courses")
                                .foregroundColor(.red)
                        })
                    }
                }
                Section() {
                    Button(action: {
                        alertType = .showTableList
                        isShowingAlert.toggle()
                    }) {
                        Text("List of Timetables")
                            .foregroundColor(.blue)
                    }
                }
                Section() {
                    Button(action: {
                        alertType = .deleteTable
                        isShowingAlert.toggle()
                    }) {
                        Text("Reset the Timetable")
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .alert(isPresented: $isShowingAlert) {
            switch alertType {
            case .showTableList:
                return Alert(
                    title: Text("Confirm Notifications Off"),
                    message: Text("Notifications for the current timetable will be turned off"),
                    primaryButton: .destructive(Text("OK")) {
                        table.setAllCoursesNotification(value: false)
                        table.updateNotificationSetting()
                        selectedTableId = "unselected"
                    },
                    secondaryButton: .cancel()
                )
            case .deleteTable:
                return Alert(
                    title: Text("Confirm Reset"),
                    message: Text("Are you sure you want to delete this timetable?"),
                    primaryButton: .destructive(Text("Reset")) {
                        table.setAllCoursesNotification(value: false)
                        table.updateNotificationSetting()
                        table.scheduledToBeDeleted = true
                        presentationMode.wrappedValue.dismiss()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .onChange(of: selectedTableId) {
            if !tables.isEmpty {
                table = getTable()
            }
        }
    }
    
    func getMinStartTime(period: Int) -> Date { // 設定できる開始時間の最小値
        var minStartTime = Calendar.current.date(from: DateComponents(hour: 0, minute: 0)) ?? Date()
        if period > 0 {
            minStartTime = table.getPeriod(index: period - 1).endTime
        }
        return minStartTime
    }
    
    func getMinEndTime(period: Int) -> Date { // 設定できる終了時間の最小値
        return table.getPeriod(index: period).startTime
    }
    
    func getTable() -> Table {
        return tables.first(where: { $0.id.uuidString == selectedTableId }) ?? tables[0]
    }
}
