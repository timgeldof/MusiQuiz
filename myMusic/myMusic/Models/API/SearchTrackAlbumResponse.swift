//
//  SearchTrackAlbumResponse.swift
//  myMusic
//
//  Created by Tim Geldof on 14/12/2019.
//  Copyright © 2019 Tim Geldof. All rights reserved.
//

import Foundation

struct SearchTrackAlbumResponse: Decodable {
    let id: Int
    let title: String
    let cover_small : String
    let cover_medium : String
    let cover_big : String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case cover_small = "cover_small"
        case cover_medium = "cover_medium"
        case cover_big = "cover_big"
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try valueContainer.decode(Int.self, forKey: CodingKeys.id)
        self.title = try valueContainer.decode(String.self, forKey: CodingKeys.title)
        self.cover_small = try valueContainer.decode(String.self, forKey: CodingKeys.cover_small)
        self.cover_medium = try valueContainer.decode(String.self, forKey: CodingKeys.cover_medium)
        self.cover_big = try valueContainer.decode(String.self, forKey: CodingKeys.cover_big)
    }
    
    init(id: Int, title: String, cover_small: String, cover_medium :String, cover_big :String){
        self.id = id
        self.title = title
        self.cover_small = cover_small
        self.cover_medium = cover_medium
        self.cover_big = cover_big
    }
    func toAlbumEntity() -> AlbumEntity {
        return AlbumEntity(
            id: self.id,
            title: self.title,
            cover_small: self.cover_small,
            cover_medium : self.cover_medium,
            cover_big: self.cover_big)
    }
    
}
