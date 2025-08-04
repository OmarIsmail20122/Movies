//
//  DetailsMovieViewModel.swift
//  Movies
//
//  Created by MacBookPro on 28/07/2025.
//

import Foundation
import UIKit

@MainActor
class DetailsViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var detailsMovie: DetailsModel?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var isFavorite: Bool = false
    @Published var isInWatchlist: Bool = false
    @Published var movieVideos: [MovieVideo] = []
    @Published var movieCredits: MovieCredits?
    @Published var similarMovies: [MovieModel] = []
    @Published var movieReviews: [Review] = []
    @Published var showFullOverview: Bool = false
    
    // MARK: - Private Properties
    private let favoritesKey = "FavoriteMovies"
    private let watchlistKey = "WatchlistMovies"
    private var currentMovieId: Int = 0
    
    // MARK: - Main Data Fetching
    func getMovieDetailsID(movieId: Int) async {
        currentMovieId = movieId
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: "\(NetworkEndPoint.url)\(movieId)") else {
            handleError(NetworkError.invalidURL)
            return
        }
        
        do {
            let response = try await NetworkManager.shared.request(
                url: url,
                headers: NetworkEndPoint.headers,
                responseType: DetailsModel.self
            )
            self.detailsMovie = response
//            await loadAdditionalData(movieId: movieId)
            checkFavoriteStatus(movieId: movieId)
            checkWatchlistStatus(movieId: movieId)
            print("Movie details loaded: \(response.title)")
            
        } catch {
            handleError(error)
        }
        
        isLoading = false
    }
    
//    // MARK: - Additional Data Loading
//    private func loadAdditionalData(movieId: Int) async {
//        async let videos = fetchMovieVideos(movieId: movieId)
//        async let credits = fetchMovieCredits(movieId: movieId)
//        async let similar = fetchSimilarMovies(movieId: movieId)
//        async let reviews = fetchMovieReviews(movieId: movieId)
//
//        let _ = await (videos, credits, similar, reviews)
//    }
    
    // MARK: - Fetch Movie Videos/Trailers
    func fetchMovieVideos(movieId: Int) async {
        guard let url = URL(string: "\(NetworkEndPoint.url)\(movieId)/videos") else { return }
        
        do {
            let response = try await NetworkManager.shared.request(
                url: url,
                headers: NetworkEndPoint.headers,
                responseType: MovieVideosResponse.self
            )
            self.movieVideos = response.results.filter { $0.type == "Trailer" && $0.site == "YouTube" }
        } catch {
            print("Failed to fetch videos: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Favorite Management
    func toggleFavorite() {
        guard let movie = detailsMovie else { return }
        
        isFavorite.toggle()
        
        var favorites = getFavoriteMovies()
        
        if isFavorite {
            let favoriteMovie = FavoriteMovie(
                id: movie.id,
                title: movie.title ,
                posterPath: movie.poster_path,
                releaseDate: movie.release_date,
                rating: movie.vote_average
            )
            favorites.append(favoriteMovie)
        } else {
            favorites.removeAll { $0.id == movie.id }
        }
        
        saveFavoriteMovies(favorites)
    }
    
    func checkFavoriteStatus(movieId: Int) {
        let favorites = getFavoriteMovies()
        isFavorite = favorites.contains { $0.id == movieId }
    }
    
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
    
    // MARK: - Watchlist Management
    func toggleWatchlist() {
        guard let movie = detailsMovie else { return }
        
        isInWatchlist.toggle()
        
        var watchlist = getWatchlistMovies()
        
        if isInWatchlist {
            let watchlistMovie = WatchlistMovie(
                id: movie.id,
                title: movie.title ?? "",
                posterPath: movie.poster_path,
                releaseDate: movie.release_date,
                overview: movie.overview
            )
            watchlist.append(watchlistMovie)
        } else {
            watchlist.removeAll { $0.id == movie.id }
        }
        
        saveWatchlistMovies(watchlist)
    }
    
    func checkWatchlistStatus(movieId: Int) {
        let watchlist = getWatchlistMovies()
        isInWatchlist = watchlist.contains { $0.id == movieId }
    }
    
    private func getWatchlistMovies() -> [WatchlistMovie] {
        guard let data = UserDefaults.standard.data(forKey: watchlistKey),
              let watchlist = try? JSONDecoder().decode([WatchlistMovie].self, from: data) else {
            return []
        }
        return watchlist
    }
    
    private func saveWatchlistMovies(_ watchlist: [WatchlistMovie]) {
        if let data = try? JSONEncoder().encode(watchlist) {
            UserDefaults.standard.set(data, forKey: watchlistKey)
        }
    }
    
    // MARK: - Utility Functions
    func formatRuntime(_ minutes: Int?) -> String {
        guard let minutes = minutes else { return "N/A" }
        
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        
        if hours > 0 {
            return "\(hours)h \(remainingMinutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    func formatReleaseDate(_ dateString: String?) -> String {
        guard let dateString = dateString else { return "N/A" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = formatter.date(from: dateString) {
            formatter.dateStyle = .long
            return formatter.string(from: date)
        }
        return dateString
    }
    
    func formatCurrency(_ amount: Int?) -> String {
        guard let amount = amount, amount > 0 else { return "N/A" }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: amount)) ?? "$\(amount)"
    }
    
    func getMainTrailerURL() -> String? {
        return movieVideos.first?.key
    }
    
    func openTrailer() {
        guard let trailerKey = getMainTrailerURL() else {
            errorMessage = "No trailer available"
            return
        }
        
        let youtubeURL = "https://www.youtube.com/watch?v=\(trailerKey)"
        if let url = URL(string: youtubeURL) {
            UIApplication.shared.open(url)
        }
    }
    
    func shareMovie() -> String {
        guard let movie = detailsMovie else { return "Check out this movie!" }
        
        let title = movie.title
        let rating = movie.vote_average
        let year = movie.release_date.prefix(4) ?? "Unknown"
        
        return "Check out \"\(title)\" (\(year)) - Rated \(String(format: "%.1f", rating))/10 ⭐"
    }
    
    func refreshData() async {
        await getMovieDetailsID(movieId: currentMovieId)
    }
    
    // MARK: - Error Handling
    private func handleError(_ error: Error) {
        if let networkError = error as? NetworkError {
            self.errorMessage = networkError.localizedDescription
        } else {
            self.errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
        }
        print("DetailsViewModel Error: \(error)")
    }
}

//@MainActor
//class DetailsViewModel : ObservableObject {
//    @Published var detailsMovie : DetailsModel?
//    @Published var errorMessage : String?
//    @Published var isLoading : Bool = false
//
//    func getMovieDetailsID(movieId : Int) async {
//        isLoading = true
//        errorMessage = nil
//
//        guard let url = URL(string: "\(NetworkEndPoint.url)\(movieId)") else {
//            errorMessage = NetworkError.invalidURL.localizedDescription
//            return
//        }
//        do {
//            let response  = try await NetworkManager.shared.request(url: url, headers: NetworkEndPoint.headers ,responseType: DetailsModel.self )
//            self.detailsMovie = response
//            print(detailsMovie!)
//
//
//        } catch {
//            self.errorMessage = error.localizedDescription
//        }
//    }
//
//}
