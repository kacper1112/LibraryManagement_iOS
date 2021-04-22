//
//  MainView.swift
//  Library21
//
//  Created by Kacper Stysiński on 01/04/2021.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            CurrentRentalsView()
                .tabItem {
                    Label("Current", systemImage: "book")
                }
            PastRentalsView()
                .tabItem {
                    Label("Past", systemImage: "flame")
                }
            SuggestedRentalsView()
                .tabItem {
                    Label("Suggestions", systemImage: "star")
                }
            
            AccountView()
                .tabItem {
                    Label("Account", systemImage:
                          "person")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
