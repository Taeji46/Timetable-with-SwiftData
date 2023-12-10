import SwiftUI

struct NoteEditView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var focusedField: Bool
    @State var course: Course
    @State var note: Note
    @State private var isShowingAlert = false
    
    var body: some View {
        Form {
            Section(header: Text("Title")) {
                TextField("Title", text: $note.title)
                    .onChange(of: note.title) {
                        note.timestamp = Date()
                    }
            }
            
            Section(header: Text("Detail")) {
                TextEditor(text: $note.detail)
                    .focused($focusedField)
                    .frame(height: 150)
                    .onChange(of: note.detail) {
                        note.timestamp = Date()
                    }
                if focusedField {
                    Button("Done") {
                        self.focusedField = false
                    }
                }
            }
        }
        .navigationBarTitle(note.title)
        .background(colorScheme == .dark ? .indigo.opacity(0.15) : .indigo.opacity(0.15))
        .scrollContentBackground(.hidden)
        .accentColor(colorScheme == .dark ? .indigo : .indigo)
        .navigationBarItems(trailing: Button(action: {
            isShowingAlert = true
        }) {
            Image(systemName: "trash")
        })
        .alert(isPresented: $isShowingAlert) {
            Alert(
                title: Text("Confirm Deletion"),
                message: Text("Are you sure you want to delete this note?"),
                primaryButton: .destructive(Text("Delete")) {
                    deleteToDo()
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    func deleteToDo() {
        course.notes.removeAll(where: { $0 == note })
    }
}
