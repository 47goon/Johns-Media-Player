//
//  SongListController.swift
//  JMPV1
//
//  Created by john on 10/22/17.
//  Copyright © 2017 johnsApps. All rights reserved.
//

import UIKit
import MediaPlayer

class SongListController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var albumView: UIImageView!
    
    var albumItem: [MPMediaItem]!
    
    var albumImage: UIImage!
    var albumNameStr: String!
    var albumArtistStr: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumName.text! = albumArtistStr
        albumTitle.text! = albumNameStr
        albumView.image = albumImage
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumItem.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath)
        cell.textLabel?.text! = "\(indexPath.row+1). \(albumItem[indexPath.row].title!) "
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let songListView = storyboard.instantiateViewController(withIdentifier: "songView") as! SongViewController
        
        songListView.songItem = albumItem[indexPath.row]

        songListView.albumIMG = albumImage

        show(songListView, sender: self)
    }


}
