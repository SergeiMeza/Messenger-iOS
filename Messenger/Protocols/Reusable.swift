//
//  Reusable+Extension.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/03.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit

protocol Reusable: class {

    static var defaultReuseIdentifier: String { get }
}

extension Reusable where Self: UIView {

    static var defaultReuseIdentifier: String {
        return (UIHelper.isIPad) ? String(describing: self).appending("-pad") : String(describing: self)
    }
}
