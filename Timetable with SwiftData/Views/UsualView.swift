import SwiftUI
import SwiftData

struct UsualView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var tables: [Table]
    @Binding var selectedTableId: String
    
    var body: some View {
        Group {
            if selectedTableId == "unselected" {
                SelectTableView(selectedTableId: $selectedTableId)
            } else {
                MainView(selectedTableId: $selectedTableId, table: getTable())
            }
        }
    }
    
    func getTable() -> Table {
        return tables.first(where: { $0.id.uuidString == selectedTableId }) ?? tables[0]
    }
}
