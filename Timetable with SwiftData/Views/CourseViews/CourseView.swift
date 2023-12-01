import SwiftUI

struct CourseView: View {
    @State var table: Table
    @State var course: Course
    @State var isShowingEditView: Bool
    @State var isShowingAttendanceRecordView: Bool
    @State var isShowingAlert: Bool
    @State var attendCount: Int
    @State var absentCount: Int
    @State var lateCount: Int
    @State var canceledCount: Int
    let courseWidth: CGFloat = UIScreen.main.bounds.width * 0.925
    let courseInfoHeight: CGFloat = 76
    let attendanceInfoHeight: CGFloat = 50
    let insideFrameWidth: CGFloat = 12
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var modelContext
    
    init(table: Table, course: Course) {
        self._table = State(initialValue: table)
        self._course = State(initialValue: course)
        _isShowingEditView = State(initialValue: false)
        _isShowingAttendanceRecordView = State(initialValue: false)
        _isShowingAlert = State(initialValue: false)
        _attendCount = State(initialValue: course.countAttendance(status: .attend))
        _absentCount = State(initialValue: course.countAttendance(status: .absent))
        _lateCount = State(initialValue: course.countAttendance(status: .late))
        _canceledCount = State(initialValue: course.countAttendance(status: .canceled))
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
                Button(action: {
                    isShowingEditView = true
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10).fill(.white)
                        RoundedRectangle(cornerRadius: 10)
                            .fill(course.getSelectedColor().opacity(0.75))
                        
                        VStack(spacing: 0) {
                            Spacer().frame(height: insideFrameWidth)
                            titleView()
                            Spacer().frame(height: insideFrameWidth)
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white.opacity(0.75))
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
                
                ZStack {
                    Button(action: {
                        isShowingAttendanceRecordView = true
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10).fill(.white)
                            RoundedRectangle(cornerRadius: 10)
                                .fill(course.getSelectedColor().opacity(0.75))
                        }
                    })
                    
                    VStack(spacing: 0) {
                        Spacer().frame(height: insideFrameWidth)
                        Text("Attendance Status")
                            .font(.system(size: 18))
                            .fontWeight(.heavy)
                            .frame(width: courseWidth - 2 * insideFrameWidth, height: 18, alignment: .leading)
                            .foregroundColor(Color.white)
                            .lineLimit(nil)
                            .padding(.leading, 18)
                        Spacer().frame(height: insideFrameWidth)
                        ZStack {
                            Rectangle()
                                .fill(Color.white.opacity(0.75))
                                .cornerRadius(12)
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
                                })
                                .frame(width: (courseWidth - 2 * insideFrameWidth) / 4.0)
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
                                })
                                .frame(width: (courseWidth - 2 * insideFrameWidth) / 4.0)
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
                                })
                                .frame(width: (courseWidth - 2 * insideFrameWidth) / 4.0)
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
                                })
                                .frame(width: (courseWidth - 2 * insideFrameWidth) / 4.0)
                            }
                            .foregroundColor(Color.black)
                        }
                        .frame(width: courseWidth - 2 * insideFrameWidth, height: attendanceInfoHeight)
                        Spacer().frame(height: insideFrameWidth)
                    }
                }
                .frame(width: courseWidth, height: attendanceInfoHeight + 18 + 3 * insideFrameWidth)
                
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
        .sheet(isPresented: $isShowingAttendanceRecordView, onDismiss: {
            attendCount = course.countAttendance(status: .attend)
            absentCount = course.countAttendance(status: .absent)
            lateCount = course.countAttendance(status: .late)
            canceledCount = course.countAttendance(status: .canceled)
        }) {
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
        .onChange(of: course.attendanceRecords) {
            attendCount = course.countAttendance(status: .attend)
            absentCount = course.countAttendance(status: .absent)
            lateCount = course.countAttendance(status: .late)
            canceledCount = course.countAttendance(status: .canceled)
        }
    }
    
    func titleView() -> some View {
        return (
            Text(course.name)
                .font(.system(size: 18))
                .fontWeight(.heavy)
                .frame(width: courseWidth - 2 * insideFrameWidth, height: 18, alignment: .leading)
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
                    .foregroundColor(course.getSelectedColor().opacity(0.75))
                    .padding(.leading, 14)
                
                Text(course.classroom)
                    .foregroundColor(Color.black)
                    .font(.system(size: 14))
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
                    .foregroundColor(course.getSelectedColor().opacity(0.75))
                    .padding(.leading, 14)
                
                Text(course.teacher)
                    .foregroundColor(Color.black)
                    .font(.system(size: 14))
            }
                .frame(width: courseWidth - 2 * insideFrameWidth, height: 14, alignment: .leading)
        )
    }
}
