//
//  ContentView.swift
//  Library21
//
//  Created by Kacper Stysiński on 29/03/2021.
//

import SwiftUI

struct BrowseBooksView: View {
    @State private var books = [Book]()
    @State private var genres = [Genre]()
    
    var body: some View {
        NavigationView {
            List(books) { book in
                let genre = findGenre(book.genreId)
                NavigationLink(destination: BookDetailsView(book: book, genre: genre)) {
                    BookView(book: book, genre: genre)
                }
            }
            .navigationBarTitle("Browse")
        }
        .onAppear(perform: loadGenres)
        .onAppear(perform: loadBooks)
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
        guard let url = URL(string: "\(Constants.baseUrl)/api/genres") else {
            print("Invalid loadGenres URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try?
                    JSONDecoder().decode([Genre].self, from: data) {
                    DispatchQueue.main.async {
                        self.genres = decodedResponse
                    }
                    return
                }
            }
            print("Fetching genres data failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
    func loadBooks() {
        guard let url = URL(string: "\(Constants.baseUrl)/api/books/display") else {
            print("Invalid loadBooks URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try?
                    JSONDecoder().decode([Book].self, from: data) {
                    DispatchQueue.main.async {
                        self.books = decodedResponse
                    }
                    return
                }
            }
            
            print("Fetching books data failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseBooksView()
    }
}
