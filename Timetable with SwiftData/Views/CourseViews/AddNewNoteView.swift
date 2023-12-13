import SwiftUI
import PhotosUI
import SwiftUIImageViewer

struct AddNewNoteView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.modelContext) private var modelContext
    @FocusState private var focusedField: Bool
    @State private var isImagePresented = false
    @State var course: Course
    @State var title: String = ""
    @State var detail: String = ""
    @State var selectedPhoto: PhotosPickerItem?
    @State var images: [Data] = []
    
    
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
            
            Section(header: Text("Image")) {
                if !images.isEmpty {
                    ForEach(images, id: \.self) { imageData in
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
                                                    images.removeAll(where: { $0 == imageData })
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
                }.disabled(images.count > 3)
                    .onChange(of: selectedPhoto) { oldPhoto, newPhoto in
                        Task {
                            if let data = try? await newPhoto?.loadTransferable(type: Data.self) {
                                images.append(data)
                                selectedPhoto = nil
                            }
                        }
                    }
            }
            
            Section {
                Button(action: {
                    addNote()
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
    
    func addNote() {
        let newMemo = Note(course: course, title: title, detail: detail)
        newMemo.images = images
        course.notes.append(newMemo)
        try? modelContext.save()
    }
}

