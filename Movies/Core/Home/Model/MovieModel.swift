//
//  MovieModel.swift
//  Movies
//
//  Created by MacBookPro on 24/07/2025.
//

import Foundation

struct MovieResponse: Decodable {
    let results: [MovieModel]
}

struct MovieModel : Identifiable , Decodable {
    
    let id: Int
    let title: String
    let overview: String
    let poster_path: String?
    let release_date : String
    let original_language : String
    let vote_average : Float
    
    
    var posterURL: String {
        "https://image.tmdb.org/t/p/w500\(poster_path ?? "")"
    }
}
