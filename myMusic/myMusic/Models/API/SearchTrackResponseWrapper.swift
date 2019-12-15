//
//  SearchTrackResponse.swift
//  myMusic
//
//  Created by Tim Geldof on 14/12/2019.
//  Copyright © 2019 Tim Geldof. All rights reserved.
//

import Foundation

struct SearchTrackResponseWrapper: Decodable{
    
    let data: [SearchTrackResponse]
    
    enum CodingKeys: String, CodingKey{
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try valueContainer.decode([SearchTrackResponse].self, forKey: CodingKeys.data)
    }
}
