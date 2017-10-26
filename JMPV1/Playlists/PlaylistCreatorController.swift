//
//  PlaylistCreatorController.swift
//  JMPV1
//
//  Created by john on 10/25/17.
//  Copyright © 2017 johnsApps. All rights reserved.
//

import UIKit
import MediaPlayer

protocol PlaylistCreationDelegate{
    func addPlaylist(playlist: Playlist)
}

class PlaylistCreatorController: UITableViewController {
    
    var playLists: [Playlist] = [Playlist]()
    var passedItems: [MPMediaItem]!
    var delegate: PlaylistCreationDelegate!
    
    
    @IBAction func cancelClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func createPlaylist(_ sender: Any) {
        
        let alert = UIAlertController(title: "New playlist", message: "Enter playlist title", preferredStyle: .alert)
        
        let createAction = UIAlertAction(title: "Create", style: .default) { [unowned self] (ac) in
            self.playLists.append(Playlist(title: alert.textFields![0].text!, items: []))
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(createAction)
        alert.addAction(cancelAction)
        alert.addTextField()
        
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playLists[indexPath.row].items.append(contentsOf: self.passedItems)
        delegate.addPlaylist(playlist: playLists[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playLists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistCell", for: indexPath)
        cell.textLabel?.text = playLists[indexPath.row].title
        return cell
    }


}
