//
//  Rental.swift
//  Library21
//
//  Created by Kacper Stysiński on 02/04/2021.
//

import Foundation
import SwiftUI

struct Book : Identifiable, Codable {
    let id:Int64
    let title:String
    let authors:[Author]
    let genreId:Int64
    let yearOfFirstRelease:Int64
    let description:String
    let bookInstanceIds:[Int64]
    
    init(id:Int64, title:String, authors:[Author], genreId:Int64, yearOfFirstRelease:Int64, description:String, bookInstanceIds:[Int64]) {
        self.id = id
        self.title = title
        self.authors = authors
        self.genreId = genreId
        self.yearOfFirstRelease = yearOfFirstRelease
        self.description = description
        self.bookInstanceIds = bookInstanceIds
    }
    
    func printAuthors() -> String {
        if (authors.count == 0) {
            return "Unknown author"
        }
        var authorsString = "by "
        var counter = 1
        
        for author in authors {
            authorsString.append("\(author.firstName) \(author.lastName)")
            if (counter < authors.count) {
                authorsString.append(", ")
            }
            counter += 1
        }
        
        return authorsString
    }
    
    func printReleaseYear() -> String {
        return "(\(yearOfFirstRelease))"
    }
}

struct BookView: View {
    var book: Book

    var body: some View {
        
        HStack {
            VStack {
                HStack {
                    Text(book.title).padding([.top]).font(.title2)
                    Spacer()
                    Text(book.printReleaseYear()).padding([.top, .leading])
                }
                
                HStack {
                    Text(book.printAuthors()).padding([.bottom]).font(.subheadline)
                    Spacer()
                }
                Text("Copies available: \(book.bookInstanceIds.count)")
            }
        }
    }
}
