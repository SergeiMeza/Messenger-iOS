//
//  Dir.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/26.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import Foundation

struct Dir {
    
    static func application() -> String {
        return Bundle.main.resourcePath ?? ""
    }
    
    static func applicaition(component: String) -> String {
        return component.isEmpty ? Dir.application() : Dir.application().appending("/" + component)
    }
    
    static func document() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
    }
    
    static func document(component: String) -> String {
        return component.isEmpty ? Dir.document() : Dir.document().appending("/" + component)
    }
    
    static func cache() -> String {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? ""
    }
    
    static func cache(component: String) -> String {
        return component.isEmpty ? Dir.cache() : Dir.cache().appending("/" + component)
    }
    
    static func createIntermediate(path: String) {
        let directory = (path as NSString).deletingLastPathComponent
        if !Dir.exist(path: directory) {
            Dir.create(directory: directory)
        }
    }
    
    static func create(directory: String) {
        try? FileManager.default.createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: nil)
    }
    
    static func exist(path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
}
