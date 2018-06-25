//
//  CacheManager.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/26.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import Foundation

struct CacheManager {
    
    static func cleanupExpired() {
        // if user is logged in
        CacheManager.cleanupExpired(days: 7)
    }
    
    static func cleanupExpired(days: Double) {
        var isDir: ObjCBool = ObjCBool.init(false)
        let past = Date().addingTimeInterval(-days*24*60*60)
        let extensions = ["jpg", "mp4", "m4a"]
        let enumerator = FileManager.default.enumerator(atPath: Dir.document())
        var file = enumerator?.nextObject() as? String
        
        // clear document files
        while (file != nil) {
            let path = Dir.document(component: file!)
            FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
            if !isDir.boolValue {
                let ext = (path as NSString).pathExtension
                if extensions.contains(ext) {
                    if let created = File.created(path: path) {
                        if created.compare(past) == .orderedAscending {
                            _ = File.remove(path: path)
                        }
                    }
                }
            }
            file = enumerator?.nextObject() as? String
        }
        
        // clear cache files
        if let files = try? FileManager.default.contentsOfDirectory(atPath: Dir.cache()) {
            for file in files {
                let path = Dir.cache(component: file)
                FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
                if !isDir.boolValue {
                    let ext = (path as NSString).pathExtension
                    if ext == "mp4" {
                        if let created = File.created(path: path) {
                            if created.compare(past) == .orderedAscending {
                                _ = File.remove(path: path)
                            }
                        }
                    }
                }
            }
        }
    }
    
    static func cleanupManual(isLogout: Bool) {
        var isDir: ObjCBool = ObjCBool.init(false)
        let extensions = isLogout ? ["jpg", "mp4", "m4a", "manual", "loading"] : ["jpg", "mp4", "m4a"]
        let enumerator = FileManager.default.enumerator(atPath: Dir.document())
        var file = enumerator?.nextObject() as? String
        
        // clear document files
        while (file != nil) {
            let path = Dir.document(component: file!)
            FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
            if !isDir.boolValue {
                let ext = (path as NSString).pathExtension
                if extensions.contains(ext) {
                    _ = File.remove(path: path)
                }
            }
            file = enumerator?.nextObject() as? String
        }
        
        // clear cache files
        if let files = try? FileManager.default.contentsOfDirectory(atPath: Dir.cache()) {
            for file in files {
                let path = Dir.cache(component: file)
                FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
                if !isDir.boolValue {
                    let ext = (path as NSString).pathExtension
                    if ext == "mp4" {
                        _ = File.remove(path: path)
                    }
                }
            }
        }
    }
    
    static func total() -> Double {
        var total = 0.0
        var isDir: ObjCBool = ObjCBool.init(false)
        let extensions = ["jpg", "mp4", "m4a"]
        let enumerator = FileManager.default.enumerator(atPath: Dir.document())
        var file = enumerator?.nextObject() as? String
        
        // count documents files
        while (file != nil) {
            let path = Dir.document(component: file!)
            FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
            if !isDir.boolValue {
                let ext = (path as NSString).pathExtension
                if extensions.contains(ext) {
                    total += File.size(path: path) ?? 0.0
                }
            }
            file = enumerator?.nextObject() as? String
        }
        
        // count caches files
        if let files = try? FileManager.default.contentsOfDirectory(atPath: Dir.cache()) {
            for file in files {
                let path = Dir.cache(component: file)
                FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
                if !isDir.boolValue {
                    let ext = (path as NSString).pathExtension
                    if ext == "mp4" {
                        total += File.size(path: path) ?? 0.0
                    }
                }
            }
        }
        
        return total
    }
}
