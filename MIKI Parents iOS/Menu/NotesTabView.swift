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
                if isLoading {
                    ProgressView("Beiträge werden geladen...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
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
            .navigationBarTitle("Notiz")
            .navigationBarItems(
                leading: Button(action: {
                    isShowingCalendarSheet.toggle()
                    fetchHolidays()
                }) {
                    Image(systemName: "calendar.badge.exclamationmark")
                        .font(.title)
                },
                trailing: Button(action: {
                    isShowingNewPostSheet.toggle()
                }) {
                    Image(systemName: "plus")
                        .font(.title)
                }
            )
            .onAppear(perform: fetchPosts)
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
    
    private func fetchPosts() {
        isLoading = true
        let db = Firestore.firestore()
        db.collection("Posts").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching posts: \(error)")
                isLoading = false
                return
            }
            self.posts = (snapshot?.documents.compactMap { document in
                try? document.data(as: Post.self)
            } ?? []).sorted {
                guard let date1 = $0.uploadDate, let date2 = $1.uploadDate else {
                    return $0.uploadDate != nil
                }
                return date1 > date2
            }
            isLoading = false
        }
    }
    
    private func deletePost(_ post: Post) {
        guard let postId = post.id else { return }
        let db = Firestore.firestore()
        db.collection("Posts").document(postId).delete { error in
            if let error = error {
                print("Error deleting post: \(error)")
            } else {
                fetchPosts()
            }
        }
    }

    private func fetchHolidays() {
        isLoadingHolidays = true
        guard let url = URL(string: "https://ferien-api.de/api/v1/holidays") else {
            print("Ungültige URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Fehler beim Laden der Feiertage: \(error)")
                isLoadingHolidays = false
                return
            }
            guard let data = data else {
                print("Keine Daten erhalten")
                isLoadingHolidays = false
                return
            }
            do {
                let decodedHolidays = try JSONDecoder().decode([Holiday].self, from: data)
                DispatchQueue.main.async {
                    self.holidays = decodedHolidays.sorted {
                        let dateFormatter = ISO8601DateFormatter()
                        guard let date1 = dateFormatter.date(from: $0.start),
                              let date2 = dateFormatter.date(from: $1.start) else {
                            return false
                        }
                        return date1 > date2
                    }
                    isLoadingHolidays = false
                }
            } catch {
                print("Fehler beim Decodieren der Feiertage: \(error)")
                isLoadingHolidays = false
            }
        }
        task.resume()
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

// Model für die API-Daten
struct Holiday: Identifiable, Codable {
    var id: String { uuid }
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
    @Environment(\.dismiss) private var dismiss

    let states = ["Alle", "BE", "BY", "BW", "HE", "HH", "MV", "NI", "NW", "RP", "SH", "SL", "SN", "ST", "TH", "BB"]
    
    var years: [String] {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        return ["Alle"] + (2020...currentYear + 1).map { String($0) }
    }

    var filteredHolidays: [Holiday] {
        let filteredByState = selectedState == "Alle" ? holidays : holidays.filter { $0.stateCode == selectedState }
        
        if selectedYear == "Alle" {
            return filteredByState
        } else {
            return filteredByState.filter {
                let startYear = String($0.start.prefix(4))
                return startYear == selectedYear
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Bundesland auswählen", selection: $selectedState) {
                    ForEach(states, id: \.self) { state in
                        Text(state).tag(state)
                    }
                }
                .pickerStyle(MenuPickerStyle())

                Picker("Jahr auswählen", selection: $selectedYear) {
                    ForEach(years, id: \.self) { year in
                        Text(year).tag(year)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                if isLoadingHolidays {
                    ProgressView("Ferienkalender wird geladen...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
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
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Schließen") {
                                dismiss()
                            }
                            .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NotesTabView()
}
