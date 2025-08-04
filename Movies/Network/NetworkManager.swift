//
//  NetworkManager.swift
//  Movies
//
//  Created by MacBookPro on 26/07/2025.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    func request<T: Decodable>(
        url: URL,
        method: String = "GET",
        headers: [String: String] = [:],
        responseType: T.Type
    ) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.requestFailed
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(httpResponse.statusCode)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}


//final class NetworkManager {
//    static let shared = NetworkManager()
//    private init() {}
//    
//    private var defaultHeaders: [String: String] {
//            return [
//                "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4YjMxYzc1OGViMDU5OWQyODhhOWVlNzM4OTMyMWRhMCIsIm5iZiI6MTY2Nzg0MzQ0Ny41NjgsInN1YiI6IjYzNjk0NTc3MTY4NGY3MDA4YWViYzY5ZiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.0jIaPWKoD_LGCQ_rRfEOeKgN8IBstQRTQvia9sw9E0g",
//                "accept": "application/json"
//            ]
//        }
//
//    func request<T: Decodable>(
//        url: URL,
//        method: String = "GET",
//        body: Data? = nil,
//        headers: [String: String] = [:],
//        responseType: T.Type
//    ) async throws -> T {
//        var request = URLRequest(url: url)
//        request.httpMethod = method
//        request.httpBody = body
//        var allHeaders = defaultHeaders
//        headers.forEach { allHeaders[$0.key] = $0.value }
//        request.allHTTPHeaderFields = allHeaders
//        
//        let (data, response) = try await URLSession.shared.data(for: request)
//
//        guard let httpResponse = response as? HTTPURLResponse else {
//            throw NetworkError.requestFailed
//        }
//
//        guard (200...299).contains(httpResponse.statusCode) else {
//            throw NetworkError.serverError(httpResponse.statusCode)
//        }
//
//        do {
//            return try JSONDecoder().decode(T.self, from: data)
//        } catch {
//            throw NetworkError.decodingFailed
//        }
//    }
//}
