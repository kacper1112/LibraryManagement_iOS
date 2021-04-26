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
    
    var authorsString:String {
        if (authors.count == 0) {
            return "Unknown author"
        }
        var authorsString = ""
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
}

struct BookView: View {
    let book: Book
    let genre: Genre

    var body: some View {
        
        HStack {
            VStack {
                HStack {
                    Text(book.title)
                        .padding([.top, .trailing])
                        .font(.title2)
                    Spacer()
                    Text("(" + String(book.yearOfFirstRelease) + ")")
                        .padding([.top, .leading])
                }
                
                HStack {
                    Text(book.authorsString)
                        .padding([.bottom, .trailing])
                        .font(.subheadline)
                    Spacer()
                    Text(genre.name)
                        .padding([.bottom, .leading])
                }
                Text("Copies available: \(book.bookInstanceIds.count)")
            }
        }
    }
}
