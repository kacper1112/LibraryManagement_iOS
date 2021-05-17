//
//  Library21App.swift
//  Library21
//
//  Created by Kacper Stysiński on 29/03/2021.
//

import SwiftUI

@main
struct Library21App: App {
    @StateObject var sessionStore = LibraryService()

    var body: some Scene {
        WindowGroup {
            MainView().environmentObject(sessionStore)
        }
    }
}

struct Constants {
    static let baseUrl = ProcessInfo.processInfo.environment["BASE_URL"] ?? ""
}
