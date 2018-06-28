import Foundation
import IGListKit
import RxCocoa
import RxSwift

class ViewModelArticles: RefreshableModel {
    private let state = BehaviorRelay<LoadingState>(value: .loading)
    private let refreshing = BehaviorRelay<Bool>(value: false)
    private let items = BehaviorRelay<[ListDiffable]>(value: [])
    
    private var lastValue: Any?
    private var busy = false
    private var articles = [Article]()
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
        articles.removeAll()
        state.accept(.loading)
        fetch()
    }
    
    func refresh() {
        lastValue = nil
        isCompleted = false
        articles.removeAll()
        refreshing.accept(true)
        fetch()
    }
    
    func loadMore() {
        if busy || isCompleted { return }
        fetch()
    }
    
    private func setItems() {
        let articleArray = ArticleArray(articles: articles)
        let diffalable = ([articleArray] as [ListDiffable]) + ([isCompleted] as [ListDiffable])
        items.accept(diffalable)
    }
    
    private func fetch() {
        busy = true
        
        Service.articles.getArticles(paginate: true, lastValue: lastValue) { [weak self] result in
            switch result {
            case .success(let articles, let lastValue):
                if articles.isEmpty { self?.isCompleted = true }
                self?.state.accept(.success)
                self?.articles.append(contentsOf: articles)
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

