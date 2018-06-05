//
//  Connection.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/04.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import Foundation
import Reachability
import SwiftyUserDefaults

extension DefaultsKeys {
    static let reachabilityChanged = DefaultsKey<Date?>("ReachabilityChanged")
}

extension Notification.Name {
    static let reachabilityChanged: Notification.Name = .init("NotificationReachabilityChanged")
}
class Connection: NSObject {
    static let shared = Connection()
    
    let reachability: Reachability
    
    override init() {
        self.reachability = Reachability.init(hostName: "www.google.com")
        reachability.startNotifier()
        
        super.init()
        
        NotificationCenter.addObserver(self, selector: #selector(reachabilityChanged), name: .reachabilityChanged)
        
    }
    
    static var isReachable: Bool {
        return Connection.shared.reachability.isReachable()
    }
    
    static var isReachableViaWWAN: Bool {
        return Connection.shared.reachability.isReachableViaWWAN()
    }
    
    static var isReachableViaWiFi: Bool {
        return Connection.shared.reachability.isReachableViaWiFi()
    }
    
    @objc func reachabilityChanged() {
        let date = Defaults[.reachabilityChanged]
        if let date = date, (Date().timeIntervalSince(date) < 3) {
            return
        }
        Defaults[.reachabilityChanged] = Date()
    }
}
