//
//  TrackCell.swift
//  p_iTuneMusic
//
//  Created by Saffi on 2018/7/8.
//  Copyright © 2018 Saffi. All rights reserved.
//

import UIKit

class TrackCell: UITableViewCell {

    @IBOutlet var albumCover: UIImageView!
    @IBOutlet var trackName: UILabel!
    @IBOutlet var artistName: UILabel!
    @IBOutlet var collectionName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
