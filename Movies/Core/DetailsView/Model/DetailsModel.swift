//
//  DetailsModel.swift
//  Movies
//
//  Created by MacBookPro on 02/08/2025.
//

import Foundation

import Foundation

struct DetailsModel: Decodable, Identifiable {
    let id: Int
    let title: String
    let original_title: String
    let overview: String
    let poster_path: String?
    let backdrop_path: String?
    let release_date: String
    let original_language: String
    let vote_average: Float
    let runtime: Int?
    let genres: [Genre]
    let status: String
    let tagline: String?
    let budget: Int
    let revenue: Int
    let production_companies : [ProductionCompanies]
    
    var posterURL: String {
        "https://image.tmdb.org/t/p/w500\(poster_path ?? "")"
    }
    
    var backdropURL: String {
        "https://image.tmdb.org/t/p/w780\(backdrop_path ?? "")"
    }
    
}

struct Genre: Decodable ,Identifiable{
    let id: Int
    let name: String
}

struct ProductionCompanies : Decodable , Identifiable {
    let id : Int
    let logo_path : String?
    let name : String
    let origin_country : String
    
    var productionLogo : String {
        "https://image.tmdb.org/t/p/w780\(logo_path ?? "")"
    }
    
}


struct GenresResponse: Decodable {
    let genres: [Genre]
}
