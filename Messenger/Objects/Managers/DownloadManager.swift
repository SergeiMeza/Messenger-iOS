//
//  DownloadManager.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/26.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import Foundation


typealias DownloadHandler = ((String?, Error?, Bool) -> Void)

struct DownloadManager {
    
    /// seconds
    static var downloadTimeout: Int = 300
    
    //   MARK: - Public Methods
    
    static func image(_ link: String?, md5: String? = nil, completion: DownloadHandler? = nil) {
        guard let link = link, !link.isEmpty else {
            completion?(nil, NetworkError(statusCode: 103), false)
            return
        }
        
        if let md5 = md5 {
            DownloadManager.start(link, ext: "jpg", md5: md5, manual: true, completion: completion)
        } else {
            DownloadManager.start(link, ext: "jpg", completion: completion)
        }
    }
    
    public static func video(_ link: String, md5: String? = nil, completion: DownloadHandler? = nil) {
        DownloadManager.start(link, ext: "mp4", md5: md5, manual: true, completion: completion)
    }
    
    public static func audio(_ link: String, md5: String? = nil, completion: DownloadHandler? = nil) {
        DownloadManager.start(link, ext: "ma4", md5: md5, manual: true, completion: completion)
    }
    
    public static func start(_ link: String, ext: String, md5: String? = nil, manual checkManual: Bool = false, completion: DownloadHandler? = nil) {
        
        // Check if link is missing
        if link.isEmpty {
            completion?(nil, NetworkError(statusCode: 100), false)
            return
        }
        
        guard let _ = URL(string: link) else {
            completion?(nil, NetworkError(statusCode: 105), false)
            return
        }
        
        let file = DownloadManager.file(link, ext: ext)
        
        let path = Dir.document(component: file)
        
        let manual = Dir.document(component: file.appending(".manual"))
        let loading = Dir.document(component: file.appending(".loading"))
        
        // Check if file is already downloaded
        if File.exist(path: path) {
            completion?(path, nil, false)
            return
        }
        
        // Check if manual download is required
        if checkManual {
            if File.exist(path: manual) {
                completion?(nil, NetworkError(statusCode: 101), false)
                return
            }
            try? ("manual" as NSString).write(toFile: manual, atomically: false, encoding: String.Encoding.utf8.rawValue)
        }
        
        // Check if file is currently downloading
        let time = Date().timeIntervalSince1970
        
        if File.exist(path: loading) {
            let check = try! NSString(contentsOfFile: loading, encoding: String.Encoding.utf8.rawValue).intValue
            if Int(time) - Int(check) < Int(DownloadManager.downloadTimeout) {
                completion?(nil, NetworkError(statusCode: 102), false)
                return
            }
        }
        try? ("\(time)" as NSString).write(toFile: loading, atomically: false, encoding: String.Encoding.utf8.rawValue)
        
        
        // Download the file
        let downloadTask = URLSession.shared.downloadTask(with: URL(string: link as String)!) { (location, response, error) in
            
            if error == nil {
                try! FileManager.default.moveItem(at: location!, to: URL(fileURLWithPath: path))
                
                if File.size(path: path) != 0 {
                    if let md5 = md5 {
                        if md5 == Checksum.md5HashOfPath(path) {
                            DownloadManager.succeed(file, completion: completion)
                        } else {
                            DownloadManager.failed(file, error: NetworkError(statusCode: 103), completion: completion)
                        }
                    } else {
                        DownloadManager.succeed(file, completion: completion)
                    }
                } else {
                    DownloadManager.failed(file, error: NetworkError(statusCode: 104), completion: completion)
                }
            } else {
                DownloadManager.failed(file, error: error, completion: completion)
            }
        }
        
        downloadTask.resume()
    }
    
    public static func fileImage(_ link: String) -> String {
        return DownloadManager.file(link, ext: "jpg")
    }
    
    public static func fileVideo(_ link: String) -> String {
        return DownloadManager.file(link, ext: "mp4")
    }
    
    public static func fileAudio(_ link: String) -> String {
        return DownloadManager.file(link, ext: "m4a")
    }
    
    public static func file(_ link: String, ext: String) -> String {
        let file = Checksum.md5HashOfString(link)
        return ((file! as NSString).appendingPathExtension(ext)! as String)
    }
    
    public static func pathImage(_ link: String) -> String? {
        return DownloadManager.path(link, ext: "jpg")
    }
    
    public static func pathVideo(_ link: String) -> String? {
        return DownloadManager.path(link, ext: "mp4")
    }
    
    public static func pathAudio(_ link: String) -> String? {
        return DownloadManager.path(link, ext: "m4a")
    }
    
    public static func path(_ link: String, ext: String) -> String? {
        if !link.isEmpty {
            let file = DownloadManager.file(link as String, ext: ext)
            let path = Dir.document(component: file)
            if File.exist(path: path) {
                return path
            }
        }
        return nil
    }
    
    public static func clearManualImage(_ link: String) {
        DownloadManager.clearManual(link, ext: "jpg")
    }
    
    public static func clearManualVideo(_ link: String) {
        DownloadManager.clearManual(link, ext: "mp4")
    }
    
    public static func clearManualAudio(_ link: String) {
        DownloadManager.clearManual(link, ext: "m4a")
    }
    
    public static func clearManual(_ link: String, ext: String) {
        let file = DownloadManager.file(link, ext: ext)
        let manual = Dir.document(component: file.appending(".manual"))
        _ = File.remove(path: manual)
    }
    
    //   MARK: - Private Methods
    
    private static func succeed(_ file: String, completion: DownloadHandler? = nil) {
        let path = Dir.document(component: file)
        let loading = Dir.document(component: file.appending(".loading"))
        _ = File.remove(path: loading)
        DispatchQueue.main.async {
            completion?(path, nil, true)
        }
    }
    
    private static func failed(_ file: String, error: Error?, completion: DownloadHandler? = nil) {
        let path = Dir.document(component: file)
        let loading = Dir.document(component: file.appending(".loading"))
        _ = File.remove(path: path)
        _ = File.remove(path: loading)
        DispatchQueue.main.async {
            completion?(nil, error, true)
        }
    }
}
