//
//  Library21App.swift
//  Library21
//
//  Created by Kacper Stysiński on 29/03/2021.
//

import SwiftUI

@main
struct Library21App: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

struct Constants {
    static let baseUrl = "http://192.168.0.80:8080"
}
