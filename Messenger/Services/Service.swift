//
//  Service.swift
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

struct Service {
    static let users = UsersService()
    static let chats = ChatsService()
    
    static func queryDatabase<Value>(path: URL, paginate: Bool, child: String, lastValue: Value? = nil, completion: @escaping ((Result<DataSnapshot?>)->Void)) {
        if Connection.isReachable {
            if paginate {
                if let lastValue = lastValue {
                    Database.database().reference().child(path.absoluteString).queryOrdered(byChild: child).queryStarting(atValue: lastValue).queryLimited(toFirst: 26).observeSingleEvent(of: .value, with: { (snapshot) in
                        if snapshot.exists() {
                            completion(Result.success(snapshot))
                        } else {
                            completion(Result.success(nil))
                        }
                    }) { (error) in
                        completion(Result.error(error))
                    }
                } else {
                    Database.database().reference().child(path.absoluteString).queryOrdered(byChild: child).queryLimited(toFirst: 25).observeSingleEvent(of: .value, with: { (snapshot) in
                        if snapshot.exists() {
                            completion(Result.success(snapshot))
                        } else {
                            completion(Result.success(nil))
                        }
                    }) { error in
                        completion(Result.error(error))
                    }
                }
            } else {
                Database.database().reference(withPath: path.absoluteString).observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.exists() {
                        completion(Result.success(snapshot))
                    } else {
                        completion(Result.success(nil))
                    }
                }, withCancel: { error in
                    completion(Result.error(error))
                })
            }
        } else {
            completion(Result.error(NetworkError.init(statusCode: 404)))
        }
    }
}
