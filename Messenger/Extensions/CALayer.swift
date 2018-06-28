//
//  CALayer.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/05.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit

extension CALayer {
    func applyCardShadow() {
        applyShadow(x: 0, y: 0.5, blur: 4, spread: 0, opacity: 0.5)
    }
    
    func applyNavBarShadow() {
        applyShadow(x: 0, y: 1, blur: 4, spread: 0)
    }
    
    func applyBottomBarShadow() {
        applyShadow(x: 0, y: -1, blur: 4, spread: 0)
    }
    
    func hiddenShadow() {
        masksToBounds = true
    }
    
    private func applyShadow(x: CGFloat, y: CGFloat, blur: CGFloat, spread: CGFloat, color: UIColor = UIColor.dark50, opacity: Float = 0.5) {
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = opacity
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
