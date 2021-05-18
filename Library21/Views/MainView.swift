//
//  MainView.swift
//  Library21
//
//  Created by Kacper Stysiński on 01/04/2021.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject private var session: LibraryService

    var body: some View {
        if session.loggedin {
            TabView {
                SuggestionsView()
                    .tabItem {
                        Label("Suggestions", systemImage: "star")
                    }
                
                BrowseBooksView()
                    .tabItem {
                        Label("Browse", systemImage: "book")
                    }
                
                RatedBooksView()
                    .tabItem {
                        Label("Rated", systemImage: "flame")
                    }
                
                AccountView()
                    .tabItem {
                        Label("Account", systemImage:
                              "person")
                    }
            }
        } else {
            LoginView()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
