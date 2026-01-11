//
//  CustomNavigationBar.swift
//  Movies
//
//  Created by MacBookPro on 06/08/2025.
//

import SwiftUI

struct CustomNavigationBar: View {
    let onBack: () -> Void
    let onShare: () -> Void
    let onFavorite: () -> Void
    let isFavorite: Bool
    
    var body: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("white"))
                    .frame(width: 44, height: 44)
                    .background(Color.black.opacity(0.3))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: onFavorite) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.title2)
                        .foregroundColor(isFavorite ? .red : Color("white"))
                        .frame(width: 44, height: 44)
                        .background(Color.black.opacity(0.3))
                        .clipShape(Circle())
                }
                
                Button(action: onShare) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title2)
                        .foregroundColor(Color("white"))
                        .frame(width: 44, height: 44)
                        .background(Color.black.opacity(0.3))
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
    }
}
