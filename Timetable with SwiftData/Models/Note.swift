import SwiftUI
import SwiftData

@Model
final class Note {
    var course: Course? // Parent
    
    var id = UUID()
    var title: String
    var detail: String
    var timestamp: Date
    var images: [Data]
    
    init(course: Course, title: String, detail: String) {
        self.title = title
        self.detail = detail
        self.timestamp = Date()
        self.images = []
        
        self.course = course
    }
}
