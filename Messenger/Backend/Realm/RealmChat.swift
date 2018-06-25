//
//  RealmChat.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/26.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import IGListKit

@objcMembers class RealmChat: Object, Mappable, ListDiffable {
    
    dynamic var objectId = ""
    dynamic var name = ""
    
    dynamic var timestamp = 0
    dynamic var reverseTimestamp = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        self.objectId <- map["object_id"]
        self.name <- map["name"]
        self.timestamp <- map["timestamp"]
        self.reverseTimestamp <- map["reverse_timestamp"]
    }
    
    override static func primaryKey() -> String? {
        return "objectId"
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return objectId as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? RealmChat else { return false}
        if self === object {
            return true
        } else if objectId == object.objectId {
            return true
        }
        return false
    }
}
