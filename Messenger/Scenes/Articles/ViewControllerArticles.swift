import UIKit
import RxCocoa
import RxSwift
import IGListKit

class ViewControllerArticles: UIViewController, OriginalTabInfo {
    
    @IBOutlet weak var loadingStateView: LoadingStateView!
    @IBOutlet weak var errorStateView: ErrorStateView!
    @IBOutlet weak var successStateView: UIView!
    @IBOutlet weak var collectionViewArticle: ListCollectionView!
    
    internal var tab: Tab = Tab()
    
    private let delegate = CollectionViewScrollDelegate()
    private let dataSource = DataSourceArticles()
    private let viewModel = ViewModelArticles()
    private let disposeBag = DisposeBag()
    
    private var stateViews: [UIView] {
        return [loadingStateView, successStateView, errorStateView]
    }
    
    private lazy var adapter: ListAdapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    private lazy var refreshControl: RxRefreshControl = RxRefreshControl(viewModel)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupListener()
        viewModel.viewDidLoad()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in
            self.collectionViewArticle?.collectionViewLayout.invalidateLayout()
            self.collectionViewArticle?.setNeedsLayout()
        }
    }
    
    func originalTabInfoTitle() -> String {
        return tab.title
    }
    
    private func setupView() {
        collectionViewArticle.backgroundColor = .backgroundColor
        collectionViewArticle.addSubview(refreshControl)
        collectionViewArticle.showsVerticalScrollIndicator = false
        adapter.collectionView = collectionViewArticle
        adapter.dataSource = dataSource
        adapter.scrollViewDelegate = delegate
    }
    
    private func setupListener() {
        errorStateView.setupButtonClickListener { [weak self] in self?.viewModel.reconnect()}
        delegate.setupEndScrollingListener { [weak self] in self?.viewModel.loadMore() }
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
    }
}
