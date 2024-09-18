//
//  FileListView.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 18.09.24.
//

import SwiftUI
import Firebase

struct FileListView: View {
    @State private var files: [FileItem] = []
    @State private var selectedFile: FileItem? // Speichert das ausgewählte File
    @State private var showSheet: Bool = false // Steuert, wann das Sheet angezeigt wird
    
    var body: some View {
        NavigationView {
            List(files) { file in // 'file' ist vom Typ 'FileItem'
                HStack {
                    if file.type == "image" {
                        if let url = URL(string: file.imageUrl) { // Stelle sicher, dass 'file' vom Typ 'FileItem' ist
                            AsyncImage(url: url) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                } else {
                                    ProgressView()
                                        .frame(width: 50, height: 50)
                                }
                            }
                        }
                    } else {
                        Image(systemName: "doc.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }

                    Text(file.name) // Zeigt den Namen der Datei an
                }
            
                .onTapGesture {
                    selectedFile = file // Speichere das ausgewählte File
                    showSheet = true // Sheet anzeigen
                }
            }
            .navigationTitle("Dateien")
            .sheet(isPresented: $showSheet, content: {
                if let selectedFile = selectedFile {
                    FileDetailView(file: selectedFile) // Detailansicht des ausgewählten Bildes oder Dokuments
                }
            })
            .onAppear {
                loadFiles()
            }
        }
    }
    
    // Lädt die Dateien aus Firestore
    private func loadFiles() {
        let db = Firestore.firestore()
        db.collection("fotos").getDocuments { snapshot, error in
            if let error = error {
                print("Error loading files: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            files = documents.compactMap { doc -> FileItem? in
                try? doc.data(as: FileItem.self)
            }
        }
    }
}

#Preview {
    FileListView()
}
