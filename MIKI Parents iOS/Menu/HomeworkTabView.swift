//
//  Page3View.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 10.09.24.
//

import SwiftUI
import Firebase
import PDFKit

struct HomeworkTabView: View {
    @State private var isShowingUploadSheet = false
    @State private var items: [FileItem] = [] // Liste der Dateien
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach($items) { item in
                        HStack {
                            // Anzeige der Datei (Bild oder PDF Vorschau)
                            let imageUrl = item.wrappedValue.imageUrl
                            if let url = URL(string: imageUrl) {
                                if imageUrl.lowercased().hasSuffix(".pdf") {
                                    // PDF Vorschau
                                    NavigationLink(destination: FullscreenPDFView(pdfUrl: url)) {
                                        PDFThumbnailView(url: url)
                                            .frame(width: 50, height: 50)
                                            .cornerRadius(16)
                                    }
                                } else {
                                    // Bildvorschau
                                    NavigationLink(destination: FullscreenView(imageUrl: url)) {
                                        AsyncImage(url: url) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 50, height: 50)
                                                .cornerRadius(16)
                                        } placeholder: {
                                            Color.gray
                                                .frame(width: 50, height: 50)
                                                .cornerRadius(16)
                                        }
                                        Text(item.wrappedValue.name) // Name der Datei
                                            .font(.headline)
                                    }
                                    
                                }
                                
                            } else {
                                Image(systemName: "doc")
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray)
                                
                            }

                            

                            Spacer()

                            // Herzchen-Schaltfläche
                            Button(action: {
                                toggleSeenStatus(for: item.wrappedValue)
                            }) {
                                Image(systemName: item.wrappedValue.isSeen ? "checkmark.circle.fill" : "checkmark.circle")
                                    .foregroundColor(item.wrappedValue.isSeen ? .green : .red)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Aufgaben")
            .navigationBarItems(trailing: Button(action: {
                isShowingUploadSheet.toggle() // Öffnet das Upload-Sheet
            }) {
                Image(systemName: "plus")
                    .font(.title)
            })
            .onAppear(perform: fetchItems) // Daten beim Erscheinen der Seite laden
            .sheet(isPresented: $isShowingUploadSheet) {
                UploadFileView(isPresented: $isShowingUploadSheet, onFileUploaded: fetchItems)
            }
        }
    }
    
    // Funktion, um Dateien von Firestore zu laden
    private func fetchItems() {
        let db = Firestore.firestore()
        db.collection("fotos").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching files: \(error)")
                return
            }
            
            self.items = snapshot?.documents.compactMap { document in
                try? document.data(as: FileItem.self)
            } ?? []
        }
    }
    
    // Funktion, um den gesehenen Status in Firestore zu toggeln
    private func toggleSeenStatus(for item: FileItem) {
        guard let itemId = item.id else { return }
        
        let db = Firestore.firestore()
        let newStatus = !item.isSeen
        
        db.collection("fotos").document(itemId).updateData([
            "isSeen": newStatus
        ]) { error in
            if let error = error {
                print("Error updating seen status: \(error)")
                return
            }
            
            // Aktualisiere den Status lokal
            if let index = items.firstIndex(where: { $0.id == itemId }) {
                items[index].isSeen = newStatus
            }
        }
    }
}
#Preview {
    HomeworkTabView()
}
