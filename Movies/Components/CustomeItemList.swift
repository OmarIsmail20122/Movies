//
//  CustomeItemList.swift
//  Movies
//
//  Created by MacBookPro on 24/07/2025.
//

import SwiftUI

struct CustomeItemList: View {
    var title : String
    var vote : Float
    var image : String
    var body: some View {
        VStack(alignment : .center) {
            AsyncImage(
                url: URL(string: image),
                transaction: Transaction(
                    animation: .spring(
                        response: 0.5,
                        dampingFraction: 0.65,
                        blendDuration: 0.025
                    )
                )
            ) { phase in
                switch phase {
                case .success(let asyncImage):
                    asyncImage
                        .resizable()
                        .frame(width: 150 , height: 150)
                        .cornerRadius(10)

                case .failure(_):
                    Image(systemName: "ant.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150 , height: 150)
                        .cornerRadius(10)

                case .empty:
                    ShimmerEffect(width: .infinity)

                @unknown default:
                    ShimmerEffect(width: .infinity)
                }
            }

            Text(title)
                .foregroundColor(Color("white"))
                .font(.footnote)
                .fontWeight(.medium)
            CustomeRate(vote: vote)
            
        }
    }
}

struct CustomeItemList_Previews: PreviewProvider {
    static var previews: some View {
        CustomeItemList(title: "", vote: 0.0 , image: "")
    }
}



@ViewBuilder
func PosterImage(image : String , width : Double , height : Double) -> some View {
    AsyncImage(
        url: URL(string: image),
        transaction: Transaction(
            animation: .spring(
                response: 0.5,
                dampingFraction: 0.65,
                blendDuration: 0.025
            )
        )
    ) { phase in
        switch phase {
        case .success(let asyncImage):
            asyncImage
                .resizable()
                .frame(width: width , height: height)
                .cornerRadius(10)

        case .failure(_):
            Image(systemName: "ant.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: width , height: height)
                .cornerRadius(10)

        case .empty:
            ShimmerEffect(width: .infinity)

        @unknown default:
            ShimmerEffect(width: .infinity)
        }
    }
    .padding(.horizontal , 20)
}
