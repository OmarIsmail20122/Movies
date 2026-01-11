//
//  LoadingView.swift
//  Movies
//
//  Created by MacBookPro on 06/08/2025.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(Color("white"))
            
            Text("Loading movie details...")
                .foregroundColor(Color("white"))
                .font(.subheadline)
        }
    }
}

