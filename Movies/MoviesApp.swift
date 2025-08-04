//
//  MoviesApp.swift
//  Movies
//
//  Created by MacBookPro on 21/07/2025.
//

import SwiftUI

@main
struct MoviesApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}


struct MainView: View {
    @StateObject private var navigationManager = NavigationManager()

    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            HomeView()
                .environmentObject(navigationManager)
        }
    }
}
