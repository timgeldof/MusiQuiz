//
//  HomeViewController.swift
//  myMusic
//
//  Created by Tim Geldof on 16/12/2019.
//  Copyright © 2019 Tim Geldof. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func playQuizButton(_ sender: Any) {
        performSegue(withIdentifier: "homeToQuiz", sender: self)
    }
}
