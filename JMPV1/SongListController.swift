//
//  SongListController.swift
//  JMPV1
//
//  Created by john on 10/22/17.
//  Copyright © 2017 johnsApps. All rights reserved.
//

import UIKit
import MediaPlayer

import AudioToolbox

class SongListController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var albumView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var albumItem: [MPMediaItem]!
    
    var playlistItems: [MPMediaItem] = [MPMediaItem]()
    
    var albumImage: UIImage!
    var albumNameStr: String!
    var albumArtistStr: String!
    
    var inPlaylistMode: Bool = false
    var selectedCells: [IndexPath] = [IndexPath]()
    
    var playListBtn = UIButton()
    
    var delegate: playlistAnim!
    var doneBtn: UIButton!
    var cancelBtn: UIButton!
    var Player: MPMusicPlayerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumName.text! = albumArtistStr
        albumTitle.text! = albumNameStr
        albumView.image = albumImage
        
        playListBtn = UIButton(type: .custom)
        playListBtn.setImage(UIImage(named: "playList"), for: .normal)
        playListBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        playListBtn.addTarget(self, action: #selector(customClick), for: .touchUpInside)
        let playListBarBtn = UIBarButtonItem(customView: playListBtn)
        
        playListBarBtn.tintColor = .white
        self.navigationItem.setRightBarButtonItems([playListBarBtn], animated: true)

        doneBtn.addTarget(self, action: #selector(doneClick), for: .touchUpInside)
        cancelBtn.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
    }
    
    @objc func doneClick(){
        delegate.playlistSelectionDone(items: playlistItems)
        cancelClick()
    }
    
    @objc func cancelClick(){
        UIView.animate(withDuration: 0.5) {[unowned self] in
            self.navigationController?.isNavigationBarHidden = false
            self.selectedCells.removeAll()
            self.playlistItems.removeAll()
            self.tableView.reloadData()
            self.inPlaylistMode = false
            self.delegate.playlistMode(false)
        }
    }
    
    @objc func customClick(){
        UIView.animate(withDuration: 0.5) {[unowned self] in
            self.inPlaylistMode = true
            self.delegate.playlistMode(true)
            self.navigationController?.isNavigationBarHidden = true
            self.view.layoutIfNeeded()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumItem.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath)
        
        cell.accessoryType = selectedCells.contains(indexPath) ? .checkmark : .none
        cell.textLabel?.text! = "\(indexPath.row+1). \(albumItem[indexPath.row].title!) "
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (inPlaylistMode){

            if selectedCells.contains(indexPath){
                selectedCells.remove(at: selectedCells.index(of: indexPath)!)
                playlistItems.remove(at: playlistItems.index(of: albumItem[indexPath.row])!)
            }else{
                selectedCells.append(indexPath)
                playlistItems.append(albumItem[indexPath.row])
            }

            tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
            return
        }
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let songListView = storyboard.instantiateViewController(withIdentifier: "songView") as! SongViewController
        
        songListView.songItem = albumItem[indexPath.row]

        songListView.albumIMG = albumImage
        songListView.Player = Player
        

        show(songListView, sender: self)
    }
    

}
