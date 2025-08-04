//
//  NavigationManager.swift
//  Movies
//
//  Created by MacBookPro on 04/08/2025.
//

import Foundation
import SwiftUI

class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()
    
    // Navigation destinations
    enum Destination: Hashable {
        case movieDetails(Int)
        case allMovies(String) // Pass the category title
        case search
        case favorites
    }
    
    // Navigate to movie details
    func navigateToMovieDetails(_ movieId: Int) {
        path.append(Destination.movieDetails(movieId))
    }
    
    // Navigate to all movies view with category
    func navigateToAllMovies(category: String) {
        path.append(Destination.allMovies(category))
    }
    
    // Navigate to search
    func navigateToSearch() {
        path.append(Destination.search)
    }
    
    // Navigate to favorites
    func navigateToFavorites() {
        path.append(Destination.favorites)
    }
    
    // Pop to root
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    // Pop one view
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
}
