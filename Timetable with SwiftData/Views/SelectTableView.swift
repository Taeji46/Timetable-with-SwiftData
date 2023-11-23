import SwiftUI
import SwiftData

struct SelectTableView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
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
                            .foregroundColor(.blue)
                    })
                }
            }
            .toolbar {
                ToolbarItem {
                    NavigationLink(destination: {
                        AddNewTableView(selectedTableId: $selectedTableId)
                    }, label: {
                        Label("Add Table", systemImage: "plus")
                    })
                }
            }
            .navigationBarTitle("Timetable List")
        }
    }
    
    func getTable() -> Table {
        return tables.first(where: { $0.id.uuidString == selectedTableId }) ?? tables[0]
    }
}
