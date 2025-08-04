//
//  PopularListItemMovie.swift
//  Movies
//
//  Created by MacBookPro on 28/07/2025.
//

import SwiftUI

struct PopularListItemMovie: View {
    let popularMovie: [MovieModel]
    let onMovieSelected: (Int) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 15) {
                ForEach(popularMovie.prefix(5)) { movie in
                    Button {
                        onMovieSelected(movie.id)
                    } label: {
                        PopularMovieCard(movie: movie)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
        }
    }
}


