//
//  UIFont+Extension.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/03.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit

extension UIFont {
    static func mediumDefaultFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "\(DeviceConst.defaultFont)-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
    }

    static func boldDefaultFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "\(DeviceConst.defaultFont)-Bold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }

    static func regularDefaultFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "\(DeviceConst.defaultFont)-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
