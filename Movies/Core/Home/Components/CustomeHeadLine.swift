//
//  CustomeHeadLine.swift
//  Movies
//
//  Created by MacBookPro on 04/08/2025.
//

import SwiftUI

struct CustomHeadLine: View {
    let headLine: String
    let onSeeAll: () -> Void
    
    var body: some View {
        HStack {
            Text(headLine)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Spacer()
            
            Button("See All") {
                onSeeAll()
            }
            .foregroundColor(.blue)
        }
    }
}

