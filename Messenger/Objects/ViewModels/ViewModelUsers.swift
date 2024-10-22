import Foundation
import IGListKit
import RxCocoa
import RxSwift
import Firebase

class ViewModelUsers: RefreshableModel {
    private let state = BehaviorRelay<LoadingState>(value: .loading)
    private let refreshing = BehaviorRelay<Bool>(value: false)
    private let items = BehaviorRelay<[ListDiffable]>(value: [])
    private var lastValue: Any?
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
        lastValue = nil
        users.removeAll()
        state.accept(.loading)
        fetch()
    }
    
    func refresh() {
        lastValue = nil
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
        let userArray = UserArray(users: users)
        let diffalable = ([userArray] as [ListDiffable]) + ([isCompleted] as[ListDiffable])
        items.accept(diffalable)
    }
    
    private func fetch() {
        busy = true
        
        Service.users.getUsers(paginate: true, lastValue: lastValue) { [weak self] result in
            switch result {
            case .success( let users, let lastValue):
                if users.isEmpty { self?.isCompleted = true }
                self?.state.accept(.success)
                self?.users.append(contentsOf: users)
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
