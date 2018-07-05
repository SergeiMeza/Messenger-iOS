import Foundation
import IGListKit
import RxCocoa
import RxSwift
import Firebase

class ViewModelShowArticle: RefreshableModel {
    private let state = BehaviorRelay<LoadingState>(value: .loading)
    private let refreshing = BehaviorRelay<Bool>(value: false)
    private let items = BehaviorRelay<[ListDiffable]>(value: [])
    private var busy = false
    private var isCompleted = false
    
    private var articleId: String
    private var article: Article?
    private var articleItems = [ListDiffable]()
    
    init (articleId: String) {
        self.articleId = articleId
    }
    
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
        articleItems.removeAll()
        state.accept(.loading)
        fetch()
    }
    
    func refresh() {
        isCompleted = false
        articleItems.removeAll()
        refreshing.accept(true)
        fetch()
    }
    
    func loadMore() {
        if busy || isCompleted { return }
        fetch()
    }
    
    private func setItems() {
        guard let article = article else {
            state.accept(.failure)
            return
        }
        articleItems.append(contentsOf: article.articleItems)
        items.accept(articleItems)
    }
    
    private func fetch() {
        busy = true
        
        Service.articles.show(objectId: articleId, completion: { [weak self] result in
            switch result {
            case .success(let article):
                self?.state.accept(.success)
                self?.article = article
                self?.setItems()
                self?.refreshing.accept(false)
                self?.busy = false
            case .error:
                self?.state.accept(.failure)
                self?.refreshing.accept(false)
                self?.busy = false
            }
        })
    }
}
