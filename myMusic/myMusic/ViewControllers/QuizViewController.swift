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
    }
    override func viewDidAppear(_ animated: Bool) {
        initializeTrackArray()
        initialAmountOfSongs = tracksArray.count
        setNextTrack()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        tracksArray = []
        currentTrack = nil
        initialAmountOfSongs = 0
        score = 0
        player = nil
    }
    
    func setNextTrack(){
        if let nextTrack = getNewTrack() {
            self.currentTrack = nextTrack
            updateUI(track: nextTrack)
        } else {
            performSegue(withIdentifier: "quizToSummary", sender: self)
        }
    }
    // SOURCE: https://stackoverflow.com/questions/33504770/remove-blurview-in-swift
    func addBlurToAlbumCover() {
        let blur = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.albumImage.bounds
        for subview in albumImage.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
        albumImage.addSubview(blurView)
    }
    
    func updateUI(track: TrackEntity){
        self.albumImage.kf.indicatorType = .activity
        self.albumImage.kf.setImage(with: URL(string: track.album!.cover_medium))
        addBlurToAlbumCover()
        playButton.setImage(#imageLiteral(resourceName: "play"), for: UIControl.State.normal)
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
        resetTextFields()
        setNextTrack()
    }
    
    @IBAction func guesButtonPressed(_ sender: Any) {
        if let currentTrack = currentTrack {
            if(currentTrack.title.lowercased() == self.songTextField.text?.lowercased() ?? ""){
                self.score += 1
            }
            if(currentTrack.artist?.name.lowercased() == self.artistTextField
                .text?.lowercased() ?? ""){
                self.score += 1
            }
        }
        resetTextFields()
        setNextTrack()
    }

    func resetTextFields(){
        self.songTextField.text = ""
        self.artistTextField.text = ""

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
            let tabBarItem1 = tabArray[1]
            let tabBarItem3 = tabArray[2]
            
            tabBarItem1.isEnabled = false
            tabBarItem3.isEnabled = false
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        let tabBarControllerItems = self.tabBarController?.tabBar.items

        if let tabArray = tabBarControllerItems {
            let tabBarItem1 = tabArray[1]
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
    // made small adjustment tho
    func animateButton(sender : UIButton){
        UIButton.animate(withDuration: 0.2, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { finish in UIButton.animate(withDuration: 0.2, animations: { sender.transform = CGAffineTransform.identity })
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SummaryViewController{
            destination.score = self.score
        }
    }

}
