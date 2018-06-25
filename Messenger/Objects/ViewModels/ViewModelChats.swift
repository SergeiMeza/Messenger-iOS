//
//  ViewModelChats.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/26.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import Foundation
import IGListKit
import RxCocoa
import RxSwift
import Firebase

class ViewModelChats: RefreshableModel {
    private let state = BehaviorRelay<LoadingState>(value: .loading)
    private let refreshing = BehaviorRelay<Bool>(value: false)
    private let items = BehaviorRelay<[ListDiffable]>(value: [])
    
    private var lastValue: Any?
    
    private var busy = false
    
    private var chats = [RealmChat]()
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
        lastValue = nil
        state.accept(.loading)
        fetch()
    }
    
    func refresh() {
        lastValue = nil
        isCompleted = false
        chats.removeAll()
        refreshing.accept(true)
        fetch()
    }
    
    func loadMore() {
        if busy || isCompleted { return }
        fetch()
    }
    
    private func setItems() {
        let diffalable = (chats as [ListDiffable]) + ([isCompleted] as [ListDiffable])
        items.accept(diffalable)
    }
    
    private func fetch() {
        busy = true
        
        Service.chats.getChats(paginate: true, lastValue: lastValue) { [weak self]
            result in
            switch result {
            case .success(let chats, let lastValue):
                if chats.isEmpty { self?.isCompleted = true }
                self?.state.accept(.success)
                self?.chats.append(contentsOf: chats)
                self?.lastValue = lastValue
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
