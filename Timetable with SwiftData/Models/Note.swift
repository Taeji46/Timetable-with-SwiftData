import SwiftUI
import SwiftData

@Model
final class Note {
    var course: Course? // Parent
    
    var id = UUID()
    var content: String
    var detail: String
    var timestamp: Date
    
    init(course: Course, content: String, detail: String) {
        self.content = content
        self.detail = detail
        self.timestamp = Date()
        
        self.course = course
    }
}
