//
//  AlbumDatabase.swift
//  myMusic
//
//  Created by Tim Geldof on 15/12/2019.
//  Copyright © 2019 Tim Geldof. All rights reserved.
//

import Foundation
import RealmSwift

class AlbumEntity: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var cover_small : String = ""
    @objc dynamic var cover_medium : String = ""
    @objc dynamic var cover_big : String = ""

    override static func primaryKey() -> String? {
        return "id"
    }
    
    required init(){
        super.init()
    }
    
    init(id: Int, title: String, cover_small: String, cover_medium : String, cover_big: String){
        self.id = id
        self.title = title
        self.cover_big = cover_big
        self.cover_medium = cover_medium
        self.cover_small = cover_small
    }
    
    func toApiAlbum() -> SearchTrackAlbumResponse {
        return
            SearchTrackAlbumResponse(
                id: self.id,
                title: self.title,
                cover_small: self.cover_small,
                cover_medium: self.cover_medium,
                cover_big: self.cover_big)
    }
    
    
}
