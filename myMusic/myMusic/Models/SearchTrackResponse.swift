//
//  SearchTrackResponse.swift
//  myMusic
//
//  Created by Tim Geldof on 14/12/2019.
//  Copyright © 2019 Tim Geldof. All rights reserved.
//

import Foundation

struct SearchTrackResponse: Decodable {
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
    }
}
