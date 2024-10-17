//
//  FamilyManager.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 15.10.24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FamilyManager {
    static let shared = FamilyManager()
    
    private init() {}
    
    // Funktion zum Beitreten der Familie nach QR-Code Scan
    func joinFamily(familyId: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(false, nil)
            return
        }
        
        let db = Firestore.firestore()
        
        // Füge den Benutzer zur Familie hinzu
        db.collection("families").document(familyId).updateData([
            "members": FieldValue.arrayUnion([userId])
        ]) { error in
            if let error = error {
                completion(false, error)
            } else {
                // Aktualisiere den Benutzerdatensatz mit der Family ID
                db.collection("users").document(userId).updateData([
                    "familyId": familyId
                ]) { userError in
                    if let userError = userError {
                        completion(false, userError)
                    } else {
                        completion(true, nil)
                    }
                }
            }
        }
    }
    
    // Beispiel: Familie und ihre Mitglieder abrufen
    func fetchFamilyMembers(familyId: String, completion: @escaping ([String]?, Error?) -> Void) {
        let db = Firestore.firestore()

        db.collection("families").document(familyId).getDocument { snapshot, error in
            if let error = error {
                completion(nil, error)
            } else if let data = snapshot?.data(), let members = data["members"] as? [String] {
                completion(members, nil)
            } else {
                completion(nil, nil)
            }
        }
    }
}
