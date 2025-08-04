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
                        isFavorite: detailsVM.isFavorite
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
                                    isInWatchlist: detailsVM.isInWatchlist
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
    }
}

// MARK: - Supporting View Components

struct CustomNavigationBar: View {
    let onBack: () -> Void
    let onShare: () -> Void
    let onFavorite: () -> Void
    let isFavorite: Bool
    
    var body: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("white"))
                    .frame(width: 44, height: 44)
                    .background(Color.black.opacity(0.3))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: onFavorite) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.title2)
                        .foregroundColor(isFavorite ? .red : Color("white"))
                        .frame(width: 44, height: 44)
                        .background(Color.black.opacity(0.3))
                        .clipShape(Circle())
                }
                
                Button(action: onShare) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title2)
                        .foregroundColor(Color("white"))
                        .frame(width: 44, height: 44)
                        .background(Color.black.opacity(0.3))
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
    }
}

struct HeaderImageSection: View {
    let movie: DetailsModel?
    
    var body: some View {
        if let imageUrl = movie?.backdropURL {
            GeometryReader { geometry in
                PosterImage(image: imageUrl,
                          width: geometry.size.width,
                          height: 240)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                    .scaleEffect(min(max(1.0, 1.0 + (geometry.frame(in: .global).minY / 1000)), 1.1))
            }
            .frame(height: 240)
        }
    }
}

struct GenresAndRatingSection: View {
    let movie: DetailsModel?
    
    var body: some View {
        if let genres = movie?.genres {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(genres) { genre in
                        GenreChip(genre: genre)
                    }
                    
                    if let vote = movie?.vote_average {
                        RatingChip(rating: vote)
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.horizontal, -20)
        }
    }
}

struct TitleSection: View {
    let movie: DetailsModel?
    let formatDate: (String?) -> String
    let formatRuntime: (Int?) -> String
    
    var body: some View {
        if let title = movie?.title {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("white"))
                    .multilineTextAlignment(.leading)
                
                if let releaseDate = movie?.release_date {
                    Text(formatDate(releaseDate))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                if let runtime = movie?.runtime {
                    Text(formatRuntime(runtime))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

struct OverviewSection: View {
    let movie: DetailsModel?
    @Binding var showFullOverview: Bool
    
    var body: some View {
        if let overview = movie?.overview, !overview.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text("Overview")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("white"))
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(overview)
                        .foregroundColor(Color("white"))
                        .font(.body)
                        .lineLimit(showFullOverview ? nil : 4)
                        .multilineTextAlignment(.leading)
                        .animation(.easeInOut, value: showFullOverview)
                    
                    if overview.count > 200 {
                        Button(action: {
                            showFullOverview.toggle()
                        }) {
                            Text(showFullOverview ? "Show Less" : "Read More")
                                .font(.caption)
                                .foregroundColor(.blue)
                                .fontWeight(.medium)
                        }
                    }
                }
            }
        }
    }
}

struct ProductionCompaniesSection: View {
    let movie: DetailsModel?
    
    var body: some View {
        if let companies = movie?.production_companies, !companies.isEmpty {
            VStack(alignment: .leading, spacing: 16) {
                Text("Production Companies")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("white"))
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(companies) { company in
                            ProductionCompanyCard(company: company)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.horizontal, -20)
            }
        }
    }
}

struct ActionButtonsSection: View {
    let onWatchTrailer: () -> Void
    let onAddToWatchlist: () -> Void
    let isInWatchlist: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Button(action: onWatchTrailer) {
                HStack {
                    Image(systemName: "play.fill")
                        .font(.title3)
                    Text("Watch Trailer")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.red)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            Button(action: onAddToWatchlist) {
                HStack {
                    Image(systemName: isInWatchlist ? "checkmark" : "plus")
                        .font(.title3)
                    Text(isInWatchlist ? "In Watchlist" : "Add to Watchlist")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(Color("white"))
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(isInWatchlist ? Color.green : Color("tableColor"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(.top, 24)
    }
}

// MARK: - Utility Views

struct GenreChip: View {
    let genre: Genre
    
    var body: some View {
        Text(genre.name)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(Color("white"))
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("tableColor"))
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
            )
    }
}

struct RatingChip: View {
    let rating: Float
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "star.fill")
                .foregroundColor(Color("yellow"))
                .font(.caption)
            
            Text(String(format: "%.1f", rating))
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(Color("white"))
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("tableColor"))
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
    }
}

struct ProductionCompanyCard: View {
    let company: ProductionCompanies
    
    var body: some View {
        VStack(spacing: 12) {
            Group {
                if let logoPath = company.productionLogo, !logoPath.isEmpty {
                    PosterImage(image: logoPath, width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color("tableColor"))
                        .frame(width: 80, height: 80)
                        .overlay(
                            Image(systemName: "building.2")
                                .foregroundColor(.gray)
                                .font(.title2)
                        )
                }
            }
            
            Text(company.name)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .foregroundColor(Color("white"))
                .frame(width: 80)
                .lineLimit(2)
        }
        .padding(.vertical, 8)
    }
}

struct InfoCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
                .fontWeight(.medium)
            
            Text(value)
                .font(.subheadline)
                .foregroundColor(Color("white"))
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("tableColor"))
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
    }
}

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(Color("white"))
            
            Text("Loading movie details...")
                .foregroundColor(Color("white"))
                .font(.subheadline)
        }
    }
}

struct ErrorView: View {
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(.red)
            
            Text("Error")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color("white"))
            
            Text(message)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button("Try Again") {
                retryAction()
            }
            .font(.headline)
            .foregroundColor(Color("white"))
            .padding(.horizontal, 30)
            .padding(.vertical, 12)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 25))
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let shareText: String
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityVC = UIActivityViewController(
            activityItems: [shareText],
            applicationActivities: nil
        )
        return activityVC
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct MovieDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MovieDetailsView(movieId: 1087192)
        }
    }
}
