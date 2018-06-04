//
//  Result.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/04.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(Error)
}
