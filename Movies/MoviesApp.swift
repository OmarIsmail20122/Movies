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
    @StateObject var movieVM = MovieViewModel()
    var body: some View {
        HomeView(movieVM: movieVM)
    }
}

