
import UIKit
import RxCocoa
import RxSwift
import IGListKit

class ViewControllerUsers: UIViewController, OriginalTabInfo {
    
    var tab = Tab()
    
    @IBOutlet weak var loadingView: LoadingStateView!
    @IBOutlet weak var errorView: ErrorStateView!
    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var collectionViewUsers: ListCollectionView!
    
    private var stateViews: [UIView] {
        return [loadingView, successView, errorView]
    }
    
    private lazy var adapter: ListAdapter = ListAdapter.init(updater: ListAdapterUpdater(), viewController: self)
    
    private lazy var refreshControl: RxRefreshControl = RxRefreshControl(viewModel)
    
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in
            self.collectionViewUsers?.collectionViewLayout.invalidateLayout()
            self.collectionViewUsers?.setNeedsLayout()
        }   
    }
    
    private func setupSubviews() {
        navigationItem.title = "Home"
        collectionViewUsers.backgroundColor = .backgroundColor
        collectionViewUsers.addSubview(refreshControl)
        collectionViewUsers.showsVerticalScrollIndicator = false
        adapter.collectionView = collectionViewUsers
        adapter.dataSource = dataSource
    }
    
    func originalTabInfoTitle() -> String {
        return tab.title
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
