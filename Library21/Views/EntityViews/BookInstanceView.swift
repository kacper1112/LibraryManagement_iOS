//
//  BookView.swift
//  Library21
//
//  Created by Kacper Stysiński on 26/04/2021.
//

import Foundation
import SwiftUI

struct BookInstanceView: View {
    let book: Book
    let bookInstance: BookInstance
    
    var body: some View {
        let backgroundColor = bookInstance.available ? nil : Color.gray.opacity(0.3)
        VStack (alignment: .leading, spacing: 5) {
            VStack (alignment: .center) {
                HStack {
                    let title = bookInstance.alternativeTitle == nil ? book.title : bookInstance.alternativeTitle
                    Text(title!)
                        .font(.headline)
                        .padding(.trailing)
                    Spacer()
                    Text("\(bookInstance.publisherName), " + String(bookInstance.yearOfRelease))
                        .font(.footnote)
                        .padding(.leading)
                }
                HStack {
                    Text("Language: \(bookInstance.languageCode)")
                        .font(.footnote)
                        .padding(.trailing)
                    Spacer()
                    Text("Pages: \(bookInstance.pagesCount)")
                        .font(.footnote)
                        .padding(.leading)
                }
            }
            if (bookInstance.available) {
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
                        Text("Due date: \(bookInstance.dueDateFormatted)")
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
