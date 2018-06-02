//
//  NSObject+Extension.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/03.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import Foundation

extension NSObject {
    
    func propertyNames() -> [String]? {
        var results = [String]()
        var count: UInt32 = 0
        let myClass: AnyClass = self.classForCoder
        guard let properties = class_copyPropertyList(myClass, &count) else {
            return nil
        }
        
        for index in 0...count-1 {
            let property = properties[Int(index)]
            let cname = property_getName(property)
            let name = String.init(cString: cname)
            results.append(name)
        }
        
        free(properties)
        return results.sorted()
    }
}
