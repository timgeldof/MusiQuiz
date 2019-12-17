//
//  HomeViewController.swift
//  MusiQuiz
//
//  Created by Tim Geldof on 16/12/2019.
//  Copyright © 2019 Tim Geldof. All rights reserved.
//

import UIKit
import Toast_Swift

class HomeViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func playQuizButton(_ sender: Any) {
        var canNavigate : Bool = false
        DatabaseController.sharedInstance.getAll { (tracks) in
            if(tracks?.count == 0){
                self.view.makeToast("Add some songs before starting a quiz :)", duration: 3.0, position: .center)
            } else {
                canNavigate = true
            }
        }
        if(canNavigate){
            performSegue(withIdentifier: "homeToQuiz", sender: self)
        }
    }
}
