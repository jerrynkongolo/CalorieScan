//
//  HomeView.swift
//  CalorieScan
//
//  Created by Jerry Nkongolo on 13/12/2024.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    let appState: AppState
    
    var body: some View {
        NavigationView {
            VStack {
                if let email = Auth.auth().currentUser?.email {
                    Text("Hello, \(email)!")
                        .font(.largeTitle)
                        .padding()
                }
                
                Spacer()

                Button("Logout") {
                    do {
                        try Auth.auth().signOut()
                        appState.isAuthenticated = false
                    } catch {
                        // Handle error
                    }
                }
                .padding()
                .background(Capsule().foregroundColor(.red))
                .foregroundColor(.white)
                
                Spacer()
            }
            .navigationBarTitle("Home", displayMode: .inline)
        }
    }
}
