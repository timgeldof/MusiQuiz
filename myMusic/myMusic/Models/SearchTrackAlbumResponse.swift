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
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
    }
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try valueContainer.decode(String.self, forKey: CodingKeys.title)
    }
}
