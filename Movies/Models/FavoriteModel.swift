//
//  FavoriteModel.swift
//  Movies
//
//  Created by MacBookPro on 04/08/2025.
//

import Foundation

struct FavoriteMovie: Codable, Identifiable {
    let id: Int
    let title: String
    let posterPath: String?
    let releaseDate: String?
    let rating: Float
}
