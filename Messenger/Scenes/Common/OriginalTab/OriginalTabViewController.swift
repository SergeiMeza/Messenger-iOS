//
//  OriginalTabViewController.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/04.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit

class OriginalTabViewController: UIViewController {
    
    let settings = Settings()
    
    private(set) var viewControllers: [UIViewController] = []
    private(set) var index = 0
    
    var titles: [String] {
        return viewControllers.map { vc -> String in
            guard let info = vc as? OriginalTabInfo else { fatalError("Must set OriginalTabInfo on \(type(of: vc)) to show in OriginalTabViewController") }
            let title = info.originalTabInfoTitle()
            return title.isEmpty ? " " : title
        }
    }
    
    /// get/set values isScrollEnabled of PageVC and isUserInteractionEnabled of TabView
    var isTransitionable: Bool {
        get {
            return pageViewController.scrollView?.isScrollEnabled ?? true || tabView.collectionView.isUserInteractionEnabled
        } set {
            pageViewController.scrollView?.isScrollEnabled = newValue
            tabView.collectionView.isUserInteractionEnabled = newValue
        }
    }
    
    /// for override
    func viewControllers(for originalTabViewController: OriginalTabViewController) -> [UIViewController] {
        fatalError("must override this")
    }
    
    func move(to index: Int, isAnimated: Bool) {
        if self.index == index { return }
        self.index = index
        self.pageViewController.to(index: index, isAnimated: isAnimated)
        self.tabView.to(index: index, isAnimated: isAnimated)
    }
    
    func reloadViewControllers() {
        viewControllers = viewControllers(for: self)
        pageViewController.reload()
        tabView.reload()
    }
    
    private(set) var tabView: OriginalTabView!
    private let pageViewController = OriginalTabPageViewController.instantiate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = viewControllers(for: self)
        
        // tab
        tabView = settings.isInfinityScroll ? OriginalTabViewInfinity(parent: self) : OriginalTabView(parent: self)
        tabView.delegate = self
        view.addSubview(tabView)
        tabView.anchor(top: view.topAnchor,
                       right: view.rightAnchor,
                       left: view.leftAnchor,
                       size: .init(width: 0, height: settings.tabHeight))
        
        // pageView
        addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        pageViewController.didMove(toParentViewController: self)
        
        pageViewController.pageDelegate = self
        pageViewController.view.anchor(
            top: tabView.bottomAnchor,
            right: view.rightAnchor,
            bottom: view.bottomAnchor,
            left: view.leftAnchor)
        view.bringSubview(toFront: tabView)
        tabView.layer.applyNavBarShadow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.layer.hiddenShadow()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.tabView?.to(index: self.index)
        }) { _ in
            self.tabView?.collectionView?.collectionViewLayout.invalidateLayout()
            self.tabView?.setNeedsLayout()
            self.tabView?.to(index: self.index)
        }
    }
}

extension OriginalTabViewController {
    
    struct Settings {
        var isInfinityScroll: Bool = true
        var tabSelectionHeight: CGFloat = 30
        var tabSelectionColor = UIColor.themeColor
        var tabHeight: CGFloat = 44
        var tabInterval: CGFloat = 6
        var tabBackgroundColor: UIColor = .white
        var tabTextColor: UIColor = .dark50
        var tabSelectedTextColor: UIColor = .white
        var onTabSelectedListener: ((Int, Int) -> Void)?
        var onPageChangedListener: ((Int, Int) -> Void)?
        var onPageScrollRateListener: ((Int, Int, CGFloat) -> Void)?
        var tabBottomInset: CGFloat = 8
    }
}

extension OriginalTabViewController: OriginalTabViewDelegate {
    
    func originalTabView(didSelect index: Int) {
        if self.index == index { return }
        self.settings.onTabSelectedListener?(self.index, index)
        self.index = index
        self.pageViewController.to(index: index)
    }
}

extension OriginalTabViewController: OriginalTabPageViewControllerDelegate {
    
    func originalTabPage(moved index: Int) {
        self.index = index
        self.settings.onPageChangedListener?(self.index, index)
        self.tabView.to(index: index)
    }
    
    func originalTabPage(moving rate: CGFloat, to isForward: Bool) {
        let to = index + (isForward ? 1 : -1)
        self.settings.onPageScrollRateListener?(index, to, rate)
        self.tabView.moving(from: index, to: to, rate: rate)
    }
}
