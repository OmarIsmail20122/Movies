//
//  SecondMovieDetails.swift
//  Movies
//
//  Created by MacBookPro on 04/08/2025.
//

import SwiftUI

struct SecondMovieDetailsView: View {
    @Environment(\.dismiss) var dismiss
    let movieId: Int
    @StateObject var detailsVM = DetailsViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            Button {
                dismiss()
            }label: {
                Image(systemName: "chevron.left")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30 , height: 20)
                    .foregroundColor(Color("white"))
            }
            .padding(.horizontal , 20)
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    if let imageUrl = detailsVM.detailsMovie?.backdropURL {
                        PosterImage(image: imageUrl,
                                    width: UIScreen.main.bounds.width - 40,
                                    height: 240)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(radius: 5)
                            .padding(.top)
                    }
                    if let genres = detailsVM.detailsMovie?.genres {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(genres) { genre in
                                    GenersItem(geners: genre)
                                }

                                if let vote = detailsVM.detailsMovie?.vote_average {
                                    RatignDetailsView(vote: vote)
                                }
                            }
                        }
                    }
                    Group {
                        if let title = detailsVM.detailsMovie?.title {
                            Text(title)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color("white"))
                        }

                        if let overview = detailsVM.detailsMovie?.overview {
                            Text("Overview")
                                .font(.headline)
                                .foregroundColor(.gray)

                            Text(overview)
                                .foregroundColor(Color("white"))
                                .font(.body)
                                .multilineTextAlignment(.leading)
                        }
                    }

                    if let companies = detailsVM.detailsMovie?.production_companies {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Production Companies")
                                .font(.title2)
                                .bold()
                                .foregroundColor(Color("white"))

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 24) {
                                    ForEach(companies) { company in
                                        ProductionCompineItem(productionCompine: company)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .background(Color("primary").ignoresSafeArea())
        .task {
            await detailsVM.getMovieDetailsID(movieId: movieId)
        }
    }
}

struct SecondMovieDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        SecondMovieDetailsView(movieId: 1087192)
    }
}

@ViewBuilder
private func GenersItem(geners: Genre) -> some View {
    Text(geners.name)
        .font(.footnote)
        .foregroundColor(Color("white"))
        .bold()
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color("tableColor"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
}

@ViewBuilder
private func ProductionCompineItem(productionCompine: ProductionCompanies) -> some View {
    VStack(spacing: 10) {
        PosterImage(image: productionCompine.productionLogo, width: 80, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 3)
        Text(productionCompine.name)
            .font(.caption)
            .multilineTextAlignment(.center)
            .foregroundColor(Color("white"))
            .frame(width: 80)
    }
}

@ViewBuilder
private func RatignDetailsView(vote : Float) -> some View {
    HStack {
        HStack {
            Image(systemName: "star.fill")
                .foregroundColor(Color("yellow"))
                .frame(width: 30 , height: 30)
            Text(String(format: "%.1f", vote))
                .font(.footnote)
                .foregroundColor(Color("white"))
                .bold()
        }

    }
    .padding(.vertical , 2)
    .padding(.horizontal, 12)
    .background(Color("tableColor"))
    .clipShape(RoundedRectangle(cornerRadius: 10))
}
