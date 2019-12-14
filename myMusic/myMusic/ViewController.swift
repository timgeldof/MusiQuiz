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
        
        NetworkController.sharedInstance.getTracks(searchQuery: "bliss", completion: {
            (fetchedTracks) in
            if let fetchedTracks = fetchedTracks {
                for track in fetchedTracks.data{
                    print(track.title)
                    print("Album:" + track.album.title)
                    print("Artist:" + track.artist.name)

                }
            }
            })
    }


}

