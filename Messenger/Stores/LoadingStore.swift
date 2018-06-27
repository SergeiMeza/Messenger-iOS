//
//  LoadingStore.swift
//  LIPS
//
//  Created by Yuta Fukazawa on 2017/09/15.
//  Copyright © 2017年 AppBrew. All rights reserved.
//

class LoadingStore {
    static let shared = LoadingStore()
    private init() {}
    
    var actionType: String?
    var actionId: Int?
    
    func reset() {
        actionType = nil
        actionId = nil
    }
}
