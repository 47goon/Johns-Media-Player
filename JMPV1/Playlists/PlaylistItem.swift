//
//  PlaylistItem.swift
//  JMPV1
//
//  Created by john on 10/25/17.
//  Copyright © 2017 johnsApps. All rights reserved.
//

import Foundation

class PlaylistItem{
    
    var title: String
    var artist: String
    var album: String
    var persistentID: UInt64
    
    init(title: String, artist: String, album: String, persistentID: UInt64) {
        self.title = title
        self.artist = artist
        self.album = album
        self.persistentID = persistentID
    }
}
