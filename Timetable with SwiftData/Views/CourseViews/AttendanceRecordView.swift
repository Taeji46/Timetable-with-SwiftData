import SwiftUI

struct AttendanceRecordView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State var course: Course
    
    var body: some View {
        ZStack {
            Color(colorScheme == .dark ? .indigo.opacity(0.15) : .indigo.opacity(0.15))
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: true) {
                VStack {
                    ForEach(course.attendanceRecords.sorted { $0.date > $1.date }) { attendance in
                        NavigationLink(destination: {
                            AttendanceEditView(course: course, attendance: attendance)
                        }, label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(colorScheme == .dark ? .black : .white)
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(course.getSelectedColor().opacity(0.75))
                                    .shadow(color: colorScheme == .dark ? .black : .gray, radius: 3, x: 3, y: 3)
                                
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
                            .frame(width: UIScreen.main.bounds.width * 0.925)
                        })
                    }
                    Spacer()
                }
                .padding(.top, UIScreen.main.bounds.width * (1.0 - 0.925) / 2.0)
                .padding([.leading, .trailing], 8)
            }
           
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
}
