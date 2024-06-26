import SwiftUI
import SwiftData

struct MainView: View {
    enum AlertType {
        case showTableList
    }
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.modelContext) private var modelContext
    @Binding var selectedTableId: String
    @Query private var tables: [Table]
    @State var table: Table
    @State var selectedTab: Int = 0
    @State var navigationTitle: String = String(localized: "Today's Lectures")
    @State var isShowingAlert: Bool = false
    @State var alertType: AlertType = .showTableList
    @State var nextTableId = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                TabView(selection: $selectedTab) {
                    DailyTableView(table: table, selectedTableId: $selectedTableId, currentTime: getCurrentTime())
                        .tabItem {
                            Image(systemName: "sun.max")
                            Text("Today")
                        }
                        .tag(0)
                    
                    WeeklyTableView(selectedTableId: $selectedTableId, table: table)
                        .tabItem {
                            Image(systemName: "calendar")
                            Text("Timetable")
                        }
                        .tag(1)
                    
                    ToDoListView(table: table, selectedTableId: $selectedTableId)
                        .tabItem {
                            Image(systemName: "checkmark.circle")
                            Text("ToDo")
                        }
                        .tag(2)
                    //                        .badge(table.toDoList.filter { $0.isCompleted == false && ($0.dueDate < Date() || Calendar.current.isDate($0.dueDate, inSameDayAs: Date()))}.count) // Overdue & Today
                        .badge(table.toDoList.filter({ $0.isCompleted == false }).count) // All
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        selectedTab == 1 ? tableDropDown : nil
                    }
                }
                .navigationBarTitle(navigationTitle, displayMode: .inline)
                .navigationBarItems(leading: menu)
                .navigationBarItems(trailing: selectedTab == 1 ? info : nil)
                .navigationBarItems(trailing:
                                        selectedTab == 2 ?
                                    Button(action: {
                    withAnimation(.easeInOut(duration: 0.75)) {
                        for toDo in table.toDoList.filter({$0.isCompleted == true}) {
                            cancelScheduledToDoNotification(toDo: toDo)
                        }
                        table.toDoList.removeAll(where: { $0.isCompleted == true })
                    }
                    
                }, label: {
                    Image(systemName: "arrow.triangle.2.circlepath")
                }) : nil
                )
                .onChange(of: selectedTab, initial: true) { oldTab, newTab in
                    switch newTab {
                    case 0:
                        navigationTitle = String(localized: "Today's Lectures")
                    case 1:
                        navigationTitle = table.title.isEmpty ? String(localized: "-") : table.title
                    case 2:
                        navigationTitle = String(localized: "ToDo")
                    default:
                        navigationTitle = String(localized: "Today's Lectures")
                    }
                }
            }
        }
        .accentColor(colorScheme == .dark ? .white : .indigo)
        .onAppear() {
//            for toDo in table.toDoList.filter({ Calendar.current.date(byAdding: .minute, value: -$0.notificationTime, to: $0.dueDate) ?? Date() < Date() }) {
//                toDo.isNotificationScheduled = false
//            }
//            
//            table.updateNotificationSetting()

            UNUserNotificationCenter.current().setBadgeCount(table.toDoList.filter({ !$0.isCompleted }).count)
        }
        .onChange(of: selectedTableId) {
            if !tables.isEmpty {
                table = getTable()
            }
            
            table.updateNotificationSetting()
            
            UNUserNotificationCenter.current().setBadgeCount(table.toDoList.filter({ !$0.isCompleted }).count)
        }
        .onChange(of: table.scheduledToBeDeleted) {
            if table.scheduledToBeDeleted {
                UNUserNotificationCenter.current().setBadgeCount(0)
                modelContext.delete(table)
                try? modelContext.save()
                selectedTableId = "unselected"
            }
        }
        .onChange(of: table.toDoList) {
            UNUserNotificationCenter.current().setBadgeCount(table.toDoList.filter({ !$0.isCompleted }).count)
        }
        .alert(isPresented: $isShowingAlert) {
            switch alertType {
            case .showTableList:
                return Alert(
                    title: Text("Confirm"),
                    message: Text("All notifications for this timetable will be turned off"),
                    primaryButton: .destructive(Text("OK")) {
                        table.cancelAllScheduledNotification()
                        selectedTableId = nextTableId
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
    
    var menu: some View {
        Menu(content: {
            NavigationLink(destination: {
                SettingView(selectedTableId: $selectedTableId, table: table)
                    .navigationTitle("Settings")
            }, label: {
                Text("Settings")
            })
            
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
        }, label: {
            Image(systemName: "list.bullet")
        })
    }
    
    var info: some View {
        Menu(content: {
            Text(String.localizedStringWithFormat(
                NSLocalizedString("Total Credits: %d", comment: ""),
                table.getTotalCredits()
            ))
            ForEach(table.periods.sorted { $0.index < $1.index }, id: \.self) { period in // period[].indexの昇順に繰り返し
                if period.index <= table.numOfPeriods {
                    Text(String.localizedStringWithFormat(
                        String(period.index) + ": " + period.getStartTimeText() + " ~ " + period.getEndTimeText()
                    ))
                }
            }
        }, label: {
            Image(systemName: "info.circle")
        })
    }
    
    var tableDropDown: some View {
        Menu(content: {
            ForEach(tables.filter({ $0.id.uuidString != selectedTableId })) { table in
                Button(action: {
                    nextTableId = table.id.uuidString
                    isShowingAlert = true
                }, label: {
                    Text(table.title)
                })
            }
            Button(action: {
                nextTableId = "unselected"
                isShowingAlert = true
            }, label: {
                Text("New Timetable")
            })
        }, label: {
            HStack {
                Text(table.title.isEmpty ? String(localized: "-") : table.title)
                    .bold()
                Image(systemName: "chevron.down")
            }
            .font(.body)
        })
    }
    
    func getTable() -> Table {
        return tables.first(where: { $0.id.uuidString == selectedTableId }) ?? tables[0]
    }
}
