//
//  MainScreenViewController.swift
//  JMPV1
//
//  Created by john on 10/24/17.
//  Copyright © 2017 johnsApps. All rights reserved.
//

import UIKit
import MediaPlayer

class MainScreenViewController: UIViewController, playlistAnim {
    
    var vcNav: UINavigationController!
    
    @IBOutlet weak var segmentCtrl: UISegmentedControl!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var playlistViewSign: UIView!
    
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var playlistView: UIView!
    
    var player: MPMusicPlayerController!
    
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
        
        player = MPMusicPlayerController.applicationMusicPlayer
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
    
    func playlistSelectionDone(items: [MPMediaItem]) {
        for item in items{
            print((item.title)!)
        }
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
    }

}
