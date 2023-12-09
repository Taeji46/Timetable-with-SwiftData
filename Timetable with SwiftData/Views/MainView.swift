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
                    
                    TodoListView(table: table, selectedTableId: $selectedTableId)
                        .tabItem {
                            Image(systemName: "checkmark.circle")
                            Text("Todo")
                        }
                        .tag(2)
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        selectedTab == 1 ? tableDropDown : nil
                    }
                }
                .navigationBarTitle(navigationTitle ,displayMode: .inline)
                .navigationBarItems(leading: menu)
                .navigationBarItems(trailing:
                                        selectedTab == 2 ?
                                    Button(action: {
                    withAnimation(.easeInOut(duration: 0.75)) {
                        for todo in table.todoList.filter({$0.isCompleted == true}) {
                            cancelScheduledTodoNotification(todo: todo)
                        }
                        table.todoList.removeAll(where: { $0.isCompleted == true })
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
                        navigationTitle = String(localized: "Todo")
                    default:
                        navigationTitle = String(localized: "Today's Lectures")
                    }
                }
            }
        }
        .accentColor(colorScheme == .dark ? .white : .indigo)
        .onAppear() {
            table.initPeriods()
        }
        .onChange(of: selectedTableId) {
            if !tables.isEmpty {
                table = getTable()
            }
        }
        .onChange(of: table.scheduledToBeDeleted) {
            if table.scheduledToBeDeleted {
                modelContext.delete(table)
                try? modelContext.save()
                selectedTableId = "unselected"
            }
        }
        .alert(isPresented: $isShowingAlert) {
            switch alertType {
            case .showTableList:
                return Alert(
                    title: Text("Confirm Notifications Off"),
                    message: Text("Notifications for the current timetable will be turned off"),
                    primaryButton: .destructive(Text("OK")) {
                        table.isCourseNotificationScheduled = false
                        table.setAllTodosNotification(value: false)
                        table.updateNotificationSetting()
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
        }, label: {
            Image(systemName: "list.bullet")
        })
    }
    
    var tableDropDown: some View {
        Menu(content: {
            ForEach(tables) { table in
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
                Text("Add a New Timetable")
            })
        }, label: {
            HStack {
                Text(table.title.isEmpty ? String(localized: "-") : table.title)
                    .bold()
                Image(systemName: "chevron.down")
            }
            .font(.body)
            .foregroundColor(colorScheme == .dark ? .white : .black)
        })
    }
    
    func getTable() -> Table {
        return tables.first(where: { $0.id.uuidString == selectedTableId }) ?? tables[0]
    }
}
