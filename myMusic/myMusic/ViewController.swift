//
//  ViewController.swift
//  myMusic
//
//  Created by Tim Geldof on 14/12/2019.
//  Copyright © 2019 Tim Geldof. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let nc = NetworkController()
        nc.getTracks(searchQuery: "bliss", completion: {
            (fetchedTracks) in
            for track in fetchedTracks.data{
                print(track.title)
            }
            
        })
        print("fail")
    }


}

