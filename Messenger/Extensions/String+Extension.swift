//
//  String+Extension.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/03.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import Foundation

extension String {
    var url: URL? {
        return URL(string: self)
    }
}
