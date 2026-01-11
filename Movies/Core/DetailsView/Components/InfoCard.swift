//
//  InfoCard.swift
//  Movies
//
//  Created by MacBookPro on 06/08/2025.
//

import SwiftUI

struct InfoCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
                .fontWeight(.medium)
            
            Text(value)
                .font(.subheadline)
                .foregroundColor(Color("white"))
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("tableColor"))
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
    }
}
