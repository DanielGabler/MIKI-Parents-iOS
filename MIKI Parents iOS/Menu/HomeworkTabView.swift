//
//  Page3View.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 10.09.24.
//

import SwiftUI
import Firebase

struct HomeworkTabView: View {
    @State private var isShowingUploadSheet = false
    @State private var items: [FileItem] = [] // Liste der Dateien
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(items) { item in
                        HStack {
                            // Anzeige der Datei (Bild oder Symbol)
                            let imageUrl = item.imageUrl
                            if let url = URL(string: imageUrl) {
                                
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(8)
                                } placeholder: {
                                    Color.gray
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(8)
                                }
                            } else {
                                Image(systemName: "doc")
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray)
                            }
                            
                            Text(item.name)
                                .font(.headline)
                            
                            Spacer()
                            
                            // Herzchen-Schaltfläche
                            Button(action: {
                                toggleSeenStatus(for: item)
                            }) {
                                Image(systemName: item.isSeen ? "heart.fill" : "heart")
                                    .foregroundColor(item.isSeen ? .red : .gray)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Aufgaben")
            .navigationBarItems(trailing: Button(action: {
                isShowingUploadSheet.toggle() // Öffnet das Sheet
            }) {
                Image(systemName: "plus")
                    .font(.title)
            })
            .onAppear(perform: fetchItems) // Daten laden, wenn die Seite erscheint
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
