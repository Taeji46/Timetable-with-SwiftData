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
                
                Text("Todo List")
                    .tabItem {
                        Image(systemName: "checkmark.circle")
                        Text("Todo")
                    }
                    .tag(2)
            }
            .navigationBarItems(trailing: NavigationLink(destination: {
                SettingView(selectedTableId: $selectedTableId, table: table)
                    .navigationTitle("Settings")
            }, label: {
                Image(systemName: "gear")
            }))
            .accentColor(colorScheme == .dark ? .white : .black)
            .navigationTitle(navigationTitle)
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
            .onAppear() {
                table.initPeriods()
                
                if table.scheduledToBeDeleted {
                    modelContext.delete(table)
                    try? modelContext.save()
                    selectedTableId = "unselected"
                }
            }
        }
        .navigationViewStyle(.stack)
        .onChange(of: selectedTableId) {
            if !tables.isEmpty {
                table = getTable()
            }
        }
    }
        
    func getTable() -> Table {
        return tables.first(where: { $0.id.uuidString == selectedTableId }) ?? tables[0]
    }
}
