import SwiftUI
import SwiftData

@Model
final class Note {
    var course: Course? // Parent
    
    var id = UUID()
    var title: String
    var detail: String
    var timestamp: Date
    var image: Data?
    
    init(course: Course, title: String, detail: String, image: Data?) {
        self.title = title
        self.detail = detail
        self.timestamp = Date()
        self.image = image
        
        self.course = course
    }
}
