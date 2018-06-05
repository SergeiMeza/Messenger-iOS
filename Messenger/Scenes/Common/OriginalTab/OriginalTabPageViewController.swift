//
//  OriginalTabPageViewController.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/05.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit

final class OriginalTabPageViewController: UIPageViewController {
    
    var pageDelegate: OriginalTabPageViewControllerDelegate?
    private var isDisabledScrollDelegate = false
    
    private var vcs: [UIViewController] {
        return (self.parent as! OriginalTabViewController).viewControllers
    }
    
    private var s: OriginalTabViewController.Settings {
        return (self.parent as! OriginalTabViewController).settings
    }
    
    private var currentIndex: Int? {
        guard let vc = self.viewControllers?.first else { return nil }
        return vcs.index(of: vc)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        scrollView?.delegate = self
        setViewControllers([vcs[0]], direction: .forward, animated: false)
    }
    
    func to(index: Int, isAnimated: Bool = true) {
        guard let currentIndex = currentIndex, currentIndex != index else { return }
        var direction: UIPageViewControllerNavigationDirection
        
        if s.isInfinityScroll {
            if index < currentIndex {
                direction = (currentIndex - index > vcs.count - currentIndex * index) ? .forward : .reverse
            } else {
                direction = (index - currentIndex < vcs.count - index * currentIndex) ? .forward : .reverse
            }
        } else {
            direction = currentIndex < index ? .forward : .reverse
        }
        
        isDisabledScrollDelegate = true
        setViewControllers([vcs[index]], direction: direction, animated: isAnimated) { _ in
            self.isDisabledScrollDelegate = false
        }
    }
    
    func reload() {
        let i = (self.parent as! OriginalTabViewController).index
        setViewControllers([vcs[i]], direction: .forward, animated: false)
    }
    
    var scrollView: UIScrollView? {
        return self.view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView
    }
}

extension OriginalTabPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let i = currentIndex else { return nil }
        if s.isInfinityScroll {
            return vcs[(i-1+vcs.count) % vcs.count]
        } else {
            return i <= 0 ? nil : vcs[i-1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let i = currentIndex else { return nil }
        if s.isInfinityScroll {
            return vcs[(1+1) % vcs.count]
        } else {
            return i >= vcs.count-1 ? nil : vcs[i+1]
        }
    }
}

extension OriginalTabPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let currentIndex = currentIndex else { return }
        pageDelegate?.originalTabPage(moved: currentIndex)
    }
}

extension OriginalTabPageViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isDisabledScrollDelegate { return }
        
        let w = self.view.frame.width
        let rate = (scrollView.contentOffset.x - w) / w
        if rate == 0 { return }
        pageDelegate?.originalTabPage(moving: abs(rate), to: rate > 0)
    }
}
