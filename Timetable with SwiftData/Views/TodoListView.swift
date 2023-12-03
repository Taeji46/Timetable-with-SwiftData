import SwiftUI
import SwiftData

struct TodoListView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State var table: Table
    @Binding var selectedTableId: String
    @Query private var tables: [Table]
    
    var body: some View {
        VStack {
            ForEach(table.todoList) { todo in
                if let course = table.courses.first(where: { $0.id.uuidString == todo.courseId }) {
                    ZStack {
                        NavigationLink(destination: {
                            TodoEditView(table: getTable(), todo: todo)
                        }, label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(colorScheme == .dark ? .black : .white)
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(todo.isCompleted ? course.getSelectedColor().opacity(0.25) :course.getSelectedColor().opacity(0.75))
                            }
                        })
                        
                        HStack(spacing: 0) {
                            if todo.isCompleted {
                                Button(action: {
                                    todo.isCompleted = false
                                }, label: {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 25))
                                })
                                .padding([.leading, .trailing], 14)
                                .foregroundColor(Color.white)
                                .frame(alignment: .leading)
                            } else {
                                Button(action: {
                                    todo.isCompleted = true
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
                    .frame(width: UIScreen.main.bounds.width * 0.90, height: 60)
                    .padding(.bottom, 0)
                }
            }
            Spacer()
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
