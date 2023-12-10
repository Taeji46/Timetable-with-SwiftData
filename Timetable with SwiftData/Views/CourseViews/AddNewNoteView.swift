import SwiftUI

struct AddNewNoteView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @FocusState private var focusedField: Bool
    @State var course: Course
    @State var title: String = ""
    @State var detail: String = ""

    
    var body: some View {
        Form {
            Section(header: Text("Title")) {
                TextField("Title", text: $title)
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
                    addToDo()
                    dismiss()
                }, label: {
                    Text("Create")
                }).disabled(title.isEmpty)
            }
        }
        .background(colorScheme == .dark ? .indigo.opacity(0.15) : .indigo.opacity(0.15))
        .scrollContentBackground(.hidden)
        .accentColor(colorScheme == .dark ? .indigo : .indigo)
        .navigationBarTitle("New Note")
    }
    
    func addToDo() {
        let newMemo = Note(course: course, title: title, detail: detail)
        course.notes.append(newMemo)
    }
}
