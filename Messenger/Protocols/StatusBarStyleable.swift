//
//  StatusBarStyleable+Extension.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/03.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit

protocol StatusBarStyleable {
    func setStatusBarColor()
}

extension StatusBarStyleable where Self: UIViewController {

    func setStatusBarColor() {
        let statusBarBgView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: UIApplication.shared.statusBarFrame.size.height))
        statusBarBgView.backgroundColor = UIColor.light100
        view.addSubview(statusBarBgView)
        view.bringSubview(toFront: statusBarBgView)
    }
}
