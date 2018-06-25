//
//  File.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/26.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import Foundation

struct File {
    
    static func temp(ext: String) -> String {
        let timestamp = Date().timestamp
        let file = NSString.init(format: "%lld.%@", timestamp, ext) as String
        return Dir.cache(component:file)
    }
    
    static func exist(path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    static func remove(path: String) -> Bool {
        do {
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch {
            return false
        }
    }
    
    static func copy(source: String, destination: String, overwrite: Bool) {
        if overwrite {
            _ = File.remove(path: destination)
        }
        if !File.exist(path: destination) {
            try? FileManager.default.copyItem(atPath: source, toPath: destination)
        }
    }
    
    static func created(path: String) -> Date? {
        let attributes = try?  FileManager.default.attributesOfItem(atPath: path)
        return attributes?[.creationDate] as? Date
    }
    
    static func modified(path: String) -> Date? {
        let attributes = try?  FileManager.default.attributesOfItem(atPath: path)
        return attributes?[.modificationDate] as? Date
    }
    
    static func size(path: String) -> Double? {
        let attributes = try?  FileManager.default.attributesOfItem(atPath: path)
        return attributes?[.size] as? Double
    }
    
    static func diskFree() -> Double? {
        if let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let attributes = try?  FileManager.default.attributesOfItem(atPath: path)
            return attributes?[.systemFreeSize] as? Double
        }
        return nil
    }
    
    
    
}
