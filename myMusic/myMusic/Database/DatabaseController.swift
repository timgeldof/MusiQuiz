//
//  DatabaseController.swift
//  myMusic
//
//  Created by Tim Geldof on 15/12/2019.
//  Copyright © 2019 Tim Geldof. All rights reserved.
//

import Foundation
import RealmSwift


class DatabaseController {
    static let sharedInstance = DatabaseController()
    
    func insertTrack(track: TrackEntity, completion: @escaping(Error?) -> Void){
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(track, update: .modified)
            }
        } catch let error {
            print("something went wrong")
            completion(error)
        }
        completion(nil)
    }
    
    func getAll(completion: @escaping(Results<TrackEntity>?) -> Void){
        let tracks: Results<TrackEntity>;
        do{
            let realm = try Realm()
            tracks = realm.objects(TrackEntity.self)
            completion(tracks)
        } catch {
            print("something went wrong: " + error.localizedDescription)
            completion(nil)
        }
    }
    
    func removeTrack(track: TrackEntity, completion: @escaping(Error?) -> Void){
        do{
            let realm = try Realm()
            try realm.write {
                realm.delete(track)
            }
        } catch let error {
            print("something went wrong")
            completion(error)
        }

        completion(nil)
    }
    func removeAllTracks(completion: @escaping(Error?) -> Void){
        do{
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
        } catch let error {
            print("something went wrong")
            completion(error)
        }
        
        completion(nil)
    }
}
