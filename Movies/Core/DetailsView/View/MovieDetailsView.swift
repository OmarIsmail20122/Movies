//
//  MovieDetailsView.swift
//  Movies
//
//  Created by MacBookPro on 28/07/2025.
//

import SwiftUI

struct MovieDetailsView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    let movieId: Int
    @StateObject var detailsVM = DetailsViewModel()
    @State private var showingShareSheet = false
    
    var body: some View {
        ZStack {
            Color("primary").ignoresSafeArea()
            
            if detailsVM.isLoading {
                LoadingView()
            } else if let errorMessage = detailsVM.errorMessage {
                ErrorView(message: errorMessage) {
                    Task {
                        await detailsVM.getMovieDetailsID(movieId: movieId)
                    }
                }
            } else {
                VStack(spacing: 15) {
                    // Custom Navigation Bar
                    CustomNavigationBar(
                        onBack: { navigationManager.pop() },
                        onShare: { showingShareSheet = true },
                        onFavorite: { detailsVM.toggleFavorite() },
                        isFavorite: detailsVM.favoritesViewModel.isFavorite
                    )
                    
                    // Main Content
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            // Movie Poster
                            HeaderImageSection(movie: detailsVM.detailsMovie)
                            
                            VStack(alignment: .leading, spacing: 25) {
                                // Genres and Rating
                                GenresAndRatingSection(movie: detailsVM.detailsMovie)
                                
                                // Title and Release Info
                                TitleSection(
                                    movie: detailsVM.detailsMovie,
                                    formatDate: detailsVM.formatReleaseDate,
                                    formatRuntime: detailsVM.formatRuntime
                                )
                                
                                // Overview
                                OverviewSection(
                                    movie: detailsVM.detailsMovie,
                                    showFullOverview: $detailsVM.showFullOverview
                                )
                                
                                // Production Companies
                                ProductionCompaniesSection(movie: detailsVM.detailsMovie)
                                
                                // Action Buttons
                                ActionButtonsSection(
                                    onWatchTrailer: { detailsVM.openTrailer() },
                                    onAddToWatchlist: { detailsVM.toggleWatchlist() },
                                    isInWatchlist: false
                                )
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.bottom, 40)
                    }
                    .refreshable {
                        await detailsVM.refreshData()
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .task {
            await detailsVM.getMovieDetailsID(movieId: movieId)
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(shareText: detailsVM.shareMovie())
        }
        .toast(
            isShowing: detailsVM.shouldShowFavoriteAlert,
            message: "Added to favorites!",
            icon: "heart.fill"
        )
    }
}

struct MovieDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MovieDetailsView(movieId: 1087192)
                .environmentObject(NavigationManager())
        }
    }
}
