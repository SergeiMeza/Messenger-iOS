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
    
    func getUsers(completion: @escaping ((Result<[RealmUser]>)->Void)) {
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
    }
}

