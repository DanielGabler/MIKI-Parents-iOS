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
            Page1View()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }

            Page2View()
                .tabItem {
                    Image(systemName: "star")
                    Text("Notizen")
                }

            Page3View()
                .tabItem {
                    Image(systemName: "person")
                    Text("Hausaufgaben")
                }

            Page4View()
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
