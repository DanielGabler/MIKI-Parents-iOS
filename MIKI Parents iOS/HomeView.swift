//
//  HomeView.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 10.09.24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreCombineSwift

struct HomeView: View {
    var body: some View {
        TabView {
            HomeTabView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }

            NotesTabView()
                .tabItem {
                    Image(systemName: "list.bullet.clipboard.fill")
                    Text("Info's")
                }

            HomeworkTabView()
                .tabItem {
                    Image(systemName: "doc.fill")
                    Text("Aufgaben")
                }

            KidsMusicTabView()
                .tabItem {
                    Image(systemName: "music.note")
                    Text("Musik")
                }
            
            SettingsTabView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Einstellungen")
                }
                .environment(userViewModel)
        }
    }
    @Environment(UserViewModel.self) private var userViewModel
}
#Preview {
    HomeView()
}
