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
    @State private var isShowingCalendarSheet = false // Sheet für Ferienkalender
    @State private var posts: [Post] = [] // Liste der Beiträge
    @State private var holidays: [Holiday] = [] // Liste der Feiertage aus der API
    @State private var postToDelete: Post? // Der Beitrag, der gelöscht werden soll
    @State private var showDeleteConfirmation = false // Zeigt den Bestätigungsdialog an
    @State private var isLoading: Bool = false // Variable für den Ladezustand
    
    var body: some View {
        NavigationView {
            VStack {
                // Ladebalken anzeigen, während die Daten geladen werden
                if isLoading {
                    ProgressView("Beiträge werden geladen...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5) // Vergrößert den Ladebalken
                        .padding()
                } else {
                    List {
                        ForEach(posts) { post in
                            VStack(alignment: .leading) {
                                Text(post.title)
                                    .font(.headline)
                                Text(post.content)
                                    .font(.subheadline)
                                if let uploadDate = post.uploadDate {
                                    Text("Erstellt: \(formattedDate(uploadDate))")
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }
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
            }
            .navigationBarTitle("Info's")
            .navigationBarItems(
                leading: Button(action: {
                    isShowingCalendarSheet.toggle() // Öffnet das Sheet für den Ferienkalender
                    fetchHolidays() // Lade die Feiertage von der API
                }) {
                    Image(systemName: "calendar") // Kalendersymbol
                        .font(.title)
                },
                trailing: Button(action: {
                    isShowingNewPostSheet.toggle() // Öffnet das Sheet für neue Posts
                }) {
                    Image(systemName: "plus")
                        .font(.title)
                }
            )
            .onAppear(perform: fetchPosts) // Beiträge laden, wenn die View erscheint
            .sheet(isPresented: $isShowingNewPostSheet) {
                NewPostView(isPresented: $isShowingNewPostSheet, onPostAdded: fetchPosts)
            }
            .sheet(isPresented: $isShowingCalendarSheet) {
                HolidayListView(holidays: $holidays)
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
        isLoading = true // Setzt den Ladezustand auf true, wenn die Anfrage gestartet wird
        let db = Firestore.firestore()
        db.collection("Posts").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching posts: \(error)")
                isLoading = false // Setzt den Ladezustand zurück
                return
            }
            
            // Beiträge laden und nur die mit einem gültigen Datum sortieren
            self.posts = (snapshot?.documents.compactMap { document in
                try? document.data(as: Post.self)
            } ?? []).sorted {
                // Optionales Unwrapping von uploadDate
                guard let date1 = $0.uploadDate, let date2 = $1.uploadDate else {
                    // Falls eines der Daten fehlt, behandle es als älteres Datum
                    return $0.uploadDate != nil
                }
                return date1 > date2
            }
            isLoading = false // Setzt den Ladezustand zurück
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

    // Funktion, um die Feiertage von der Ferienkalender API zu laden
    private func fetchHolidays() {
        guard let url = URL(string: "https://ferien-api.de/api/v1/holidays/NW/2024") else {
            print("Ungültige URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Fehler beim Laden der Feiertage: \(error)")
                return
            }
            
            guard let data = data else {
                print("Keine Daten erhalten")
                return
            }
            
            do {
                // Decode die API-Antwort in das Holiday-Model
                let decodedHolidays = try JSONDecoder().decode([Holiday].self, from: data)
                DispatchQueue.main.async {
                    self.holidays = decodedHolidays
                }
            } catch {
                print("Fehler beim Decodieren der Feiertage: \(error)")
            }
        }
        
        task.resume()
    }
    
    // Funktion zum Formatieren des Datums
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

// Model für die API-Daten
struct Holiday: Identifiable, Codable {
    var id: String { uuid } // Um Holiday Identifiable zu machen
    let uuid = UUID().uuidString
    let name: String
    let start: String
    let end: String
    let stateCode: String
}

// View zum Anzeigen der Feiertage in einer Liste
struct HolidayListView: View {
    @Binding var holidays: [Holiday]
    
    var body: some View {
        NavigationView {
            List(holidays) { holiday in
                VStack(alignment: .leading) {
                    Text(holiday.name)
                        .font(.headline)
                    Text("Start: \(holiday.start)")
                    Text("Ende: \(holiday.end)")
                    Text("Bundesland: \(holiday.stateCode)")
                }
            }
            .navigationBarTitle("Ferienkalender", displayMode: .inline)
        }
    }
}

#Preview {
    NotesTabView()
}
