//
//  TabBarControllerHome.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/06.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

extension DefaultsKeys {
    static let tabPopoverInfo = DefaultsKey<[Int]>("TabPopoverInfo")
}


class TabBarControllerHome: UITabBarController {
    
    var tabTitles: [String] = []
    
    private var displayingPopovers = [MessengerPopover]()
    
    private var currentIndex = 0
    
    private lazy var defaultTabBarHeight = {
        tabBar.frame.size.height
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .themeColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.displayPopover()
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        currentIndex = self.selectedIndex
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
            guard let strongSelf = self else { return }
            if strongSelf.currentIndex != strongSelf.selectedIndex {
                strongSelf.displayPopover()
            }
        }
    }
    
    private func displayPopover() {
        var tabPopoverInfo = Defaults[.tabPopoverInfo]
        tabPopoverInfo.append(self.selectedIndex)
        Defaults[.tabPopoverInfo] = tabPopoverInfo
        
        if tabPopoverInfo.filter({ $0 == self.selectedIndex }).count > 3 { return }
        
        let options: [MessengerPopoverOption] = [
            .color(.themeColor),
            .type(.up),
            .blackOverlayColor(.clear),
            .cornerRadius(11),
            .showShadow(false),
            .showBlackOverlay(false),
            .dismissOnBlackOverlayTap(false)
        ]
        let popover: MessengerPopover = MessengerPopover.init(options: options)
        let popoverView = initializePopoverView(title: tabTitles[self.selectedIndex])
        popover.setOptions(options)
        let frame = self.frameForTabAtIndex(index: self.selectedIndex)
        
        popover.willShowHandler = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.displayingPopovers.append(popover)
            DispatchQueue.main.async {
                strongSelf.displayingPopovers.filter { $0 != popover }.forEach { $0.dismiss() }
            }
        }
        
        popover.didShowHandler = {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                popover.dismiss()
            })
        }
        
        popover.didDismissHandler = { [weak self] in
            guard let strongSelf = self else { return }
            if strongSelf.displayingPopovers.contains(popover) {
                strongSelf.displayingPopovers = strongSelf.displayingPopovers.filter { $0 != popover }
            }
        }
        
        popover.show(popoverView, point: .init(
            x: frame?.midX ?? 0,
            y: tabBar.frame.origin.y - 6
            ))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let newTabBarHeight = defaultTabBarHeight - DeviceConst.tabBarOffset
        
        var newFrame = tabBar.frame
        newFrame.size.height = newTabBarHeight
        newFrame.origin.y = view.frame.size.height - newTabBarHeight
        
        tabBar.frame = newFrame
    }
    
    func initializePopoverView(title: String) -> UIView {
        let label = UILabel()
        label.text = title
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.sizeToFit()
        let width = label.frame.width
        
        let view = UIView.init(frame: .init(x: 0, y: 0, width: width + 16, height: 22))
        view.addSubview(label)
        label.fillSuperview()

        return view
    }
    
    func frameForTabAtIndex(index: Int) -> CGRect? {
        var frames = tabBar.subviews.compactMap { (view:UIView) -> CGRect? in
            if let view = view as? UIControl {
                return view.frame
            }
            return nil
        }
        frames.sort { $0.origin.x < $1.origin.x }
        if frames.count > index {
            return frames[index]
        }
        return frames.last ?? CGRect.zero
    }
}
