//
//  Page2View.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 10.09.24.
//

import SwiftUI
import FirebaseFirestore

struct NotesTabView: View {
    @State private var isShowingNewPostSheet = false
    @State private var posts: [Post] = [] // Liste der Beiträge
    @State private var postToDelete: Post? // Der Beitrag, der gelöscht werden soll
    @State private var showDeleteConfirmation = false // Zeigt den Bestätigungsdialog an
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(posts) { post in
                        VStack(alignment: .leading) {
                            Text(post.title)
                                .font(.headline)
                            Text(post.content)
                                .font(.subheadline)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                postToDelete = post
                                showDeleteConfirmation = true
                            } label: {
                                Label("Löschen", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Info's")
            .navigationBarItems(trailing: Button(action: {
                isShowingNewPostSheet.toggle() // Öffnet das Sheet
            }) {
                Image(systemName: "plus")
                    .font(.title)
            })
            .onAppear(perform: fetchPosts) // Beiträge laden, wenn die View erscheint
            .sheet(isPresented: $isShowingNewPostSheet) {
                NewPostView(isPresented: $isShowingNewPostSheet, onPostAdded: fetchPosts)
            }
            .alert(isPresented: $showDeleteConfirmation) {
                Alert(
                    title: Text("Beitrag löschen"),
                    message: Text("Bist du sicher, dass du diesen Beitrag löschen möchtest?"),
                    primaryButton: .destructive(Text("Löschen")) {
                        if let post = postToDelete {
                            deletePost(post)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
    
    // Funktion, um die Beiträge von Firebase zu laden
    private func fetchPosts() {
        let db = Firestore.firestore()
        db.collection("Posts").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching posts: \(error)")
                return
            }
            
            self.posts = snapshot?.documents.compactMap { document in
                try? document.data(as: Post.self)
            } ?? []
        }
    }
    
    // Funktion, um den Beitrag in Firebase zu löschen
    private func deletePost(_ post: Post) {
        guard let postId = post.id else { return }
        
        let db = Firestore.firestore()
        db.collection("Posts").document(postId).delete { error in
            if let error = error {
                print("Error deleting post: \(error)")
            } else {
                fetchPosts() // Aktualisiere die Liste nach dem Löschen
            }
        }
    }
}
#Preview {
    NotesTabView()
}
