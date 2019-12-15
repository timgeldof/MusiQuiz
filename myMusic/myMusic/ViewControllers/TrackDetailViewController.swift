//
//  TrackDetailViewController.swift
//  myMusic
//
//  Created by Tim Geldof on 14/12/2019.
//  Copyright © 2019 Tim Geldof. All rights reserved.
//

import UIKit
import AVFoundation

class TrackDetailViewController: UIViewController {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var songTitleLabel: UILabel!


    
    var track : SearchTrackResponse? = nil
    var player: AVPlayer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI();
    }
    func updateUI(){
        if let track = track {
            self.albumImage.kf.setImage(with: URL(string: track.album.cover_medium))
            self.artistNameLabel.text = track.artist.name
            self.durationLabel.text = track.durationToMinuteString()
            self.songTitleLabel.text = track.title
            setUpPlayer(url: track.preview)
        }

    }
    func setUpPlayer(url: String){
        let playerItem = AVPlayerItem(url: URL(string: url)!)
        self.player = AVPlayer(playerItem: playerItem)
        self.player?.volume = 1
    }
    @IBAction func onStopPressed(_ sender: Any) {
        if let player = player {
            player.seek(to: .zero)
            playButton.setImage(#imageLiteral(resourceName: "play"), for: UIControl.State.normal)
            if(player.isPlaying){
                player.pause()
            }
        }
    }
    @IBAction func onPlayPressed(_ sender: Any) {
        if let player = player {
            if(!player.isPlaying){
                player.play()
                playButton.setImage(#imageLiteral(resourceName: "pause"), for: UIControl.State.normal)
            } else {
                player.pause()
                playButton.setImage(#imageLiteral(resourceName: "play"), for: UIControl.State.normal)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
// SOURCE: https://stackoverflow.com/questions/5655864/check-play-state-of-avplayer
extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
