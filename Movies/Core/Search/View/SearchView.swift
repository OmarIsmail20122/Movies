//
//  SearchView.swift
//  Movies
//
//  Created by MacBookPro on 28/07/2025.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var searchVM = SearchViewModel()
    @State private var showingFilters = false
    @State private var searchText = ""
    @FocusState private var isSearchFocused: Bool
    @EnvironmentObject var navigationManager : NavigationManager
    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    var body: some View {
            ZStack {
                Color("primary").ignoresSafeArea()
                
                VStack(alignment: .leading ,spacing: 0) {
                    
                    // Search Header
                    HStack (alignment: .center){
                        Button(action: {
                            navigationManager.pop()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(Color("white"))
                                .frame(width:35, height: 40)
                                .background(Color.black.opacity(0.3))
                                .clipShape(Circle())
                        }
                        SearchHeaderView(
                            searchText: $searchText,
                            isSearchFocused: $isSearchFocused,
                            onSearchSubmit: {
                                Task {
                                    searchVM.searchQuery = searchText
                                    await searchVM.searchMovies(query: searchText)
                                }
                            },
                            onFilterTapped: {
                                showingFilters = true
                            },
                            onClearTapped: {
                                searchText = ""
                                searchVM.clearSearch()
                            },
                            hasActiveFilters: searchVM.selectedGenre != nil || searchVM.sortOption != .popularity
                        )
                    }
                   
                    
                    // Main Content
                    if searchVM.isLoading && searchVM.searchResults.isEmpty {
                        LoadingView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 0) {
                                if searchText.isEmpty {
                                    // Empty State - Popular Movies and Recent Searches
                                    EmptySearchStateView(
                                        popularMovies: searchVM.popularMovies,
                                        recentSearches: searchVM.recentSearches,
                                        onRecentSearchTapped: { search in
                                            searchText = search
                                            Task {
                                                searchVM.searchQuery = search
                                                await searchVM.searchMovies(query: search)
                                            }
                                        },
                                        onRemoveRecentSearch: { search in
                                            searchVM.removeRecentSearch(search)
                                        },
                                        onClearAllRecent: {
                                            searchVM.clearRecentSearches()
                                        }
                                    )
                                } else if searchVM.searchResults.isEmpty && !searchVM.isLoading {
                                    // No Results State
                                    NoResultsView(searchQuery: searchText)
                                        .frame(height: 400)
                                } else {
                                    // Search Results
                                    SearchResultsView(
                                        results: searchVM.searchResults,
                                        totalResults: searchVM.totalResults,
                                        isLoading: searchVM.isLoading,
                                        hasMorePages: searchVM.hasMorePages,
                                        onLoadMore: {
                                            Task {
                                                await searchVM.loadMoreResults()
                                            }
                                        }
                                    )
                                }
                            }
                        }
                        .refreshable {
                            await searchVM.refreshData()
                        }
                    }
                }
                
                // Error Message
                if let errorMessage = searchVM.errorMessage {
                    VStack {
                        Spacer()
                        ErrorBannerView(message: errorMessage) {
                            searchVM.errorMessage = nil
                        }
                        .padding()
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingFilters) {
                SearchFiltersView(
                    selectedGenre: $searchVM.selectedGenre,
                    sortOption: $searchVM.sortOption,
                    genres: searchVM.availableGenres
                ) {
                    Task {
                        await searchVM.searchWithFilters()
                    }
                }
            }
            .onChange(of: searchText) { newValue in
                if newValue.isEmpty {
                    searchVM.clearSearch()
                }
            }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}


struct ErrorBannerView: View {
    let message: String
    let onDismiss: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle")
                .foregroundColor(.red)
            
            Text(message)
                .font(.caption)
                .foregroundColor(Color("white"))
                .lineLimit(2)
            
            Spacer()
            
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
        }
        .padding()
        .background(Color("tableColor"))
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}


struct SearchFiltersView: View {
    @Binding var selectedGenre: Genre?
    @Binding var sortOption: SearchViewModel.SortOption
    let genres: [Genre]
    let onApply: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 24) {
                // Sort Options
                VStack(alignment: .leading, spacing: 16) {
                    Text("Sort By")
                        .font(.headline)
                        .foregroundColor(Color("white"))
                    
                    ForEach(SearchViewModel.SortOption.allCases, id: \.self) { option in
                        Button(action: {
                            sortOption = option
                        }) {
                            HStack {
                                Image(systemName: sortOption == option ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(sortOption == option ? .blue : .gray)
                                
                                Text(option.displayName)
                                    .foregroundColor(Color("white"))
                                
                                Spacer()
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
                
                // Genre Filter
                VStack(alignment: .leading, spacing: 16) {
                    Text("Genre")
                        .font(.headline)
                        .foregroundColor(Color("white"))
                    
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            ForEach(genres) { genre in
                                Button(action: {
                                    selectedGenre = selectedGenre?.id == genre.id ? nil : genre
                                }) {
                                    Text(genre.name)
                                        .font(.caption)
                                        .foregroundColor(selectedGenre?.id == genre.id ? .white : Color("white"))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(
                                            selectedGenre?.id == genre.id ? Color.blue : Color("tableColor")
                                        )
                                        .cornerRadius(20)
                                }
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding(20)
            .background(Color("primary"))
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        onApply()
                        dismiss()
                    }
                    .foregroundColor(.blue)
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

struct NoResultsView: View {
    let searchQuery: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Results Found")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(Color("white"))
            
            Text("We couldn't find any movies matching '\(searchQuery)'")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}
struct RatingBadge: View {
    let rating: Float
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
                .font(.caption2)
            
            Text(String(format: "%.1f", rating))
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.black.opacity(0.7))
        .cornerRadius(8)
    }
}

struct MovieGridItem: View {
    let movie: MovieModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Poster Image
            ZStack {
                if let posterPath = movie.posterURL {
                    PosterImage(image: posterPath, width: 150, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 4)
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color("tableColor"))
                        .frame(height: 200)
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                                .font(.largeTitle)
                        )
                }
                
                // Rating Badge
                if let rating = movie.vote_average, rating > 0 {
                    VStack {
                        HStack {
                            Spacer()
                            RatingBadge(rating: rating)
                        }
                        Spacer()
                    }
                    .padding(8)
                }
            }
            
            // Movie Info
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(Color("white"))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                if let releaseDate = movie.release_date {
                    Text(String(releaseDate.prefix(4)))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

struct SearchResultsView: View {
    let results: [MovieModel]
    let totalResults: Int
    let isLoading: Bool
    let hasMorePages: Bool
    let onLoadMore: () -> Void
    
    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Results Header
            HStack {
                Text("\(totalResults) Results")
                    .font(.headline)
                    .foregroundColor(Color("white"))
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            // Results Grid
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(results) { movie in
                    NavigationLink(destination: MovieDetailsView(movieId: movie.id)) {
                        MovieGridItem(movie: movie)
                    }
                }
                
                // Load More Indicator
                if hasMorePages {
                    Button(action: onLoadMore) {
                        if isLoading {
                            ProgressView()
                                .tint(Color("white"))
                        } else {
                            Text("Load More")
                                .foregroundColor(.blue)
                        }
                    }
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .gridCellColumns(2)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 20)
    }
}


struct RecentSearchRow: View {
    let search: String
    let onTapped: () -> Void
    let onRemove: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onTapped) {
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.gray)
                        .font(.caption)
                    
                    Text(search)
                        .foregroundColor(Color("white"))
                        .font(.body)
                    
                    Spacer()
                }
            }
            
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color("tableColor"))
        .cornerRadius(8)
    }
}

struct EmptySearchStateView: View {
    let popularMovies: [MovieModel]
    let recentSearches: [String]
    let onRecentSearchTapped: (String) -> Void
    let onRemoveRecentSearch: (String) -> Void
    let onClearAllRecent: () -> Void
    
    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Recent Searches
            if !recentSearches.isEmpty {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Recent Searches")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("white"))
                        
                        Spacer()
                        
                        Button("Clear All") {
                            onClearAllRecent()
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                    }
                    
                    LazyVStack(spacing: 8) {
                        ForEach(recentSearches, id: \.self) { search in
                            RecentSearchRow(
                                search: search,
                                onTapped: { onRecentSearchTapped(search) },
                                onRemove: { onRemoveRecentSearch(search) }
                            )
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            
            // Popular Movies
            if !popularMovies.isEmpty {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Popular Movies")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("white"))
                        .padding(.horizontal, 20)
                    
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(popularMovies) { movie in
                            NavigationLink(destination: MovieDetailsView(movieId: movie.id)) {
                                MovieGridItem(movie: movie)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .padding(.vertical, 20)
    }
}

struct SearchHeaderView: View {
    @Binding var searchText: String
    var isSearchFocused: FocusState<Bool>.Binding
    let onSearchSubmit: () -> Void
    let onFilterTapped: () -> Void
    let onClearTapped: () -> Void
    let hasActiveFilters: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                // Search TextField
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search movies...", text: $searchText)
                        .focused(isSearchFocused)
                        .textFieldStyle(PlainTextFieldStyle())
                        .foregroundColor(Color("white"))
                        .onSubmit {
                            onSearchSubmit()
                        }
                    
                    if !searchText.isEmpty {
                        Button(action: onClearTapped) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color("tableColor"))
                .cornerRadius(12)
                
                // Filter Button
                Button(action: onFilterTapped) {
                    ZStack {
                        Image(systemName: "slider.horizontal.3")
                            .font(.title3)
                            .foregroundColor(Color("white"))
                        
                        if hasActiveFilters {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 8, height: 8)
                                .offset(x: 8, y: -8)
                        }
                    }
                }
                .frame(width: 44, height: 44)
                .background(Color("tableColor"))
                .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
        }
        .background(Color("primary"))
    }
}
