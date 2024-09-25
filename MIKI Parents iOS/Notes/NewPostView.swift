//
//  NewPostView.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 17.09.24.
//

import SwiftUI
import Firebase

struct NewPostView: View {
    @Binding var isPresented: Bool
    @State private var title: String = ""
    @State private var content: String = ""
    var onPostAdded: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Titel")) {
                    TextField("Titel eingeben", text: $title)
                }
                
                Section(header: Text("Inhalt")) {
                    TextField("Inhalt eingeben", text: $content)
                }
            }
            .navigationBarTitle("Neuer Beitrag", displayMode: .inline)
            .navigationBarItems(leading: Button("Abbrechen") {
                isPresented = false
            }, trailing: Button("Speichern") {
                addNewPost()
            })
        }
    }
    
    // Funktion zum Hinzufügen eines neuen Beitrags in Firebase
    private func addNewPost() {
        let db = Firestore.firestore()
        let newPost = Post(title: title, content: content, uploadDate: Date())
        
        do {
            let _ = try db.collection("Posts").addDocument(from: newPost)
            isPresented = false // Schließt das Modal
            onPostAdded() // Ruft die Funktion auf, um die Liste zu aktualisieren
        } catch {
            print("Error adding post: \(error)")
        }
    }
}
