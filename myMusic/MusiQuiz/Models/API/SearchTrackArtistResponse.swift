//
//  SearchTrackArtistResponse.swift
//  myMusic
//
//  Created by Tim Geldof on 14/12/2019.
//  Copyright © 2019 Tim Geldof. All rights reserved.
//

import Foundation

struct SearchTrackArtistResponse: Decodable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case id = "id"
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try valueContainer.decode(Int.self, forKey: CodingKeys.id)
        self.name = try valueContainer.decode(String.self, forKey: CodingKeys.name)
    }
    init(id: Int, name: String){
        self.id = id
        self.name = name
    }
    func toArtistEntity() -> ArtistEntity {
        return ArtistEntity(id: self.id, name: self.name)
    }
}
