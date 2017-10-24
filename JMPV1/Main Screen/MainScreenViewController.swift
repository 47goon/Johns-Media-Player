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
    @IBOutlet weak var segmentCtrl: UISegmentedControl!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var playlistView: UIView!
    
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

    }
    func doAnim() {
        print("YAY IT WORKS")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAlbumNav"{
            let vcNav = segue.destination as! UINavigationController
            
            let albumNav = vcNav.viewControllers[0] as! ViewController
            albumNav.delegate = self
        }
    }

}
