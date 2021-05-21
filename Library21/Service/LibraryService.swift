//
//  LibraryService.swift
//  Library21
//
//  Created by Extollite on 17/05/2021.
//

import Foundation

final class LibraryService: ObservableObject {
    @Published var session: URLSession?
    @Published var user : User?
    @Published var loggedin = false
    private var loggingOut = false

    func login(_ pesel : String, _ password : String, errorCallback : @escaping () -> Void, successCallback : @escaping () -> Void) {
        user = nil
        if (session == nil) {
            let config = URLSessionConfiguration.default
            session = URLSession(configuration: config)
        }
        
        guard var urlComponent = URLComponents(string: "\(Constants.baseUrl)/api/users/login") else {
            NSLog("Invalid login URL")
            return
        }
        urlComponent.queryItems = [
            URLQueryItem(name: "pesel", value: pesel)
        ]
        
        let loginData = "\(pesel):\(password)".data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        
        var request = URLRequest(url: urlComponent.url!)
        request.httpMethod = "GET"
        request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")

        session!.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                NSLog("\(error!)")
                return
            }

            if let httpStatus = response as? HTTPURLResponse {
                if (httpStatus.statusCode >= 300) {
                    DispatchQueue.main.async {
                        errorCallback()
                    }
                    return
                }
            }
            var decodedResponse : User
            do {
                decodedResponse = try JSONDecoder().decode(User.self, from: data)
            } catch {
                NSLog("\(error)")
                return
            }
            
            DispatchQueue.main.async {
                successCallback()
                self.user = decodedResponse
                self.loggedin = true
            }
        }.resume()
    }
    
    func changePassword(_ pesel : String, _ newPassword : String, callback : @escaping () -> Void) {
        guard var urlComponent = URLComponents(string: "\(Constants.baseUrl)/api/users/changePassword") else {
            NSLog("Invalid changePassword URL")
            return
        }
        urlComponent.queryItems = [
            URLQueryItem(name: "pesel", value: pesel),
            URLQueryItem(name: "newPassword", value: newPassword)
        ]

        
        var request = URLRequest(url: urlComponent.url!)
        request.httpMethod = "PATCH"

        session!.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                NSLog("\(error!)")
                return
            }

            if let httpStatus = response as? HTTPURLResponse {
                if (httpStatus.statusCode >= 300) {
                    self.logout()
                    return
                }
            }
            var decodedResponse : User
            do {
                decodedResponse = try JSONDecoder().decode(User.self, from: data)
            } catch {
                NSLog("\(error)")
                return
            }
            
            DispatchQueue.main.async {
                callback()
                self.user = decodedResponse
            }
        }.resume()
    }
    
    func loadBookRating(_ bookId : Int64, callback : @escaping (BookRating?) -> Void) {
        guard var urlComponent = URLComponents(string: "\(Constants.baseUrl)/api/books/rating/get") else {
            NSLog("Invalid loadBookRating URL")
            return
        }
        urlComponent.queryItems = [
            URLQueryItem(name: "bookId", value: String(bookId))
        ]
        
        let request = URLRequest(url: urlComponent.url!)

        dataTask(request, callback)
    }
    
    func saveBookRating(_ bookId : Int64, _ rating : Int32, callback : @escaping (BookRating) -> Void) {
        guard var urlComponent = URLComponents(string: "\(Constants.baseUrl)/api/books/rating/add") else {
            NSLog("Invalid saveBookRating URL")
            return
        }
        urlComponent.queryItems = [
            URLQueryItem(name: "bookId", value: String(bookId)),
            URLQueryItem(name: "rating", value: String(rating))
        ]
        
        var request = URLRequest(url: urlComponent.url!)
        request.httpMethod = "POST"
        
        dataTask(request, callback)
    }
    
    func loadBooks(_ callback : @escaping ([BookWithCopies]) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/api/books/display") else {
            NSLog("Invalid loadBooks URL")
            return
        }
                
        listDataTask(url, callback)
    }
    
    func loadBooksWithRating(_ callback : @escaping ([BookWithRating]) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/api/books/rating/getAll") else {
            NSLog("Invalid loadBooksWithRating URL")
            return
        }
                
        listDataTask(url, callback)
    }
    
    func loadGenres(_ callback : @escaping ([Genre]) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/api/genres") else {
            NSLog("Invalid loadGenres URL")
            return
        }
                
        listDataTask(url, callback)
    
    }
    
    func loadCopies(_ bookId : Int64, _ callback : @escaping ([BookCopy]) -> Void) {
        guard var urlComponent = URLComponents(string: "\(Constants.baseUrl)/api/books/copies/availabilityByBookId") else {
            NSLog("Invalid loadCopies URL")
            return
        }
        
        urlComponent.queryItems = [
            URLQueryItem(name: "bookId", value: String(bookId))
        ]
        
        listDataTask(urlComponent.url!, callback)
    }
    
    private func listDataTask<T : Decodable> (_ url : URL, _ callback : @escaping ([T]) -> Void) {
        if (self.loggedin == false || self.loggingOut == true) {
            return
        }
        
        let request = URLRequest(url: url)

        session!.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                NSLog("\(error!)")
                return
            }

            if let httpStatus = response as? HTTPURLResponse {
                if (httpStatus.statusCode == 401) {
                    self.logout()
                    return
                }
                if (httpStatus.statusCode >= 300) {
                    return
                }
            }
            var decodedResponse : [T]
            do {
                decodedResponse = try JSONDecoder().decode([T].self, from: data)
            } catch {
                NSLog("\(error)")
                return
            }
            DispatchQueue.main.async {
                callback(decodedResponse)
            }
        }.resume()
    }
    
    private func dataTask<T : Decodable> (_ request : URLRequest, _ callback : @escaping (T) -> Void) {
        if (self.loggedin == false || self.loggingOut == true) {
            return
        }
        
        session!.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                NSLog("\(error!)")
                return
            }

            if let httpStatus = response as? HTTPURLResponse {
                if (httpStatus.statusCode == 401) {
                    self.logout()
                    return
                }
                if (httpStatus.statusCode >= 300) {
                    return
                }
            }
            var decodedResponse : T
            do {
                decodedResponse = try JSONDecoder().decode(T.self, from: data)
            } catch {
                NSLog("\(error)")
                return
            }
            DispatchQueue.main.async {
                callback(decodedResponse)
            }
        }.resume()
    }
    
    func logout() {
        if (self.loggedin == false || self.loggingOut == true) {
            return
        }
        self.loggingOut = true
        for cookie in session!.configuration.httpCookieStorage!.cookies! {
            session!.configuration.httpCookieStorage!.deleteCookie(cookie)
        }
        DispatchQueue.main.async {
            self.loggedin = false
            self.loggingOut = false
            self.session = nil
        }
    }
}
