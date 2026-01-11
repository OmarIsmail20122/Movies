//
//  TitleSection.swift
//  Movies
//
//  Created by MacBookPro on 06/08/2025.
//

import SwiftUI

@MainActor
struct TitleSection: View {
    let movie: DetailsModel?
    let formatDate: @MainActor (String?) -> String
    let formatRuntime: @MainActor (Int?) -> String
    
    var body: some View {
        if let title = movie?.title {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("white"))
                    .multilineTextAlignment(.leading)
                
                if let releaseDate = movie?.release_date {
                    Text(formatDate(releaseDate))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                if let runtime = movie?.runtime {
                    Text(formatRuntime(runtime))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}
