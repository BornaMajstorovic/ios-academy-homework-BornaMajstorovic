//
//  user.swift
//  TVShows
//
//  Created by Borna on 16/07/2019.
//  Copyright © 2019 Borna. All rights reserved.
//

import Foundation

struct User: Codable {
    let email: String
    let type: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case type
        case id = "_id"
    }
}
struct LoginData: Codable {
    let token: String
}
