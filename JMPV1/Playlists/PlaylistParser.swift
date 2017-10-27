//
//  PlaylistParser.swift
//  JMPV1
//
//  Created by john on 10/26/17.
//  Copyright © 2017 johnsApps. All rights reserved.
//

import Foundation
import MediaPlayer

class PlaylistParser{
    static var delegate: PlaylistCreationDelegate!
    
    static func importData(from url: URL) {
        guard let dictionary = NSDictionary(contentsOf: url) as? [String: AnyObject],
            let title = dictionary["title"], let items = dictionary["items"] as? [[String : Any]] else {
                return
        }
        var finalPlaylist: [MPMediaItem] = [MPMediaItem]()
        for item in items{
            if let song = item["song"], let album = item["album"], let artist = item["artist"]  {
                let predicate = MPMediaPropertyPredicate(value: song, forProperty: MPMediaItemPropertyTitle)
                let songQuery = MPMediaQuery()
                songQuery.addFilterPredicate(predicate)
                
                var song: MPMediaItem?
                if let items = songQuery.items  {
                    if items.count > 0{
                        if items[0].albumArtist == artist as? String && items[0].albumTitle == album as? String{
                            song = items[0]
                            finalPlaylist.append(song!)
                        }
                    }
                }
            }
        }
        delegate.addPlaylist(playlist: Playlist(title: title as! String, items: finalPlaylist))
        
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Failed to remove item from Inbox")
        }
    }
    
}
