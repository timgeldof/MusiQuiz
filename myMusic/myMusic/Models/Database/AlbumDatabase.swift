//
//  AlbumDatabase.swift
//  myMusic
//
//  Created by Tim Geldof on 15/12/2019.
//  Copyright © 2019 Tim Geldof. All rights reserved.
//

import Foundation
import RealmSwift

class AlbumDatabase: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var cover_small : String = ""
    @objc dynamic var cover_medium : String = ""
    @objc dynamic var cover_big : String = ""

    required init(){
        super.init()
    }
    
    init(title: String, cover_small: String, cover_medium : String, cover_big: String){
        self.title = title
        self.cover_big = cover_big
        self.cover_medium = cover_medium
        self.cover_small = cover_small
    }
    
    static func toApiAlbum(dbTrack : AlbumDatabase) -> SearchTrackAlbumResponse? {
        return nil
    }
    
    
}
