//
//  ShowEpisodes.swift
//  TVShows
//
//  Created by Borna on 23/07/2019.
//  Copyright © 2019 Borna. All rights reserved.
//

import Foundation

struct ShowEpisodes: Decodable {

    let id: String
    let title: String
    let description: String
    let imageUrl: String
    let episodeNumber: String
    let season: String
    
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case description
        case imageUrl
        case episodeNumber
        case season
    }
}
