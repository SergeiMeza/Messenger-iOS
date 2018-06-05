//
//  UsersService.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/04.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import Foundation
import Firebase
import ObjectMapper
import SwiftyJSON
import Moya

struct UsersService {
    
    func getUsersFromFirebase(completion: @escaping ((Result<[RealmUser]>)->Void)) {
        if Connection.isReachable {
            let path = DeviceConst.firebaseDatabaseRootURL.appendingPathComponent("USER")
            Database.database().reference(withPath: path.absoluteString).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let value = snapshot.value as? [String: Any] else {
                    completion(Result.error(NetworkError(statusCode: 404)))
                    return
                }
                let users = Mapper<RealmUser>().mapArray(JSONArray: value.compactMap({ $0.value as? [String:Any] }))
                completion(Result.success(users))
            }, withCancel: { error in
                completion(Result.error(error))
            })
        } else {
            completion(Result.error(NetworkError.init(statusCode: 404)))
        }
    }
    
    func getUsersFromFirestore(paginate: Bool, lastDocument: DocumentSnapshot? = nil, completion: @escaping ((Result<(users: [RealmUser], lastDocument: DocumentSnapshot?)>)->Void)) {
        if Connection.isReachable {
            let path = DeviceConst.firebaseDatabaseRootURL.appendingPathComponent("USERS/active_users")
            if paginate {
                if let lastDocument = lastDocument {
                    Firestore.firestore().collection(path.absoluteString).start(afterDocument: lastDocument).limit(to: 25).getDocuments { (snapshot, error) in
                        if let error = error {
                            completion(Result.error(error))
                            return
                        }
                        let users = Mapper<RealmUser>().mapArray(JSONArray: snapshot!.documents.compactMap({
                            var values = $0.data()
                            values[DeviceConst.object_id] = $0.documentID
                            return values
                        }))
                        completion(Result.success((users, snapshot?.documents.last)))
                    }
                } else {
                    Firestore.firestore().collection(path.absoluteString).limit(to: 25).getDocuments { (snapshot, error) in
                        if let error = error {
                            completion(Result.error(error))
                            return
                        }
                        let users = Mapper<RealmUser>().mapArray(JSONArray: snapshot!.documents.compactMap({
                            var values = $0.data()
                            values[DeviceConst.object_id] = $0.documentID
                            return values
                        }))
                        completion(Result.success((users, snapshot?.documents.last)))
                    }
                }
            } else {
                Firestore.firestore().collection(path.absoluteString).getDocuments { (snapshot, error) in
                    if let error = error {
                        completion(Result.error(error))
                        return
                    }
                    let users = Mapper<RealmUser>().mapArray(JSONArray: snapshot!.documents.compactMap({
                        var values = $0.data()
                        values[DeviceConst.object_id] = $0.documentID
                        return values
                    }))
                    completion(Result.success((users, nil)))
                }
            }
            
        } else {
            completion(Result.error(NetworkError.init(statusCode: 404)))
        }
    }
}

