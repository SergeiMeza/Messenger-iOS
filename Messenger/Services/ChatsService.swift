//
//  ChatsService.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/26.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import Foundation
import Firebase
import ObjectMapper
import SwiftyJSON
import Moya
import GameKit

struct ChatsService {
    
    func getChats(paginate: Bool, lastValue: Any? = nil, completion: @escaping ((Result<(chats: [RealmChat], lastValue: Any?)>)->Void)) {
        
        #if DEBUG
//        generateRandomChatsWithFirebaseDatabase()
        #endif
        
        let path = DeviceConst.firebaseDatabaseRootURL.appendingPathComponent("CHATS/me_id")
        Service.queryDatabase(path: path, paginate: paginate, child: "reverse_timestamp", lastValue: lastValue) { result in
            switch result {
            case .success(let snapshot):
                guard let value = snapshot?.value as? [String: Any] else {
                    snapshot == nil ? completion(Result.success(([], nil))) : completion(Result.error(NetworkError(statusCode: 404)))
                    return
                }
                var chats = Mapper<RealmChat>().mapArray(JSONArray: value.compactMap({ $0.value as? [String:Any] }))
                chats.sort { $0.reverseTimestamp < $1.reverseTimestamp }
                completion(Result.success((chats, chats.last?.reverseTimestamp)))
            case .error(let error):
                completion(Result.error(error))
            }
        }
    }
    
    func generateRandomChatsWithFirebaseDatabase() {
        let randomGenerator = GKRandomDistribution.init(lowestValue: 0, highestValue: 4)
        for index in 1...50 {
            let chat = FirebaseObject.init(path: "CHATS/me_id")
            chat[DeviceConst.object_id] = FirebaseObject.autoId()
            let timestamp = Date().timeIntervalSinceReferenceDate
            chat["timestamp"] = timestamp + Double(index)
            chat["reverse_timestamp"] = -(timestamp + Double(index))
            chat["name"] = ["David", "Rose", "Mary", "John", "Paul"][randomGenerator.nextInt()]
            chat.saveInBackground()
        }
    }
}
