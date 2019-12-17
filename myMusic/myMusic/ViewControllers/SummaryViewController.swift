//
//  SummaryViewController.swift
//  myMusic
//
//  Created by Tim Geldof on 16/12/2019.
//  Copyright © 2019 Tim Geldof. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController {

    var score : Int = 0
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text = String(score)
        // Do any additional setup after loading the view.
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
