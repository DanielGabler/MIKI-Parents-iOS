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
    @State private var isLoading: Bool = false // Variable für den Ladezustand der Posts
    @State private var isLoadingHolidays: Bool = false // Variable für den Ladezustand der Feiertage
    @State private var selectedState: String = "Alle" // Ausgewähltes Bundesland
    @State private var selectedYear: String = "Alle" // Ausgewähltes Jahr

    var body: some View {
        NavigationView {
            VStack {
                // Ladebalken anzeigen, während die Beiträge geladen werden
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
            .navigationBarTitle("Info's") // Titel Beschreibung
            .navigationBarItems(
                leading: Button(action: {
                    isShowingCalendarSheet.toggle() // Öffnet das Sheet für den Ferienkalender
                    fetchHolidays() // Lade die Feiertage von der API
                }) {
                    Image(systemName: "calendar.and.person") // Kalendersymbol
                        .font(.title)
                },
                trailing: Button(action: {
                    isShowingNewPostSheet.toggle() // Öffnet das Sheet für neue Posts
                }) {
                    Image(systemName: "plus") // Plus Symbol für neuen Beitrag
                        .font(.title)
                }
            )
            .onAppear(perform: fetchPosts) // Beiträge laden, wenn die View erscheint
            .sheet(isPresented: $isShowingNewPostSheet) {
                NewPostView(isPresented: $isShowingNewPostSheet, onPostAdded: fetchPosts)
            }
            .sheet(isPresented: $isShowingCalendarSheet) {
                HolidayListView(holidays: $holidays, isLoadingHolidays: $isLoadingHolidays, selectedState: $selectedState, selectedYear: $selectedYear)
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

    // Funktion, um die Feiertage von der Ferienkalender API zu laden und nach Jahr zu sortieren
    private func fetchHolidays() {
        isLoadingHolidays = true // Ladezustand auf true setzen
        guard let url = URL(string: "https://ferien-api.de/api/v1/holidays") else {
            print("Ungültige URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Fehler beim Laden der Feiertage: \(error)")
                isLoadingHolidays = false // Ladezustand auf false setzen
                return
            }
            
            guard let data = data else {
                print("Keine Daten erhalten")
                isLoadingHolidays = false // Ladezustand auf false setzen
                return
            }
            
            do {
                // Decode die API-Antwort in das Holiday-Model
                let decodedHolidays = try JSONDecoder().decode([Holiday].self, from: data)
                DispatchQueue.main.async {
                    // Feiertage nach Startdatum sortieren (neueste oben)
                    self.holidays = decodedHolidays.sorted {
                        let dateFormatter = ISO8601DateFormatter()
                        guard let date1 = dateFormatter.date(from: $0.start),
                              let date2 = dateFormatter.date(from: $1.start) else {
                            return false
                        }
                        return date1 > date2
                    }
                    isLoadingHolidays = false // Ladezustand auf false setzen
                }
            } catch {
                print("Fehler beim Decodieren der Feiertage: \(error)")
                isLoadingHolidays = false // Ladezustand auf false setzen
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

// View zum Anzeigen der Feiertage in einer Liste oder eines Ladebalkens
struct HolidayListView: View {
    @Binding var holidays: [Holiday]
    @Binding var isLoadingHolidays: Bool
    @Binding var selectedState: String
    @Binding var selectedYear: String
    
    // Liste der Bundesländer (StateCodes)
    let states = ["Alle", "BE", "BY", "BW", "HE", "HH", "MV", "NI", "NW", "RP", "SH", "SL", "SN", "ST", "TH", "BB"]
    
    // Liste der verfügbaren Jahre
    var years: [String] {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        return ["Alle"] + (2020...currentYear + 1).map { String($0) }
    }

    // Gefilterte Ferien nach Bundesland und Jahr
    var filteredHolidays: [Holiday] {
        let filteredByState = selectedState == "Alle" ? holidays : holidays.filter { $0.stateCode == selectedState }
        
        if selectedYear == "Alle" {
            return filteredByState
        } else {
            return filteredByState.filter {
                let startYear = String($0.start.prefix(4)) // Jahr aus dem Startdatum extrahieren
                return startYear == selectedYear
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Picker für die Auswahl des Bundeslands
                Picker("Bundesland auswählen", selection: $selectedState) {
                    ForEach(states, id: \.self) { state in
                        Text(state).tag(state)
                    }
                }
                .pickerStyle(MenuPickerStyle()) // Auswahl über ein Menü

                // Picker für die Auswahl des Jahres
                Picker("Jahr auswählen", selection: $selectedYear) {
                    ForEach(years, id: \.self) { year in
                        Text(year).tag(year)
                    }
                }
                .pickerStyle(MenuPickerStyle()) // Auswahl über ein Menü
                
                if isLoadingHolidays {
                    ProgressView("Ferienkalender wird geladen...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5) // Vergrößert den Ladebalken
                        .padding()
                } else {
                    List(filteredHolidays) { holiday in
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
    }
}

#Preview {
    NotesTabView()
}
