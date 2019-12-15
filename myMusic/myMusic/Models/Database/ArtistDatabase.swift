//
//  ArtistDatabase.swift
//  myMusic
//
//  Created by Tim Geldof on 15/12/2019.
//  Copyright © 2019 Tim Geldof. All rights reserved.
//

import Foundation
import RealmSwift

class ArtistDatabase: Object{
    @objc dynamic var name: String = ""

    required init() {
        super.init()
    }
    
    init(name: String){
        self.name = name
    }
    static func toApiArtist(dbTrack : ArtistDatabase) -> SearchTrackArtistResponse? {
        return nil
    }
    
}
