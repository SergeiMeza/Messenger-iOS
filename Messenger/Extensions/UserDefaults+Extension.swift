//
//  UserDefaults+Extension.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/04.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import Foundation

public let defaults = UserDefaults(suiteName: "group.PremiumApps.Messenger")

public extension UserDefaults {
    
    public class func set(_ value: Any?, forKey key: String) {
        defaults?.set(value, forKey: key)
        defaults?.synchronize()
    }
    
    public class func removeObject(forKey key: String, afterMilliseconds delay: Int = 0) {
        if delay == 0 {
            defaults?.removeObject(forKey: key)
            defaults?.synchronize()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.milliseconds(delay), execute: {
                defaults?.removeObject(forKey: key)
                defaults?.synchronize()
            })
        }
    }
    
    public class func object(forKey key: String) -> Any? {
        return defaults?.object(forKey: key)
    }
    
    public class func string(forKey key: String) -> String? {
        return defaults?.string(forKey: key)
    }
    
    public class func integer(forKey key: String) -> Int {
        return defaults?.integer(forKey: key) ?? 0
    }
    
    public class func bool(forKey key: String) -> Bool {
        return defaults?.bool(forKey: key) ?? false
    }
    
    public class func synchronize() {
        defaults?.synchronize()
    }
}
