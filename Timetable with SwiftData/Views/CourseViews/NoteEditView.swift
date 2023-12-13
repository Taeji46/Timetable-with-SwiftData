import SwiftUI
import PhotosUI
import SwiftUIImageViewer

struct NoteEditView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var modelContext
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
                if !note.images.isEmpty {
                    ForEach(note.images, id: \.self) { imageData in
                        if let uiImage = UIImage(data: imageData) {
                            HStack {
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
                                                })
                                                .tint(.indigo)
                                                .padding()
                                            }
                                            .overlay(alignment: .topLeading) {
                                                Button(action: {
                                                    note.images.removeAll(where: { $0 == imageData })
                                                    try? modelContext.save()
                                                    isImagePresented = false
                                                }, label: {
                                                    Image(systemName: "trash")
                                                })
                                                .tint(.indigo)
                                                .padding()
                                            }
                                    }
                            }
                        }
                    }
                }
                
                PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                    Label("Add Image", systemImage: "photo")
                }.disabled(note.images.count > 3)
                .onChange(of: selectedPhoto) { oldPhoto, newPhoto in
                    Task {
                        if let data = try? await newPhoto?.loadTransferable(type: Data.self) {
                            note.images.append(data)
                            try? modelContext.save()
                            selectedPhoto = nil
                        }
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
                    deleteNote()
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    func deleteNote() {
        course.notes.removeAll(where: { $0 == note })
    }
}

