import SwiftUI
import PhotosUI
import SwiftUIImageViewer

struct AddNewNoteView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @FocusState private var focusedField: Bool
    @State private var isImagePresented = false
    @State var course: Course
    @State var title: String = ""
    @State var detail: String = ""
    @State var selectedPhoto: PhotosPickerItem?
    @State var selectedPhotoData: Data?

    
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
                if let selectedPhotoData, let uiImage = UIImage(data: selectedPhotoData) {
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
                
                if selectedPhotoData == nil {
                    PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                        Label("Add Image", systemImage: "photo")
                    }
                } else {
                    Button(action: {
                        withAnimation {
                            selectedPhoto = nil
                            selectedPhotoData = nil
                        }
                    }, label: {
                        Label("Remove Image", systemImage: "xmark")
                    })
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
        .task(id: selectedPhoto) {
            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                selectedPhotoData = data
            }
        }
        .background(colorScheme == .dark ? .indigo.opacity(0.15) : .indigo.opacity(0.15))
        .scrollContentBackground(.hidden)
        .accentColor(colorScheme == .dark ? .indigo : .indigo)
        .navigationBarTitle("New Note")
    }
    
    func addToDo() {
        let newMemo = Note(course: course, title: title, detail: detail, image: selectedPhotoData)
        course.notes.append(newMemo)
    }
}
