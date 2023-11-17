import SwiftUI

struct CourseView: View {
    @State var course: Course
    @State var isShowingEditView: Bool
    @State var isShowingAttendanceRecordView: Bool
    var courseWidth: CGFloat
    var courseHeight: CGFloat
    var mainInfoHeight: CGFloat
    var attendanceInfoHeight: CGFloat
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    init(course: Course) {
        self._course = State(initialValue: course)
        _isShowingEditView = State(initialValue: false)
        _isShowingAttendanceRecordView = State(initialValue: false)
        courseWidth = UIScreen.main.bounds.width * 0.925
        courseHeight = UIScreen.main.bounds.height / 4.0 * 1.5
        mainInfoHeight = 100
        attendanceInfoHeight = 60
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                ZStack {
                    Rectangle().fill(.white).frame(width: courseWidth, height: mainInfoHeight + 70).cornerRadius(12)
                    Rectangle()
                        .fill(.blue.opacity(0.75))
                        .frame(width: courseWidth, height: mainInfoHeight + 70)
                        .cornerRadius(12)
                        .onTapGesture {
                            isShowingEditView = true
                        }
                    
                    VStack {
                        if !course.isCourseEmpty() {
                            Spacer()
                            titleView()
                            Spacer()
                            ZStack {
                                Rectangle()
                                    .fill(Color.white.opacity(0.75))
                                    .cornerRadius(12)
                                VStack {
                                    timeView()
                                    classroomView()
                                    teacherView()
                                }
                            }
                            .frame(width: courseWidth - 20, height: mainInfoHeight)
                            Spacer()
                        }
                    }
                }
                .frame(width: courseWidth, height: mainInfoHeight + 70)
                
                ZStack {
                    Rectangle().fill(.white).frame(width: courseWidth, height: attendanceInfoHeight + 70).cornerRadius(12)
                    Rectangle()
                        .fill(.blue.opacity(0.75))
                        .frame(width: courseWidth, height: attendanceInfoHeight + 70)
                        .cornerRadius(12)
                        .onTapGesture {
                            isShowingAttendanceRecordView = true
                        }
                    
                    VStack {
                        if !course.isCourseEmpty() {
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
                                            .font(.system(size: 18))
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
                                            .font(.system(size: 18))
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
                                            .font(.system(size: 18))
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
                                            .font(.system(size: 18))
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
                            .frame(width: courseWidth - 20, height: attendanceInfoHeight)
                            Spacer()
                        }
                    }
                }
                .frame(width: courseWidth, height: attendanceInfoHeight + 70)
            }
        }
        .navigationTitle(course.name)
        .navigationBarItems(trailing: Button(action: {
            isShowingEditView = true
        }) {
            Image(systemName: "pencil")
        })
        .sheet(isPresented: $isShowingEditView) {
            NavigationView {
                CourseEditView(course: course, selectedColor: .blue)
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
    }
    
    func titleView() -> some View {
        return (
            Text(course.name)
                .font(.system(size: 20))
                .fontWeight(.heavy)
                .frame(width: courseWidth - 20, height: 20, alignment: .leading)
                .foregroundColor(Color.white)
                .lineLimit(nil)
                .padding(.leading, 20)
        )
    }
    
    func timeView() -> some View {
        return (
            HStack {
                Image(systemName: "clock.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16, height: 16)
                    .foregroundColor(.blue.opacity(0.75))
                    .padding(.leading, 16)
            }
                .frame(width: courseWidth - 20, height: 16, alignment: .leading)
        )
    }
    
    func classroomView() -> some View {
        return (
            HStack {
                Image(systemName: "mappin.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16, height: 16)
                    .foregroundColor(.blue.opacity(0.75))
                    .padding(.leading, 16)
                
                Text(course.classroom)
                    .foregroundColor(Color.black)
                    .font(.system(size: 16))
            }
                .frame(width: courseWidth - 20, height: 16, alignment: .leading)
        )
    }
    
    func teacherView() -> some View {
        return (
            HStack {
                Image(systemName: "person.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16, height: 16)
                    .foregroundColor(.blue.opacity(0.75))
                    .padding(.leading, 16)
                
                Text(course.teacher)
                    .foregroundColor(Color.black)
                    .font(.system(size: 16))
            }
                .frame(width: courseWidth - 20, height: 16, alignment: .leading)
        )
    }
}
