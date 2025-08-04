//
//  CustomeImageIndicator.swift
//  Movies
//
//  Created by MacBookPro on 24/07/2025.
//

import SwiftUI

struct CustomeImageIndicator: View {
    var image: String
    var title: String
    var overview: String
    var releaseDate: String
    var language: String
    var vote: Float

    var body: some View {
        AsyncImage(
            url: URL(string: image),
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
                    .frame(height: 150)
                    .cornerRadius(10)
                    .overlay {
                        contentOverlay
                    }

            case .failure(_):
                Image(systemName: "ant.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .cornerRadius(10)
                    .overlay {
                        contentOverlay
                    }

            case .empty:
                ShimmerEffect(width: .infinity)

            @unknown default:
                ShimmerEffect(width: .infinity)
            }
        }
    }

    private var contentOverlay: some View {
        VStack(spacing: 5) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(title)
                        .foregroundColor(Color("white"))
                        .font(.title3)
                        .fontWeight(.bold)
                        .lineLimit(1)

                    Text(overview)
                        .foregroundColor(Color("white"))
                        .font(.subheadline)
                        .fontWeight(.regular)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    Text(releaseDate)
                        .foregroundColor(Color("white"))
                        .font(.subheadline)
                        .fontWeight(.regular)
                }

                Spacer()

                CustomeRate(vote: vote)
            }

            Spacer()

            HStack {
                Text("Language: \(language)")
                    .foregroundColor(Color("white"))

                Spacer()

                Circle()
                    .foregroundColor(Color("red"))
                    .frame(width: 40, height: 40)
                    .overlay {
                        Image(systemName: "play.fill")
                            .foregroundColor(Color("white"))
                    }
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
    }
}

@ViewBuilder
func ShimmerEffect(width : Double) -> some View {
    ShimmerView()
        .frame(width: width ,height: 150)
        .cornerRadius(10)
}

