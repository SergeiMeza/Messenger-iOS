//
//  OriginalTabPageViewControllerDelegate.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/05.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit

protocol OriginalTabPageViewControllerDelegate {
    func originalTabPage(moved index: Int)
    func originalTabPage(moving rate: CGFloat, to isForward: Bool)
}
