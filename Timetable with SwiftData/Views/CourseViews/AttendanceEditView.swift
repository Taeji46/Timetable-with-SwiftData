import SwiftUI

struct AttendanceEditView: View {
    @Environment(\.presentationMode) var presentationMode
    var course: Course
    @State var attendance: Attendance
    @State var isShowingAlert = false
    private let currentDate = Date()
    var body: some View {
        Form {
            Section(header: Text("Status")) {
                Picker("Status", selection: $attendance.status) {
                    Text("Attend").tag(AttendanceStatus.attend)
                    Text("Absent").tag(AttendanceStatus.absent)
                    Text("Late").tag(AttendanceStatus.late)
                    Text("Canceled").tag(AttendanceStatus.canceled)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Section(header: Text("Date")) {
                DatePicker("Date", selection: $attendance.date, in: ...currentDate, displayedComponents: .date)
                    .labelsHidden()
            }
        }
        .navigationBarItems(trailing: Button(action: {
            isShowingAlert = true
        }) {
            Image(systemName: "trash")
        })
        .alert(isPresented: $isShowingAlert) {
            Alert(
                title: Text("Confirm Deletion"),
                message: Text("Are you sure you want to delete this Attendance Record?"),
                primaryButton: .destructive(Text("Delete")) {
                    course.attendanceRecords.removeAll(where: { $0 == attendance })
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
        }
    }
}