import SwiftUI

struct CourseView: View {
    @State var table: Table
    @State var course: Course
    @State var isShowingEditView: Bool
    @State var isShowingAttendanceRecordView: Bool
    @State var isShowingAlert: Bool
    let courseWidth: CGFloat = UIScreen.main.bounds.width * 0.925
    let courseHeight: CGFloat = UIScreen.main.bounds.height / 4.0 * 0.6
    let attendanceInfoHeight: CGFloat = UIScreen.main.bounds.height / 4.0 * 0.5
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var modelContext
    
    init(table: Table, course: Course) {
        self._table = State(initialValue: table)
        self._course = State(initialValue: course)
        _isShowingEditView = State(initialValue: false)
        _isShowingAttendanceRecordView = State(initialValue: false)
        _isShowingAlert = State(initialValue: false)
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: (colorScheme == .dark ?
                           Gradient(stops: [
                            .init(color: course.getSelectedColor().opacity(0.25), location: 0.0),
                            .init(color: course.getSelectedColor().opacity(0.25), location: 0.1),
                            .init(color: course.getSelectedColor().opacity(0.1), location: 0.25),
                            .init(color: course.getSelectedColor().opacity(0.0), location: 1.0)
                           ]):
                            Gradient(colors: [course.getSelectedColor().opacity(0.1), course.getSelectedColor().opacity(0.1)])),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10).fill(.white)
                    RoundedRectangle(cornerRadius: 10)
                        .fill(course.getSelectedColor().opacity(0.75))
                        .onTapGesture {
                            isShowingEditView = true
                        }
                    
                    VStack(spacing: 10) {
                        titleView()
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white.opacity(0.75))
                            VStack {
                                timeView()
                                classroomView()
                                teacherView()
                            }
                        }
                        .frame(width: courseWidth - 20, height: courseHeight * 0.6)
                    }
                }
                .frame(width: courseWidth, height: courseHeight)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10).fill(.white)
                    RoundedRectangle(cornerRadius: 10)
                        .fill(course.getSelectedColor().opacity(0.75))
                        .onTapGesture {
                            isShowingAttendanceRecordView = true
                        }
                    
                    VStack {
                        Spacer()
                        Text("Attendance Status")
                            .font(.system(size: 18))
                            .fontWeight(.heavy)
                            .frame(width: courseWidth - 20, height: 18, alignment: .leading)
                            .foregroundColor(Color.white)
                            .lineLimit(nil)
                            .padding(.leading, 18)
                        Spacer()
                        ZStack {
                            Rectangle()
                                .fill(Color.white.opacity(0.75))
                                .cornerRadius(12)
                            HStack {
                                Spacer()
                                VStack {
                                    Text("Attend")
                                        .font(.system(size: 14))
                                    Text(String(course.countAttendance(status: .attend)))
                                        .font(.system(size: 14))
                                }
                                .frame(width: (courseWidth - 100) / 4.0)
                                .onTapGesture {
                                    course.attendanceRecords.append(Attendance(status: .attend, date: Date()))
                                }
                                Spacer()
                                Divider()
                                Spacer()
                                VStack {
                                    Text("Absent")
                                        .font(.system(size: 14))
                                    Text(String(course.countAttendance(status: .absent)))
                                        .font(.system(size: 14))
                                }
                                .frame(width: (courseWidth - 100) / 4.0)
                                .onTapGesture {
                                    course.attendanceRecords.append(Attendance(status: .absent, date: Date()))
                                }
                                Spacer()
                                Divider()
                                Spacer()
                                VStack {
                                    Text("Late")
                                        .font(.system(size: 14))
                                    Text(String(course.countAttendance(status: .late)))
                                        .font(.system(size: 14))
                                }
                                .frame(width: (courseWidth - 100) / 4.0)
                                .onTapGesture {
                                    course.attendanceRecords.append(Attendance(status: .late, date: Date()))
                                }
                                Spacer()
                                Divider()
                                Spacer()
                                VStack {
                                    Spacer()
                                    Text("Canceled")
                                        .font(.system(size: 14))
                                    Text(String(course.countAttendance(status: .canceled)))
                                        .font(.system(size: 14))
                                    Spacer()
                                }
                                .frame(width: (courseWidth - 100) / 4.0)
                                .onTapGesture {
                                    course.attendanceRecords.append(Attendance(status: .canceled, date: Date()))
                                }
                                Spacer()
                            }
                            .foregroundColor(Color.black)
                        }
                        .frame(width: courseWidth - 20, height: attendanceInfoHeight * 0.4)
                        Spacer()
                    }
                }
                .frame(width: courseWidth, height: attendanceInfoHeight)
                Spacer()
            }
        }
        .navigationTitle(course.name)
        .navigationBarItems(trailing: Button(action: {
            isShowingAlert = true
        }) {
            Image(systemName: "trash")
        })
        .sheet(isPresented: $isShowingEditView) {
            NavigationView {
                CourseEditView(table: table, course: course, selectedColor: course.getSelectedColor())
                    .navigationBarTitle("Details", displayMode: .inline)
                    .navigationBarItems(
                        trailing:
                            Button("Done") {
                                isShowingEditView = false
                            }
                    )
            }
        }
        .sheet(isPresented: $isShowingAttendanceRecordView) {
            NavigationView {
                AttendanceRecordView(course: course)
                    .navigationBarTitle("Attendance Status", displayMode: .inline)
                    .navigationBarItems(
                        trailing:
                            Button("Done") {
                                isShowingAttendanceRecordView = false
                            }
                    )
            }
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(
                title: Text("Confirm Deletion"),
                message: Text("Are you sure you want to delete this course?"),
                primaryButton: .destructive(Text("Delete")) {
                    cancelScheduledNotification(course: course)
                    table.courses.removeAll(where: {$0 == course})
                    try? modelContext.save()
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    func titleView() -> some View {
        return (
            Text(course.name)
                .font(.system(size: 18))
                .fontWeight(.heavy)
                .frame(width: courseWidth - 20, height: 18, alignment: .leading)
                .foregroundColor(Color.white)
                .lineLimit(nil)
                .padding(.leading, 18)
        )
    }
    
    func timeView() -> some View {
        let startTimeText = table.getPeriod(index: course.period).getStartTimeText()
        let endTimeText = table.getPeriod(index: course.period).getEndTimeText()
        return (
            HStack {
                Image(systemName: "clock.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 14, height: 14)
                    .foregroundColor(course.getSelectedColor().opacity(0.75))
                    .padding(.leading, 14)
                Text(startTimeText + " ~ " + endTimeText)
                    .foregroundColor(Color.black)
                    .font(.system(size: 14))
            }
                .frame(width: courseWidth - 20, height: 15, alignment: .leading)
        )
    }
    
    func classroomView() -> some View {
        return (
            HStack {
                Image(systemName: "mappin.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 14, height: 14)
                    .foregroundColor(course.getSelectedColor().opacity(0.75))
                    .padding(.leading, 14)
                
                Text(course.classroom)
                    .foregroundColor(Color.black)
                    .font(.system(size: 14))
            }
                .frame(width: courseWidth - 20, height: 14, alignment: .leading)
        )
    }
    
    func teacherView() -> some View {
        return (
            HStack {
                Image(systemName: "person.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 14, height: 14)
                    .foregroundColor(course.getSelectedColor().opacity(0.75))
                    .padding(.leading, 14)
                
                Text(course.teacher)
                    .foregroundColor(Color.black)
                    .font(.system(size: 14))
            }
                .frame(width: courseWidth - 20, height: 14, alignment: .leading)
        )
    }
}
