//
//  APIService.swift
//  Movies
//
//  Created by MacBookPro on 26/07/2025.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case requestFailed
    case decodingFailed
    case serverError(Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "The URL is invalid."
        case .requestFailed: return "Network request failed."
        case .decodingFailed: return "Failed to decode data."
        case .serverError(let code): return "Server error: \(code)"
        }
    }
}

