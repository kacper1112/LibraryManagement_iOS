//
//  BookDetailsView.swift
//  Library21
//
//  Created by Jędrzej Racibor on 26/04/2021.
//

import Foundation
import SwiftUI

struct BookDetailsView: View {
    let book: Book
    let genre: Genre
    @State private var bookCopies = [BookCopy]()
    @State private var revealDetails = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 5) {
                HStack (spacing: 0){
                    Text(book.title)
                        .font(.title2)
                        .bold()
                    Text("(" + String(book.yearOfFirstRelease) + ")")
                }
                
                Divider()
                    .padding(.bottom, 5)
                
                HStack (spacing: 0) {
                    Text("Authors: ")
                        .font(.subheadline)
                    Text("\(book.authorsString)")
                        .font(.subheadline)
                }
                
                Divider()
                    .padding(.bottom, 5)
                
                HStack (spacing: 0) {
                    Text("Genre: ")
                        .font(.subheadline)
                    Text(genre.name)
                        .font(.subheadline)
                }
                
                Divider()
                    .padding(.bottom, 5)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Description")
                        .font(.title3)
                        .bold()
                    Divider()
                    Text(book.description)
                        .font(.callout)
                        .multilineTextAlignment(.leading)
                        .lineLimit(10)
                        .padding(5)
                }
                
                Divider()
                    .padding(.bottom, 5)
                
                VStack(alignment: .center, spacing: 0) {
                    DisclosureGroup(isExpanded: $revealDetails) {
                        VStack(alignment: .leading, spacing: 5) {
                            ForEach(bookCopies) { bookCopy in 
                                BookCopyView(book: book, bookCopy: bookCopy)
                                Divider()
                            }
                        }
                    } label: {
                        Label("Copies", systemImage: "list.bullet")
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation {
                                    self.revealDetails.toggle()
                                }
                            }
                    }
                }
                .padding(5)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .navigationBarTitle(Text(book.title), displayMode: .inline)
        .onAppear {
            loadInstances(book.id)
        }
    }
    
    func loadInstances(_ bookId : Int64) {
        guard var urlComponent = URLComponents(string: "\(Constants.baseUrl)/api/books/copies/availabilityByBookId") else {
            print("Invalid loadInstances URL")
            return
        }
        urlComponent.queryItems = [
            URLQueryItem(name: "bookId", value: String(bookId))
        ]
        
        let request = URLRequest(url: urlComponent.url!)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                var decodedResponse : [BookCopy]?
                do {
                    decodedResponse = try JSONDecoder().decode([BookCopy].self, from: data)
                } catch {
                    print(error)
                    return
                }
                DispatchQueue.main.async {
                    self.bookCopies = decodedResponse!.sorted { ($0.dueDateAsDate ?? .distantPast) < ($1.dueDateAsDate ?? .distantPast) }
                }
                return
            }
            
            print("Fetching book instances data failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
}
