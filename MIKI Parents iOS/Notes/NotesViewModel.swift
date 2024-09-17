//
//  NotesViewModel.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 16.09.24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreCombineSwift

class NotesViewModel: ObservableObject {
    @Published var items = [FirestoreItem]()
    @Published var errorMessage: String?

    private var db = Firestore.firestore()

    func fetchItems() {
        db.collection("Posts").getDocuments { snapshot, error in
            if let error = error {
                self.errorMessage = "Error fetching data: \(error.localizedDescription)"
                return
            }

            guard let documents = snapshot?.documents else {
                self.errorMessage = "No documents found"
                return
            }

            self.items = documents.compactMap { document in
                try? document.data(as: FirestoreItem.self)
            }
        }
    }
}
