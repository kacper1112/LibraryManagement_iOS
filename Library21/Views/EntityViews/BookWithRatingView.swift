//
//  BookWithRatingView.swift
//  Library21
//
//  Created by Extollite on 19/05/2021.
//

import Foundation
import SwiftUI

struct BookWithRatingView: View {
    let book: BookWithRating
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
                Text("Your rating: \(book.rating)")
            }
        }
    }
}
