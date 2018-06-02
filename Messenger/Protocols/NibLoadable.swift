//
//  NibLoadable+Extension.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/03.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit

protocol NibLoadable: class {

    static var nibName: String { get }
}

extension NibLoadable where Self: UIView {

    static var nibName: String {

        return String(describing: self)
    }
}
