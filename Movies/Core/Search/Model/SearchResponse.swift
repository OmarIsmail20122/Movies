//
//  SearchResponse.swift
//  Movies
//
//  Created by MacBookPro on 10/08/2025.
//

import Foundation

struct SearchResponse: Decodable {
    let page: Int
    let results: [MovieModel]
    let total_pages: Int
    let total_results: Int
}
