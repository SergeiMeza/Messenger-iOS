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
import GameKit
import RealmSwift

struct UsersService {
    
    func getUsers(paginate: Bool, lastValue: Any? = nil, completion: @escaping ((Result<(users: [RealmUser], lastValue: Any?)>)->Void)) {
        
        #if DEBUG
//        generateRandomUsersWithFirebaseDatabase()
        #endif
        
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
    
    func generateRandomUsersWithFirebaseDatabase() {
        let randomGenerator = GKRandomDistribution.init(lowestValue: 0, highestValue: 4)
        for index in 1...100 {
            let user = FirebaseObject.init(path: "USER")
            user[DeviceConst.object_id] = FirebaseObject.autoId()
            user["index"] = index
            user["reverse_index"] = -index
            user["name"] = ["David", "Rose", "Mary", "John", "Paul"][randomGenerator.nextInt()]
            user["age"] = [13, 10, 18, 22, 24][randomGenerator.nextInt()]
            user["gender"] = [0 , 1, 2, 3][randomGenerator.nextInt() % 4]
            user["favorite_color"] = ["red", "blue", "orange", "pink", "yellow"][min(randomGenerator.nextInt(), 3)]
            user["is_wizard"] = [true, false][randomGenerator.nextInt() % 2]
            user.saveInBackground()
        }
    }
    
    
    func getUsersFromFirebaseDatabaseAndSaveInRealm() {
        Service.users.getUsers(paginate: false) { result in
            switch result {
            case .error(let error):
                print(error)
            case .success(let users, _):
                DispatchQueue.init(label: "background", qos: DispatchQoS.background).async {
                    autoreleasepool {
                        let realm = try! Realm()
                        try! realm.write {
                            users.forEach {
                                realm.add($0, update: true)
                            }
                        }
                    }
                }
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

