//
//  NowPlayingMovieCard.swift
//  Movies
//
//  Created by MacBookPro on 04/08/2025.
//

import SwiftUI

struct NowPlayingMovieCard: View {
    let movie: MovieModel
    
    var body: some View {
        AsyncImage(
            url: URL(string: movie.posterURL),
            transaction: Transaction(
                animation: .spring(
                    response: 0.5,
                    dampingFraction: 0.65,
                    blendDuration: 0.025
                )
            )
        ) { phase in
            switch phase {
            case .success(let asyncImage):
                asyncImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 300, height: 180)
                    .clipped()
                    .cornerRadius(15)
                    .overlay {
                        nowPlayingOverlay
                    }
                    
            case .failure(_):
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 300, height: 180)
                    .cornerRadius(15)
                    .overlay {
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                            .font(.largeTitle)
                    }
                    .overlay {
                        nowPlayingOverlay
                    }
                    
            case .empty:
                ShimmerEffect(width: 300, height: 180)
                
            @unknown default:
                ShimmerEffect(width: 300, height: 180)
            }
        }
    }
    
    private var nowPlayingOverlay: some View {
        LinearGradient(
            colors: [Color.clear, Color.black.opacity(0.8)],
            startPoint: .top,
            endPoint: .bottom
        )
        .cornerRadius(15)
        .overlay {
            VStack(spacing: 8) {
                Spacer()
                
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(movie.title)
                            .foregroundColor(.white)
                            .font(.headline)
                            .fontWeight(.bold)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                        
                        Text(movie.overview)
                            .foregroundColor(.white.opacity(0.9))
                            .font(.caption)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                        
                        HStack(spacing: 8) {
                            Image(systemName: "calendar")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.caption2)
                            
                            Text(formatDate(movie.release_date))
                                .foregroundColor(.white.opacity(0.7))
                                .font(.caption2)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 8) {
                        CustomeRate(vote: movie.vote_average)
                        
                        Circle()
                            .fill(Color.red)
                            .frame(width: 35, height: 35)
                            .overlay {
                                Image(systemName: "play.fill")
                                    .foregroundColor(.white)
                                    .font(.caption)
                            }
                    }
                }
            }
            .padding(12)
        }
    }
}

