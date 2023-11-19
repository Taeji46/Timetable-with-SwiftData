import SwiftUI
import SwiftData

@main
struct Timetable_with_SwiftDataApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage(wrappedValue: 0, "appearanceMode") var appearanceMode
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(AppearanceModeSetting(rawValue: appearanceMode)?.colorScheme)
        }
        .modelContainer(for: [Table.self, Period.self])
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission was obtained")
            } else {
                print("Notification permission was denied")
            }
        }
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
