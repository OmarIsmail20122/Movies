//
//  HomeView.swift
//  Movies
//
//  Created by MacBookPro on 24/07/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject var movieVM = MovieViewModel()
    @StateObject var detailsVM = DetailsViewModel()
    @StateObject private var navigationManager = NavigationManager()
    @StateObject private var networkMonitor = NetworkMonitor()
    @State private var showDetails = false
    @State var textSearch: String = ""
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            if networkMonitor.isConnected {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 25) {
                        // Search Bar
                        searchBarView
                        
                        // Now Playing Section
                        VStack(alignment: .leading, spacing: 15) {
                            CustomHeadLine(
                                headLine: "Now Playing",
                                onSeeAll: {
                                    navigationManager.navigateToAllMovies(category: "Now Playing")
                                }
                            )
                            NowPlayingViewItem(
                                nowPlayingModel: movieVM.nowPlayingMovie,
                                onMovieSelected: { movieId in
                                    navigationManager.navigateToMovieDetails(movieId)
                                }
                            )
                        }
                        
                        // Top Rated Section
                        VStack(alignment: .leading, spacing: 15) {
                            CustomHeadLine(
                                headLine: "Top Rated",
                                onSeeAll: {
                                    navigationManager.navigateToAllMovies(category: "Top Rated")
                                }
                            )
                            TopRatedListView(
                                topRatedMovie: movieVM.topRatedMovie,
                                onMovieSelected: { movieId in
                                    navigationManager.navigateToMovieDetails(movieId)
                                }
                            )
                        }
                        
                        // Popular Section
                        VStack(alignment: .leading, spacing: 15) {
                            CustomHeadLine(
                                headLine: "Popular",
                                onSeeAll: {
                                    navigationManager.navigateToAllMovies(category: "Popular")
                                }
                            )
                            PopularListItemMovie(
                                popularMovie: movieVM.popularMovie,
                                onMovieSelected: { movieId in
                                    navigationManager.navigateToMovieDetails(movieId)
                                }
                            )
                        }
                    }
                }
                .padding()
                .ignoresSafeArea()
                .navigationBarHidden(true)
                .navigationDestination(for: NavigationManager.Destination.self) { destination in
                    destinationView(for: destination)
                }
                .background(Color("primary"))
            } else {
                Text("❌ لا يوجد اتصال بالإنترنت")
                   .foregroundColor(.red)
                   .padding(.top, 50)
                   .font(.title3)
            }
        }
    .onAppear {
            if networkMonitor.isConnected {
                Task {
                    await loadInitialData()
                }
            }
        }
        .onChange(of: networkMonitor.isConnected) { isConnected in
            if isConnected {
                Task {
                    await loadInitialData()
                }
            }
        }
//        .task {
//            await loadInitialData()
//        }
    }
    
    @ViewBuilder
    private func destinationView(for destination: NavigationManager.Destination) -> some View {
        switch destination {
        case .movieDetails(let movieId):
            MovieDetailsView(movieId: movieId)
                .environmentObject(navigationManager)
        case .allMovies(let category):
            AllMovieView(title: category)
                .environmentObject(navigationManager)
        case .search:
            SearchView()
                .environmentObject(navigationManager)
        case .favorites:
            FavoritesView()
                .environmentObject(navigationManager)
        }
    }
    
    private var searchBarView: some View {
        ZStack(alignment: .trailing) {
            HStack(spacing: 10) {
                Image("search")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white.opacity(0.7))
                
                TextField("Search", text: $textSearch)
                    .foregroundColor(Color("white"))
                    .frame(height: 50)
                    .onSubmit {
                        if !textSearch.isEmpty {
                            navigationManager.navigateToSearch()
                        }
                    }
            }
            .padding(.horizontal, 15)
            .background(Color.black.opacity(0.6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            Button(action: {
                // Handle filter action
            }) {
                Image("filter")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
            }
            .padding(.trailing, 15)
        }
        .padding(.top, 30)
    }
    
    private func loadInitialData() async {
        async let nowPlaying: () = movieVM.fetchNowPlayingMovies()
        async let topRated: () = movieVM.fetchTopRatedMovies()
        async let popular: () = movieVM.fetchPopularMovies()
        
        await nowPlaying
        await topRated
        await popular
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

