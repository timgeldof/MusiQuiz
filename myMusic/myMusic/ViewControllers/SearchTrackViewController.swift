//
//  SearchTrackViewController.swift
//  myMusic
//
//  Created by Tim Geldof on 14/12/2019.
//  Copyright © 2019 Tim Geldof. All rights reserved.
//

import UIKit

class SearchTrackViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchQuery: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    private var tracks : [SearchTrackResponse]  = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    func updateTable(tracks: [SearchTrackResponse]){
        DispatchQueue.main.async {
            self.tracks = tracks
            self.tableView.reloadData()
        }
    }
    
    @IBAction func OnSearchPressed(_ sender: Any) {
        if let s = self.searchQuery.text{
            NetworkController.sharedInstance.getTracks(searchQuery: s, completion: {
                (fetchedTracks) in
                if let fetchedTracks = fetchedTracks {
                    for track in fetchedTracks.data{
                        print(track.title)
                        print("Album:" + track.album.title)
                        print("Artist:" + track.artist.name)
                    }
                    self.updateTable(tracks: fetchedTracks.data)
                }
            })
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tracks.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) ->Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell.backgroundColor = UIColor.lightGray
        cell.textLabel?.text = self.tracks[indexPath.row].title
        cell.detailTextLabel?.text = self.tracks[indexPath.row].artist.name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showDetailSearchedTrack", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TrackDetailViewController,
            let row = tableView.indexPathForSelectedRow?.row {
            destination.track = tracks[row]
        }
    }


}
