//
//  PopularListItemMovie.swift
//  Movies
//
//  Created by MacBookPro on 28/07/2025.
//

import SwiftUI

struct PopularListItemMovie: View {
    let popularMovie: [MovieModel]
    var body: some View {
        ScrollView(.horizontal , showsIndicators: false) {
            HStack(spacing : 25) {
                ForEach(popularMovie.prefix(5)) { movie in
                    NavigationLink(value: movie.id, label: {
                        CustomeItemList(title: movie.title, vote: movie.vote_average, image: movie.posterURL)
                    })
                }
            }
            .navigationDestination(for: Int.self) { movieID in
                MovieDetailsView(movieId: movieID).navigationBarBackButtonHidden(true)
            }
        }
    }
}
