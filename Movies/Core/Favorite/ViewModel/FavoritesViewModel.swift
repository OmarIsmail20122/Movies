//
//  FavoritesViewModel.swift
//  Movies
//
//  Created by MacBookPro on 11/01/2026.
//

import Foundation

class FavoritesViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var favoriteMovies: [FavoriteMovie] = []
    @Published var isFavorite: Bool = false
    
    // MARK: - Private Properties
    private let favoritesKey = "FavoriteMovies"
    
    // MARK: - Initialization
    init() {
        loadFavorites()
    }
    
    // MARK: - Main Actor Methods
    @MainActor
    func updateIsFavorite(_ value: Bool) {
        isFavorite = value
    }
    
    // MARK: - Public Methods
    func loadFavorites() {
        favoriteMovies = getFavoriteMovies()
    }
    
    func toggleFavorite(movie: FavoriteMovie) {
        if isFavorite(movieId: movie.id) {
            removeFavorite(movieId: movie.id)
        } else {
            addFavorite(movie)
        }
        loadFavorites()
    }
    
    func addFavorite(_ movie: FavoriteMovie) {
        var favorites = getFavoriteMovies()
        
        // Prevent duplicates
        guard !favorites.contains(where: { $0.id == movie.id }) else { return }
        
        favorites.append(movie)
        saveFavoriteMovies(favorites)
        isFavorite = true
    }
    
    func removeFavorite(movieId: Int) {
        var favorites = getFavoriteMovies()
        favorites.removeAll { $0.id == movieId }
        saveFavoriteMovies(favorites)
        isFavorite = false
    }
    
    func isFavorite(movieId: Int) -> Bool {
        let favorites = getFavoriteMovies()
        return favorites.contains { $0.id == movieId }
    }
    
    func checkFavoriteStatus(movieId: Int) {
        isFavorite = isFavorite(movieId: movieId)
    }
    
    func clearAllFavorites() {
        saveFavoriteMovies([])
        loadFavorites()
    }
    
    // MARK: - Private Methods
    private func getFavoriteMovies() -> [FavoriteMovie] {
        guard let data = UserDefaults.standard.data(forKey: favoritesKey),
              let favorites = try? JSONDecoder().decode([FavoriteMovie].self, from: data) else {
            return []
        }
        return favorites
    }
    
    private func saveFavoriteMovies(_ favorites: [FavoriteMovie]) {
        if let data = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(data, forKey: favoritesKey)
        }
    }
}
