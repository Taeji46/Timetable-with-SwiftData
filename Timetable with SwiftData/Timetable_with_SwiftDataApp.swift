import SwiftUI
import SwiftData

@main
struct Timetable_with_SwiftDataApp: App {
    @AppStorage(wrappedValue: 0, "appearanceMode") var appearanceMode
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(AppearanceModeSetting(rawValue: appearanceMode)?.colorScheme)
        }
        .modelContainer(for: [Table.self, Period.self])
    }
}
