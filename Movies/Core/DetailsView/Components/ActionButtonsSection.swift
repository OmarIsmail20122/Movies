//
//  ActionButtonsSection.swift
//  Movies
//
//  Created by MacBookPro on 06/08/2025.
//

import SwiftUI

struct ActionButtonsSection: View {
    let onWatchTrailer: () -> Void
    let onAddToWatchlist: () -> Void
    let isInWatchlist: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Button(action: onWatchTrailer) {
                HStack {
                    Image(systemName: "play.fill")
                        .font(.title3)
                    Text("Watch Trailer")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.red)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            Button(action: onAddToWatchlist) {
                HStack {
                    Image(systemName: isInWatchlist ? "checkmark" : "plus")
                        .font(.title3)
                    Text(isInWatchlist ? "In Watchlist" : "Add to Watchlist")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(Color("white"))
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(isInWatchlist ? Color.green : Color("tableColor"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(.top, 24)
    }
}

