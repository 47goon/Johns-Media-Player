//
//  Playlist.swift
//  JMPV1
//
//  Created by john on 10/25/17.
//  Copyright © 2017 johnsApps. All rights reserved.
//

import Foundation
import MediaPlayer

class Playlist: NSObject, NSCoding {
    
    var title: String
    var items: [MPMediaItem]
    var unknownItems: [[String:String]]?
    
    init(title: String, items: [MPMediaItem]) {
        self.title = title
        self.items = items
        super.init()
    }
    
    // I copied this, I am a hour in with no progress on this... grasping at straws
    required init?(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObject(forKey: "title") as! String
        items = (aDecoder.decodeObject(forKey: "items") as! [MPMediaItem])
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(items, forKey: "items")
    }
    //
    
    func exportToFileURL() -> URL? {
        
        var finalArr: [[String : Any]] = [[:]]
        for item in items{
            finalArr.append(["artist": item.artist!, "album": item.albumTitle!, "song": item.title!])
        }

        let contents: [String : Any] = ["title": self.title, "items": finalArr]

        guard let path = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask).first else {
                return nil
        }
        
        
        let saveFileURL = path.appendingPathComponent("/\(title).jmplist")

        (contents as NSDictionary).write(to: saveFileURL, atomically: true)

        return saveFileURL
    }
    
    
}

