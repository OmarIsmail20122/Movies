//
//  TopRatedListView.swift
//  Movies
//
//  Created by MacBookPro on 28/07/2025.
//

import SwiftUI

struct TopRatedListView: View {
    let topRatedMovie : [MovieModel]
    var body: some View {
        NavigationStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 25) {
                    ForEach(topRatedMovie.prefix(5)) { topRated in
                        NavigationLink(value: topRated.id) {
                            CustomeItemList(
                                title: topRated.title,
                                vote: topRated.vote_average,
                                image: topRated.posterURL
                            )
                        }
                    }
                }
                .frame(height: 210)
            }
            .navigationDestination(for: Int.self) { movieId in
                MovieDetailsView(movieId: movieId).navigationBarBackButtonHidden(true)
            }
        }
    }
}
