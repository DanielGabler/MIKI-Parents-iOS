//
//  HomeView.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 10.09.24.
//

import SwiftUI

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
                    Text("Notizen")
                }

            HomeworkTabView()
                .tabItem {
                    Image(systemName: "doc.fill")
                    Text("Hausaufgaben")
                }

            KidsMusicTabView()
                .tabItem {
                    Image(systemName: "music.note.list")
                    Text("Kids Music")
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
