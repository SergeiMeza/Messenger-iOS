//
//  MessengerAPI.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/04.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import Foundation
import Moya
import RxMoya
import RxSwift
import SwiftyJSON
import Alamofire

enum MessengerAPI {
    case getAllUsers
}

extension MessengerAPI: TargetType {
    var apiVersion: String {
        return "v0"
    }
    
    var baseURL: URL {
        return URL(string: "https://messenger-1994.firebaseio.com/")!
    }
    
    var path: String {
        switch self {
        case .getAllUsers:
            return "/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAllUsers:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .requestData(Data())
    }
    
    var parameterEncoding: Moya.ParameterEncoding {
        switch self.method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    var validate: Bool {
        return false
    }
    
    var headers: [String : String]? {
        return nil
    }
}
