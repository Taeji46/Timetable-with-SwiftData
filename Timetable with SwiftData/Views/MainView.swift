import SwiftUI
import SwiftData

struct MainView: View {
    @State var selectedTab: Int
    @State var navigationTitle: String
    
    init() {
        selectedTab = 0;
        navigationTitle = String(localized: "Today's Lectures")
    }
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                Text("Today")
                    .tabItem {
                        Image(systemName: "sun.max")
                        Text("Today")
                    }
                    .tag(0)
                
                WeeklyTableView()
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Timetable")
                    }
                    .tag(1)
                
                Text("Setting")
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                    .tag(2)
            }
            .accentColor(.blue)
            .navigationTitle(navigationTitle)
            .onChange(of: selectedTab, initial: true) { oldTab, newTab in
                switch newTab {
                case 0:
                    navigationTitle = String(localized: "Today's Lectures")
                case 1:
                    navigationTitle = "table.title"
                case 2:
                    navigationTitle = String(localized: "Settings")
                default:
                    navigationTitle = String(localized: "Today's Lectures")
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}
