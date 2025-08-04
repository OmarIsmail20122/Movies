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
            NavigationStack {
                HomeView()
            }
            .toolbarBackground(Color("primary"), for: .navigationBar) // custom nav color
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}
