//
//  NavigationController.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/26.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.backgroundColor = .white
        navigationBar.isTranslucent = false
    }
}
