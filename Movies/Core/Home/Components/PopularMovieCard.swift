//
//  PopularMovieCard.swift
//  Movies
//
//  Created by MacBookPro on 04/08/2025.
//

import SwiftUI

struct PopularMovieCard: View {
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
                    .frame(width: 250, height: 150)
                    .clipped()
                    .cornerRadius(12)
                    .overlay {
                        popularOverlay
                    }
                    
            case .failure(_):
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 250, height: 150)
                    .cornerRadius(12)
                    .overlay {
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                            .font(.title)
                    }
                    .overlay {
                        popularOverlay
                    }
                    
            case .empty:
                ShimmerEffect(width: 250, height: 150)
                
            @unknown default:
                ShimmerEffect(width: 250, height: 150)
            }
        }
    }
    
    private var popularOverlay: some View {
        LinearGradient(
            colors: [Color.clear, Color.clear, Color.black.opacity(0.9)],
            startPoint: .top,
            endPoint: .bottom
        )
        .cornerRadius(12)
        .overlay {
            VStack(spacing: 6) {
                HStack {
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "flame")
                            .foregroundColor(.orange)
                            .font(.caption)
                        
                        Text("Popular")
                            .foregroundColor(.white)
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.orange.opacity(0.2))
                            .cornerRadius(8)
                    }
                    .padding(8)
                }
                
                Spacer()
                
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(movie.title)
                            .foregroundColor(.white)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .lineLimit(1)
                        
                        Text(movie.overview)
                            .foregroundColor(.white.opacity(0.9))
                            .font(.caption)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                        
                        HStack(spacing: 6) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.caption2)
                            
                            Text(String(format: "%.1f", movie.vote_average))
                                .foregroundColor(.white)
                                .font(.caption2)
                                .fontWeight(.medium)
                            
                            Text("•")
                                .foregroundColor(.white.opacity(0.6))
                                .font(.caption2)
                            
                            Text(formatDate(movie.release_date))
                                .foregroundColor(.white.opacity(0.7))
                                .font(.caption2)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 32, height: 32)
                            .overlay {
                                Image(systemName: "play.fill")
                                    .foregroundColor(.white)
                                    .font(.caption)
                            }
                    }
                }
                .padding(10)
            }
        }
    }
}

