//
//  BookDetailsView.swift
//  Library21
//
//  Created by Jędrzej Racibor on 26/04/2021.
//

import Foundation
import SwiftUI

struct BookDetailsView: View {
    @EnvironmentObject private var session: LibraryService
    
    let book: Book
    let genre: Genre
    @State private var bookCopies = [BookCopy]()
    
    @State private var revealDetails = false
    @State private var bookRated = false
    @State private var bookRating = 10.0
    
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
                
                VStack {
                    HStack {
                        Spacer().overlay(
                            Text("Your rating:")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        )
                        Text("\(Int(bookRating))")
                            .padding(.horizontal)
                        Spacer().overlay(
                            Button {
                                saveRating(book.id, Int32(bookRating))
                            } label : {
                                Text("Save")
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        )
                    }
                    HStack {
                        Text("1")
                        Slider(value: $bookRating, in: 1...10, step: 1)
                        Text("10")
                    }.foregroundColor(Color.accentColor)
                }.padding(.horizontal, 5)
                
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Description")
                        .font(.title3)
                        .bold()
                    Divider()
                    Text(book.description ?? "")
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
            }.alert(isPresented: self.$bookRated) {
                Alert(title: Text("Success"),
                      message: Text("Book rated!"),
                      dismissButton: .cancel(Text("Ok")))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .navigationBarTitle(Text(book.title), displayMode: .inline)
        .onAppear {
            loadCopies(book.id)
            loadRating(book.id)
        }
    }
    
    func loadCopies(_ bookId : Int64) {
        session.loadCopies(bookId) { bookCopies in
            self.bookCopies = bookCopies.sorted { ($0.dueDateAsDate ?? .distantPast) < ($1.dueDateAsDate ?? .distantPast) }
        }
    }
    
    func loadRating(_ bookId : Int64) {
        session.loadBookRating(bookId) { bookRating in
            let rated = bookRating == nil ? 10.0 : Double(bookRating!.rating)
            self.bookRating = rated
        }
    }
    
    func saveRating(_ bookId : Int64, _ rating : Int32) {
        session.saveBookRating(bookId, rating) { bookRating in
            self.bookRating = Double(bookRating.rating)
            self.bookRated = true
        }
    }
}
