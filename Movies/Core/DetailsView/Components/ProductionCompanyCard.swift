//
//  ProductionCompanyCard.swift
//  Movies
//
//  Created by MacBookPro on 06/08/2025.
//

import SwiftUI

struct ProductionCompanyCard: View {
    let company: ProductionCompanies
    
    var body: some View {
        VStack(spacing: 12) {
            PosterImage(image: company.productionLogo , width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
//            Group {
//                if let logoPath = company.productionLogo, !logoPath.isEmpty {
//
//                } else {
//                    RoundedRectangle(cornerRadius: 12)
//                        .fill(Color("tableColor"))
//                        .frame(width: 80, height: 80)
//                        .overlay(
//                            Image(systemName: "building.2")
//                                .foregroundColor(.gray)
//                                .font(.title2)
//                        )
//                }
//            }
            
            Text(company.name)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .foregroundColor(Color("white"))
                .frame(width: 80)
                .lineLimit(2)
        }
        .padding(.vertical, 8)
    }
}
