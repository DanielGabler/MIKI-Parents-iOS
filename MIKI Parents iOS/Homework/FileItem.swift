//
//  FileItem.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 18.09.24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreCombineSwift

struct FileItem: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var imageUrl: String // Dies wird sowohl für Bilder als auch für Dokumente verwendet
    var type: String // "image" oder "document"
    var isSeen: Bool
}
