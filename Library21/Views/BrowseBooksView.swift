//
//  ContentView.swift
//  Library21
//
//  Created by Kacper Stysiński on 29/03/2021.
//

import SwiftUI

struct BookWrapper: Decodable {
    let books: [Book]
}

struct BrowseBooksView: View {
    @State private var books = [Book]()
    
    var body: some View {
        List(books) { book in
            BookView(book: book)
        }.onAppear(perform: loadBooks)
    
    }
    
    func loadBooks() {
        guard let url = URL(string: "\(Constants.baseUrl)/api/books/display") else {
            print("Invalid URL")
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
