//
//  QuizViewController.swift
//  MusiQuiz
//
//  Created by Tim Geldof on 16/12/2019.
//  Copyright © 2019 Tim Geldof. All rights reserved.
//

import UIKit
import AVFoundation
import RealmSwift
import Toast_Swift

class QuizViewController: UIViewController {
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var artistTextField: UITextField!
    @IBOutlet weak var songTextField: UITextField!
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var player: AVPlayer? = nil
    var tracksArray : [TrackEntity] = []
    var currentTrack : TrackEntity? = nil
    var initialAmountOfSongs = 0
    var score: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        registerForKeyboardNotifications()
        /* SOURCE:  the keyboard logic consists of a combination of information from the book "App development for swift" and online resources. I changed the code to fit my application.
        */
    }
    override func viewDidAppear(_ animated: Bool) {
        initializeTrackArray()
        initialAmountOfSongs = tracksArray.count
        if(initialAmountOfSongs==0){
            navigationController?.popToRootViewController(animated: true)
        } else {
            setNextTrack()
        }
        addBlurToAlbumCover()

    }
    @objc func rotated() {
        addBlurToAlbumCover()
    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func registerForKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector : #selector( keyboardWasShown(_:)),
            name: UIResponder.keyboardDidShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector( keyboardWillBeHidden(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    @objc func keyboardWasShown(_ notification: NSNotification){
        guard let info = notification.userInfo,
        let keyboardFrameValue =
            info[UIResponder.keyboardFrameBeginUserInfoKey]
        as? NSValue
            else { return }
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    @objc func keyboardWillBeHidden(_ notification: NSNotification){
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
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
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.98
        for subview in albumImage.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
        blurEffectView.frame = self.albumImage.frame
        albumImage.addSubview(blurEffectView)
    }
    
    func updateUI(track: TrackEntity){
        self.albumImage.kf.indicatorType = .activity
        self.albumImage.kf.setImage(with: URL(string: track.album!.cover_medium))
        playButton.setImage(#imageLiteral(resourceName: "play"), for: UIControl.State.normal)
        addBlurToAlbumCover()
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
        let playerItem = CachingPlayerItem(url: URL(string: url)!)
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
        self.view.makeToast("Too bad, the song was \(currentTrack!.title) by \(currentTrack!.artist!.name)", duration: 2.0, position: .top)

        setNextTrack()
        view.endEditing(true)

    }
    
    @IBAction func guesButtonPressed(_ sender: Any) {
        var amountCorrect: Int = 0
        if let currentTrack = currentTrack {
            if(currentTrack.title.lowercased() == self.songTextField.text?.lowercased() ?? ""){
                self.score += 1
                amountCorrect += 1
            }
            if(currentTrack.artist?.name.lowercased() == self.artistTextField
                .text?.lowercased() ?? ""){
                self.score += 1
                amountCorrect += 1
            }
        }
        switch(amountCorrect){
            case 0 :
                self.view.makeToast("Too bad, the song was \(currentTrack!.title) by \(currentTrack!.artist!.name)", duration: 2.0, position: .top)
            case 1:
                self.view.makeToast("Almost! The song was \(currentTrack!.title) by \(currentTrack!.artist!.name)", duration: 2.0, position: .top)
        case 2:                 self.view.makeToast("You got it, nice job!", duration: 2.0, position: .top)

        default: print("It's debug time!")

        }
        resetTextFields()
        setNextTrack()
        view.endEditing(true)

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
            destination.maxPossibleScore = initialAmountOfSongs*2
            let acc : Double = Double(score)/Double(initialAmountOfSongs*2)
            destination.accuracy = acc*Double(100)
        }
    }

}
