//
//  Checksum.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/26.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import Foundation

public let rootLocalURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.PremiumApps.Messenger")

public struct Checksum {
    
    public static func md5HashOfData(_ data: Data?) -> String? {
        guard let data = data else { return nil }
        return data.md5.hex
    }
    
    public static func md5HashOfPath(_ path: String) -> String? {
        guard FileManager.default.fileExists(atPath: path), let url = URL(string: path), let data = try? Data.init(contentsOf: url) else { return nil }
        return data.md5.hex
    }
    
    public static func md5HashOfString(_ string: String?) -> String? {
        guard let string = string, string.isEmpty == false, let data = string.data(using: .utf8) else { return nil }
        return data.md5.hex
    }
    
    public static func shaHashOfData(_ data: Data?) -> String? {
        guard let data = data else { return nil }
        return data.sha1.hex
    }
    
    public static func shaHashOfPath(_ path: String) -> String? {
        guard FileManager.default.fileExists(atPath: path), let url = URL(string: path), let data = try? Data.init(contentsOf: url) else { return nil }
        return data.sha1.hex
    }
    
    public static func shaHashOfString(_ string: String?) -> String? {
        guard let string = string, string.isEmpty == false, let data = string.data(using: .utf8) else { return nil }
        return data.sha1.hex
    }
}
