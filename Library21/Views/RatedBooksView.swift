//
//  PastRentalsView.swift
//  Library21
//
//  Created by Kacper Stysiński on 01/04/2021.
//

import SwiftUI
import SwiftUIRefresh

struct RatedBooksView: View {
    @EnvironmentObject private var session: LibraryService
    
    @State private var isShowing = false
    @State private var booksLoaded = false
    @State private var books = [BookWithRating]()
    @State private var genres = [Genre]()
    
    var body: some View {
        ZStack {
            if !booksLoaded {
                VStack {
                    Text("Loading books. Please wait...")
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
            } else if books.count == 0 {
                VStack {
                    Text("You have not rated any books yet.")
                }
            } else {
                NavigationView {
                    List(books) { book in
                        let genre = findGenre(book.genreId)
                        NavigationLink(destination: BookDetailsView(book: book,
                                                                    genre: genre,
                                                                    ratingUpdateCallback: reloadBooks)) {
                            BookWithRatingView(book: book, genre: genre)
                        }
                    }
                    .navigationBarTitle("Rated books")
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
        booksLoaded = false
        isShowing = false
        
        loadGenres()
        loadBooks()
    }
    
    func reloadBooks() {
        booksLoaded = false
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
        session.loadBooksWithRating { books in
            self.books = books
            booksLoaded = true
        }
    }
}

struct RatedBooksView_Previews: PreviewProvider {
    static var previews: some View {
        RatedBooksView()
    }
}
