//
//  TopRatedMovieCard.swift
//  Movies
//
//  Created by MacBookPro on 04/08/2025.
//

import SwiftUI

struct TopRatedMovieCard: View {
    let movie: MovieModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
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
                        .aspectRatio(2/3, contentMode: .fill)
                        .frame(width: 140)
                        .clipped()
                        .cornerRadius(12)
                        .overlay(alignment: .topTrailing) {
                            ratingBadge
                        }
                        
                case .failure(_):
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .aspectRatio(2/3, contentMode: .fill)
                        .frame(width: 140)
                        .cornerRadius(12)
                        .overlay {
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                                .font(.title2)
                        }
                        .overlay(alignment: .topTrailing) {
                            ratingBadge
                        }
                        
                case .empty:
                    ShimmerEffect(width: 140, height: 210)
                    
                @unknown default:
                    ShimmerEffect(width: 140, height: 210)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption2)
                    
                    Text(String(format: "%.1f", movie.vote_average))
                        .foregroundColor(.white.opacity(0.8))
                        .font(.caption2)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Text(formatDate(movie.release_date))
                        .foregroundColor(.white.opacity(0.6))
                        .font(.caption2)
                }
            }
        }
        .frame(width: 140)
    }
    
    private var ratingBadge: some View {
        Circle()
            .fill(Color.black.opacity(0.7))
            .frame(width: 30, height: 30)
            .overlay {
                Text(String(format: "%.1f", movie.vote_average))
                    .foregroundColor(.white)
                    .font(.caption2)
                    .fontWeight(.bold)
            }
            .padding(8)
    }
}
