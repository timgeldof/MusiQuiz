//
//  SearchTrackViewController.swift
//  MusiQuiz
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
        self.searchQuery.addTarget(self, action: #selector(OnSearchChanged), for: .editingChanged)

        // Do any additional setup after loading the view.
    }
    func updateTable(tracks: [SearchTrackResponse]){
        DispatchQueue.main.async {
            self.tracks = tracks
            self.tableView.reloadData()
        }
    }
    
    
    @objc func OnSearchChanged() {
        if let s = self.searchQuery.text{
            NetworkController.sharedInstance.getTracks(searchQuery: s, completion: {
                (fetchedTracks) in
                if let fetchedTracks = fetchedTracks {
                    self.updateTable(tracks: fetchedTracks.data)
                }
            })
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.tracks.count == 0){
            self.tableView.setEmptyView(title: "No result for search", message:"Songs matching your search will appear here. Check you internet connection if changing the search does nothing.")
        } else {
            tableView.restore()
        }
        return self.tracks.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) ->Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TrackTableViewCell
        cell.backgroundColor = UIColor.lightGray
        cell.update(with: self.tracks[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        performSegue(withIdentifier: "showDetailSearchedTrack", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TrackDetailViewController,
            let row = tableView.indexPathForSelectedRow?.row {
            destination.track = tracks[row]
        }
    }


}
