//
//  MovieViewModel.swift
//  Movies
//
//  Created by MacBookPro on 26/07/2025.
//

import Foundation

@MainActor
class MovieViewModel : ObservableObject {
    @Published var nowPlayingMovie : [MovieModel] = []
    @Published var topRatedMovie : [MovieModel] = []
    @Published var popularMovie : [MovieModel] = []
    @Published var errorMessage : String?
    @Published var isLoading : Bool = false
    
    init() {
        Task {
            await fetchTopRatedMovies()
            await fetchNowPlayingMovies()
            await fetchPopularMovies()
        }
    }
    func fetchNowPlayingMovies() async {
        isLoading = true
        errorMessage = nil
        guard let url = NetworkEndPoint.nowPlaying else {
            errorMessage = NetworkError.invalidURL.localizedDescription
            return
        }
        do {
            let response : MovieResponse = try await NetworkManager.shared.request(url: url, headers: NetworkEndPoint.headers, responseType: MovieResponse.self)
            self.nowPlayingMovie = response.results
        } catch {
            self.errorMessage = error.localizedDescription
            print(error.localizedDescription)
        }
        isLoading = false
    }
    
    func fetchTopRatedMovies() async {
        isLoading = true
        errorMessage = nil
        guard let url = NetworkEndPoint.topRated else {
            errorMessage = NetworkError.invalidURL.localizedDescription
            return
        }
        
        do{
            let respone : MovieResponse = try await NetworkManager.shared.request(url: url, headers: NetworkEndPoint.headers, responseType: MovieResponse.self)
            self.topRatedMovie = respone.results
        } catch {
            self.errorMessage = error.localizedDescription
            print(error.localizedDescription)
        }
        isLoading = false
    }
    
    func fetchPopularMovies() async {
        isLoading = true
        errorMessage = nil
        
        guard let url = NetworkEndPoint.popular else {
            errorMessage = NetworkError.invalidURL.localizedDescription
            return
        }
        
        do {
            let response : MovieResponse = try await NetworkManager.shared.request(url: url, headers: NetworkEndPoint.headers, responseType: MovieResponse.self)
            self.popularMovie = response.results
        } catch {
            self.errorMessage = error.localizedDescription
            
        }
        
    }
    
    
    
}
