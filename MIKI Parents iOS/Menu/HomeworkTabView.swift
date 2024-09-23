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
                ScrollView {
                    ForEach(items) { item in // Verwende nur items
                        HStack {
                            // Anzeige der Datei (Bild oder PDF Vorschau)
                            let imageUrl = item.imageUrl
                            if let url = URL(string: imageUrl) { // Korrektur hier
                                if imageUrl.lowercased().hasSuffix(".pdf") {
                                    // PDF Vorschau
                                    NavigationLink(destination: FullscreenPDFView(pdfUrl: url, uploadDate: Timestamp())) {
                                        PDFThumbnailView(url: url)
                                            .frame(width: 80, height: 80)
                                            .cornerRadius(16)
                                    }
                                } else {
                                    // Bildvorschau
                                    NavigationLink(destination: FullscreenView(imageUrl: url, uploadDate: Timestamp())) {
                                        HStack {
                                            AsyncImage(url: url) { image in
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 80, height: 80)
                                                    .cornerRadius(16)
                                            } placeholder: {
                                                Color.gray
                                                    .frame(width: 80, height: 80)
                                                    .cornerRadius(16)
                                            }
                                            VStack(alignment: .leading) {
                                                Text(item.name) // Name der Datei
                                                    .font(.headline)
                                                    .fontWeight(.bold)
                                                    .foregroundColor(Color.gray)
                                                // Zeige das Upload-Datum an
                                                Text(dateFormatter.string(from: item.uploadDate?.dateValue() ?? Date()))
                                                    .font(.subheadline)
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                    }
                                }
                            } else {
                                Image(systemName: "doc")
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            // Herzchen-Schaltfläche
                            Button(action: {
                                toggleSeenStatus(for: item) // Korrektur hier
                            }) {
                                Image(systemName: item.isSeen ? "checkmark.circle.fill" : "checkmark.circle")
                                    .foregroundColor(item.isSeen ? .green : .red)
                            }
                        }
                    }
                }
                .padding()
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

            // Sortiere die Dateien nach dem Upload-Datum (neuestes zuerst)
            self.items.sort {
                let date1 = $0.uploadDate?.dateValue() ?? Date.distantPast
                let date2 = $1.uploadDate?.dateValue() ?? Date.distantPast
                return date1 > date2
            }
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
