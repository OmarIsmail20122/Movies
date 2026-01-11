import SwiftUI
import Foundation

// MARK: - Movie Video Models
struct MovieVideosResponse: Codable {
    let results: [MovieVideo]
}

struct MovieVideo: Codable, Identifiable {
    let id: String
    let name: String
    let key: String
    let site: String
    let type: String
    let official: Bool
    let publishedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, key, site, type, official
        case publishedAt = "published_at"
    }
    
    var isTrailer: Bool {
        return type.lowercased() == "trailer"
    }
    
    var youTubeURL: URL? {
        guard site.lowercased() == "youtube" else { return nil }
        return URL(string: "https://www.youtube.com/watch?v=\(key)")
    }
    
    var thumbnailURL: URL? {
        guard site.lowercased() == "youtube" else { return nil }
        return URL(string: "https://img.youtube.com/vi/\(key)/hqdefault.jpg")
    }
}

// MARK: - NetworkEndPoint Extension
extension NetworkEndPoint {
    static func movieVideos(movieID: Int) -> URL? {
        return URL(string: "\(baseURL)/movie/\(movieID)/videos?api_key=\(apiKey)&language=en-US")
    }
    
    // Add these if not already present
    private static let baseURL = "https://api.themoviedb.org/3"
    private static let apiKey = "YOUR_TMDB_API_KEY" // Replace with your actual API key
}

// MARK: - Movie Video Service
class MovieVideoService: ObservableObject {
    @Published var videos: [MovieVideo] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchMovieVideos(movieID: Int) async {
        isLoading = true
        errorMessage = nil
        
        guard let url = NetworkEndPoint.movieVideos(movieID: movieID) else {
            errorMessage = NetworkError.invalidURL.localizedDescription
            isLoading = false
            return
        }
        
        do {
            let response: MovieVideosResponse = try await NetworkManager.shared.request(
                url: url,
                headers: NetworkEndPoint.headers,
                responseType: MovieVideosResponse.self
            )
            
            // Filter for trailers and sort by official first, then by published date
            self.videos = response.results
                .filter { $0.isTrailer }
                .sorted { first, second in
                    if first.official != second.official {
                        return first.official
                    }
                    return first.publishedAt > second.publishedAt
                }
        } catch {
            self.errorMessage = error.localizedDescription
            print("Video fetch error: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    // Get the main trailer (first official trailer or first available)
    var mainTrailer: MovieVideo? {
        return videos.first { $0.official } ?? videos.first
    }
    
    func clearVideos() {
        videos.removeAll()
        errorMessage = nil
    }
}

// MARK: - Updated Details ViewModel
class DetailsViewModel2: ObservableObject {
    @Published var detailsMovie: DetailsModel?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showFullOverview = false
    @Published var isFavorite = false
    @Published var isInWatchlist = false
    
    // Video service
    @StateObject private var videoService = MovieVideoService()
    
    func getMovieDetailsID(movieId: Int) async {
        isLoading = true
        errorMessage = nil
        
        guard let url = NetworkEndPoint2.movieVideos(movieID: movieId).url else {
            errorMessage = NetworkError.invalidURL.localizedDescription
            isLoading = false
            return
        }
        
        do {
            let response: DetailsModel = try await NetworkManager.shared.request(
                url: url,
                headers: NetworkEndPoint.headers,
                responseType: DetailsModel.self
            )
            self.detailsMovie = response
            
            // Fetch videos after getting movie details
            await videoService.fetchMovieVideos(movieID: movieId)
            
        } catch {
            self.errorMessage = error.localizedDescription
            print(error.localizedDescription)
        }
        
        isLoading = false
    }
    
    func refreshData() async {
        guard let movieId = detailsMovie?.id else { return }
        await getMovieDetailsID(movieId: movieId)
    }
    
    func openTrailer() {
        guard let trailer = videoService.mainTrailer,
              let url = trailer.youTubeURL else {
            print("No trailer available")
            return
        }
        UIApplication.shared.open(url)
    }
    
    func toggleFavorite() {
        isFavorite.toggle()
        // Add your favorite logic here (save to UserDefaults, Core Data, etc.)
    }
    
    func toggleWatchlist() {
        isInWatchlist.toggle()
        // Add your watchlist logic here
    }
    
    func shareMovie() -> String {
        guard let movie = detailsMovie else { return "" }
        return "Check out \(movie.title)! \(movie.overview)"
    }
    
    func formatReleaseDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else { return dateString }
        
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
    
    func formatRuntime(_ runtime: Int) -> String {
        let hours = runtime / 60
        let minutes = runtime % 60
        return "\(hours)h \(minutes)m"
    }
    
    // Access video service properties
    var videos: [MovieVideo] {
        videoService.videos
    }
    
    var mainTrailer: MovieVideo? {
        videoService.mainTrailer
    }
    
    var isLoadingVideos: Bool {
        videoService.isLoading
    }
    
    var videoErrorMessage: String? {
        videoService.errorMessage
    }
}


// MARK: - Movie Trailer View Component
struct MovieTrailerView2: View {
    let video: MovieVideo
    let onPlay: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                // Thumbnail
                AsyncImage(url: video.thumbnailURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "play.rectangle")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                        )
                }
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Play button overlay
                Button(action: onPlay) {
                    Circle()
                        .fill(Color.black.opacity(0.7))
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: "play.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .offset(x: 2) // Slight offset for visual balance
                        )
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(video.name)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                HStack {
                    if video.official {
                        Text("Official")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                    }
                    
                    Text("YouTube")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
            }
        }
    }
}

// MARK: - Trailers Section Component
struct TrailersSection2: View {
    let videos: [MovieVideo]
    let isLoading: Bool
    let errorMessage: String?
    let onPlayTrailer: (MovieVideo) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Trailers")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                }
            }
            
            if let errorMessage = errorMessage {
                Text("Failed to load trailers: \(errorMessage)")
                    .font(.caption)
                    .foregroundColor(.gray)
            } else if videos.isEmpty && !isLoading {
                Text("No trailers available")
                    .font(.body)
                    .foregroundColor(.gray)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 16) {
                        ForEach(videos) { video in
                            MovieTrailerView2(video: video) {
                                onPlayTrailer(video)
                            }
                            .frame(width: 280)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.horizontal, -20) // Compensate for container padding
            }
        }
    }
}

// MARK: - Updated Action Buttons Section
struct ActionButtonsSection2: View {
    let onWatchTrailer: () -> Void
    let onAddToWatchlist: () -> Void
    let isInWatchlist: Bool
    let hasTrailer: Bool // New parameter
    
    var body: some View {
        VStack(spacing: 16) {
            // Watch Trailer Button
            Button(action: onWatchTrailer) {
                HStack {
                    Image(systemName: "play.fill")
                        .font(.system(size: 18))
                    Text("Watch Trailer")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(hasTrailer ? Color.red : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .disabled(!hasTrailer)
            
            // Watchlist Button
            Button(action: onAddToWatchlist) {
                HStack {
                    Image(systemName: isInWatchlist ? "checkmark" : "plus")
                        .font(.system(size: 18))
                    Text(isInWatchlist ? "In Watchlist" : "Add to Watchlist")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(.white.opacity(0.1))
                .foregroundColor(.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
            }
        }
    }
}

// MARK: - Updated Movie Details View
struct MovieDetailsView2: View {
    @Environment(\.dismiss) private var dismiss
    let movieId: Int
    @StateObject var detailsVM = DetailsViewModel2()
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
                        onBack: { dismiss() },
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
                            
//                                // Title and Release Info
//                                TitleSection2(
//                                    movie: detailsVM.detailsMovie,
//                                    formatDate: detailsVM.formatReleaseDate,
//                                    formatRuntime: detailsVM.formatRuntime
//                                )
                                
                                // Overview
                                OverviewSection(
                                    movie: detailsVM.detailsMovie,
                                    showFullOverview: $detailsVM.showFullOverview
                                )
                                
                                // Trailers Section - NEW
                                TrailersSection2(
                                    videos: detailsVM.videos,
                                    isLoading: detailsVM.isLoadingVideos,
                                    errorMessage: detailsVM.videoErrorMessage
                                ) { video in
                                    if let url = video.youTubeURL {
                                        UIApplication.shared.open(url)
                                    }
                                }
                                
                                // Production Companies
                                ProductionCompaniesSection(movie: detailsVM.detailsMovie)
                            
                                // Action Buttons - Updated with trailer info
                                ActionButtonsSection2(
                                    onWatchTrailer: { detailsVM.openTrailer() },
                                    onAddToWatchlist: { detailsVM.toggleWatchlist() },
                                    isInWatchlist: detailsVM.isInWatchlist,
                                    hasTrailer: detailsVM.mainTrailer != nil
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

// MARK: - Supporting Views (Add these if not already present)

struct CustomNavigationBar2: View {
    let onBack: () -> Void
    let onShare: () -> Void
    let onFavorite: () -> Void
    let isFavorite: Bool
    
    var body: some View {
        HStack {
            Button(action: onBack) {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                    Text("Back")
                        .font(.system(size: 16, weight: .medium))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.white.opacity(0.1))
                .cornerRadius(20)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: onFavorite) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 20))
                        .foregroundColor(isFavorite ? .red : .white)
                }
                
                Button(action: onShare) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
}

struct LoadingView2: View {
    var body: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
            Text("Loading...")
                .foregroundColor(.white)
                .padding(.top, 10)
        }
    }
}

struct ErrorView2: View {
    let message: String
    let retry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.white)
            
            Text("Error")
                .font(.title)
                .foregroundColor(.white)
            
            Text(message)
                .font(.body)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Retry", action: retry)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}
