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
    @Environment(\.presentationMode) var presentation
    
    let book: Book
    let genre: Genre
    var ratingUpdateCallback: (() -> Void)?
    @State private var runCallback = false
    
    @State private var bookCopies = [BookCopy]()
    @State private var revealDetails = false
    @State private var bookRatedAlert = false
    @State private var isBookRated = false
    @State private var bookRating = 0.0
    
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
                    if (!isBookRated) {
                        Text("You have not rated this book yet.")
                            .font(.subheadline)
                            .padding(.bottom, 5)
                    }
                    HStack {
                        Spacer().overlay(
                            Text("Your rating:")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        )
                        Text(bookRating == 0.0 ? "-" : "\(Int(bookRating))")
                            .padding(.horizontal)
                        Spacer().overlay(
                            Button {
                                saveRating(book.id, Int32(bookRating))
                            } label : {
                                Text("Save")
                            }
                            .disabled(bookRating == 0.0)
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
            }.alert(isPresented: self.$bookRatedAlert) {
                Alert(title: Text("Success"),
                      message: Text("Book rated!"),
                      dismissButton: .cancel(Text("Ok"), action: ratedAlertCancelAction))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .navigationBarTitle(Text(book.title), displayMode: .inline)
        .onAppear {
            loadCopies(book.id)
            loadRating(book.id)
        }
        .onDisappear() {
            if runCallback == true {
                ratingUpdateCallback!()
            }
        }
    }
    
    func ratedAlertCancelAction() {
        if ratingUpdateCallback != nil {
            presentation.wrappedValue.dismiss()
            self.runCallback = true
        }
    }
    
    func loadCopies(_ bookId : Int64) {
        session.loadCopies(bookId) { bookCopies in
            self.bookCopies = bookCopies.sorted { ($0.dueDateAsDate ?? .distantPast) < ($1.dueDateAsDate ?? .distantPast) }
        }
    }
    
    func loadRating(_ bookId : Int64) {
        session.loadBookRating(bookId) { bookRating in
            let rated = bookRating == nil ? 0.0 : Double(bookRating!.rating)
            self.bookRating = rated
            self.isBookRated = bookRating != nil
        }
    }
    
    func saveRating(_ bookId : Int64, _ rating : Int32) {
        session.saveBookRating(bookId, rating) { bookRating in
            self.bookRating = Double(bookRating.rating)
            self.isBookRated = true
            self.bookRatedAlert = true
        }
    }
}
