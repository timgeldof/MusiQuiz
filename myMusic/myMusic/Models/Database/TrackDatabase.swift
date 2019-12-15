//
//  TrackDatabase.swift
//  myMusic
//
//  Created by Tim Geldof on 15/12/2019.
//  Copyright © 2019 Tim Geldof. All rights reserved.
//

import Foundation
import RealmSwift

class TrackDatabase : Object {
    @objc dynamic var title: String = ""
    @objc dynamic var album: AlbumDatabase? = nil
    @objc dynamic var preview: String = ""
    @objc dynamic var duration: Int = 0
    @objc dynamic var artist: ArtistDatabase? = nil


    
    required init(){
        super.init()
    }
    
    init(title: String, duration: Int, preview: String, artist: ArtistDatabase?, album: AlbumDatabase?) {
        self.title = title
        self.duration = duration
        self.preview = preview
        self.artist = artist
        self.album = album
    }
    
    // TODO: impl. method
    static func toApiTrack(dbTrack : TrackDatabase) -> SearchTrackResponse? {
        return nil
    }
}
