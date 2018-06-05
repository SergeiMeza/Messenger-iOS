//
//  DeviceConst.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/03.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit

struct DeviceConst {
    static let firebaseDatabaseRootURL = "v0".url!
    static let firebaseFirestoreRootCollection = "v0"
    
    static let defaultFont = "CourierNew"
    
    static let object_id = "object_id"
    static let created_at = "created_at"
    static let updated_at = "updated_at"
    
    static let maxVideoDuration: Double = 60.0
    
    static let kilo = 1000
    static let mega = kilo * kilo
    static let giga = mega * kilo
    
    static let tabBarOffset: CGFloat = 8
}
