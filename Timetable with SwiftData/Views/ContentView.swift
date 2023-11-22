import SwiftUI
import SwiftData

struct ContentView: View {
    @Binding var selectedTableId: String
    @State private var refreshView = false
    @Query private var tables: [Table]
    
    var body: some View {
        if tables.count == 0 {
            WelcomeView(selectedTableId: $selectedTableId)
        } else {
            SelectTableView(selectedTableId: $selectedTableId)
        }
    }
}
