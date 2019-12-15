//
//  SearchTrackAlbumResponse.swift
//  myMusic
//
//  Created by Tim Geldof on 14/12/2019.
//  Copyright © 2019 Tim Geldof. All rights reserved.
//

import Foundation

struct SearchTrackAlbumResponse: Decodable {
    
    let title: String
    let cover_small : String
    let cover_medium : String
    let cover_big : String
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case cover_small = "cover_small"
        case cover_medium = "cover_medium"
        case cover_big = "cover_big"

    }
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try valueContainer.decode(String.self, forKey: CodingKeys.title)
        self.cover_small = try valueContainer.decode(String.self, forKey: CodingKeys.cover_small)
        self.cover_medium = try valueContainer.decode(String.self, forKey: CodingKeys.cover_medium)
        self.cover_big = try valueContainer.decode(String.self, forKey: CodingKeys.cover_big)

    }
}
