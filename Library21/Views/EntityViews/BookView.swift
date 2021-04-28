//
//  BookView.swift
//  Library21
//
//  Created by Kacper Stysiński on 26/04/2021.
//

import Foundation
import SwiftUI

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
                Text("Copies available: \(book.numberOfAvailableCopies)")
            }
        }
    }
}
