//
//  RefreshableModel.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/04.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import RxSwift
import RxCocoa

protocol RefreshableModel: class {
    func refresh()
    var refreshingState: Driver<Bool> { get }
}
