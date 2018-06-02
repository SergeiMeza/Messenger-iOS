//
//  UIView+Extension.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/03.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    struct Static {
        static var key = "key"
    }
    
    var viewIdentifier: String? {
        get {
            return objc_getAssociatedObject( self, &Static.key ) as? String
        }
        set {
            objc_setAssociatedObject(self, &Static.key, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func parentViewController() -> UIViewController? {
        var parentResponder: UIResponder? = self
        while true {
            guard let nextResponder = parentResponder?.next else { return nil }
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            parentResponder = nextResponder
        }
    }
    
    class func animateOriginal(withDuration: TimeInterval, animations: @escaping () -> Void) {
        if withDuration == 0 {
            animations()
        } else {
            UIView.animate(withDuration: withDuration, animations: animations)
        }
    }
    
    
    func anchor(top: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, inset: UIEdgeInsets = .zero, size: CGSize = .zero) {
        self.translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            let constraint = topAnchor.constraint(equalTo: top, constant: inset.top)
            constraint.identifier = "top"
            constraint.isActive = true
        }
        
        if let right = right {
            let constraint = rightAnchor.constraint(equalTo: right, constant: -inset.right)
            constraint.identifier = "right"
            constraint.isActive = true
        }
        
        if let bottom = bottom {
            let constraint = bottomAnchor.constraint(equalTo: bottom, constant: -inset.bottom)
            constraint.identifier = "bottom"
            constraint.isActive = true
        }
        
        if let left = left {
            let constraint = leftAnchor.constraint(equalTo: left, constant: inset.left)
            constraint.identifier = "left"
            constraint.isActive = true
        }
        
        if size.width != 0 {
            let constraint = widthAnchor.constraint(equalToConstant: size.width)
            constraint.identifier = "width"
            constraint.isActive = true
        }
        
        if size.height != 0 {
            let constraint = heightAnchor.constraint(equalToConstant: size.height)
            constraint.identifier = "height"
            constraint.isActive = true
        }
    }
    
    func whAnchor(widthConstant: CGFloat? = 0, heightConstant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let widthConstant = widthConstant, widthConstant != 0 {
            let constraint = widthAnchor.constraint(equalToConstant: widthConstant)
            constraint.identifier = "width"
            constraint.isActive = true
        }
        
        if let heightConstant = heightConstant, heightConstant != 0 {
            let constraint = heightAnchor.constraint(equalToConstant: heightConstant)
            constraint.identifier = "height"
            constraint.isActive = true
        }
    }
    
    func fillSuperview() {
        guard let superview = self.superview else {
            return
        }
        anchor(top: superview.topAnchor, right: superview.rightAnchor, bottom: superview.bottomAnchor, left: superview.leftAnchor)
    }

    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.frame = bounds
        mask.path = path.cgPath
        layer.mask = mask
    }
}
