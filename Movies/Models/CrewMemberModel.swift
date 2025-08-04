//
//  CrewMemberModel.swift
//  Movies
//
//  Created by MacBookPro on 04/08/2025.
//

import Foundation

struct CrewMember: Codable, Identifiable {
    let id: Int
    let name: String
    let job: String
    let profile_path: String?
}
