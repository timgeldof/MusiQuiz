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

class QuizViewController: UIViewController, ReachabilityObserverDelegate, UITextFieldDelegate {
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var artistTextField: UITextField!
    @IBOutlet weak var songTextField: UITextField!
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var player: AVPlayer? = nil
    
    var quiz: Quiz = Quiz()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        registerForKeyboardNotifications()
        /* SOURCE:  the keyboard logic consists of a combination of information from the book "App development for swift" and online resources. I changed the code to fit my application.
        */
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        quiz.setUp()
        
        if(quiz.initialAmountOfSongs == 0){
            navigationController?.popToRootViewController(animated: true)
        } else {
            setNextTrackUI()
        }
        addBlurToAlbumCover()
        try! addReachabilityObserver()

    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == artistTextField {
            textField.resignFirstResponder()
            songTextField.becomeFirstResponder()
        } else if textField == songTextField {
            songTextField.resignFirstResponder()
            textField.resignFirstResponder()
        }
        return true
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
        quiz.reset()
        player = nil
        removeReachabilityObserver()
    }


    
    func setNextTrackUI(){
        let songsLeft: Bool = quiz.setNextTrack()
        if(songsLeft){
            updateUI(track: quiz.currentTrack!)
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
    
    @IBAction func replayButtonPressed(_ sender: UIButton) {
        animateButton(sender: sender)

        if let player = player {
            player.seek(to: .zero)
        }
    }
    
    @IBAction func skipButtonPressed(_ sender: UIButton) {
        animateButton(sender: sender)

        resetTextFields()
        self.view.makeToast("Too bad, the song was \(quiz.currentTrack!.title) by \(quiz.currentTrack!.artist!.name)", duration: 2.0, position: .top)

        setNextTrackUI()
        view.endEditing(true)

    }
    
    @IBAction func guesButtonPressed(_ sender: UIButton) {
        animateButton(sender: sender)

        let amountCorrect = (quiz.makeGuess(songGuess: self.songTextField.text, artistGuess: self.artistTextField.text))
        switch(amountCorrect){
            case 0 :
                self.view.makeToast("Too bad, the song was \(quiz.currentTrack!.title) by \(quiz.currentTrack!.artist!.name)", duration: 2.0, position: .top)
            case 1:
                self.view.makeToast("Almost! The song was \(quiz.currentTrack!.title) by \(quiz.currentTrack!.artist!.name)", duration: 2.0, position: .top)
        case 2:                 self.view.makeToast("You got it, nice job!", duration: 2.0, position: .top)

        default: print("It's debug time!")

        }
        resetTextFields()
        setNextTrackUI()
        view.endEditing(true)

    }

    func resetTextFields(){
        self.songTextField.text = ""
        self.artistTextField.text = ""
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
    
    // SOURCE: https://jgreen3d.com/animate-ios-buttons-touch/
    // made small adjustment tho
    func animateButton(sender : UIButton){
        UIButton.animate(withDuration: 0.2, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { finish in UIButton.animate(withDuration: 0.2, animations: { sender.transform = CGAffineTransform.identity })
        })
    }
    func reachabilityChanged(_ isReachable: Bool) {
         if(!isReachable){
             self.view.makeToast("No internet available! The song won't be able to play", duration: 2.0, position: .top)
         }
     }
     
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SummaryViewController{
            destination.score = quiz.score
            destination.maxPossibleScore = quiz.initialAmountOfSongs*2
            let acc : Double = Double(quiz.score)/Double(quiz.initialAmountOfSongs*2)
            destination.accuracy = acc*Double(100)
        }
    }

}
