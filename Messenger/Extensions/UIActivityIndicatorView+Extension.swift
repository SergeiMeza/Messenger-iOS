//
//  UIActivityIndicatorView+Extension.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/03.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView {

    convenience init(parent: UIView?, y: CGFloat) {
        let size: CGFloat = 50
        guard let parent = parent else {
            self.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
            return
        }
        let x = (parent.frame.width - size) / 2
        self.init(frame: CGRect(x: x, y: y, width: size, height: size))

        self.grayIndicator()
    }

    convenience init(parent: UIView?) {
        let size: CGFloat = 50
        guard let parent = parent else {
            self.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
            return
        }
        let x = (parent.frame.width - size) / 2
        let y = (parent.frame.height - size) / 2
        self.init(frame: CGRect(x: x, y: y, width: size, height: size))

        self.grayIndicator()
    }

    func grayIndicator() {
        color = UIColor.black
        hidesWhenStopped = true
    }
}
