//
//  PlaylistViewController.swift
//  JMPV1
//
//  Created by john on 10/25/17.
//  Copyright © 2017 johnsApps. All rights reserved.
//

import UIKit
import MediaPlayer

class PlaylistViewController: UITableViewController, PlaylistDelegate {

    var playlists: [Playlist]!
    var delegate: playlistAnim!
    var player: MPMusicPlayerController!
    
    func updatePlaylists(playLists: [Playlist]) {
        self.playlists = playLists
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistCell", for: indexPath)
        cell.textLabel?.text = playlists[indexPath.row].title
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let songListView = storyboard.instantiateViewController(withIdentifier: "playlistAlbumView") as! PlaylistSongViewController
        songListView.songs = playlists[indexPath.row].items
        songListView.title = playlists[indexPath.row].title
        
        songListView.delegate = delegate
        songListView.player = player
        navigationController?.pushViewController(songListView, animated: true)
    }
    
    @objc func shareTapped(){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


}
