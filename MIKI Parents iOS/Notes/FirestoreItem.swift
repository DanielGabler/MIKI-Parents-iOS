//
//  FirestoreItem.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 16.09.24.
//

import Foundation
import FirebaseFirestoreCombineSwift

struct FirestoreItem: Identifiable, Codable {
    @Posts var id: String?
    var title: String
    var description: String
}
