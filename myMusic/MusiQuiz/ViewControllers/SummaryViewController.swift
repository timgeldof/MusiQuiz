//
//  SummaryViewController.swift
//  MusiQuiz
//
//  Created by Tim Geldof on 16/12/2019.
//  Copyright © 2019 Tim Geldof. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController {

    var score : Int = 0
    var maxPossibleScore: Int = 0
    var accuracy: Double = 0.0
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var maxScoreLabel: UILabel!
    @IBOutlet weak var accuracyLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text = String(score)
        maxScoreLabel.text = String(maxPossibleScore)
        accuracyLabel.text =
            String(accuracy).prefix(5)+"%"
        
        
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
