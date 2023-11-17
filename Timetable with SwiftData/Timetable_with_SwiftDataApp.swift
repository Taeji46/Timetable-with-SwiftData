import SwiftUI
import SwiftData

@main
struct Timetable_with_SwiftDataApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Table.self)
    }
}
