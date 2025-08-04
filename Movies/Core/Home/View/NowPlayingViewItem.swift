//
//  NowPlayingViewItem.swift
//  Movies
//
//  Created by MacBookPro on 28/07/2025.
//

import SwiftUI

struct NowPlayingViewItem: View {
    let nowPlayingModel : [MovieModel]
    var body: some View {
        
        ScrollView(.horizontal ,showsIndicators: false) {
                HStack(spacing: 25) {
                    ForEach(nowPlayingModel.prefix(5)) { data in
                        NavigationLink(value: data.id, label: {
                            CustomeImageIndicator(image: data.posterURL , title: data.title , overview: data.overview , releaseDate: data.release_date , language: data.original_language , vote: data.vote_average )
                                .frame(width: UIScreen.main.bounds.width - 100, height: 150)
                        })
                    }
                }
                .navigationDestination(for: Int.self) {
                    movieID in
                    MovieDetailsView(movieId: movieID).navigationBarBackButtonHidden(true)
                }
        }
    }
}
