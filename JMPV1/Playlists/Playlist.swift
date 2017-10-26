//
//  Playlist.swift
//  JMPV1
//
//  Created by john on 10/25/17.
//  Copyright © 2017 johnsApps. All rights reserved.
//

import Foundation
import MediaPlayer

class Playlist{
    var title: String
    var items: [MPMediaItem]
    
    init(title: String, items: [MPMediaItem]) {
        self.title = title
        self.items = items
    }
}
