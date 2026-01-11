//
//  HeaderImageSection.swift
//  Movies
//
//  Created by MacBookPro on 06/08/2025.
//

import SwiftUI

struct HeaderImageSection: View {
    let movie: DetailsModel?
    
    var body: some View {
        if let imageUrl = movie?.backdropURL {
            GeometryReader { geometry in
                PosterImage(image: imageUrl,
                          width: geometry.size.width,
                          height: 240)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                    .scaleEffect(min(max(1.0, 1.0 + (geometry.frame(in: .global).minY / 1000)), 1.1))
            }
            .frame(height: 240)
        }
    }
}
