import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var tables: [Table]
    
    var body: some View {
        if tables.count == 0 {
            WelcomeView()
        } else {
            MainView(table: tables[0])
        }
    }
}
