//import SwiftUI
//import SwiftData
//
//struct WeeklyTableView: View {
//    @State var table: Table
//    
//    var body: some View {
//        courseTableView(table: table)
//    }
//    
//    func courseTableView(table: Table) -> some View {
//        return (
//            VStack {
//                ForEach(0..<table.numOfPeriods, id: \.self) { period in
//                    HStack {
//                        ForEach(0..<table.numOfDays, id: \.self) { day in
//                            WeeklyCourseView(course: table.courseArray[day][period], courseWidth: getCourseWidth(), courseHeight: getCourseHeight())
//                        }
//                    }
//                }
//            }
//        )
//    }
//    
//    func getCourseHeight() -> CGFloat {
//        if table.numOfPeriods < 7 {
//            return UIScreen.main.bounds.height / CGFloat(Float(table.numOfPeriods)) * 0.6
//        } else {
//            return UIScreen.main.bounds.height / CGFloat(Float(6)) * 0.6
//        }
//    }
//    
//    func getCourseWidth() -> CGFloat {
//        return UIScreen.main.bounds.width / CGFloat(Float(table.numOfDays)) * 0.75
//    }
//}
//
