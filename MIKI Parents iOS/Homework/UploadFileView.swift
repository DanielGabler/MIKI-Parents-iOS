//
//  UploadFileView.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 18.09.24.
//

import SwiftUI
import Firebase
import FirebaseStorage

struct UploadFileView: View {
    @Binding var isPresented: Bool
    @State private var fileName: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var selectedDocumentUrl: URL? = nil
    @State private var isShowingImagePicker = false // To control the display of the image picker
    @State private var isShowingDocumentPicker = false // To control the display of the document picker
    var onFileUploaded: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Datei auswählen")) {
                    // Auswahl des Bildes
                    Button(action: {
                        isShowingImagePicker = true // Show the image picker
                    }) {
                        Text("Bild auswählen")
                    }
                    
                    // Vorschau des ausgewählten Bildes
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                    }
                    
                    // Auswahl des Dokuments
                    Button(action: {
                        isShowingDocumentPicker = true // Show the document picker
                    }) {
                        Text("Dokument auswählen")
                    }

                    // Anzeige des ausgewählten Dokuments
                    if let selectedDocumentUrl = selectedDocumentUrl {
                        Text("Dokument ausgewählt: \(selectedDocumentUrl.lastPathComponent)")
                            .font(.subheadline)
                    }
                }
                
                Section(header: Text("Dateiname")) {
                    TextField("Name eingeben", text: $fileName)
                }
            }
            .navigationBarTitle("Datei hochladen", displayMode: .inline)
            .navigationBarItems(leading: Button("Abbrechen") {
                isPresented = false
            }, trailing: Button("Hochladen") {
                uploadFile()
            })
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(selectedImage: $selectedImage) // Open Image Picker
            }
            .sheet(isPresented: $isShowingDocumentPicker) {
                DocumentPicker(selectedDocument: $selectedDocumentUrl) // Open Document Picker
            }
        }
    }
    
    // Funktion zum Hochladen der Datei (Bild oder Dokument)
    private func uploadFile() {
        // Überprüfen, ob der Dateiname leer ist, und falls ja, Standardwert setzen
        if fileName.trimmingCharacters(in: .whitespaces).isEmpty {
            fileName = "kein Text"
        }
        
        // Wenn ein Bild ausgewählt wurde
        if let selectedImage = selectedImage, let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
            let storage = Storage.storage()
            let storageRef = storage.reference().child("images/\(UUID().uuidString).jpg")
            
            storageRef.putData(imageData, metadata: nil) { metadata, error in
                if let error = error {
                    print("Error uploading image: \(error)")
                    return
                }
                
                storageRef.downloadURL { url, error in
                    if let error = error {
                        print("Error getting download URL: \(error)")
                        return
                    }
                    
                    if let downloadURL = url {
                        saveFileMetadata(fileUrl: downloadURL.absoluteString, type: "image")
                    }
                }
            }
        }
        
        // Wenn ein Dokument ausgewählt wurde
        else if let documentUrl = selectedDocumentUrl {
            do {
                let documentData = try Data(contentsOf: documentUrl)
                let storage = Storage.storage()
                let storageRef = storage.reference().child("documents/\(UUID().uuidString).pdf")
                
                storageRef.putData(documentData, metadata: nil) { metadata, error in
                    if let error = error {
                        print("Error uploading document: \(error)")
                        return
                    }
                    
                    storageRef.downloadURL { url, error in
                        if let error = error {
                            print("Error getting download URL: \(error)")
                            return
                        }
                        
                        if let downloadURL = url {
                            saveFileMetadata(fileUrl: downloadURL.absoluteString, type: "document")
                        }
                    }
                }
            } catch {
                print("Error reading document: \(error)")
            }
        }
    }
    
    // Funktion zum Speichern der Metadaten in Firestore
    private func saveFileMetadata(fileUrl: String, type: String) {
        let db = Firestore.firestore()
        let newFile = FileItem(name: fileName, imageUrl: fileUrl, type: type, isSeen: false, isViewed: false, uploadDate: Timestamp()) // Dateityp setzen

        do {
            let _ = try db.collection("fotos").addDocument(from: newFile)
            isPresented = false
            onFileUploaded()
        } catch {
            print("Error saving file metadata: \(error)")
        }
    }
}
