//
//  CollectionViewScrollDelegate.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/04.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CollectionViewScrollDelegate: NSObject, UIScrollViewDelegate {

    private var listener: (() -> Void)?

    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let distance = scrollView.contentSize.height - (targetContentOffset.pointee.y + scrollView.bounds.height)
        
        if distance < 200 {
            DispatchQueue.global(qos: .default).async { [weak self] in
                sleep(2)
                DispatchQueue.main.async {
                    self?.listener?()
                }
            }
        }
    }
    
    func setupEndScrollingListener(_ listener: @escaping (() -> Void)) {
        self.listener = listener
    }
}
