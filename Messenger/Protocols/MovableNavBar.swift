//
//  MovableNavBar+Extension.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/03.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit

protocol MovableNavBar: class {
    var isBarHidden: Bool { get set }
    
    func appearNavBar(animated: Bool)
    func hideNavBar(animated: Bool)
}

extension MovableNavBar where Self: UIViewController {
    var menuBarHeight: CGFloat { return 33.0 }
    
    var statusBarHeight: CGFloat { return UIApplication.shared.statusBarFrame.size.height }
    
    var navigationBarHeight: CGFloat { return navigationController?.navigationBar.frame.size.height ?? 0 }
    
    func appearNavBar(animated: Bool) {
        if isBarHidden,
           let nc = navigationController {
            isBarHidden = false
            nc.setNavigationBarHidden(false, animated: animated)
        }
    }
    
    func hideNavBar(animated: Bool) {
        if !isBarHidden,
           let nc = navigationController {
            isBarHidden = true
            nc.setNavigationBarHidden(true, animated: animated)
        }
    }
}
