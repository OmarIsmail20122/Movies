//
//  ShimmerView.swift
//  Movies
//
//  Created by MacBookPro on 27/07/2025.
//

import SwiftUI

struct ShimmerView: View {
    @State private var startPoint : UnitPoint = .init(x: -1.8, y: -1.2)
    @State private var endPoint : UnitPoint = .init(x: 0, y: -0.2)
    
    private var gradientColor = [Color.gray.opacity(0.2), Color.white.opacity(0.2), Color.gray.opacity(0.2)]
    var body: some View {
        LinearGradient( colors: gradientColor, startPoint: startPoint, endPoint: endPoint)
            .onAppear {
                withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses : false)) {
                    startPoint = .init(x: 1, y: 1)
                    endPoint = .init(x: 2.2, y: 2.2)
                }
            }
    }
}

struct ShimmerView_Previews: PreviewProvider {
    static var previews: some View {
        ShimmerView()
    }
}


