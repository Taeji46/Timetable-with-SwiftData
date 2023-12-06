import SwiftUI
import SwiftData

struct ContentView: View {
    @Binding var selectedTableId: String
    @Query private var tables: [Table]
    
    var body: some View {
        if tables.isEmpty {
            WelcomeView(selectedTableId: $selectedTableId)
        } else {
            UsualView(selectedTableId: $selectedTableId)
        }
    }
}
