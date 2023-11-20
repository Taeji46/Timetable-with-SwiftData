import SwiftUI
import SwiftData

struct SettingView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage(wrappedValue: 0, "appearanceMode") var appearanceMode
    @State var table: Table
    @State var isShowingAlert: Bool
    
    init(table: Table) {
        self.table = table
        isShowingAlert = false
    }
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Title of timetable")) {
                    TextField("Title", text: $table.title)
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
                    HStack {
                        ForEach(themeColorTemplates) { colorTemplate in
                            Button(action: {}) {
                                Circle()
                                    .fill(colorTemplate.color.opacity(0.75))
                                    .frame(width: 30, height: 30)
                            }
                            .overlay(
                                Circle()
                                    .stroke(table.getSelectedColor() == colorTemplate.color ? Color.blue : Color.clear, lineWidth: 2)
                            )
                            .onTapGesture {
                                table.colorName = colorTemplate.name
                            }
                            .padding(.horizontal, 5)
                        }
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
                    if table.periods.count > 0 { // Table削除の際のOutOfRangeエラーの回避
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
                        isShowingAlert = true
                    }) {
                        Text("Reset the Timetable")
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(
                title: Text("Confirm Reset"),
                message: Text("Are you sure you want to delete this timetable?"),
                primaryButton: .destructive(Text("Reset")) {
                    table.setAllCoursesNotification(value: false)
                    table.updateNotificationSetting()
                    modelContext.delete(table)
                },
                secondaryButton: .cancel()
            )
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
}

enum AppearanceModeSetting: Int {
    case followSystem = 0
    case lightMode = 1
    case darkMode = 2
    
    var colorScheme: ColorScheme? {
        switch self {
        case .followSystem:
            return .none
        case .lightMode:
            return .light
        case .darkMode:
            return .dark
        }
    }
}
