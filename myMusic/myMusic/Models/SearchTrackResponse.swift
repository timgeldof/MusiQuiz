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
    let duration: Int
    let preview: String
    let artist: SearchTrackArtistResponse
    let album: SearchTrackAlbumResponse
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case duration = "duration"
        case preview = "preview"
        case artist = "artist"
        case album = "album"
    }
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try valueContainer.decode(String.self, forKey: CodingKeys.title)
        self.duration = try valueContainer.decode(Int.self, forKey: CodingKeys.duration)
        self.preview = try valueContainer.decode(String.self, forKey: CodingKeys.preview)
        self.artist = try valueContainer.decode(SearchTrackArtistResponse.self, forKey: CodingKeys.artist)
        self.album = try valueContainer.decode(SearchTrackAlbumResponse.self, forKey: CodingKeys.album)

    }
}
