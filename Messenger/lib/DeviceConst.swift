//
//  DeviceConst.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/03.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import Foundation

struct DeviceConst {
    static let defaultFont = "CourierNew"
    
    static let firebaseDatabaseRootURL = "v0".url!
    
    static let object_id = "object_id"
    static let created_at = "created_at"
    static let updated_at = "updated_at"
    
    static let maxVideoDuration: Double = 60.0
    
    static let kilo = 1000
    static let mega = kilo * kilo
    static let giga = mega * kilo
}
