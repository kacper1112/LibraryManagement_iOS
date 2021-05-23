//
//  LoginView.swift
//  Library21
//
//  Created by Extollite on 17/05/2021.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var session: LibraryService
    @State private var pesel = "user"
    @State private var password = "user1"
    @State private var incorrectDataToggle = false
    @State private var loginInProgress = false
    @State private var loginErrorMessage = ""
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.secondary)
                    TextField("Enter your pesel", text: self.$pesel)
                        .foregroundColor(Color.black)
                }
                Divider()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            
            
            VStack {
                HStack {
                    Image(systemName: "key.fill")
                        .foregroundColor(.secondary)
                    SecureField("Enter password", text: self.$password)
                        .foregroundColor(Color.black)
                }
                Divider()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)

            VStack {
                HStack(spacing: 5) {
                    Text("Login in progress...")
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }.opacity(self.loginInProgress ? 1 : 0)
            }
            .padding()
                        
            Button {
                loginInProgress = true
                session.login(self.pesel, self.password, errorCallback: errorCallback) {
                    loginInProgress = false
                }
            } label: {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.secondary, lineWidth: 1)
                    )
            }
            .disabled(loginInProgress)
            .padding()
        }.padding(.horizontal, 40)
        .alert(isPresented: self.$incorrectDataToggle) {
            Alert(title: Text("Login failed"), message: Text(loginErrorMessage), dismissButton: .destructive(Text("Ok")))
        }
    }
    
    private func errorCallback(_ message : String?) {
        self.incorrectDataToggle.toggle()
        self.loginErrorMessage = message ?? "Incorrect login credentials!"
        self.loginInProgress = false
    }
}
