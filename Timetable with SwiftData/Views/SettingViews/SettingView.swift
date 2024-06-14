import SwiftUI
import SwiftData

struct SettingView: View {
    enum AlertType {
        case showTableList
        case deleteTable
    }
    
    @Environment(\.presentationMode) var presentationMode
    @AppStorage(wrappedValue: 0, "appearanceMode") var appearanceMode
    @Environment(\.colorScheme) var colorScheme: ColorScheme
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
                
                Section {
                    NavigationLink(destination: {
                        TableSizeSettingView(table: table)
                    }, label: {
                        Text("Table Size")
                    })
                    NavigationLink(destination: {
                        PeriodsRangeSettingView(table: table)
                    }, label: {
                        Text("Time Range of Periods")
                    })
                }
                
                Section() {
                    Toggle("Notification of Lectures", isOn: $table.isCourseNotificationScheduled)
                        .onChange(of: table.isCourseNotificationScheduled) {
                            table.updateNotificationSetting()
                        }
                }
                
                if table.isCourseNotificationScheduled {
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
                        Text("Delete the Timetable")
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .background(colorScheme == .dark ? .indigo.opacity(0.15) : .indigo.opacity(0.15))
        .scrollContentBackground(.hidden)
        .accentColor(colorScheme == .dark ? .indigo : .indigo)
        .alert(isPresented: $isShowingAlert) {
            switch alertType {
            case .showTableList:
                return Alert(
                    title: Text("Confirm"),
                    message: Text("All notifications for this timetable will be turned off"),
                    primaryButton: .destructive(Text("OK")) {
                        table.cancelAllScheduledNotification()
//                        table.updateNotificationSetting()
                        selectedTableId = "unselected"
                    },
                    secondaryButton: .cancel()
                )
            case .deleteTable:
                return Alert(
                    title: Text("Confirm"),
                    message: Text("Are you sure you want to delete this timetable?"),
                    primaryButton: .destructive(Text("Delete")) {
                        table.cancelAllScheduledNotification()
                        table.scheduledToBeDeleted = true
                        presentationMode.wrappedValue.dismiss()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .onAppear() {
//            cancelAllSystemScheduledNotifications()
            UNUserNotificationCenter.current().getPendingNotificationRequests {
                print("Pending requests :", $0)
            }
        }
    }
    
    func getTable() -> Table {
        return tables.first(where: { $0.id.uuidString == selectedTableId }) ?? tables[0]
    }
}
