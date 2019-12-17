//
//  NetworkController.swift
//  myMusic
//
//  Created by Tim Geldof on 14/12/2019.
//  Copyright © 2019 Tim Geldof. All rights reserved.
//

import Foundation


extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.map { URLQueryItem(name: $0.0, value: $0.1) }
        
        return components?.url
    }
}

class NetworkController{
    // SOURCE: What is a singleton and how to create one in swift
    static let sharedInstance = NetworkController()
    
    let BASE_URL: String = "https://api.deezer.com/"
    
    func getTracks(searchQuery: String, completion: @escaping (SearchTrackResponseWrapper?) -> Void){
        let BASE_URL: String = "https://api.deezer.com/"
        let searchURL = URL(string: BASE_URL + "search/track")
        let s = searchURL?.withQueries(["q":searchQuery])

        let task = URLSession.shared.dataTask(with: s!){
            (data, error, response) in
            if let data = data,
               let resp =  try? JSONDecoder().decode(SearchTrackResponseWrapper.self, from: data){
                completion(resp)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
}
