//
//  CustomeRate.swift
//  Movies
//
//  Created by MacBookPro on 24/07/2025.
//

import SwiftUI

struct CustomeRate: View {
    var vote : Float
    var body: some View {
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
}

//struct CustomeRate_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomeRate()
//    }
//}
