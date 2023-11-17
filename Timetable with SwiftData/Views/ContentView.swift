import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        WeeklyTableView()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Course.self, inMemory: true)
}
