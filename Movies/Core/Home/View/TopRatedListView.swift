//
//  TopRatedListView.swift
//  Movies
//
//  Created by MacBookPro on 28/07/2025.
//

import SwiftUI

struct TopRatedListView: View {
    let topRatedMovie: [MovieModel]
    let onMovieSelected: (Int) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                ForEach(topRatedMovie.prefix(5)) { movie in
                    Button {
                        onMovieSelected(movie.id)
                    } label: {
                        TopRatedMovieCard(movie: movie)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
        }
    }
}


