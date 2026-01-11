//
//  Constants.swift
//  Movies
//
//  Created by MacBookPro on 24/07/2025.
//

import Foundation

class NetworkEndPoint {
    static var url : String = "https://api.themoviedb.org/3/"
    static var nowPlaying = URL(string: "\(url)movie/now_playing?language=en-US&page=1")
    static var popular = URL(string: "\(url)movie/popular?language=en-US&page=1")
    static var topRated = URL(string: "\(url)movie/top_rated?language=en-US&page=1")
    static let searchURL = URL(string: "\(url)search/movie")
    static let discoverURL = URL(string: "\(url)discover/movie")
    static let genresURL = URL(string: "\(url)genre/movie/list")

  
    static var token : String = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4YjMxYzc1OGViMDU5OWQyODhhOWVlNzM4OTMyMWRhMCIsIm5iZiI6MTY2Nzg0MzQ0Ny41NjgsInN1YiI6IjYzNjk0NTc3MTY4NGY3MDA4YWViYzY5ZiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.0jIaPWKoD_LGCQ_rRfEOeKgN8IBstQRTQvia9sw9E0g"
    
    static let headers = [
        "accept": "application/json",
        "Authorization": "Bearer \(token)"
    ]
}
