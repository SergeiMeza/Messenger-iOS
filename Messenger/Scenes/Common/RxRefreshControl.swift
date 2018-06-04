//
//  RxRefreshControl.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/04.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxRefreshControl: UIRefreshControl {
    
    private weak var refreshableModel: RefreshableModel?
    private let disposeBag = DisposeBag()
    
    private override init() {
        super.init()
        
        rx.controlEvent(.valueChanged)
            .asDriver()
            .drive(onNext: { _ in
                self.refreshableModel?.refresh()
            }).disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init coder has not been implemented")
    }
    
    convenience init(_ refreshableModel: RefreshableModel) {
        self.init()
        self.refreshableModel = refreshableModel
    }
    
    func setupEndRefresingListener(_ callback: (() -> Void)? = nil) {
        
        refreshableModel?.refreshingState
            .drive(onNext: { [weak self] _ in
                self?.endRefreshing()
                callback?()
            }).disposed(by: disposeBag)
    }
}
