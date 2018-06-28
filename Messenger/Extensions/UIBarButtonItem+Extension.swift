//
//  UIBarButtonItem+Extension.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/28.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    convenience init(title: String, style: UIBarButtonItemStyle = .plain) {
        self.init(title: title, style: style, target: nil, action: nil)
    }
}
