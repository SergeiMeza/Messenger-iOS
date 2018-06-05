//
//  NotificationCenter+Extension.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/04.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import Foundation

public extension NotificationCenter {
    
    public static func addObserver(_ observer: NSObject, selector: Selector, name: Notification.Name) -> () {
        NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: nil)
    }
    
    public static func removeObserver(_ observer: NSObject) {
        NotificationCenter.default.removeObserver(observer)
    }
    
    public static func post(_ notification: Notification.Name) {
        NotificationCenter.default.post(name: notification, object: nil)
    }
}
