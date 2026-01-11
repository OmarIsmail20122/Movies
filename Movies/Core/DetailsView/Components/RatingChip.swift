//
//  RatingChip.swift
//  Movies
//
//  Created by MacBookPro on 06/08/2025.
//

import SwiftUI

struct RatingChip: View {
    let rating: Float
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "star.fill")
                .foregroundColor(Color("yellow"))
                .font(.caption)
            
            Text(String(format: "%.1f", rating))
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(Color("white"))
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("tableColor"))
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
    }
}
