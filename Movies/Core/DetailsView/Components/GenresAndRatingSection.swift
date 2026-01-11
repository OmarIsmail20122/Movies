//
//  GenresAndRatingSection.swift
//  Movies
//
//  Created by MacBookPro on 06/08/2025.
//

import SwiftUI

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
