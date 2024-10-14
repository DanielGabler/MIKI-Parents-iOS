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
                    Text("Notiz")
                }

            HomeworkTabView()
                .tabItem {
                    Image(systemName: "doc.fill")
                    Text("Aufgabe")
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
               
        }
    }
    
}
#Preview {
    HomeView()
}
