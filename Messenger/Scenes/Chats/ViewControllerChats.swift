//
//  ViewControllerChats.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/25.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import IGListKit

class ViewControllerChats: UIViewController {
    
    @IBOutlet weak var loadingView: LoadingStateView!
    @IBOutlet weak var errorView: ErrorStateView!
    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var collectionViewChats: ListCollectionView!
    
    private var stateViews: [UIView] {
        return [loadingView, successView, errorView]
    }
    
    private lazy var adapter: ListAdapter = ListAdapter.init(updater: ListAdapterUpdater(), viewController: self)
    private lazy var refreshControl: RxRefreshControl = RxRefreshControl(viewModel)
    
    private let delegate = CollectionViewScrollDelegate()
    private let datasource = DataSourceChats()
    private let viewModel = ViewModelChats()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupListener()
        viewModel.viewDidLoad()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in
            self.collectionViewChats?.collectionViewLayout.invalidateLayout()
            self.collectionViewChats?.setNeedsLayout()
        }
    }
    
    private func setupViews() {
        navigationItem.title = "Chats"
        collectionViewChats.backgroundColor = .backgroundColor
        collectionViewChats.addSubview(refreshControl)
        adapter.collectionView = collectionViewChats
        adapter.dataSource = datasource
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
                strongSelf.datasource.items = items
                strongSelf.adapter.performUpdates(animated: true)
            }).disposed(by: disposeBag)
        
        collectionViewChats.createEndScrollingObservable()
            .subscribe(onNext: { [weak self] _,_ in
                self?.viewModel.loadMore()
            }).disposed(by: disposeBag)
    }
}
