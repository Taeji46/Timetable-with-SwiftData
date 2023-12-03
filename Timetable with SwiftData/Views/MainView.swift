import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.modelContext) private var modelContext
    @Binding var selectedTableId: String
    @Query private var tables: [Table]
    @State var table: Table
    @State var selectedTab: Int = 0
    @State var navigationTitle: String = String(localized: "Today's Lectures")
    
    var body: some View {
        NavigationStack {
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
            .navigationTitle(navigationTitle)
            .navigationBarItems(leading: menu)
            .navigationBarItems(trailing:
                                    selectedTab == 2 ?
                                NavigationLink(destination: {
                AddNewTodoView(table: table)
            }, label: {
                Image(systemName: "plus")
            }) : nil
            )
            .navigationBarItems(trailing:
                                    selectedTab == 2 ?
                                Button(action: {
                table.todoList.removeAll(where: { $0.isCompleted == true })
            }, label: {
                Image(systemName: "arrow.circlepath")
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
        .accentColor(colorScheme == .dark ? .white : .black)
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
    }
    
    var menu: some View {
        Menu(content: {
            NavigationLink(destination: {
                SettingView(selectedTableId: $selectedTableId, table: table)
                    .navigationTitle("Settings")
            }, label: {
                Text("Settings")
            })
        }, label: {
            Image(systemName: "list.bullet")
        })
    }
    
    func getTable() -> Table {
        return tables.first(where: { $0.id.uuidString == selectedTableId }) ?? tables[0]
    }
}
