//
//  TrackDatabase.swift
//  myMusic
//
//  Created by Tim Geldof on 15/12/2019.
//  Copyright © 2019 Tim Geldof. All rights reserved.
//

import Foundation
import RealmSwift

class TrackEntity : Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var album: AlbumEntity? = nil
    @objc dynamic var preview: String = ""
    @objc dynamic var duration: Int = 0
    @objc dynamic var artist: ArtistEntity? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required init(){
        super.init()
    }
    
    init(id:Int, title: String, duration: Int, preview: String, artist: ArtistEntity?, album: AlbumEntity?) {
        self.id = id
        self.title = title
        self.duration = duration
        self.preview = preview
        self.artist = artist
        self.album = album
    }
    
    func toApiTrack() -> SearchTrackResponse {
        return SearchTrackResponse(
            id: self.id,
            title: self.title,
            duration: self.duration,
            preview: self.preview,
            artist: self.artist!.toApiArtist(),
            album: self.album!.toApiAlbum())
    }
}
