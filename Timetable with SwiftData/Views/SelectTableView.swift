import SwiftUI
import SwiftData

struct SelectTableView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var tables: [Table]
    @Binding var selectedTableId: String
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(tables) { table in
                    Button(action: {
                        selectedTableId = table.id.uuidString
                    }, label: {
                        Text(table.title)
                            .foregroundColor(table.getSelectedColor())
                    })
                }
            }
            .toolbar {
                ToolbarItem {
                    Button(action: addTable) {
                        Label("Add Table", systemImage: "plus")
                    }
                }
            }
            .navigationBarTitle("Timetable List")
        }
    }
    
    func getTable() -> Table {
        return tables.first(where: { $0.id.uuidString == selectedTableId }) ?? tables[0]
    }
    
    private func addTable() {
        let newTable = Table(title: "New Timetable", colorName: "blue", numOfDays: 5, numOfPeriods: 6)
        modelContext.insert(newTable)
    }
}
