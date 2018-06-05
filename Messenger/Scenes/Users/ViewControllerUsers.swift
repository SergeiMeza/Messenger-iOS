//
//  ViewControllerUsers.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/04.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import IGListKit

class ViewControllerUsers: UIViewController {
    
    @IBOutlet weak var loadingView: LoadingStateView!
    @IBOutlet weak var errorView: ErrorStateView!
    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var collectionViewUsers: ListCollectionView!
    
    private var stateViews: [UIView] {
        return [loadingView, successView, errorView]
    }
    
    private lazy var adapter: ListAdapter = {
       return ListAdapter.init(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    private lazy var refreshControl: RxRefreshControl = {
        return RxRefreshControl(viewModel)
    }()
    
    private let delegate = CollectionViewScrollDelegate()
    private let dataSource = DataSourceUsers()
    private let viewModel = ViewModelUsers()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupListener()
        viewModel.viewDidLoad()
    }
    
    private func setupSubviews() {
        title = "Home"
        tabBarItem.title = "Home"
        collectionViewUsers.backgroundColor = .backgroundColor
        collectionViewUsers.addSubview(refreshControl)
        adapter.collectionView = collectionViewUsers
        adapter.dataSource = dataSource
    }
    
    private func setupListener() {
        errorView.setupButtonClickListener { [weak self] in self?.viewModel.reconnect() }
        refreshControl.setupEndRefresingListener()
        
        viewModel.loadingState
            .drive(onNext: { [weak self] state in
                guard let strongSelf = self else { return }
                strongSelf.view.bringSubview(toFront: strongSelf.stateViews[state.rawValue])
            }).disposed(by: disposeBag)
        
        viewModel.currentItems
            .drive(onNext: { [weak self] items in
                guard let strongSelf = self else { return }
                strongSelf.dataSource.items = items
                strongSelf.adapter.performUpdates(animated: true)
                }).disposed(by: disposeBag)
        
        collectionViewUsers.createEndScrollingObservable()
            .subscribe(onNext: { [weak self] _, _ in
                self?.viewModel.loadMore()
            }).disposed(by: disposeBag)
    }
}
