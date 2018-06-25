//
//  RealmUser.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/04.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import IGListKit

@objcMembers class RealmUser: Object, Mappable, ListDiffable {
    
    dynamic var objectId = ""
    dynamic var name = ""
    
    dynamic var age = 0
    dynamic var gender = 0
    
    dynamic var favoriteColor = ""
    dynamic var isWizard = false
    
    dynamic var index = 0
    dynamic var reverseIndex = 0
    
    enum GenderType: Int {
        case undefined = 0
        case male = 1
        case female = 2
        case other = 3
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        self.objectId <- map["object_id"]
        self.name <- map["name"]
        self.age <- map["age"]
        self.gender <- map["gender"]
        self.favoriteColor <- map["favorite_color"]
        self.isWizard <- map["is_wizard"]
        self.index <- map["index"]
        self.reverseIndex <- map["reverse_index"]
    }
    
    override static func primaryKey() -> String? {
        return "objectId"
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return objectId as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? RealmUser else { return false}
        if self === object {
            return true
        } else if objectId == object.objectId {
            return true
        }
        return false
    }
}
