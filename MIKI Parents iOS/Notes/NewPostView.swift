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
                let post = Post(title: title, content: content, uploadDate: Date())
                
                do {
                    try db.collection("Posts").addDocument(from: post) { error in
                        if let error = error {
                            print("Error adding post: \(error)")
                        } else {
                            onPostAdded()
                            sendPushNotification(title: post.title)
                            isPresented = false
                        }
                    }
                } catch {
                    print("Error saving post: \(error)")
                }
            }
            
            // Funktion, um Push-Nachrichten zu senden
            private func sendPushNotification(title: String) {
                let urlString = "https://fcm.googleapis.com/fcm/send"
                let url = URL(string: urlString)!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("key=AIzaSyCaDhKmKAzxuCOk0xzTc9VR6EwnCic8Tlc", forHTTPHeaderField: "Authorization")
                
                let body: [String: Any] = [
                    "to": "/topics/all", // Sende an alle, die das Thema abonniert haben
                    "notification": [
                        "title": "Neuer Beitrag",
                        "body": title,
                        "sound": "default"
                    ]
                ]
                
                request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print("Error sending push notification: \(error)")
                    } else {
                        print("Push notification sent successfully")
                    }
                }
                
                task.resume()
            }
        }
