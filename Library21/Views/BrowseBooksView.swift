//
//  ContentView.swift
//  Library21
//
//  Created by Kacper Stysiński on 29/03/2021.
//

import SwiftUI
import SwiftUIRefresh

struct BrowseBooksView: View {
    @EnvironmentObject private var session: LibraryService
    
    @State private var isShowing = false
    @State private var booksLoaded = false
    @State private var books = [Book]()
    @State private var genres = [Genre]()
    
    var body: some View {
        ZStack {
            if !booksLoaded {
                VStack {
                    Text("Loading books. Please wait...")
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
            } else {
                NavigationView {
                    List(books) { book in
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
        booksLoaded = false
        isShowing = false
        
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
        session.loadBooks { books in
            self.books = books
            booksLoaded = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseBooksView()
    }
}
