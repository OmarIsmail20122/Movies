//
//  ReviewModel.swift
//  Movies
//
//  Created by MacBookPro on 04/08/2025.
//

import Foundation

struct Review: Codable, Identifiable {
    let id: String
    let author: String
    let content: String
    let created_at: String
    let rating: Int?
}

struct ReviewsResponse: Codable {
    let results: [Review]
}
