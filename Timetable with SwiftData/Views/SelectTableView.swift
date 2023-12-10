import SwiftUI
import SwiftData

struct SelectTableView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Query private var tables: [Table]
    @Binding var selectedTableId: String
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(colorScheme == .dark ? .indigo.opacity(0.15) : .indigo.opacity(0.15))
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: true) {
                    VStack {
                        ForEach(tables) { table in
                            Button(action: {
                                selectedTableId = table.id.uuidString
                            }, label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(colorScheme == .dark ? .black : .white)
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(table.getSelectedColor().opacity(0.75))
                                        .shadow(color: colorScheme == .dark ? .black : .gray, radius: 3, x: 3, y: 3)
                                    
                                    Text(table.title)
                                        .bold()
                                        .padding()
                                        .foregroundColor(Color.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.925, height: 50)
                                .padding(.bottom, 4)
                            })
                        }
                    }
                    .padding(.top, UIScreen.main.bounds.width * (1.0 - 0.925) / 2.0)
                    .padding([.leading, .trailing], 8)
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
            .navigationBarTitle("Timetable List", displayMode: .inline)
        }
        .accentColor(colorScheme == .dark ? .white : .indigo)
    }
    
    func getTable() -> Table {
        return tables.first(where: { $0.id.uuidString == selectedTableId }) ?? tables[0]
    }
}
