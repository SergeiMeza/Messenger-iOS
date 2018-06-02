//
//  FirebaseObject.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/03.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import Firebase
import SwiftyJSON

class FirebaseObject {
    
    // MARK: - Properties
    let path: String
    let subpath: String?
    var dictionary: [String: Any]!
    
    var json: JSON {
        return (dictionary != nil) ? JSON(dictionary) : JSON.null
    }
    
    // MARK: - Inializers
    
    init(path: String) {
        guard !path.isEmpty else { fatalError("FirebaseObject: Path for object is empty") }
        self.path = DeviceConst.firebaseDatabaseRootURL.appendingPathComponent(path).absoluteString
        self.subpath = nil
        self.dictionary = [:]
    }
    
    init(path: String, dictionary: [String: Any]) {
        guard !path.isEmpty else { fatalError("FirebaseObject: Path for object is empty") }
        self.path = DeviceConst.firebaseDatabaseRootURL.appendingPathComponent(path).absoluteString
        self.subpath = nil
        self.dictionary = dictionary
    }
    
    init(path: String, subpath: String?) {
        guard !path.isEmpty else { fatalError("FirebaseObject: Path for object is empty") }
        self.path = DeviceConst.firebaseDatabaseRootURL.appendingPathComponent(path).absoluteString
        self.subpath = subpath
        self.dictionary = [:]
    }
    
    init(path: String, subpath:String?, dictionary: [String: Any]) {
        self.path = DeviceConst.firebaseDatabaseRootURL.appendingPathComponent(path).absoluteString
        self.subpath = subpath
        self.dictionary = dictionary
    }
    
    // MARK: - Subscripts
    
    subscript(key: String) -> Any? {
        get {
            guard !key.isEmpty else { fatalError("FirebaseObject: key(String) is empty") }
            return dictionary[key]
        } set(newValue) {
            dictionary[key] = newValue
        }
    }
    
    var objectId: String? {
        get {
            return self[DeviceConst.object_id] as? String
        }
    }
    
    func initObjectId() -> String {
        guard dictionary[DeviceConst.object_id] == nil else {
            return dictionary[DeviceConst.object_id] as! String
        }
        let objectReference = databaseReference()
        self[DeviceConst.object_id] = objectReference.key
        return dictionary[DeviceConst.object_id] as! String
    }
    
    //   MARK: Save Methods
    
    /// Will replace object before
    open func saveInBackground(completion block: ((Error?) -> ())? = nil) {
        let reference = databaseReference()
        if dictionary[DeviceConst.object_id] == nil {
            dictionary[DeviceConst.object_id] = reference.key
        }
        if dictionary[DeviceConst.created_at] == nil {
            dictionary[DeviceConst.created_at] = Date().timestamp_iso8601
        }
        dictionary[DeviceConst.updated_at] = Date().timestamp_iso8601
        reference.updateChildValues(dictionary) { (error, reference) in
            block?(error)
        }
    }
    
    //   MARK: Update Methods
    /// Override for FUser class
    open func updateInBackground(completion block: ((Error?) -> ())? = nil) {
        let reference = databaseReference()
        if dictionary[DeviceConst.object_id] != nil {
            dictionary[DeviceConst.updated_at] = Date().timestamp_iso8601
            reference.updateChildValues(dictionary) { (error, reference) in
                block?(error)
            }
        } else {
            let userInfo = [ NSLocalizedDescriptionKey :  "Object cannot be updated."]
            let err = NSError(domain: "Local", code: 101, userInfo: userInfo)
            block?(err)
        }
    }
    
    //   MARK: Delete Methods
    open func deleteInBackground(completion block: ((Error?) -> ())? = nil) {
        let reference = databaseReference()
        if dictionary[DeviceConst.object_id] != nil {
            reference.removeValue { (error, reference) in
                block?(error)
            }
        } else {
            let userInfo = [NSLocalizedDescriptionKey :  "Object cannot be deleted."]
            let err = NSError(domain: "Local", code: 102, userInfo: userInfo)
            block?(err)
        }
    }
    
    //   MARK: Fetch Methods
    open func fetchInBackground(completion block: ((Error?) -> ())? = nil) {
        let reference = databaseReference()
        reference.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                guard let dictionary = snapshot.value as? [String: Any] else {
                    let userInfo = [NSLocalizedDescriptionKey :  "Object not found."]
                    let err = NSError(domain: "Local", code: 103, userInfo: userInfo)
                    block?(err)
                    return
                }
                self.dictionary = dictionary
                block?(nil)
            } else {
                let userInfo: [String : Any] = [NSLocalizedDescriptionKey :  "Object not found."]
                let err = NSError(domain: "Local", code: 103, userInfo: userInfo)
                block?(err)
            }
        }
    }
    
    //   MARK: Private Methods
    internal func databaseReference() -> DatabaseReference {
        let reference: DatabaseReference
        if let subpath = subpath, !subpath.isEmpty {
            reference = Database.database().reference(withPath: path).child(subpath)
        } else {
            reference = Database.database().reference(withPath: path)
        }
        
        if dictionary[DeviceConst.object_id] == nil || (dictionary[DeviceConst.object_id] as? String) == "" {
            return reference.childByAutoId()
        } else {
            return reference.child(dictionary[DeviceConst.object_id] as! String)
        }
    }
}
