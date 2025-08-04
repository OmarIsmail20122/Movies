//
//  NowPlayingViewItem.swift
//  Movies
//
//  Created by MacBookPro on 28/07/2025.
//

import SwiftUI

struct NowPlayingViewItem: View {
    let nowPlayingModel: [MovieModel]
    let onMovieSelected: (Int) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 15) {
                ForEach(nowPlayingModel.prefix(5)) { movie in
                    Button {
                        onMovieSelected(movie.id)
                    } label: {
                        NowPlayingMovieCard(movie: movie)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
        }
    }
}





@ViewBuilder
func ShimmerEffect(width: Double, height: Double) -> some View {
    ShimmerView()
        .frame(width: width, height: height)
        .cornerRadius(12)
}

func formatDate(_ dateString: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd"
    
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "MMM yyyy"
    
    if let date = inputFormatter.date(from: dateString) {
        return outputFormatter.string(from: date)
    }
    return dateString
}

