//
//  Post.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 17.09.24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreCombineSwift

struct Post: Identifiable, Codable {
    @DocumentID var id: String? // Firebase generiert automatisch eine ID
    var title: String
    var content: String
}
