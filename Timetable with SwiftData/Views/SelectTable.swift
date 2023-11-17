import SwiftUI
import SwiftData

struct SelectTableView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var tables: [Table]
    @State private var isShow: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(tables) { table in
                    NavigationLink(destination: MainView(table: table)) {
                        Text(table.title)
                    }
                }
                .onDelete(perform: deleteTable)
                
                if tables.count == 0 {
                    Button(action: {
                        addTable()
                    }, label: {
                        Text("Create a new timetable")
                    })
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addTable) {
                        Label("Add Table", systemImage: "plus")
                    }
                }
            }
            .navigationBarTitle("Timetable List")
        }
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                var transaction = Transaction()
                transaction.disablesAnimations = true
                withTransaction(transaction) {
                    self.isShow = true
                }
            }
        })
        .fullScreenCover(isPresented: $isShow) {
            MainView(table: tables[0])
        }
    }
    
    private func addTable() {
        let newTable = Table(title: "TimeTable", numOfDays: 5, numOfPeriods: 6)
        modelContext.insert(newTable)
    }
    
    private func deleteTable(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(tables[index])
            }
        }
    }
}
