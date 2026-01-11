//
//  AllMovieView.swift
//  Movies
//
//  Created by MacBookPro on 03/08/2025.
//

import SwiftUI

struct AllMovieView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    var title: String = ""
    @StateObject var movieVM = MovieViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(selectedMovies) { movie in
                        Button {
                            navigationManager.navigateToMovieDetails(movie.id)
                        } label: {
                            AllMovieDataItem(
                                imageURL: movie.posterURL,
                                title: movie.title,
                                overview: movie.overview,
                                vote: movie.vote_average
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.vertical)
            }
        }
        .background(Color("primary"))
        .navigationBarHidden(true)
        .task {
            await loadMovies()
        }
    }
    
    private func loadMovies() async {
        switch title {
        case "Top Rated":
            await movieVM.fetchTopRatedMovies()
        case "Now Playing":
            await movieVM.fetchNowPlayingMovies()
        default:
            await movieVM.fetchPopularMovies()
        }
    }
    
    private var selectedMovies: [MovieModel] {
        switch title {
        case "Top Rated": return movieVM.topRatedMovie
        case "Now Playing": return movieVM.nowPlayingMovie
        default: return movieVM.popularMovie
        }
    }
    
    private var headerView: some View {
        HStack {
            Button {
                navigationManager.pop()
            } label: {
                Image(systemName: "chevron.left")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 20)
                    .foregroundColor(.white)
            }
            Spacer()
            Text(title)
                .font(.title)
                .bold()
                .foregroundColor(.white)
        }
        .padding()
    }
}



struct AllMovieView_Previews: PreviewProvider {
    static var previews: some View {
        AllMovieView()
    }
}

@ViewBuilder
private func AllMovieDataItem (imageURL : String , title : String , overview: String , vote : Float) -> some View {
    HStack {
        CustomDataWidget(imageURL: imageURL, title: title, overview: overview, vote: vote)
    }
    .padding()
    
}

@ViewBuilder
private func CustomDataWidget(imageURL : String , title : String , overview : String , vote : Float) -> some View {
    HStack(content: {
        PosterImage(image: imageURL, width: 120, height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 3)
        VStack(alignment:.leading , spacing: 10) {
            Text(title)
                .foregroundColor(Color("white"))
                .font(.headline)
                .bold()
            Text(overview)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
                .foregroundColor(Color("white"))
                .font(.caption)
            CustomeRate(vote: vote)
        }
    })
}
