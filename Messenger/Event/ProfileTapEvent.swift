//
//  ProfileTapEvent.swift
//  LIPS
//
//  Created by eaponuxoo on 2018/03/01.
//  Copyright © 2018年 AppBrew. All rights reserved.
//

import Foundation
import RxSwift

struct ProfileTapEvent: BusEvent {
    let user: RealmUser
}
