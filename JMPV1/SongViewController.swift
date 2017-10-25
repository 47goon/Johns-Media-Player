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
    
    var songItem: MPMediaItem!
    var albumIMG: UIImage!
    
    var Player: MPMusicPlayerController!
    
    @IBAction func stateChanged(_ sender: Any) {
        print(Player.playbackState)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imageBG.image = albumIMG
        albumArt.image = albumIMG
        
        Player.nowPlayingItem = songItem
        Player.play()
        
        songNameLBL.text! = songItem.title!
        artistNameLBL.text! = songItem.artist!
    }

}
