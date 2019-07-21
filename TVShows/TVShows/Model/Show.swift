//
//  Show.swift
//  TVShows
//
//  Created by Borna on 21/07/2019.
//  Copyright © 2019 Borna. All rights reserved.
//

import Foundation

struct Show: Decodable {
    
    let id: String
    let title: String
    let imageUrl: String
    let likesCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case imageUrl
        case likesCount
    }
}

