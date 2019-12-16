//
//  ArtistDatabase.swift
//  myMusic
//
//  Created by Tim Geldof on 15/12/2019.
//  Copyright © 2019 Tim Geldof. All rights reserved.
//

import Foundation
import RealmSwift

class ArtistEntity: Object{
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""

    required init() {
        super.init()
    }
    override static func primaryKey() -> String? {
        return "id"
    }
    
    init(id: Int, name: String){
        self.id = id
        self.name = name
    }
    func toApiArtist() -> SearchTrackArtistResponse {
        return
            SearchTrackArtistResponse(id: self.id, name: self.name)
    }
    
}
