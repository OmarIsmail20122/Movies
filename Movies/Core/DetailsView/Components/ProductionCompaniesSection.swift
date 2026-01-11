//
//  ProductionCompaniesSection.swift
//  Movies
//
//  Created by MacBookPro on 06/08/2025.
//

import SwiftUI

struct ProductionCompaniesSection: View {
    let movie: DetailsModel?
    
    var body: some View {
        if let companies = movie?.production_companies, !companies.isEmpty {
            VStack(alignment: .leading, spacing: 16) {
                Text("Production Companies")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("white"))
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(companies) { company in
                            ProductionCompanyCard(company: company)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.horizontal, -20)
            }
        }
    }
}
