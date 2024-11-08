//
//  FirestoreItem.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 16.09.24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreCombineSwift

struct FirestoreItem: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var description: String
}
