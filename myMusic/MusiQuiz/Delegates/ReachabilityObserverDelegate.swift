//
//  ReachabilityObserverDelegate.swift
//  MusiQuiz
//
//  Created by Tim Geldof on 18/12/2019.
//  Copyright © 2019 Tim Geldof. All rights reserved.
//

import Foundation
import Reachability
// SOURCE: https://medium.com/@popcornomnom/handling-internet-connection-reachability-on-ios-swift-5-2a5cc68fb4b7
// the implementation of the delegation methods were handled by myself though

fileprivate var reachability: Reachability!

protocol ReachabilityActionDelegate {
    func reachabilityChanged(_ isReachable: Bool)
}

protocol ReachabilityObserverDelegate: class, ReachabilityActionDelegate {
    func addReachabilityObserver() throws
    func removeReachabilityObserver()
}

// Declaring default implementation of adding/removing observer
extension ReachabilityObserverDelegate {
    
    /** Subscribe on reachability changing */
    func addReachabilityObserver() throws {
        reachability = try Reachability()
        
        reachability.whenReachable = { [weak self] reachability in
            self?.reachabilityChanged(true)
        }
        
        reachability.whenUnreachable = { [weak self] reachability in
            self?.reachabilityChanged(false)
        }
        
        try reachability.startNotifier()
    }
    
    /** Unsubscribe */
    func removeReachabilityObserver() {
        reachability.stopNotifier()
        reachability = nil
    }
}

class ReachabilityHandler: ReachabilityObserverDelegate {
  
  //MARK: Lifecycle
  
  required init() {
    try? addReachabilityObserver()
  }
  
  deinit {
    removeReachabilityObserver()
  }
  
  //MARK: Reachability
    
  func reachabilityChanged(_ isReachable: Bool) {
    if !isReachable {
        print("No internet connection")
    }
}

}
