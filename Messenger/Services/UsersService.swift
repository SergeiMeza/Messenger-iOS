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
    
    func getUsers(paginate: Bool, lastValue: Any? = nil, completion: @escaping ((Result<(users: [RealmUser], lastValue: Any?)>)->Void)) {
        let path = DeviceConst.firebaseDatabaseRootURL.appendingPathComponent("USER")
        Service.queryDatabase(path: path, paginate: paginate, child: "index", lastValue: lastValue) { result in
            switch result {
            case .success(let snapshot):
                guard let value = snapshot?.value as? [String: Any] else {
                    snapshot == nil ? completion(Result.success(([], nil))) : completion(Result.error(NetworkError(statusCode: 404)))
                    return
                }
                var users = Mapper<RealmUser>().mapArray(JSONArray: value.compactMap({ $0.value as? [String:Any] }))
                users.sort { $0.index < $1.index }
                completion(Result.success((users, users.last?.index)))
            case .error(let error):
                completion(Result.error(error))
            }
        }
    }
    
    /**
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
    */
}

