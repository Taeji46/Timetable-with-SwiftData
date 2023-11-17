import SwiftUI

struct AttendanceRecordView: View {
    @State var course: Course
    
    var body: some View {
        List {
            ForEach(course.attendanceRecords.reversed(), id: \.id) { attendance in
                VStack(alignment: .leading) {
                    HStack {
                        Text(formattedDate(attendance.date))
                            .frame(alignment: .leading)

                        Spacer()

                        Text(attendance.status.localizedString)
                            .frame(alignment: .trailing)
                    }
                }
            }
            .onDelete(perform: deleteAttendance)
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            return dateFormatter.string(from: date)
        }
    
    func deleteAttendance(at offsets: IndexSet) {
        course.attendanceRecords.remove(atOffsets: offsets)
    }
}
