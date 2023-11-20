import SwiftUI
import SwiftData

struct MainView: View {
    @State var table: Table
    @State var selectedTab: Int = 0
    @State var navigationTitle: String = String(localized: "Today's Lectures")
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                DailyTableView(table: table, currentTime: getCurrentTime())
                    .tabItem {
                        Image(systemName: "sun.max")
                        Text("Today")
                    }
                    .tag(0)
                
                WeeklyTableView(table: table)
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Timetable")
                    }
                    .tag(1)
                
                SettingView(table: table)
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                    .tag(2)
            }
            .accentColor(table.getSelectedColor())
            .navigationTitle(navigationTitle)
            .onChange(of: selectedTab, initial: true) { oldTab, newTab in
                switch newTab {
                case 0:
                    navigationTitle = String(localized: "Today's Lectures")
                case 1:
                    navigationTitle = table.title
                case 2:
                    navigationTitle = String(localized: "Settings")
                default:
                    navigationTitle = String(localized: "Today's Lectures")
                }
            }
            .onAppear() {
                table.initPeriods()
            }
        }
        .navigationViewStyle(.stack)
    }
}
