import SwiftUI
import PhotosUI
import SwiftUIImageViewer

struct NoteEditView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var focusedField: Bool
    @State var course: Course
    @State var note: Note
    @State var selectedPhoto: PhotosPickerItem?
    @State private var isShowingAlert = false
    @State private var isImagePresented = false
    
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
            
            Section(header: Text("Image")) {
                if let imageData = note.image, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .onTapGesture {
                            isImagePresented = true
                        }
                        .sheet(isPresented: $isImagePresented) {
                            SwiftUIImageViewer(image: Image(uiImage: uiImage))
                                .overlay(alignment: .topTrailing) {
                                    Button(action: {
                                        isImagePresented = false
                                    }, label: {
                                        Image(systemName: "xmark")
                                            .font(.headline)
                                    })
                                    .clipShape(Circle())
                                    .tint(.indigo)
                                    .padding()
                                }
                        }
                }
                
                if note.image == nil {
                    PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                        Label("Add Image", systemImage: "photo")
                    }
                } else {
                    Button(action: {
                        withAnimation {
                            selectedPhoto = nil
                            note.image = nil
                        }
                    }, label: {
                        Label("Remove Image", systemImage: "xmark")
                    })
                }
            }
        }
        .task(id: selectedPhoto) {
            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                note.image = data
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
