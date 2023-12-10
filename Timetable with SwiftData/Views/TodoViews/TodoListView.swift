import SwiftUI
import SwiftData

struct TodoListView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State var table: Table
    @Binding var selectedTableId: String
    @State var selectedTodoListView: Int = 0
    @Query private var tables: [Table]
    
    var body: some View {
        ZStack {
            Color(colorScheme == .dark ? .indigo.opacity(0.15) : .indigo.opacity(0.15))
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Picker("", selection: $selectedTodoListView) {
                    Text("Unfinished").tag(0)
                    Text("Done").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: UIScreen.main.bounds.width * 0.625)
                .padding(.top, UIScreen.main.bounds.width * (1.0 - 0.925) / 2.0)
                
                ScrollView {
                    todoListView
                }
            }
            
            floatingButton
        }
        .onChange(of: selectedTableId) {
            if !tables.isEmpty {
                table = getTable()
            }
        }
    }
    
    var todoListView: some View {
        VStack {
            ForEach(selectedTodoListView == 0 ? table.todoList.filter({ $0.isCompleted == false }).sorted { $0.date < $1.date } : table.todoList.filter({ $0.isCompleted == true }).sorted { $0.date < $1.date }) { todo in
                if let course = todo.getCourse() {
                    ZStack {
                        NavigationLink(destination: {
                            TodoEditView(table: getTable(), todo: todo)
                        }, label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(colorScheme == .dark ? .black : .white)
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(todo.isCompleted ? course.getSelectedColor().opacity(0.35) :course.getSelectedColor().opacity(0.75))
                                    .shadow(color: colorScheme == .dark ? .black : .gray, radius: 3, x: 3, y: 3)
                            }
                        })
                        
                        HStack(spacing: 0) {
                            if todo.isCompleted {
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.75)) {
                                        todo.isCompleted = false
                                    }
                                }, label: {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 25))
                                })
                                .padding([.leading, .trailing], 14)
                                .foregroundColor(Color.white)
                                .frame(alignment: .leading)
                            } else {
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.75)) {
                                        todo.isCompleted = true
                                    }
                                }, label: {
                                    Image(systemName: "circle")
                                        .font(.system(size: 25))
                                })
                                .padding([.leading, .trailing], 14)
                                .foregroundColor(Color.white)
                                .frame(alignment: .leading)
                            }
                            
                            VStack(alignment: .leading) {
                                Text(course.name)
                                    .bold()
                                    .foregroundColor(todo.isCompleted ? .white.opacity(0.7) : .white)
                                    .font(.system(size: 12))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                
                                Text(todo.task)
                                    .bold()
                                    .foregroundColor(todo.isCompleted ? .white.opacity(0.7) : .white)
                                    .font(.system(size: 18))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text(formattedDate1(todo.date))
                                    .padding(.trailing, 14)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                    .bold()
                                    .font(.system(size: 14))
                                    .foregroundColor(todo.isCompleted ? .white.opacity(0.7) : .white)
                                
                                Text(formattedDate2(todo.date))
                                    .padding(.trailing, 14)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                    .bold()
                                    .font(.system(size: 14))
                                    .foregroundColor(todo.isCompleted ? .white.opacity(0.7) : .white)
                            }
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.925, height: 55)
                    .padding(.bottom, 0)
                    .transition(.scale)
                }
            }
            Spacer()
        }
        .padding([.leading, .trailing], 8)
        .padding(.top, UIScreen.main.bounds.width * (1.0 - 0.925) / 2.0)
    }
    
    var floatingButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                NavigationLink(destination: {
                    AddNewTodoView(table: table)
                }, label: {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .font(.system(size: 24))
                })
                .frame(width: 60, height: 60)
                .background(colorScheme == .dark ? .indigo.opacity(0.75) : .indigo.opacity(0.75))
                .cornerRadius(30.0)
                .shadow(color: colorScheme == .dark ? .clear : .gray, radius: 3, x: 3, y: 3)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 16.0, trailing: 16.0))
            }
        }
    }
    
    func formattedDate1(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
    
    func formattedDate2(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
    
    func getTable() -> Table {
        return tables.first(where: { $0.id.uuidString == selectedTableId }) ?? tables[0]
    }
}
