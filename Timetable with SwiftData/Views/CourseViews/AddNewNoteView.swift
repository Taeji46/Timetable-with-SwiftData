import SwiftUI

struct AddNewNoteView: View {
    @Environment(\.dismiss) var dismiss
    @FocusState private var focusedField: Bool
    @State var course: Course
    @State var content: String = ""
    @State var detail: String = ""

    
    var body: some View {
        Form {
            Section(header: Text("Content")) {
                TextField("Content", text: $content)
            }
            
            Section(header: Text("Detail")) {
                TextEditor(text: $detail)
                    .focused($focusedField)
                    .frame(height: 150)
                if focusedField {
                    Button("Done") {
                        self.focusedField = false
                    }
                }
            }

            Section {
                Button(action: {
                    addTodo()
                    dismiss()
                }, label: {
                    Text("Add to Note List")
                }).disabled(content.isEmpty)
            }
        }
        .navigationBarTitle("Add a new Note")
    }
    
    func addTodo() {
        let newMemo = Note(course: course, content: content, detail: detail)
        course.notes.append(newMemo)
    }
}
