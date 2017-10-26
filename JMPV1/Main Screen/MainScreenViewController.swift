//
//  MainScreenViewController.swift
//  JMPV1
//
//  Created by john on 10/24/17.
//  Copyright © 2017 johnsApps. All rights reserved.
//

import UIKit
import MediaPlayer

protocol PlaylistDelegate{
    func updatePlaylists(playLists: [Playlist])
}

class MainScreenViewController: UIViewController, playlistAnim, PlaylistCreationDelegate {
    
    var vcNav: UINavigationController!
    
    @IBOutlet weak var segmentCtrl: UISegmentedControl!
    
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var playlistViewSign: UIView!
    
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var playlistView: UIView!
    
    @IBOutlet weak var bvImageView: UIImageView!
    @IBOutlet weak var bvSongName: UILabel!
    @IBOutlet weak var bvArtistName: UILabel!
    @IBOutlet weak var bvPlayBtn: UIButton!
    
    var player: MPMusicPlayerController = MPMusicPlayerController.systemMusicPlayer
    
    var playLists: [Playlist] = [Playlist]()
    var playListDelegate: PlaylistDelegate?
    
    @IBAction func segmentChanged(_ sender: Any) {
        self.view.bringSubview(toFront: bottomView)
        switch segmentCtrl.selectedSegmentIndex {
        case 0:
            UIView.animate(withDuration: 0.2, animations: { [unowned self] in
                self.playlistView.alpha = 0
                self.containerView.alpha = 1
            })
        case 1:
            UIView.animate(withDuration: 0.2, animations: { [unowned self] in
                self.playlistView.alpha = 1
                self.containerView.alpha = 0
            })
        default:
            break
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        playlistViewSign.alpha = 0
        doneBtn.alpha = 0
        cancelBtn.alpha = 0
        
        progressSlider.value = 0
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sliderTapped(gestureRecognizer:)))
        self.progressSlider.addGestureRecognizer(tapGestureRecognizer)
        progressSlider.setThumbImage(UIImage(), for: .normal)
        
        player.beginGeneratingPlaybackNotifications()
    }
    
    //Solution on https://stackoverflow.com/questions/34619535/tap-on-uislider-to-set-the-value
    // Credit to myuiviews
    @objc func sliderTapped(gestureRecognizer: UIGestureRecognizer) {
        
        let pointTapped: CGPoint = gestureRecognizer.location(in: self.view)
        
        let positionOfSlider: CGPoint = progressSlider.frame.origin
        let widthOfSlider: CGFloat = progressSlider.frame.size.width
        let newValue = ((pointTapped.x - positionOfSlider.x) * CGFloat(progressSlider.maximumValue) / widthOfSlider)
        
        progressSlider.setValue(Float(newValue), animated: true)
        player.currentPlaybackTime = TimeInterval(progressSlider.value)
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        player.currentPlaybackTime = TimeInterval(progressSlider.value)
    }
    
    func playlistMode(_ mode: Bool) {
        if mode {
            UIView.animate(withDuration: 0.1) { [unowned self] in
                self.playlistViewSign.alpha = 1
                self.doneBtn.alpha = 1
                self.cancelBtn.alpha = 1
            }
        }else{
            UIView.animate(withDuration: 0.1) { [unowned self] in
                self.playlistViewSign.alpha = 0
                self.doneBtn.alpha = 0
                self.cancelBtn.alpha = 0
            }
        }
        
    }
    
    var isPlaying: Bool = false
    
    @IBAction func playPressed(_ sender: UIButton) {
        guard player.nowPlayingItem != nil, (player.playbackState == .playing || player.playbackState == .paused ) else {
            return
        }
        if isPlaying{
            sender.setImage(UIImage(named: "pauseBtn"), for: .normal)
            player.play()
        }else{
            sender.setImage(UIImage(named: "playBtn"), for: .normal)
            player.pause()
        }
        isPlaying = !isPlaying
    }
    
    func playlistSelectionDone(items: [MPMediaItem]) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let playListView = storyboard.instantiateViewController(withIdentifier: "playListCreator") as! UINavigationController
        
        let pCreateVC = playListView.viewControllers[0] as! PlaylistCreatorController
        pCreateVC.playLists = playLists
        pCreateVC.passedItems = items
        pCreateVC.delegate = self
        show(playListView, sender: self)
    }
    
    func addPlaylist(playlist: Playlist) {
        let check = self.playLists.filter({ $0.title == playlist.title })
        if check.count > 0 {
            let indexTest = self.playLists.index(where: { (p) -> Bool in
                p.title == check[0].title
            })
            if let indexFinal = indexTest{
                // This is terrible...
                for item in playlist.items{
                    if self.playLists[indexFinal].items.contains(item){ continue }
                    self.playLists[indexFinal].items.append(item)
                }
                playListDelegate?.updatePlaylists(playLists: playLists)
            }
            
        } else {
            self.playLists.append(playlist)
            playListDelegate?.updatePlaylists(playLists: playLists)
        }
        
    }
    
    @objc func updateSlider(){
        progressSlider.value = Float(player.currentPlaybackTime)
        if (player.nowPlayingItem?.title! != bvSongName.text!){
            NotificationCenter.default.post(name: Notification.Name(rawValue: "com.johnCodes.TrackChanged"), object: self)
            updateBottomView(albumArt: (player.nowPlayingItem?.artwork?.image(at: CGSize(width: 128, height: 128)))!, songName: (player.nowPlayingItem?.title!)!, artistName: (player.nowPlayingItem?.artist!)!, songItem: (player.nowPlayingItem)!)
        }
    }
    
    func updateBottomView(albumArt: UIImage, songName: String, artistName: String, songItem: MPMediaItem){
        if bvPlayBtn.isHidden { bvPlayBtn.isHidden = false }
        bvPlayBtn.setImage(UIImage(named: "pauseBtn"), for: .normal)
        isPlaying = true
        bvImageView.image = albumArt
        bvSongName.text! = songName
        bvArtistName.text! = artistName
        
        progressSlider.maximumValue = Float(songItem.playbackDuration)
        _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAlbumNav"{
            vcNav = segue.destination as! UINavigationController
            
            let albumNav = vcNav.viewControllers[0] as! ViewController
            albumNav.delegate = self
            albumNav.doneBtn = doneBtn
            albumNav.cancelBtn = cancelBtn
            albumNav.Player = player
        }
        
        if segue.identifier == "toPlaylistView"{
            vcNav = segue.destination as! UINavigationController
            let playListView = vcNav.viewControllers[0] as! PlaylistViewController
            playListView.playlists = self.playLists
            playListView.delegate = self
            playListView.player = player
            self.playListDelegate = playListView
        }
    }
}











