//
//  OverviewSection.swift
//  Movies
//
//  Created by MacBookPro on 06/08/2025.
//

import SwiftUI

struct OverviewSection: View {
    let movie: DetailsModel?
    @Binding var showFullOverview: Bool
    
    var body: some View {
        if let overview = movie?.overview, !overview.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text("Overview")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("white"))
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(overview)
                        .foregroundColor(Color("white"))
                        .font(.body)
                        .lineLimit(showFullOverview ? nil : 4)
                        .multilineTextAlignment(.leading)
                        .animation(.easeInOut, value: showFullOverview)
                    
                    if overview.count > 200 {
                        Button(action: {
                            showFullOverview.toggle()
                        }) {
                            Text(showFullOverview ? "Show Less" : "Read More")
                                .font(.caption)
                                .foregroundColor(.blue)
                                .fontWeight(.medium)
                        }
                    }
                }
            }
        }
    }
}
