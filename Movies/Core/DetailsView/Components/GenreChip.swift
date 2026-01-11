//
//  GenreChip.swift
//  Movies
//
//  Created by MacBookPro on 06/08/2025.
//

import SwiftUI
struct GenreChip: View {
    let genre: Genre
    
    var body: some View {
        Text(genre.name)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(Color("white"))
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("tableColor"))
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
            )
    }
}
