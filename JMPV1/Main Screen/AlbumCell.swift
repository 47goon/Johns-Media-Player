//
//  AlbumCell.swift
//  JMPV1
//
//  Created by john on 10/22/17.
//  Copyright © 2017 johnsApps. All rights reserved.
//

import UIKit

class AlbumCell: UITableViewCell {
    
    @IBOutlet weak var albumArtView: UIImageView!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var artistTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            self.contentView.backgroundColor = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 0.7)
        }else{
            self.contentView.backgroundColor = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1)
        }

    }


}
