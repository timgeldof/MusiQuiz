//
//  Quiz.swift
//  MusiQuiz
//
//  Created by Tim Geldof on 26/12/2019.
//  Copyright © 2019 Tim Geldof. All rights reserved.
//

import Foundation

class Quiz{
    
    var tracksArray : [TrackEntity] = []
    var currentTrack : TrackEntity? = nil
    var initialAmountOfSongs = 0
    var score: Int = 0
    
    
    
    func setUp(){
        initializeTrackArray()
        initialAmountOfSongs = tracksArray.count
    }
    
    func reset(){
        tracksArray = []
        currentTrack = nil
        initialAmountOfSongs = 0
        score = 0
    }
    
    func getNewTrack() -> TrackEntity? {
        guard let track = tracksArray.randomElement() else {
            return nil
        }
        tracksArray.remove(at: tracksArray.firstIndex(of: track)!)
        return track
    }
    
    func initializeTrackArray() {
        DatabaseController.sharedInstance.getAll { (tracks) in
            if let tracks = tracks {
                for track in tracks {
                    self.tracksArray.append(track)
                }
            } else {
                print("something went wrong")
            }
        }
    }
    
    func songGuessMatchesTrack(_ currentTrack: TrackEntity, _ songGuess: String?) -> Bool {
        return currentTrack.title.lowercased().filter("abcdefghijklmnopqrstuvwxyz ".contains) == songGuess?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).filter("abcdefghijklmnopqrstuvwxyz ".contains) ?? ""
    }
    
    func artistGuessMatchesTrack(_ currentTrack: TrackEntity, _ artistGuess: String?) -> Bool {
        return currentTrack.artist?.name.lowercased().filter("abcdefghijklmnopqrstuvwxyz ".contains) == artistGuess?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).filter("abcdefghijklmnopqrstuvwxyz ".contains) ?? ""
    }
    
    func makeGuess( songGuess: String?, artistGuess: String?) -> Int {
        var amountCorrect: Int = 0
        if let currentTrack = currentTrack {
            if(songGuessMatchesTrack(currentTrack, songGuess)){
                self.score += 1
                amountCorrect += 1
            }
            if(artistGuessMatchesTrack(currentTrack, artistGuess)){
                self.score += 1
                amountCorrect += 1
            }
        }
        return amountCorrect
    }
    func setNextTrack() -> Bool {
        if let nextTrack = getNewTrack() {
            self.currentTrack = nextTrack
            return true
        } else {
            return false
        }
    }
    
    
    
}
