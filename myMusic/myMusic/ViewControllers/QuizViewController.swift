//
//  QuizViewController.swift
//  myMusic
//
//  Created by Tim Geldof on 16/12/2019.
//  Copyright © 2019 Tim Geldof. All rights reserved.
//

import UIKit
import AVFoundation
import RealmSwift
class QuizViewController: UIViewController {
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var artistTextField: UITextField!
    @IBOutlet weak var songTextField: UITextField!
    @IBOutlet weak var albumImage: UIImageView!
    
    var player: AVPlayer? = nil
    var tracksArray : [TrackEntity] = []
    var currentTrack : TrackEntity? = nil
    var initialAmountOfSongs = 0
    var score: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTrackArray()
        initialAmountOfSongs = tracksArray.count
        setNextTrack()
    }
    
    func setNextTrack(){
        if let nextTrack = getNewTrack() {
            updateUI(track: nextTrack)
        } else {
            print("quiz over")
        }
    }
    func updateUI(track: TrackEntity){
        self.albumImage.kf.setImage(with: URL(string: track.album!.cover_medium))
        setUpPlayer(url: track.preview)
    }
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        animateButton(sender: sender)
        if let player = player {
            player.seek(to: .zero)
            playButton.setImage(#imageLiteral(resourceName: "play"), for: UIControl.State.normal)
            if(player.isPlaying){
                player.pause()
            }
        }
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        animateButton(sender: sender)
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
    
    func setUpPlayer(url: String){
        let playerItem = AVPlayerItem(url: URL(string: url)!)
        self.player = AVPlayer(playerItem: playerItem)
        self.player?.volume = 1
    }
    
    @IBAction func replayButtonPressed(_ sender: Any) {
        if let player = player {
            player.seek(to: .zero)
        }
    }
    
    @IBAction func skipButtonPressed(_ sender: Any) {
        setNextTrack()
    }
    
    @IBAction func guesButtonPressed(_ sender: Any) {
        setNextTrack()
    }
    func getNewTrack() -> TrackEntity? {
        guard let track = tracksArray.randomElement() else {
            return nil
        }
        tracksArray.remove(at: tracksArray.firstIndex(of: track)!)
        return track
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        let tabBarControllerItems = self.tabBarController?.tabBar.items

        if let tabArray = tabBarControllerItems {
            let tabBarItem1 = tabArray[0]
            let tabBarItem3 = tabArray[2]
            
            tabBarItem1.isEnabled = false
            tabBarItem3.isEnabled = false
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        let tabBarControllerItems = self.tabBarController?.tabBar.items

        if let tabArray = tabBarControllerItems {
            let tabBarItem1 = tabArray[0]
            let tabBarItem3 = tabArray[2]
            
            tabBarItem1.isEnabled = true
            tabBarItem3.isEnabled = true
        }
    }
    
    func initializeTrackArray() {
        DatabaseController.sharedInstance.getAll { (tracks) in
            if let tracks = tracks {
                for track in tracks {
                    self.tracksArray.append(track)
                }
            } else {
                print("something went wrong")
            }
        }
    }
    // SOURCE: https://jgreen3d.com/animate-ios-buttons-touch/
    func animateButton(sender : UIButton){
        UIButton.animate(withDuration: 0.2, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { finish in UIButton.animate(withDuration: 0.2, animations: { sender.transform = CGAffineTransform.identity })
        })
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
