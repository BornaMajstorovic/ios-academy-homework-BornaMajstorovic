//
//  Media.swift
//  TVShows
//
//  Created by Borna on 30/07/2019.
//  Copyright © 2019 Borna. All rights reserved.
//

import Foundation

struct Media: Decodable {
 
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
    }
}
