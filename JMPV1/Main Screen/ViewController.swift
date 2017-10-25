//
//  ViewController.swift
//  JMPV1
//
//  Created by john on 10/22/17.
//  Copyright © 2017 johnsApps. All rights reserved.
//

//
//  ViewController.swift
//  JmpAlpha
//
//  Created by john on 10/20/17.
//  Copyright © 2017 johnsApps. All rights reserved.
//

import UIKit
import MediaPlayer

protocol playlistAnim{
    func playlistMode(_ mode: Bool)
    func playlistSelectionDone(items: [MPMediaItem])
}

class ViewController: UITableViewController {
    
    var songs:[String] = [String]()
    
    var musicPlayer = MPMusicPlayerController.applicationMusicPlayer
    var mediaItems: [MPMediaItemCollection]!
    
    var delegate: playlistAnim!
    var doneBtn: UIButton!
    var cancelBtn: UIButton!
    
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let qry = MPMediaQuery.albums()
        qry.groupingType = MPMediaGrouping.album
        let allAlbums = qry.collections
        
        title = "All Albums"
        MPMediaLibrary.requestAuthorization { (status) in
            if status == .authorized{
                self.mediaItems = allAlbums!
                self.count = self.mediaItems.count
                self.tableView.reloadData()
            }
        }

        
        tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath ) as! AlbumCell
        
        cell.albumArtView.image = mediaItems[indexPath.row].representativeItem!.artwork?.image(at: CGSize(width: cell.albumArtView.frame.width, height: cell.albumArtView.frame.height  ))
        cell.albumTitle.text! = mediaItems[indexPath.row].representativeItem!.albumTitle!
        cell.artistTitle.text! = "By: \(mediaItems[indexPath.row].representativeItem!.artist!)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let songListView = storyboard.instantiateViewController(withIdentifier: "songList") as! SongListController
        songListView.albumItem = mediaItems[indexPath.row].items
        songListView.albumNameStr = mediaItems[indexPath.row].representativeItem!.albumTitle!
        songListView.albumArtistStr = mediaItems[indexPath.row].representativeItem!.artist!
        songListView.albumImage = mediaItems[indexPath.row].representativeItem!.artwork?.image(at: CGSize(width: 128, height: 128 ))
        
        songListView.delegate = delegate
        songListView.doneBtn = doneBtn
        songListView.cancelBtn = cancelBtn
        
        show(songListView, sender: self)
    }
    
    
    
    
}

