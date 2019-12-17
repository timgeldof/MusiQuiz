//
//  TrackTableViewCell.swift
//  myMusic
//
//  Created by Tim Geldof on 15/12/2019.
//  Copyright © 2019 Tim Geldof. All rights reserved.
//

import UIKit
import Kingfisher

class TrackTableViewCell: UITableViewCell {

    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var songTitleLabel: UILabel!

    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func update(with track: SearchTrackResponse){
        self.artistLabel.text = track.artist.name
        self.songTitleLabel.text = track.title
        let downloadURL: URL = URL(string: track.album.cover_small)!
        self.albumImage.kf.indicatorType = .activity
        self.albumImage.kf.setImage(with: downloadURL)
        self.durationLabel.text = track.durationToMinuteString()
    }
    

}
