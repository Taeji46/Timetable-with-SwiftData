import SwiftUI

struct CourseView: View {
    @State var table: Table
    @State var course: Course
    @State var isShowingAlert: Bool
    @State var attendCount: Int
    @State var absentCount: Int
    @State var lateCount: Int
    @State var canceledCount: Int
    let courseWidth: CGFloat = UIScreen.main.bounds.width * 0.925
    let courseInfoHeight: CGFloat = 76
    let attendanceInfoHeight: CGFloat = 50
    let insideFrameWidth: CGFloat = 10
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var modelContext
    
    init(table: Table, course: Course) {
        self._table = State(initialValue: table)
        self._course = State(initialValue: course)
        _isShowingAlert = State(initialValue: false)
        _attendCount = State(initialValue: course.countAttendance(status: .attend))
        _absentCount = State(initialValue: course.countAttendance(status: .absent))
        _lateCount = State(initialValue: course.countAttendance(status: .late))
        _canceledCount = State(initialValue: course.countAttendance(status: .canceled))
    }
    
    var body: some View {
        ZStack {
            Color(colorScheme == .dark ? .indigo.opacity(0.15) : .indigo.opacity(0.15))
                .ignoresSafeArea()
            
            ScrollView {
                VStack {
                    courseInfoView
                    attendanceInfoView
                    Divider()
                    noteListView
                    Divider()
                    todoListView
                    Spacer()
                }
                .padding(.top, UIScreen.main.bounds.width * (1.0 - 0.925) / 2.0)
                .padding([.leading, .trailing], 8)
                .foregroundColor(.white)
            }
        }
        .navigationTitle(course.name)
        .navigationBarItems(trailing: Button(action: {
            isShowingAlert = true
        }) {
            Image(systemName: "trash")
        })
        .navigationBarItems(
            trailing:
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.75)) {
                        for todo in table.todoList.filter({ $0.courseId == course.id.uuidString && $0.isCompleted == true }) {
                            cancelScheduledTodoNotification(todo: todo)
                        }
                        table.todoList.removeAll(where: { $0.courseId == course.id.uuidString && $0.isCompleted == true })
                    }
                }, label: {
                    Image(systemName: "arrow.triangle.2.circlepath")
                })
        )
        .navigationBarItems(trailing: menu)
        .alert(isPresented: $isShowingAlert) {
            Alert(
                title: Text("Confirm Deletion"),
                message: Text("Are you sure you want to delete this course?"),
                primaryButton: .destructive(Text("Delete")) {
                    table.deleteCourse(course: course)
                    try? modelContext.save()
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
        }
        .onChange(of: course.attendanceRecords) {
            attendCount = course.countAttendance(status: .attend)
            absentCount = course.countAttendance(status: .absent)
            lateCount = course.countAttendance(status: .late)
            canceledCount = course.countAttendance(status: .canceled)
        }
    }
    
    var courseInfoView: some View {
        NavigationLink(destination: {
            CourseEditView(table: table, course: course, selectedColor: course.getSelectedColor())
                .navigationBarTitle("Details", displayMode: .inline)
                .accentColor(colorScheme == .dark ? .white : .indigo)
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(colorScheme == .dark ? .black : .white)
                RoundedRectangle(cornerRadius: 10)
                    .fill(course.getSelectedColor().opacity(0.75))
                    .shadow(color: colorScheme == .dark ? .clear : .gray, radius: 3, x: 3, y: 3)
                
                VStack(spacing: 0) {
                    Spacer().frame(height: insideFrameWidth)
                    titleView()
                    Spacer().frame(height: insideFrameWidth)
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.white, lineWidth: 1)
                        VStack {
                            timeView()
                            classroomView()
                            teacherView()
                        }
                    }
                    .frame(width: courseWidth - 2 * insideFrameWidth, height: courseInfoHeight)
                    Spacer().frame(height: insideFrameWidth)
                }
            }
            .frame(width: courseWidth, height: courseInfoHeight + 18 + 3 * insideFrameWidth)
        })
    }
    
    var attendanceInfoView: some View {
        ZStack {
            NavigationLink(destination: {
                AttendanceRecordView(course: course)
                    .navigationBarTitle("Attendance Status", displayMode: .inline)
                    .accentColor(colorScheme == .dark ? .white : .indigo)
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(colorScheme == .dark ? .black : .white)
                    RoundedRectangle(cornerRadius: 10)
                        .fill(course.getSelectedColor().opacity(0.75))
                        .shadow(color: colorScheme == .dark ? .clear : .gray, radius: 3, x: 3, y: 3)
                }
            })
            
            VStack(spacing: 0) {
                Spacer().frame(height: insideFrameWidth)
                Text("Attendance Status")
                    .font(.system(size: 18))
                    .bold()
                    .frame(width: courseWidth - 2 * insideFrameWidth, height: 18, alignment: .leading)
                    .lineLimit(nil)
                    .padding(.leading, 18)
                Spacer().frame(height: insideFrameWidth)
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.white, lineWidth: 1)
                    HStack(spacing: 0) {
                        Button(action: {
                            course.attendanceRecords.append(Attendance(status: .attend, date: Date()))
                        }, label: {
                            VStack {
                                Text("Attend")
                                    .font(.system(size: 14))
                                Text(String(attendCount))
                                    .font(.system(size: 14))
                            }
                            .frame(width: (courseWidth - 2 * insideFrameWidth) / 4.0)
                        })
                        Divider()
                        Button(action: {
                            course.attendanceRecords.append(Attendance(status: .absent, date: Date()))
                        }, label: {
                            VStack {
                                Text("Absent")
                                    .font(.system(size: 14))
                                Text(String(absentCount))
                                    .font(.system(size: 14))
                            }
                            .frame(width: (courseWidth - 2 * insideFrameWidth) / 4.0)
                        })
                        Divider()
                        Button(action: {
                            course.attendanceRecords.append(Attendance(status: .late, date: Date()))
                        }, label: {
                            VStack {
                                Text("Late")
                                    .font(.system(size: 14))
                                Text(String(lateCount))
                                    .font(.system(size: 14))
                            }
                            .frame(width: (courseWidth - 2 * insideFrameWidth) / 4.0)
                        })
                        Divider()
                        Button(action: {
                            course.attendanceRecords.append(Attendance(status: .canceled, date: Date()))
                        }, label: {
                            VStack {
                                Text("Canceled")
                                    .font(.system(size: 14))
                                Text(String(canceledCount))
                                    .font(.system(size: 14))
                            }
                            .frame(width: (courseWidth - 2 * insideFrameWidth) / 4.0)
                        })
                    }
                    .bold()
                }
                .frame(width: courseWidth - 2 * insideFrameWidth, height: attendanceInfoHeight)
                Spacer().frame(height: insideFrameWidth)
            }
        }
        .frame(width: courseWidth, height: attendanceInfoHeight + 18 + 3 * insideFrameWidth)
    }
    
    var todoListView: some View {
        ForEach(table.todoList.filter { $0.courseId == course.id.uuidString }.sorted { $0.date < $1.date }) { todo in
            ZStack {
                NavigationLink(destination: {
                    TodoEditView(table: table, todo: todo)
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
                        Text("Todo")
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
        }
    }
    
    var noteListView: some View {
        ForEach(course.notes.sorted(by: { $0.timestamp > $1.timestamp })) { note in
            ZStack {
                NavigationLink(destination: {
                    NoteEditView(course: course, note: note)
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(colorScheme == .dark ? .black : .white)
                        RoundedRectangle(cornerRadius: 10)
                            .fill(course.getSelectedColor().opacity(0.75))
                            .shadow(color: colorScheme == .dark ? .black : .gray, radius: 3, x: 3, y: 3)
                    }
                })
                
                HStack(spacing: 0) {
                    VStack(alignment: .leading) {
                        Text(note.content)
                            .bold()
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .padding(.leading, 18)
                        
                        Text(note.detail.replacingOccurrences(of: "\n", with: " "))
                            .bold()
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .padding(.leading, 18)

                    }
                    
                    Spacer()
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.925, height: 55)
            .padding(.bottom, 0)
        }
    }
    
    var menu: some View {
        VStack {
            Menu(content: {
                NavigationLink(destination: {
                    AddNewTodoView(table: table, course: course)
                }, label: {
                    Text("Todo")
                })
                NavigationLink(destination: {
                    AddNewNoteView(course: course)
                }, label: {
                    Text("Note")
                })
            }, label: {
                Image(systemName: "plus")
            })
        }
    }
    
    func titleView() -> some View {
        return (
            Text(course.name)
                .font(.system(size: 18))
                .bold()
                .frame(width: courseWidth - 2 * insideFrameWidth, height: 18, alignment: .leading)
                .lineLimit(nil)
                .padding(.leading, 18)
        )
    }
    
    func timeView() -> some View {
        let startTimeText = table.getPeriod(index: course.period).getStartTimeText()
        let endTimeText = table.getPeriod(index: course.period + course.duration - 1).getEndTimeText()
        return (
            HStack {
                Image(systemName: "clock.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 14, height: 14)
                    .padding(.leading, 14)
                
                Text(startTimeText + " ~ " + endTimeText)
                    .font(.system(size: 14))
                    .bold()
            }
                .frame(width: courseWidth - 2 * insideFrameWidth, height: 14, alignment: .leading)
        )
    }
    
    func classroomView() -> some View {
        return (
            HStack {
                Image(systemName: "mappin.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 14, height: 14)
                    .padding(.leading, 14)
                
                Text(course.classroom)
                    .font(.system(size: 14))
                    .bold()
            }
                .frame(width: courseWidth - 2 * insideFrameWidth, height: 14, alignment: .leading)
        )
    }
    
    func teacherView() -> some View {
        return (
            HStack {
                Image(systemName: "person.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 14, height: 14)
                    .padding(.leading, 14)
                
                Text(course.teacher)
                    .font(.system(size: 14))
                    .bold()
            }
                .frame(width: courseWidth - 2 * insideFrameWidth, height: 14, alignment: .leading)
        )
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
}
