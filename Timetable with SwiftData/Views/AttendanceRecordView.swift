import SwiftUI

struct AttendanceRecordView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State var course: Course
    
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
            
            List {
                ForEach(course.attendanceRecords.sorted { $0.date > $1.date }, id: \.id) { attendance in
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(colorScheme == .dark ? .black : .white)
                        RoundedRectangle(cornerRadius: 10)
                            .fill(course.getSelectedColor().opacity(0.75))
                        
                        HStack {
                            Text(formattedDate(attendance.date))
                                .bold()
                                .padding()
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer()
                            
                            Text(attendance.status.localizedString)
                                .bold()
                                .padding()
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.90, height: 40)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
                .onDelete(perform: deleteAttendance)
            }
            .listStyle(PlainListStyle())
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
