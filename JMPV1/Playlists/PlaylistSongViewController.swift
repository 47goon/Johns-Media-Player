//
//  PlaylistSongViewController.swift
//  JMPV1
//
//  Created by john on 10/25/17.
//  Copyright © 2017 johnsApps. All rights reserved.
//

import UIKit
import MediaPlayer

class PlaylistSongViewController: UITableViewController {
    
    var songs: [MPMediaItem]!
    var unknownSongs: [[String:String]]?
    
    
    var delegate: playlistAnim!
    var player: MPMusicPlayerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let shareBarBtn = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        shareBarBtn.tintColor = .white
        self.navigationItem.setRightBarButtonItems([shareBarBtn], animated: true)

    }
    
    @objc func shareTapped(){
        let playlist = Playlist(title: self.title ?? "Playlist", items: songs)
        guard let url = playlist.exportToFileURL() else {
            print("GUARD FAILED")
            return
        }

        let vc = UIActivityViewController(activityItems: ["Check out this playlist.", url], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        if unknownSongs != nil {
            return 2
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return (unknownSongs?.count)!
        }
        return songs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            if let unknownArr = unknownSongs {
                let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! AlbumCell
                cell.albumArtView.image = UIImage(named: "PBTS")
                cell.albumTitle.text! = unknownArr[indexPath.row]["album"]!
                cell.artistTitle.text! = unknownArr[indexPath.row]["artist"]!
                
                cell.artistTitle.textColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
                cell.albumTitle.textColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
                cell.contentView.backgroundColor = UIColor(red: 100/255, green: 0/255, blue: 0/255, alpha: 1)
                cell.backgroundColor = UIColor(red: 100/255, green: 0/255, blue: 0/255, alpha: 1)

                return cell
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! AlbumCell
        cell.albumArtView.image = (songs[indexPath.row].artwork?.image(at: CGSize(width: 128, height: 128)))!
        cell.albumTitle.text! = songs[indexPath.row].title! // Song title for playlist view...
        cell.artistTitle.text! = "By: \(songs[indexPath.row].artist!)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            UIApplication.shared.openURL(URL(string: "https://itunes.apple.com/store/")!)
            return
        }
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let songListView = storyboard.instantiateViewController(withIdentifier: "songView") as! SongViewController
        
        songListView.songIndex = indexPath.row
        songListView.playListItems = songs
        songListView.albumIMG = (songs[indexPath.row].artwork?.image(at: CGSize(width: 128, height: 128)))!
        songListView.Player = player
        
        //TODO: Make it so I only send songItem, Quick fix for slider rn
        delegate.updateBottomView(albumArt: (songs[indexPath.row].artwork?.image(at: CGSize(width: 128, height: 128)))!, songName: songs[indexPath.row].title!, artistName: songs[indexPath.row].artist!, songItem: songs[indexPath.row])
        
        show(songListView, sender: self)
    }
 



}
