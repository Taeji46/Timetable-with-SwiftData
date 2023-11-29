import SwiftUI
import SwiftData
import Colorful

struct SelectTableView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Query private var tables: [Table]
    @Binding var selectedTableId: String
    
    var body: some View {
        NavigationStack {
            ZStack {
                ColorfulView()
                    .ignoresSafeArea()
                VStack() {
                    Group {
                        ForEach(tables) { table in
                            Button(action: {
                                selectedTableId = table.id.uuidString
                            }, label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(colorScheme == .dark ? .black : .white)
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(table.getSelectedColor().opacity(0.75))
                                    
                                    Text(table.title)
                                        .bold()
                                        .padding()
                                        .foregroundColor(Color.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.90, height: 50)
                            })
                        }
                    }
                    .padding(.top, 10)
                    Spacer()
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
