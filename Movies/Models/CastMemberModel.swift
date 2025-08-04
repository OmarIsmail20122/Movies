//
//  CastMemberModel.swift
//  Movies
//
//  Created by MacBookPro on 04/08/2025.
//

import Foundation

struct CastMember: Codable, Identifiable {
    let id: Int
    let name: String
    let character: String
    let profile_path: String?
}
