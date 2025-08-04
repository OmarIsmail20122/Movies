//
//  AllMovieView.swift
//  Movies
//
//  Created by MacBookPro on 03/08/2025.
//

import SwiftUI

struct AllMovieView: View {
    @Environment(\.dismiss) var dismiss
    var title : String = ""
    @StateObject var movieVM = MovieViewModel()
    
    var body: some View {
            VStack {
                HStack {
                    Button {
                        dismiss()
                    }label: {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30 , height: 20)
                            .foregroundColor(Color("white"))
                    }
                    Spacer()
                    Text(title)
                        .font(.title)
                        .bold()
                        .foregroundColor(Color("white"))
                        .animation(.easeInOut(duration: 5))
                }
                .padding(.all , 10)
                ScrollView{
                    ZStack {
//                        Color("primary")
                        VStack (alignment: .leading){
                            ForEach(selectedMovies) { movie in
                                NavigationLink(value: movie.id, label: {
                                    AllMovieDataItem(imageURL: movie.posterURL, title: movie.title, overview: movie.overview, vote: movie.vote_average)
                                })
                            }
                        }
                        .navigationDestination(for: Int.self) {
                            movieID in
                            MovieDetailsView(movieId: movieID)
                        }
                    }
            }
            .task {
                switch title {
                case "Top Rated":
                    await movieVM.fetchTopRatedMovies()
                case "Now Playing":
                    await movieVM.fetchNowPlayingMovies()
                default:
                    await movieVM.fetchPopularMovies()
                }
            }
        }
        .background(Color("primary"))
    }
    
    private var selectedMovies: [MovieModel] {
        switch title {
        case "Top Rated": return movieVM.topRatedMovie
        case "Now Playing": return movieVM.nowPlayingMovie
        default: return movieVM.popularMovie
        }
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
        PosterImage(image: imageURL, width: 100, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 3)
        VStack(alignment:.leading , spacing: 10) {
            Text(title)
                .foregroundColor(Color("white"))
                .font(.title2)
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
