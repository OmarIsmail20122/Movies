//
//  FavoritesView.swift
//  Movies
//
//  Created by MacBookPro on 04/08/2025.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var showDeleteAlert = false
    @State private var movieToDelete: FavoriteMovie?
    
    var body: some View {
        ZStack {
            Color("primary")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Header
                customHeader
                
                if viewModel.favoriteMovies.isEmpty {
                    emptyStateView
                } else {
                    favoritesList
                }
            }
        }
        .padding()
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .navigationDestination(for: NavigationManager.Destination.self) { destination in
            destinationView(for: destination, navigationManager: navigationManager)
        }
        .background(Color("primary"))
        .alert("Remove from Favorites", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Remove", role: .destructive) {
                if let movie = movieToDelete {
                    withAnimation {
                        viewModel.removeFavorite(movieId: movie.id)
                        // Navigate back to refresh the list
                        navigationManager.pop()
                    }
                }
            }
        } message: {
            Text("Are you sure you want to remove \"\(movieToDelete?.title ?? "this movie")\" from your favorites?")
        }
        .onAppear {
            viewModel.loadFavorites()
        }
        .onChange(of: viewModel.favoriteMovies.count) { newValue in
                    // Reload favorites when count changes (item removed from details view)
                    viewModel.loadFavorites()
                }
    }
    
    // MARK: - Custom Header
    private var customHeader: some View {
        HStack(spacing: 20) {
            Button(action: {
                navigationManager.pop()
            }) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("white"))
                    .frame(width: 40, height: 40)
                    .background(Color.black.opacity(0.3))
                    .clipShape(Circle())
            }
            Text("Favorites")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Spacer()
            
            if !viewModel.favoriteMovies.isEmpty {
                Button(action: showClearAllAlert) {
                    Image(systemName: "trash")
                        .font(.title3)
                        .foregroundColor(.white)
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 50)
        .padding(.bottom, 10)
    }
    
    // MARK: - Empty State View
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "heart.slash.fill")
                .font(.system(size: 70))
                .foregroundColor(.white.opacity(0.6))
            
            Text("No Favorites Yet")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Text("Movies you mark as favorites will appear here")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    // MARK: - Favorites List
    private var favoritesList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.favoriteMovies) { movie in
                    Button(action: {
                        navigationManager.navigateToMovieDetails(movie.id)
                    }) {
                        FavoriteMovieCard(
                            movie: movie,
                            onDelete: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    viewModel.removeFavorite(movieId: movie.id)
                                    viewModel.loadFavorites()
                                }
                            }
                        )
                    }
                    .buttonStyle(.plain)
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity),
                        removal: .scale.combined(with: .opacity)
                    ))
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)
        }
    }
    
    // MARK: - Clear All Alert
    private func showClearAllAlert() {
        let alert = UIAlertController(
            title: "Clear All Favorites",
            message: "Are you sure you want to remove all movies from your favorites?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Clear All", style: .destructive) { _ in
            withAnimation {
                viewModel.clearAllFavorites()
            }
        })
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(alert, animated: true)
        }
    }
}

// MARK: - Favorite Movie Card
struct FavoriteMovieCard: View {
    let movie: FavoriteMovie
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Poster Image
            
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 80, height: 120)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                case .failure:
                    Image(systemName: "film")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                        .frame(width: 80, height: 120)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                @unknown default:
                    EmptyView()
                }
            }
            
            // Movie Info
            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                if let releaseDate = movie.releaseDate {
                    Text(formatYear(releaseDate))
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    
                    Text(String(format: "%.1f", movie.rating))
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                    
                    Text("/ 10")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }
                
                Spacer()
            }
            .padding(.vertical, 4)
            
            Spacer()
            
            // Delete Button
            Button(action: onDelete) {
                Image(systemName: "heart.fill")
                    .font(.title3)
                    .foregroundColor(.red)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
    
    private func formatYear(_ dateString: String) -> String {
        let components = dateString.split(separator: "-")
        return components.first.map(String.init) ?? dateString
    }
}



struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
