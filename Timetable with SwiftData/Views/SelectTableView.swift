import SwiftUI
import SwiftData

struct SelectTableView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var tables: [Table]
    @Binding var selectedTableId: String
    
    var body: some View {
        if selectedTableId == "unselected" {
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
                    
                    if tables.count == 0 {
                        Button(action: {
                            addTable()
                        }, label: {
                            Text("Create a new timetable")
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
        } else {
            MainView(selectedTableId: $selectedTableId, table: getTable())
        }
    }
    
    private func addTable() {
        let newTable = Table(title: "New TimeTable", numOfDays: 5, numOfPeriods: 6)
        modelContext.insert(newTable)
    }
    
    func getTable() -> Table {
        return tables.first(where: { $0.id.uuidString == selectedTableId }) ?? tables[0]
    }
}
