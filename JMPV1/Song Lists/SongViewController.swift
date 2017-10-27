//
//  SongViewController.swift
//  JMPV1
//
//  Created by John Smith on 10/24/17.
//  Copyright © 2017 johnsApps. All rights reserved.
//

import UIKit
import MediaPlayer

class SongViewController: UIViewController {

    @IBOutlet weak var albumArt: UIImageView!
    
    @IBOutlet weak var imageBG: UIImageView!
    @IBOutlet weak var songNameLBL: UILabel!
    @IBOutlet weak var artistNameLBL: UILabel!
    
    var songIndex: Int!
    var albumItem: [MPMediaItem]!
    var playListItems: [MPMediaItem]?
    var albumIMG: UIImage!
    
    var Player: MPMusicPlayerController!
    
    var albumSlice: ArraySlice<MPMediaItem>!
    
    @objc func updateView(_ n: Notification){
        if let songTitle = Player.nowPlayingItem?.title, let artistTitle = Player.nowPlayingItem?.artist{
            songNameLBL.text! = songTitle
            artistNameLBL.text! = artistTitle
        }
        
        
        let img = Player.nowPlayingItem?.artwork?.image(at: CGSize(width: 128, height: 128))
        imageBG.image = img
        albumArt.image = img
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if playListItems != nil{
            let song = playListItems![songIndex]
            imageBG.image = albumIMG
            albumArt.image = albumIMG
        
            Player.setQueue(with: MPMediaItemCollection(items: playListItems!))
            Player.nowPlayingItem = song
            Player.play()
            
            songNameLBL.text! = song.title!
            artistNameLBL.text! = song.artist!
            
            NotificationCenter.default.addObserver(self, selector: #selector(updateView), name: Notification.Name(rawValue: "com.johnCodes.TrackChanged") , object: nil)
            return
        }
        
        let song = albumItem[songIndex]
        
        imageBG.image = albumIMG
        albumArt.image = albumIMG
        
        let collection = MPMediaItemCollection(items: albumItem)
        Player.setQueue(with: collection)
        Player.nowPlayingItem = albumItem[songIndex]
        Player.play()
        
        songNameLBL.text! = song.title!
        artistNameLBL.text! = song.artist!
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateView), name: Notification.Name(rawValue: "com.johnCodes.TrackChanged") , object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
