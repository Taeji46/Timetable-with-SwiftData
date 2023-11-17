import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var courses: [Course]
    
    var body: some View {
        NavigationStack {
            HStack {
                ForEach(0..<5) { day in
                    VStack {
                        ForEach(0..<6) { period in
                            if let course = courses.first(where: { $0.day == day && $0.period == period }) {
                                NavigationLink(destination: {
                                    CourseView(course: course)
                                }, label: {
                                    WeeklyCourseView(course: course, courseWidth: getCourseWidth(), courseHeight: getCourseHeight())
                                })
                            } else {
                                Button(action: {
                                    addCourse(day: day, period: period)
                                }, label: {
                                    WeeklyEmptyCourseView(courseWidth: getCourseWidth(), courseHeight: getCourseHeight())
                                })
                            }
                        }
                    }
                }
            }
        }
    }
    func getCourseHeight() -> CGFloat {
        return UIScreen.main.bounds.height / CGFloat(Float(6)) * 0.6
    }
    
    func getCourseWidth() -> CGFloat {
        return UIScreen.main.bounds.width / CGFloat(Float(5)) * 0.75
    }
    
    private func addCourse(day: Int, period: Int) {
        let newCourse = Course(name: "", classroom: "", teacher: "", day: day, period: period)
        modelContext.insert(newCourse)
    }
    
    private func deleteCourses() {
        modelContext.delete(courses[courses.count - 1])
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Course.self, inMemory: true)
}
