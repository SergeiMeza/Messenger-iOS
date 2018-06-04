//
//  ViewModelUsers.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/04.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import Foundation
import IGListKit
import RxCocoa
import RxSwift

class ViewModelUsers: RefreshableModel {
    private let state = BehaviorRelay<LoadingState>(value: .loading)
    private let refreshing = BehaviorRelay<Bool>(value: false)
    private let items = BehaviorRelay<[ListDiffable]>(value: [])
    
    private var currentPage = 0
    private var busy = false
    
    private var users = [RealmUser]()
    private var isCompleted = false
    
    var currentItems: Driver<[ListDiffable]> {
        return items.asDriver()
    }
    
    var loadingState: Driver<LoadingState> {
        return state.asDriver()
    }
    
    var refreshingState: Driver<Bool> {
        return refreshing.asDriver().filter { !$0 }
    }
    
    func viewDidLoad() {
        state.accept(.loading)
        fetch()
    }
    
    func reconnect() {
        currentPage = 0
        state.accept(.loading)
        fetch()
    }
    
    func refresh() {
        currentPage = 0
        isCompleted = false
        users.removeAll()
        refreshing.accept(true)
        fetch()
    }
    
    func loadMore() {
        if busy || isCompleted { return }
        fetch()
    }
    
    private func setItems() {
        let diffalable = (users as [ListDiffable]) + ([isCompleted] as[ListDiffable])
        items.accept(diffalable)
    }
    
    private func fetch() {
        currentPage += 1
        busy = true
        
        Service.users.getUsers { [weak self] result in
            switch result {
            case .success( let users):
                if users.isEmpty { self?.isCompleted = true }
                self?.state.accept(.success)
                self?.users.append(contentsOf: users)
                self?.setItems()
                self?.refreshing.accept(false)
                self?.busy = false
            case .error:
                self?.state.accept(.failure)
                self?.refreshing.accept(false)
                self?.busy = false
            }
        }
    }
}
