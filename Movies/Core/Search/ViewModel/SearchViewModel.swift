//
//  SearchViewModel.swift
//  Movies
//
//  Created by MacBookPro on 28/07/2025.
//

import Foundation

@MainActor
class SearchViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var searchResults: [MovieModel] = []
    @Published var searchQuery: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var totalResults: Int = 0
    @Published var currentPage: Int = 1
    @Published var hasMorePages: Bool = false
    @Published var recentSearches: [String] = []
    @Published var popularMovies: [MovieModel] = []
    @Published var selectedGenre: Genre?
    @Published var availableGenres: [Genre] = []
    @Published var sortOption: SortOption = .popularity
    
    // MARK: - Private Properties
    private let recentSearchesKey = "RecentSearches"
    private let maxRecentSearches = 10
    private var searchTask: Task<Void, Never>?
    
    enum SortOption: String, CaseIterable {
        case popularity = "popularity.desc"
        case releaseDate = "release_date.desc"
        case rating = "vote_average.desc"
        case title = "title.asc"
        
        var displayName: String {
            switch self {
            case .popularity: return "Popularity"
            case .releaseDate: return "Release Date"
            case .rating: return "Rating"
            case .title: return "Title"
            }
        }
    }
    
    init() {
        loadRecentSearches()
        Task {
            await loadInitialData()
        }
    }
    
    // MARK: - Initial Data Loading
    func loadInitialData() async {
        async let popular: () = fetchPopularMovies()
        async let genres: () = fetchGenres()
        
        let _ = await (popular, genres)
    }
    
    // MARK: - Search Functionality
    func searchMovies(query: String) async {
        // Cancel previous search task
        searchTask?.cancel()
        
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            searchResults = []
            totalResults = 0
            hasMorePages = false
            currentPage = 1
            return
        }
        
        searchTask = Task {
            await performSearch(query: query, page: 1)
        }
        
        await searchTask?.value
    }
    
    func loadMoreResults() async {
        guard !isLoading && hasMorePages && !searchQuery.isEmpty else { return }
        
        let nextPage = currentPage + 1
        await performSearch(query: searchQuery, page: nextPage, isLoadingMore: true)
    }
    
    private func performSearch(query: String, page: Int, isLoadingMore: Bool = false) async {
        if !isLoadingMore {
            isLoading = true
            errorMessage = nil
        }
        
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let encodedQuery = trimmedQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = NetworkEndPoint.searchURL else {
            handleError(NetworkError.invalidURL)
            return
        }
        
        do {
            let response = try await NetworkManager.shared.request(
                url: url,
                headers: NetworkEndPoint.headers,
                responseType: SearchResponse.self
            )
            
            if page == 1 {
                searchResults = response.results
                addToRecentSearches(trimmedQuery)
            } else {
                searchResults.append(contentsOf: response.results)
            }
            
            totalResults = response.total_results
            currentPage = response.page
            hasMorePages = response.page < response.total_pages
            
        } catch {
            handleError(error)
        }
        
        isLoading = false
    }
    
    // MARK: - Advanced Search with Filters
    func searchWithFilters() async {
        isLoading = true
        errorMessage = nil
        guard let url = NetworkEndPoint.searchURL else {
            errorMessage = NetworkError.invalidURL.localizedDescription
            return
        }
        do {
            let response = try await NetworkManager.shared.request(
                url: url,
                headers: NetworkEndPoint.headers,
                responseType: SearchResponse.self
            )
            
            searchResults = response.results
            totalResults = response.total_results
            currentPage = response.page
            hasMorePages = response.page < response.total_pages
            print(response)
        } catch {
            handleError(error)
        }
        
        isLoading = false
    }
    
    // MARK: - Popular Movies
    func fetchPopularMovies() async {
        guard let url = NetworkEndPoint.popular else {
            errorMessage = NetworkError.invalidURL.localizedDescription
            return
            
        }
        
        do {
            let response = try await NetworkManager.shared.request(
                url: url,
                headers: NetworkEndPoint.headers,
                responseType: MovieResponse.self
            )
            popularMovies = Array(response.results.prefix(20))
        } catch {
            print("Failed to fetch popular movies: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Genres
    func fetchGenres() async {
        guard let url = NetworkEndPoint.genresURL else { return }
        
        do {
            let response = try await NetworkManager.shared.request(
                url: url,
                headers: NetworkEndPoint.headers,
                responseType: GenresResponse.self
            )
            availableGenres = response.genres
        } catch {
            print("Failed to fetch genres: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Recent Searches Management
    private func addToRecentSearches(_ search: String) {
        var searches = recentSearches
        
        // Remove if already exists
        searches.removeAll { $0.lowercased() == search.lowercased() }
        
        // Add to beginning
        searches.insert(search, at: 0)
        
        // Limit to maxRecentSearches
        if searches.count > maxRecentSearches {
            searches = Array(searches.prefix(maxRecentSearches))
        }
        
        recentSearches = searches
        saveRecentSearches()
    }
    
    func clearRecentSearches() {
        recentSearches.removeAll()
        UserDefaults.standard.removeObject(forKey: recentSearchesKey)
    }
    
    func removeRecentSearch(_ search: String) {
        recentSearches.removeAll { $0 == search }
        saveRecentSearches()
    }
    
    private func loadRecentSearches() {
        if let searches = UserDefaults.standard.array(forKey: recentSearchesKey) as? [String] {
            recentSearches = searches
        }
    }
    
    private func saveRecentSearches() {
        UserDefaults.standard.set(recentSearches, forKey: recentSearchesKey)
    }
    
    // MARK: - Utility Functions
    func clearSearch() {
        searchQuery = ""
        searchResults = []
        totalResults = 0
        hasMorePages = false
        currentPage = 1
        selectedGenre = nil
        sortOption = .popularity
        errorMessage = nil
    }
    
    func refreshData() async {
        if searchQuery.isEmpty {
            await fetchPopularMovies()
        } else {
            await searchMovies(query: searchQuery)
        }
    }
    
    // MARK: - Error Handling
    private func handleError(_ error: Error) {
        if let networkError = error as? NetworkError {
            errorMessage = networkError.localizedDescription
        } else {
            errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
        }
        print("SearchViewModel Error: \(error)")
    }
}
