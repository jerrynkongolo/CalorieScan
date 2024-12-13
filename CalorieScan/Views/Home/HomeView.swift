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
        MainTabView()
            .environmentObject(appState)
    }
}
