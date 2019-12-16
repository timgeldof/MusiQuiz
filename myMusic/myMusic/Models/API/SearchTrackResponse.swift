//
//  SearchTrackResponse.swift
//  myMusic
//
//  Created by Tim Geldof on 14/12/2019.
//  Copyright © 2019 Tim Geldof. All rights reserved.
//

import Foundation

struct SearchTrackResponse: Decodable {
    let id: Int
    let title: String
    let duration: Int
    let preview: String
    let artist: SearchTrackArtistResponse
    let album: SearchTrackAlbumResponse
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case duration = "duration"
        case preview = "preview"
        case artist = "artist"
        case album = "album"
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try valueContainer.decode(Int.self, forKey: CodingKeys.id)
        self.title = try valueContainer.decode(String.self, forKey: CodingKeys.title)
        self.duration = try valueContainer.decode(Int.self, forKey: CodingKeys.duration)
        self.preview = try valueContainer.decode(String.self, forKey: CodingKeys.preview)
        self.artist = try valueContainer.decode(SearchTrackArtistResponse.self, forKey: CodingKeys.artist)
        self.album = try valueContainer.decode(SearchTrackAlbumResponse.self, forKey: CodingKeys.album)

    }
    init(id: Int, title: String, duration: Int, preview: String, artist: SearchTrackArtistResponse, album: SearchTrackAlbumResponse) {
        self.id = id
        self.title = title
        self.duration = duration
        self.preview = preview
        self.artist = artist
        self.album = album
    }
    func durationToMinuteString() -> String{
        let seconds: Int = self.duration % 60
        let minutes: Int =  Int(floor(Double(self.duration) / Double(60)))
        if (seconds==0) {
            return "\(minutes):00"
        }
        if (seconds<10) {
            return "\(minutes):0\(seconds)"
        }
        return "\(minutes):\(seconds)"
    }
    
    func toTrackEntity() -> TrackEntity {
        return TrackEntity(
            id: self.id,
            title: self.title,
            duration: self.duration,
            preview: self.preview,
            artist: self.artist.toArtistEntity(),
            album: self.album.toAlbumEntity())
    }
}
