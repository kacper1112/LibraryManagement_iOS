//
//  SuggestedRentalsView.swift
//  Library21
//
//  Created by Kacper Stysiński on 01/04/2021.
//

import SwiftUI

struct SuggestionsView: View {
    @EnvironmentObject private var session: LibraryService
    
    @State private var isShowing = false
    @State private var currentAndRequiredRatingsLoaded = false
    @State private var recommendationsLoaded = false
    @State private var currentRatingsCount : Int64 = 0
    @State private var requiredRatingsCount : Int64 = 0
    @State private var recommendations = [BookWithCopies]()
    @State private var genres = [Genre]()
    
    var body: some View {
        ZStack {
            if !recommendationsLoaded || !currentAndRequiredRatingsLoaded {
                VStack {
                    Text("Loading books. Please wait...")
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
            } else if currentRatingsCount < requiredRatingsCount {
                VStack {
                    Text("You need to rate \(requiredRatingsCount - currentRatingsCount) more books to be able to see recommendations")
                        .padding()
                }
            } else {
                NavigationView {
                    List(recommendations) { book in
                        let genre = findGenre(book.genreId)
                        NavigationLink(destination: BookDetailsView(book: book, genre: genre)) {
                            BookView(book: book, genre: genre)
                        }
                    }
                    .navigationBarTitle("Browse")
                    .pullToRefresh(isShowing: $isShowing) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            loadData()
                        }
                    }
                }
            }
        }
        .onAppear(perform: loadData)
    }
    
    func loadData() {
        currentAndRequiredRatingsLoaded = false
        recommendationsLoaded = false
        isShowing = false
        
        loadCurrentRequiredRatings()
        loadGenres()
        loadBooks()
    }
    
    func findGenre(_ genreId:Int64) -> Genre {
        for genre in genres {
            if genre.id == genreId {
                return genre
            }
        }
        return Genre(id: -1, name: "Unknown genre")
    }
    
    func loadGenres() {
        session.loadGenres { genres in
            self.genres = genres
        }
    }
    
    func loadBooks() {
        session.loadRecommendations { recommendations in
            self.recommendations = recommendations
            recommendationsLoaded = true
        }
    }
    
    func loadCurrentRequiredRatings() {
        session.loadCurrentAndRequiredRatings { currentAndRequiredRatings in
            self.currentRatingsCount = currentAndRequiredRatings.currentCount
            self.requiredRatingsCount = currentAndRequiredRatings.requiredCount
            currentAndRequiredRatingsLoaded = true
        }
    }
}

struct SuggestedRentalsView_Previews: PreviewProvider {
    static var previews: some View {
        SuggestionsView()
    }
}
