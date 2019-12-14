//
//  SearchTrackArtistResponse.swift
//  myMusic
//
//  Created by Tim Geldof on 14/12/2019.
//  Copyright © 2019 Tim Geldof. All rights reserved.
//

import Foundation

struct SearchTrackArtistResponse: Decodable {
    
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try valueContainer.decode(String.self, forKey: CodingKeys.name)
    }
}
