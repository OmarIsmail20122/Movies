//
//  CustomeHeadLine.swift
//  Movies
//
//  Created by MacBookPro on 24/07/2025.
//

import SwiftUI

struct CustomeHeadLine: View {
    var headLine : String = ""
    var body: some View {
        HStack {
            Text(headLine)
                .foregroundColor(Color("white"))
                .font(.title2)
                .fontWeight(.semibold)
            Spacer()
            
            NavigationLink(destination: {
                AllMovieView(title: headLine).navigationBarBackButtonHidden(true)
            }, label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(Color("white"))
            })
        }
    }
}

struct CustomeHeadLine_Previews: PreviewProvider {
    static var previews: some View {
        CustomeHeadLine()
    }
}
