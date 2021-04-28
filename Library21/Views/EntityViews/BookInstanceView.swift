//
//  BookView.swift
//  Library21
//
//  Created by Kacper Stysiński on 26/04/2021.
//

import Foundation
import SwiftUI

struct BookCopyView: View {
    let book: Book
    let bookCopy: BookCopy
    
    var body: some View {
        let backgroundColor = bookCopy.available ? nil : Color.gray.opacity(0.3)
        VStack (alignment: .leading, spacing: 5) {
            VStack (alignment: .center) {
                HStack {
                    let title = bookCopy.alternativeTitle == nil ? book.title : bookCopy.alternativeTitle
                    Text(title!)
                        .font(.headline)
                        .padding(.trailing)
                    Spacer()
                    Text("\(bookCopy.publisherName), " + String(bookCopy.yearOfRelease))
                        .font(.footnote)
                        .padding(.leading)
                }
                HStack {
                    Text("Language: \(bookCopy.languageCode)")
                        .font(.footnote)
                        .padding(.trailing)
                    Spacer()
                    Text("Pages: \(bookCopy.pagesCount)")
                        .font(.footnote)
                        .padding(.leading)
                }
            }
            if (bookCopy.available) {
                VStack (alignment: .leading) {
                    (Text("Book ")
                        .font(.footnote)
                        + Text("available")
                        .foregroundColor(Color.green)
                        .font(.footnote))
                }
            } else {
                VStack (alignment: .center) {
                    HStack {
                        (Text("Book ")
                            + Text("unavailable")
                            .foregroundColor(Color.red))
                            .font(.footnote)
                            .padding(.trailing)
                        Spacer()
                        Text("Due date: \(bookCopy.dueDateFormatted)")
                            .font(.footnote)
                            .padding(.leading)
                    }
                }
            }
        }
        .padding(.horizontal, 5)
        .background(backgroundColor)
    }
}
