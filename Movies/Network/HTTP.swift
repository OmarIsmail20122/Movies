//
//  HTTP.swift
//  Movies
//
//  Created by MacBookPro on 26/07/2025.
//

import Foundation

enum HTTP {
    enum method : String {
        case get  = "GET"
        case post = "POST"
    }
    
    enum Headers {
        enum Key : String {
            case contentType = "Content-Type"
        }
        enum Value : String {
            case applicationJson = "application/json"
        }
    }
}
