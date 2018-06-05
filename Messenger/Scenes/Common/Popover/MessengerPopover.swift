//
//  MessengerPopover.swift
//  MessengerPopover
//
//  Created by Jeany Sergei Meza Rodriguez on 4/19/30 H.
//  Copyright © 30 Heisei Amigo. All rights reserved.
//

import UIKit

// MARK: - MessengerPopoverOption

enum MessengerPopoverOption {
    case arrowSize(CGSize)
    case animationIn(TimeInterval)
    case animationOut(TimeInterval)
    case cornerRadius(CGFloat)
    case sideEdge(CGFloat)
    case blackOverlayColor(UIColor)
    case overlayBlur(UIBlurEffectStyle)
    case type(MessengerPopoverType)
    case color(UIColor)
    case dismissOnBlackOverlayTap(Bool)
    case showBlackOverlay(Bool)
    case springDamping(CGFloat)
    case initialSpringVelocity(CGFloat)
    case showShadow(Bool)
    case shadowOpacity(Float)
    case shadowColor(UIColor)
    case shadowOffset(CGSize)
    case shadowRadius(CGFloat)
}

// MARK: - LipsPopoverType

@objc enum MessengerPopoverType: Int {
    case up, down, auto
}

// MARK: - LipsPopover

@IBDesignable class MessengerPopover: UIView {
    
    // MARK: - Customizable Properties
    
    @IBInspectable var arrowSize: CGSize = .init(width: 0, height: 0)
    @IBInspectable var animationIn: Double = 0.4
    @IBInspectable var animationOut: Double = 0.5
    @IBInspectable var cornerRadius: CGFloat = 8.0
    @IBInspectable var sideEdge: CGFloat = 20.0
    @IBInspectable var blackOverlayColor: UIColor = .init(white: 0.0, alpha: 0.2)
    @IBInspectable var popoverColor: UIColor = .white
    @IBInspectable var dismissOnBlackOverlayTap: Bool = true
    @IBInspectable var showBlackOverlay: Bool = true
    @IBInspectable var highlightFromView: Bool = false
    @IBInspectable var highlightCornerRadius: CGFloat = 0
    @IBInspectable var springDamping: CGFloat = 0.6
    @IBInspectable var initialSpringVelocity: CGFloat = 4
    @IBInspectable var showShadow: Bool = true
    @IBInspectable var shadowOpacity: Float = 0.20
    @IBInspectable var shadowColor: UIColor = .black
    @IBInspectable var shadowOffset: CGSize = .init(width: 4, height: 4)
    @IBInspectable var shadowRadius: CGFloat = 12
    
    var popoverType: MessengerPopoverType = .down
    var overlayBlur: UIBlurEffect?
    
    // MARK: - Customizable Closures
    
    var willShowHandler: (()->())?
    var willDismissHandler: (()->())?
    var didShowHandler: (()->())?
    var didDismissHandler: (()->())?
    
    fileprivate(set) var blackOverlay: UIControl = UIControl()
    
    fileprivate var containerView: UIView!
    fileprivate var contentView: UIView!
    fileprivate var contentViewFrame: CGRect!
    fileprivate var arrowShowPoint: CGPoint!
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.accessibilityViewIsModal = true
    }
    
    init(showHandler: (()->())?, dismissHandler: (()->())?) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.didShowHandler = showHandler
        self.didDismissHandler = dismissHandler
        self.accessibilityViewIsModal = true
    }
    
    init(options: [MessengerPopoverOption]?, showHandler: (()->())? = nil, dismissHandler: (()->())? = nil) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.setOptions(options)
        self.didShowHandler = showHandler
        self.didDismissHandler = dismissHandler
        self.accessibilityViewIsModal = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .clear
        self.accessibilityViewIsModal = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = bounds
    }
    
    
    func showAsDialog(_ contentView: UIView) {
        guard let rootView = UIApplication.shared.keyWindow else {
            return
        }
        self.showAsDialog(contentView, inView: rootView)
    }
    
    func showAsDialog(_ contentView: UIView, inView: UIView) {
        self.arrowSize = .zero
        let point = CGPoint(x: inView.center.x,
                            y: inView.center.y - contentView.frame.height / 2)
        self.show(contentView, point: point, inView: inView)
    }
    
    func show(_ contentView: UIView, fromView: UIView) {
        guard let rootView = UIApplication.shared.keyWindow else {
            return
        }
        self.show(contentView, fromView: fromView, inView: rootView)
    }
    
    func show(_ contentView: UIView, fromView: UIView, inView: UIView) {
        let point: CGPoint
        
        if self.popoverType == .auto {
            if let point = fromView.superview?.convert(fromView.frame.origin, to: nil),
                point.y + fromView.frame.height + self.arrowSize.height + contentView.frame.height > inView.frame.height {
                self.popoverType = .up
            } else {
                self.popoverType = .down
            }
        }
        
        switch self.popoverType {
        case .up:
            point = inView.convert(
                CGPoint(
                    x: fromView.frame.origin.x + (fromView.frame.size.width / 2),
                    y: fromView.frame.origin.y
            ), from: fromView.superview)
        case .down, .auto:
            point = inView.convert(
                CGPoint(
                    x: fromView.frame.origin.x + (fromView.frame.size.width / 2),
                    y: fromView.frame.origin.y + fromView.frame.size.height
            ), from: fromView.superview)
        }
        
        if self.highlightFromView {
            self.createHighlightLayer(fromView: fromView, inView: inView)
        }
        
        self.show(contentView, point: point, inView: inView)
    }
    
    func show(_ contentView: UIView, point: CGPoint) {
        guard let rootView = UIApplication.shared.keyWindow else {
            return
        }
        self.show(contentView, point: point, inView: rootView)
    }

    func show(_ contentView: UIView, point: CGPoint, inView: UIView) {
        if dismissOnBlackOverlayTap || showBlackOverlay {
            blackOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blackOverlay.frame = inView.bounds
            inView.addSubview(blackOverlay)
            
            if showBlackOverlay {
                if let overlayBlur = self.overlayBlur {
                    let effectView = UIVisualEffectView.init(effect: overlayBlur)
                    effectView.frame = blackOverlay.bounds
                    effectView.isUserInteractionEnabled = false
                    blackOverlay.addSubview(effectView)
                } else {
                    if !highlightFromView {
                        blackOverlay.backgroundColor = blackOverlayColor
                    }
                    blackOverlay.alpha = 0
                }
            }
            
            if dismissOnBlackOverlayTap {
                blackOverlay.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
            }
        }
        
        self.containerView = inView
        self.contentView = contentView
        self.contentView.backgroundColor = .clear
        self.contentView.layer.cornerRadius = self.cornerRadius
//        self.contentView.clipsToBounds = true
        
        if showShadow {
            self.layer.shadowRadius = shadowRadius
            self.layer.shadowColor = shadowColor.cgColor
            self.layer.shadowOffset = shadowOffset
            self.layer.shadowOpacity = shadowOpacity
        }
        
        self.arrowShowPoint = point
        self.show()
    }
    
    override func accessibilityPerformEscape() -> Bool {
        dismiss()
        return true
    }
    
    @objc func dismiss() {
        if self.superview != nil {
            self.willDismissHandler?()
        
            UIView.animate(withDuration: animationOut,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: initialSpringVelocity / 1.33,
                           options: UIViewAnimationOptions(), animations: {
                            self.transform = CGAffineTransform.init(scaleX: 0.0001, y: 0.0001)
                            self.blackOverlay.alpha = 0
            }) { _ in
                self.contentView.removeFromSuperview()
                self.blackOverlay.removeFromSuperview()
                self.removeFromSuperview()
                self.transform = .identity
                self.didDismissHandler?()
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let arrow = UIBezierPath()
        let color = self.popoverColor
        let arrowPoint = self.containerView.convert(self.arrowShowPoint, to: self)
        switch self.popoverType {
        case .up:
            arrow.move(to: CGPoint(x: arrowPoint.x, y: self.bounds.height))
            arrow.addLine(
                to: CGPoint(
                    x: arrowPoint.x - self.arrowSize.width * 0.5,
                    y: self.isCornerLeftArrow ? self.arrowSize.height : self.bounds.height - self.arrowSize.height
                )
            )
            
            arrow.addLine(to: CGPoint(x: self.cornerRadius, y: self.bounds.height - self.arrowSize.height))
            arrow.addArc(
                withCenter: CGPoint(
                    x: self.cornerRadius,
                    y: self.bounds.height - self.arrowSize.height - self.cornerRadius
                ),
                radius: self.cornerRadius,
                startAngle: self.radians(90),
                endAngle: self.radians(180),
                clockwise: true)
            
            arrow.addLine(to: CGPoint(x: 0, y: self.cornerRadius))
            arrow.addArc(
                withCenter: CGPoint(
                    x: self.cornerRadius,
                    y: self.cornerRadius
                ),
                radius: self.cornerRadius,
                startAngle: self.radians(180),
                endAngle: self.radians(270),
                clockwise: true)
            
            arrow.addLine(to: CGPoint(x: self.bounds.width - self.cornerRadius, y: 0))
            arrow.addArc(
                withCenter: CGPoint(
                    x: self.bounds.width - self.cornerRadius,
                    y: self.cornerRadius
                ),
                radius: self.cornerRadius,
                startAngle: self.radians(270),
                endAngle: self.radians(0),
                clockwise: true)
            
            arrow.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height - self.arrowSize.height - self.cornerRadius))
            arrow.addArc(
                withCenter: CGPoint(
                    x: self.bounds.width - self.cornerRadius,
                    y: self.bounds.height - self.arrowSize.height - self.cornerRadius
                ),
                radius: self.cornerRadius,
                startAngle: self.radians(0),
                endAngle: self.radians(90),
                clockwise: true)
            
            arrow.addLine(
                to: CGPoint(
                    x: arrowPoint.x + self.arrowSize.width * 0.5,
                    y: self.isCornerRightArrow ? self.arrowSize.height : self.bounds.height - self.arrowSize.height
                )
            )
            
        case .down, .auto:
            arrow.move(to: CGPoint(x: arrowPoint.x, y: 0))
            arrow.addLine(
                to: CGPoint(
                    x: arrowPoint.x + self.arrowSize.width * 0.5,
                    y: self.isCornerRightArrow ? self.arrowSize.height + self.bounds.height : self.arrowSize.height
                )
            )
            
            arrow.addLine(to: CGPoint(x: self.bounds.width - self.cornerRadius, y: self.arrowSize.height))
            arrow.addArc(
                withCenter: CGPoint(
                    x: self.bounds.width - self.cornerRadius,
                    y: self.arrowSize.height + self.cornerRadius
                ),
                radius: self.cornerRadius,
                startAngle: self.radians(270.0),
                endAngle: self.radians(0),
                clockwise: true)
            
            arrow.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height - self.cornerRadius))
            arrow.addArc(
                withCenter: CGPoint(
                    x: self.bounds.width - self.cornerRadius,
                    y: self.bounds.height - self.cornerRadius
                ),
                radius: self.cornerRadius,
                startAngle: self.radians(0),
                endAngle: self.radians(90),
                clockwise: true)
            
            arrow.addLine(to: CGPoint(x: 0, y: self.bounds.height))
            arrow.addArc(
                withCenter: CGPoint(
                    x: self.cornerRadius,
                    y: self.bounds.height - self.cornerRadius
                ),
                radius: self.cornerRadius,
                startAngle: self.radians(90),
                endAngle: self.radians(180),
                clockwise: true)
            
            arrow.addLine(to: CGPoint(x: 0, y: self.arrowSize.height + self.cornerRadius))
            arrow.addArc(
                withCenter: CGPoint(
                    x: self.cornerRadius,
                    y: self.arrowSize.height + self.cornerRadius
                ),
                radius: self.cornerRadius,
                startAngle: self.radians(180),
                endAngle: self.radians(270),
                clockwise: true)
            
            arrow.addLine(to: CGPoint(
                x: arrowPoint.x - self.arrowSize.width * 0.5,
                y: self.isCornerLeftArrow ? self.arrowSize.height + self.bounds.height : self.arrowSize.height))
        }
        
        color.setFill()
        arrow.fill()
    }
    
    func setOptions(_ options: [MessengerPopoverOption]?) {
        if let options = options {
            for option in options {
                switch option {
                case let .arrowSize(value):
                    self.arrowSize = value
                case let .animationIn(value):
                    self.animationIn = value
                case let .animationOut(value):
                    self.animationOut = value
                case let .cornerRadius(value):
                    self.cornerRadius = value
                case let .sideEdge(value):
                    self.sideEdge = value
                case let .blackOverlayColor(value):
                    self.blackOverlayColor = value
                case let .overlayBlur(style):
                    self.overlayBlur = UIBlurEffect(style: style)
                case let .type(value):
                    self.popoverType = value
                case let .color(value):
                    self.popoverColor = value
                case let .dismissOnBlackOverlayTap(value):
                    self.dismissOnBlackOverlayTap = value
                case let .showBlackOverlay(value):
                    self.showBlackOverlay = value
                case let .springDamping(value):
                    self.springDamping = value
                case let .initialSpringVelocity(value):
                    self.initialSpringVelocity = value
                case let .showShadow(value):
                    self.showShadow = value
                case let .shadowOpacity(value):
                    self.shadowOpacity = value
                case let .shadowColor(value):
                    self.shadowColor = value
                case let .shadowOffset(value):
                    self.shadowOffset = value
                case let .shadowRadius(value):
                    self.shadowRadius = value
                }
            }
        }
    }
}

private extension MessengerPopover {
    
    func create() {
        var frame = self.contentView.frame
        frame.origin.x = self.arrowShowPoint.x - frame.size.width * 0.5
        
        var sideEdge: CGFloat = 0.0
        if frame.size.width < self.containerView.frame.size.width {
            sideEdge = self.sideEdge
        }
        
        let outerSideEdge = frame.maxX - self.containerView.bounds.size.width
        if outerSideEdge > 0 {
            frame.origin.x -= (outerSideEdge + sideEdge)
        } else {
            if frame.minX < 0 {
                frame.origin.x += abs(frame.minX) + sideEdge
            }
        }
        self.frame = frame
        
        let arrowPoint = self.containerView.convert(self.arrowShowPoint, to: self)
        var anchorPoint: CGPoint
        switch self.popoverType {
        case .up:
            frame.origin.y = self.arrowShowPoint.y - frame.height - self.arrowSize.height
            anchorPoint = CGPoint(x: arrowPoint.x / frame.size.width, y: 1)
        case .down, .auto:
            frame.origin.y = self.arrowShowPoint.y
            anchorPoint = CGPoint(x: arrowPoint.x / frame.size.width, y: 0)
        }
        
        if self.arrowSize == .zero {
            anchorPoint = CGPoint(x: 0.5, y: 0.5)
        }
        
        let lastAnchor = self.layer.anchorPoint
        self.layer.anchorPoint = anchorPoint
        let x = self.layer.position.x + (anchorPoint.x - lastAnchor.x) * self.layer.bounds.size.width
        let y = self.layer.position.y + (anchorPoint.y - lastAnchor.y) * self.layer.bounds.size.height
        self.layer.position = CGPoint(x: x, y: y)
        
        frame.size.height += self.arrowSize.height
        self.frame = frame
    }
    
    func createHighlightLayer(fromView: UIView, inView: UIView) {
        let path = UIBezierPath(rect: inView.bounds)
        let highlightRect = inView.convert(fromView.frame, from: fromView.superview)
        let highlightPath = UIBezierPath(roundedRect: highlightRect, cornerRadius: self.highlightCornerRadius)
        path.append(highlightPath)
        path.usesEvenOddFillRule = true
        
        let fillLayer = CAShapeLayer()
        fillLayer.path = path.cgPath
        fillLayer.fillRule = kCAFillRuleEvenOdd
        fillLayer.fillColor = self.blackOverlayColor.cgColor
        self.blackOverlay.layer.addSublayer(fillLayer)
    }
    
    func show() {
        self.setNeedsDisplay()
        switch self.popoverType {
        case .up:
            self.contentView.frame.origin.y = 0.0
        case .down, .auto:
            self.contentView.frame.origin.y = self.arrowSize.height
        }
        self.addSubview(self.contentView)
        self.containerView.addSubview(self)
        
        self.create()
        self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        self.willShowHandler?()
        UIView.animate(
            withDuration: self.animationIn,
            delay: 0,
            usingSpringWithDamping: self.springDamping,
            initialSpringVelocity: self.initialSpringVelocity,
            options: UIViewAnimationOptions(),
            animations: {
                self.transform = CGAffineTransform.identity
        }){ _ in
            self.didShowHandler?()
        }
        UIView.animate(
            withDuration: self.animationIn / 3,
            delay: 0,
            options: .curveLinear,
            animations: {
                self.blackOverlay.alpha = 1
        }, completion: nil)
    }
    
    var isCornerLeftArrow: Bool {
        return self.arrowShowPoint.x == self.frame.origin.x
    }
    
    var isCornerRightArrow: Bool {
        return self.arrowShowPoint.x == self.frame.origin.x + self.bounds.width
    }
    
    func radians(_ degrees: CGFloat) -> CGFloat {
        return CGFloat.pi * degrees / 180
    }
}

