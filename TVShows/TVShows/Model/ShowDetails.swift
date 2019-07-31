//
//  ShowDetails.swift
//  TVShows
//
//  Created by Borna on 23/07/2019.
//  Copyright © 2019 Borna. All rights reserved.
//

import Foundation

struct ShowDetails: Decodable {
    
    let type: String
    let title: String
    let description: String
    let id: String
    let likesCount: Int
    let imageUrl: String
    let mediaId: String?
    
    enum CodingKeys: String, CodingKey {
        case type
        case title
        case description
        case id = "_id"
        case likesCount
        case imageUrl
        case mediaId
    }
}
