//
//  FavoriteTracksViewController.swift
//  MusiQuiz
//
//  Created by Tim Geldof on 14/12/2019.
//  Copyright © 2019 Tim Geldof. All rights reserved.
//

import UIKit
import RealmSwift
import Toast_Swift

class FavoriteTracksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    private var tracks : Results<TrackEntity>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        DatabaseController.sharedInstance.getAll(completion: {
            (tracks) in
            self.tracks = tracks
            self.updateTable()
        })
    }


    
    func updateTable(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tracks = tracks {
            if(tracks.count == 0){
                self.view.makeToast("Add some songs!", position: .center)
            }
            return tracks.count
        } else {
            return 0
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) ->Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TrackTableViewCell
        if let tracks = tracks {
            cell.update(with: tracks[indexPath.row].toApiTrack())
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        performSegue(withIdentifier: "favoritesToDetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            DatabaseController.sharedInstance.removeTrack(track: tracks![indexPath.row], completion: {
                (error) in
                if let error = error {
                    print("Delete failed: " + error.localizedDescription)
                } else {
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    self.updateTable()
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TrackDetailViewController,
            let row = tableView.indexPathForSelectedRow?.row {
            destination.track = tracks![row].toApiTrack()
        }
    }

}
