//
//  MovieVideoModel.swift
//  Movies
//
//  Created by MacBookPro on 04/08/2025.
//

import Foundation

struct MovieVideo: Codable, Identifiable {
    let id: String
    let key: String
    let name: String
    let site: String
    let type: String
}

struct MovieVideosResponse: Codable {
    let results: [MovieVideo]
}
