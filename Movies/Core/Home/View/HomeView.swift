//
//  HomeView.swift
//  Movies
//
//  Created by MacBookPro on 24/07/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject var movieVM = MovieViewModel()
    @StateObject var detailsVM = DetailsViewModel()
    @State private var showDetails = false
    @State var textSearch : String = ""
    var body: some View {
            ScrollView(.vertical , showsIndicators: false){
                VStack (alignment: .leading,spacing : 25){
                    ZStack(alignment: .trailing){
                        HStack(spacing : 10) {
                            Image("search")
                            TextField("Search", text: $textSearch)
                                .foregroundColor(Color("white"))
                                .frame(height: 50)
                        }
                        .padding(.horizontal , 10)
                        .background(Color(.black))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        Button(action: {}) {
                            Image("filter")
                        }
                        .padding()
                    }
                    .padding(.top , 30)
                    CustomeHeadLine(headLine: "Now Playing")
                    NowPlayingViewItem(nowPlayingModel: movieVM.nowPlayingMovie)
                    
                    CustomeHeadLine(headLine: "Top Rated")
                    TopRatedListView(topRatedMovie: movieVM.topRatedMovie)
                    
                    CustomeHeadLine(headLine: "Popular")
                    PopularListItemMovie(popularMovie: movieVM.popularMovie)
                }
                .padding()
            }
        .background(Color("primary"))
        .ignoresSafeArea()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
