import SwiftUI
import SwiftData

struct ToDoListView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State var table: Table
    @Binding var selectedTableId: String
    @State var selectedToDoListView: Int = 0
    @Query private var tables: [Table]
    @State private var currentDate = Date()
    @State private var today = Calendar.current.startOfDay(for: Date())
    @State private var oneWeekLater = Calendar.current.date(byAdding: .day, value: 7, to: Calendar.current.startOfDay(for: Date()))!
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color(colorScheme == .dark ? .indigo.opacity(0.15) : .indigo.opacity(0.15))
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Picker("", selection: $selectedToDoListView) {
                    Text("Not Done").tag(0)
                    Text("Done2").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: UIScreen.main.bounds.width * 0.625)
                .padding(.top, UIScreen.main.bounds.width * (1.0 - 0.925) / 2.0)
                
                ScrollView {
                    if selectedToDoListView == 0 {
                        incompletedToDoListView
                    } else {
                        completedToDoListView
                    }
                }
            }
            
            floatingButton
        }
        .onChange(of: selectedTableId) {
            if !tables.isEmpty {
                table = getTable()
            }
        }
        .onAppear {
            currentDate = Date()
            today = Calendar.current.startOfDay(for: Date())
            oneWeekLater = Calendar.current.date(byAdding: .day, value: 7, to: Calendar.current.startOfDay(for: Date()))!
            
            for toDo in table.toDoList.filter({ Calendar.current.date(byAdding: .minute, value: -$0.notificationTime, to: $0.dueDate) ?? Date() < Date() }) {
                toDo.isNotificationScheduled = false
            }
            
            table.updateNotificationSetting()
        }
        .onReceive(timer) { _ in
            withAnimation(.easeInOut(duration: 0.75)) {
                currentDate = Date()
                today = Calendar.current.startOfDay(for: Date())
                oneWeekLater = Calendar.current.date(byAdding: .day, value: 7, to: Calendar.current.startOfDay(for: Date()))!
            }
        }
    }
    
    var incompletedToDoListView: some View {
        VStack {
            Text(String.localizedStringWithFormat(
                NSLocalizedString("Not Done: %d", comment: ""),
                table.toDoList.filter { $0.isCompleted == false }.count
            ))
            .frame(width: UIScreen.main.bounds.width * 0.925, alignment: .leading)
            .font(.system(size: 12))
            .bold()
            
            Divider()
            
            if table.toDoList.contains(where: { $0.isCompleted == false && $0.dueDate <= currentDate }) {
                Text("Overdue")
                    .frame(width: UIScreen.main.bounds.width * 0.925, alignment: .leading)
                    .font(.system(size: 12))
                    .bold()
                    .foregroundColor(.red)
                ForEach(table.toDoList.filter({ $0.isCompleted == false && $0.dueDate < currentDate }).sorted { $0.dueDate < $1.dueDate }) { toDo in
                    if let course = toDo.getCourse() {
                        toDoItemView(course: course, toDo: toDo)
                    } else {
                        NoCourseToDoItemView(toDo: toDo)
                    }
                }
                Divider()
            }
            
            if table.toDoList.contains(where: { $0.isCompleted == false && $0.dueDate > currentDate && Calendar.current.isDate($0.dueDate, inSameDayAs: currentDate) }) {
                Text("Today")
                    .frame(width: UIScreen.main.bounds.width * 0.925, alignment: .leading)
                    .font(.system(size: 12))
                    .bold()
                ForEach(table.toDoList.filter({ $0.isCompleted == false && $0.dueDate >= currentDate && Calendar.current.isDate($0.dueDate, inSameDayAs: currentDate) }).sorted { $0.dueDate < $1.dueDate}) { toDo in
                    if let course = toDo.getCourse() {
                        toDoItemView(course: course, toDo: toDo)
                    } else {
                        NoCourseToDoItemView(toDo: toDo)
                    }
                }
                Divider()
            }
            
            if table.toDoList.contains(where: { $0.isCompleted == false && !Calendar.current.isDate($0.dueDate, inSameDayAs: currentDate) && $0.dueDate > currentDate && $0.dueDate < oneWeekLater }) {
                Text("This Week")
                    .frame(width: UIScreen.main.bounds.width * 0.925, alignment: .leading)
                    .font(.system(size: 12))
                    .bold()
                ForEach(table.toDoList.filter({ $0.isCompleted == false && !Calendar.current.isDate($0.dueDate, inSameDayAs: currentDate) && $0.dueDate > today && $0.dueDate < oneWeekLater }).sorted { $0.dueDate < $1.dueDate }) { toDo in
                    if let course = toDo.getCourse() {
                        toDoItemView(course: course, toDo: toDo)
                    } else {
                        NoCourseToDoItemView(toDo: toDo)
                    }
                }
                Divider()
            }
            
            if table.toDoList.contains(where: { $0.isCompleted == false && $0.dueDate >= oneWeekLater }) {
                Text("Later")
                    .frame(width: UIScreen.main.bounds.width * 0.925, alignment: .leading)
                    .font(.system(size: 12))
                    .bold()
                ForEach(table.toDoList.filter({ $0.isCompleted == false && $0.dueDate >= oneWeekLater }).sorted { $0.dueDate < $1.dueDate }) { toDo in
                    if let course = toDo.getCourse() {
                        toDoItemView(course: course, toDo: toDo)
                    } else {
                        NoCourseToDoItemView(toDo: toDo)
                    }
                }
                Divider()
            }
            Spacer()
        }
        .padding([.leading, .trailing], 8)
        .padding(.top, UIScreen.main.bounds.width * (1.0 - 0.925) / 2.0)
    }
    
    var completedToDoListView: some View {
        VStack {
            Text(String.localizedStringWithFormat(
                NSLocalizedString("Done: %d", comment: ""),
                table.toDoList.filter { $0.isCompleted == true }.count
            ))
            .frame(width: UIScreen.main.bounds.width * 0.925, alignment: .leading)
            .font(.system(size: 12))
            .bold()
            
            Divider()
            
            ForEach(table.toDoList.filter({ $0.isCompleted == true }).sorted { $0.dueDate < $1.dueDate }) { toDo in
                if let course = toDo.getCourse() {
                    toDoItemView(course: course, toDo: toDo)
                } else {
                    NoCourseToDoItemView(toDo: toDo)
                }
            }
            Spacer()
        }
        .padding([.leading, .trailing], 8)
        .padding(.top, UIScreen.main.bounds.width * (1.0 - 0.925) / 2.0)
    }
    
    func toDoItemView(course: Course, toDo: ToDo) -> some View {
        ZStack {
            NavigationLink(destination: {
                ToDoEditView(table: getTable(), toDo: toDo)
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(colorScheme == .dark ? .black : .white)
                    RoundedRectangle(cornerRadius: 10)
                        .fill(toDo.isCompleted ? course.getSelectedColor().opacity(0.35) :course.getSelectedColor().opacity(0.75))
                        .shadow(color: colorScheme == .dark ? .black : .gray, radius: 3, x: 3, y: 3)
                        .overlay(
                            toDo.isNotificationScheduled
                            ? Image(systemName: "bell.fill")
                                .font(.system(size: 12))
                                .foregroundColor(toDo.isCompleted ? .white.opacity(0.7) : .white)
                                .padding(4)
                                .background(Color.red)
                                .clipShape(Circle())
                                .offset(x: -4, y: -4)
                            : nil,
                            alignment: .topLeading
                        )
                }
            })
            
            HStack(spacing: 0) {
                if toDo.isCompleted {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.75)) {
                            toDo.isCompleted = false
                            UNUserNotificationCenter.current().setBadgeCount(table.toDoList.filter({ !$0.isCompleted }).count)
                        }
                    }, label: {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 25))
                    })
                    .padding(.leading, 14)
                    .padding(.trailing, 14)
                    .foregroundColor(Color.white)
                    .frame(alignment: .leading)
                } else {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.75)) {
                            toDo.isCompleted = true
                            toDo.isNotificationScheduled = false
                            cancelScheduledToDoNotification(toDo: toDo)
                            UNUserNotificationCenter.current().setBadgeCount(table.toDoList.filter({ !$0.isCompleted }).count)
                        }
                    }, label: {
                        Image(systemName: "circle")
                            .font(.system(size: 25))
                    })
                    .padding(.leading, 14)
                    .padding(.trailing, 14)
                    .foregroundColor(Color.white)
                    .frame(alignment: .leading)
                }
                
                VStack(alignment: .leading) {
                    Text(!course.name.isEmpty ? course.name : "-")
                        .bold()
                        .foregroundColor(toDo.isCompleted ? .white.opacity(0.7) : .white)
                        .font(.system(size: 12))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    
                    Text(!toDo.title.isEmpty ? toDo.title : "-")
                        .bold()
                        .foregroundColor(toDo.isCompleted ? .white.opacity(0.7) : .white)
                        .font(.system(size: 18))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(formattedDate1(toDo.dueDate))
                        .padding(.trailing, 14)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .bold()
                        .font(.system(size: 14))
                        .foregroundColor(toDo.isCompleted ? .white.opacity(0.7) : .white)
                    
                    Text(formattedDate2(toDo.dueDate))
                        .padding(.trailing, 14)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .bold()
                        .font(.system(size: 14))
                        .foregroundColor(toDo.isCompleted ? .white.opacity(0.7) : .white)
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.925, height: 55)
        .padding(.bottom, 0)
        .transition(.scale)
    }
    
    func NoCourseToDoItemView(toDo: ToDo) -> some View {
        ZStack {
            NavigationLink(destination: {
                ToDoEditView(table: getTable(), toDo: toDo)
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(colorScheme == .dark ? .black : .white)
                    RoundedRectangle(cornerRadius: 10)
                        .fill(toDo.isCompleted ? .gray.opacity(0.35) : .gray.opacity(0.75))
                        .shadow(color: colorScheme == .dark ? .black : .gray, radius: 3, x: 3, y: 3)
                        .overlay(
                            toDo.isNotificationScheduled
                            ? Image(systemName: "bell.fill")
                                .font(.system(size: 12))
                                .foregroundColor(toDo.isCompleted ? .white.opacity(0.7) : .white)
                                .padding(4)
                                .background(Color.red)
                                .clipShape(Circle())
                                .offset(x: -4, y: -4)
                            : nil,
                            alignment: .topLeading
                        )
                }
            })
            
            HStack(spacing: 0) {
                if toDo.isCompleted {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.75)) {
                            toDo.isCompleted = false
                            UNUserNotificationCenter.current().setBadgeCount(table.toDoList.filter({ !$0.isCompleted }).count)
                        }
                    }, label: {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 25))
                    })
                    .padding(.leading, 14)
                    .padding(.trailing, 14)
                    .foregroundColor(Color.white)
                    .frame(alignment: .leading)
                } else {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.75)) {
                            toDo.isCompleted = true
                            toDo.isNotificationScheduled = false
                            cancelScheduledToDoNotification(toDo: toDo)
                            UNUserNotificationCenter.current().setBadgeCount(table.toDoList.filter({ !$0.isCompleted }).count)
                        }
                    }, label: {
                        Image(systemName: "circle")
                            .font(.system(size: 25))
                    })
                    .padding(.leading, 14)
                    .padding(.trailing, 14)
                    .foregroundColor(Color.white)
                    .frame(alignment: .leading)
                }
                
                VStack(alignment: .leading) {
                    Text("Lecture Not Selected")
                        .bold()
                        .foregroundColor(toDo.isCompleted ? .white.opacity(0.7) : .white)
                        .font(.system(size: 12))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    
                    Text(!toDo.title.isEmpty ? toDo.title : "-")
                        .bold()
                        .foregroundColor(toDo.isCompleted ? .white.opacity(0.7) : .white)
                        .font(.system(size: 18))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(formattedDate1(toDo.dueDate))
                        .padding(.trailing, 14)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .bold()
                        .font(.system(size: 14))
                        .foregroundColor(toDo.isCompleted ? .white.opacity(0.7) : .white)
                    
                    Text(formattedDate2(toDo.dueDate))
                        .padding(.trailing, 14)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .bold()
                        .font(.system(size: 14))
                        .foregroundColor(toDo.isCompleted ? .white.opacity(0.7) : .white)
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.925, height: 55)
        .padding(.bottom, 0)
        .transition(.scale)
    }
    
    var floatingButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                NavigationLink(destination: {
                    AddNewToDoView(table: table)
                }, label: {
                    ZStack {
                        Color(colorScheme == .dark ? .black : .white)
                        Color(colorScheme == .dark ? .indigo.opacity(0.75) : .indigo.opacity(0.75))
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                    }
                })
                .frame(width: 60, height: 60)
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
