import UIKit
import TTTAttributedLabel
import IGListKit
import RxCocoa
import RxSwift

class ViewControllerShowArticle: UIViewController, MovableNavBar {
    
    var articleId: String = ""
    
    var isBarHidden: Bool = false
    
    @IBOutlet weak var loadingStateView: LoadingStateView!
    @IBOutlet weak var errorStateView: ErrorStateView!
    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var collectionViewArticle: ListCollectionView!
    
    private var stateViews: [UIView] {
        return [loadingStateView, successView, errorStateView]
    }
    
    private lazy var adapter: ListAdapter = ListAdapter.init(updater: ListAdapterUpdater(), viewController: self)
    
    private lazy var refreshControl: RxRefreshControl = RxRefreshControl(viewModel)
    private lazy var viewModel = ViewModelShowArticle(articleId: self.articleId)
    private let dataSource = DataSourceShowArticle()
    private let disposeBag = DisposeBag()
    
    private lazy var backButton: UIButton = {
        let backButton = UIButton()
        backButton.setImage(#imageLiteral(resourceName: "ic_28_back"), for: .normal)
        backButton.imageEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: 0)
        backButton.tintColor = .light100
        backButton.alpha = 0.9
        backButton.backgroundColor = .themeColor
        backButton.frame = CGRect(x: 8, y:  8, width: 42, height: 42)
        backButton.layer.cornerRadius = backButton.frame.width / 2
        backButton.addTarget(self, action: #selector(popSelf), for: .touchUpInside)
        return backButton
    }()
    
    private lazy var shareButton: UIButton = {
        let shareButton = UIButton()
        shareButton.setImage(#imageLiteral(resourceName: "ic_28_export"), for: .normal)
        shareButton.alpha = 0.9
        shareButton.backgroundColor = .themeColor
        shareButton.tintColor = .light100
        shareButton.frame = CGRect(x: 8, y:  8, width: 42, height: 42)
        shareButton.layer.cornerRadius = backButton.frame.width / 2
        shareButton.addTarget(self, action: #selector(shareArticle), for: .touchUpInside)
        return shareButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupListener()
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavBar(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeListener()
        appearNavBar(animated: true)
        super.viewWillDisappear(animated)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in
            self.collectionViewArticle?.collectionViewLayout.invalidateLayout()
            self.collectionViewArticle?.setNeedsLayout()
        }
    }
    
    private func setupSubviews() {
        extendedLayoutIncludesOpaqueBars = true
        collectionViewArticle.backgroundColor = .white
        collectionViewArticle.addSubview(refreshControl)
        collectionViewArticle.showsVerticalScrollIndicator = false
        adapter.collectionView = collectionViewArticle
        adapter.dataSource = dataSource
        
        successView.addSubview(backButton)
        successView.addSubview(shareButton)
        navigationController?.interactivePopGestureRecognizer?.delegate = (self as? UIGestureRecognizerDelegate)
        shareButton.anchor(top: backButton.topAnchor, right: successView.rightAnchor, inset: UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 8))
        shareButton.heightAnchor.constraint(equalToConstant: 41).isActive = true
        shareButton.widthAnchor.constraint(equalToConstant: 41).isActive = true
    }
    
    private func setupListener() {
        errorStateView.setupButtonClickListener { [weak self] in self?.viewModel.reconnect() }
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
        
        //        RxBus.shared.asObservable(event: ProductTapEvent.self)
        //            .subscribe { [weak self] event in
        //                guard let event = event.element else { return }
        //                let vc = ProductShowViewController.instantiate()
        //                vc.product = event.product
        //                LipsAnalytics.logEvent(.articleToProductShow, parameters: ["productId": event.product.id, "articleId": self?.articleId ?? 0])
        //                self?.navigationController?.pushViewController(vc, animated: true)
        //            }.disposed(by: disposeBag)
        
        //        RxBus.shared.asObservable(event: PostTapEvent.self)
        //            .subscribe { [weak self] event in
        //                guard let event = event.element else { return }
        //                let vc = PostShowViewController.instantiate()
        //                vc.post = event.post
        //                vc.postId = event.post.id
        //                LipsAnalytics.logEvent(.articleToPostShow, parameters: ["postId": event.post.id, "articleId": self?.articleId ?? 0])
        //                self?.navigationController?.pushViewController(vc, animated: true)
        //            }.disposed(by: disposeBag)
        
        //        RxBus.shared.asObservable(event: ProfileTapEvent.self)
        //            .subscribe { [weak self] event in
        //                guard let event = event.element else { return }
        //                let vc = ProfileViewController.instantiate()
        //                vc.user = event.user
        //                LipsAnalytics.logEvent(.articleToUserShow, parameters: ["userId": event.user.id, "articleId": self?.articleId ?? 0])
        //                self?.navigationController?.pushViewController(vc, animated: true)
        //            }.disposed(by: disposeBag)
        
        //        RxBus.shared.asObservable(event: HashTagTapEvent.self)
        //            .subscribe { [weak self] event in
        //                guard let event = event.element else { return }
        //                let vc = PostsViewController.instantiate(type: .byTagName(text: event.hashTag), params: ["text": event.hashTag])
        //                LipsAnalytics.logEvent(.articleToHashTag, parameters: ["tagName": event.hashTag, "articleId": self?.articleId ?? 0])
        //                self?.navigationController?.pushViewController(vc, animated: true)
        //            }.disposed(by: disposeBag)
        
        //        RxBus.shared.asObservable(event: UrlLinkTapEvent.self)
        //            .subscribe { [weak self] event in
        //                guard let event = event.element else { return }
        //                let vc = SiteWebViewController(url: event.url, title: nil)
        //                LipsAnalytics.logEvent(.articleToWebView, parameters: ["url": "\(event.url)", "articleId": self?.articleId ?? 0])
        //                self?.present(MyNavigationController(rootViewController: vc), animated: true)
        //            }.disposed(by: disposeBag)
    }
    
    private func removeListener() {
        //        RxBus.shared.remove(event: HashTagTapEvent.self)
        //        RxBus.shared.remove(event: UrlLinkTapEvent.self)
        //        RxBus.shared.remove(event: ProductTapEvent.self)
        //        RxBus.shared.remove(event: PostTapEvent.self)
        //        RxBus.shared.remove(event: ProfileTapEvent.self)
    }
    
    
    @objc func shareArticle() {
//        let urlString = "https://lipscosme.com/levre/articles/\(article!.id)"
//        if let url = URL.init(string: urlString) {
//            socialShare(sharingURL: url)
//        } else {
//            socialShare(sharingText: urlString)
//        }
    }
    
    func socialShare(sharingText: String? = nil, sharingImage: UIImage? = nil, sharingURL: URL? = nil) {
        var sharingItems = [AnyObject]()
        
        if let text = sharingText {
            sharingItems.append(text as AnyObject)
        }
        if let image = sharingImage {
            sharingItems.append(image)
        }
        if let url = sharingURL {
            sharingItems.append(url as NSURL)
        }
        
        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func popSelf() {
        navigationController?.popViewController(animated: true)
    }
}

//extension ViewControllerShowArticle: UITableViewDataSource, UITableViewDelegate {

//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        guard section == 0 else { return UIView()}
//        let headerCell: TableViewCellShowArticleTopItems = tableView.dequeueReusableCell(forIndexPath: IndexPath())
//        guard article != nil else { return UIView()}
//        headerCell.setTopItems(article: article!)
//        headerCell.backgroundColor = UIColor.white
//        return headerCell
//    }

//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        guard section == 0 else { return UIView()}
//        let footerCell = UIView()
//        footerCell.backgroundColor = UIColor.white
//        return footerCell
//    }

//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 1
//    }

//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

//        let item: ArticleItem = article!.articleItems[indexPath.row]
//        let isLast = indexPath.row == article!.articleItems.count - 1
//
//        if isLast {
//            LipsAnalytics.logEvent(.articleFinishedReading, parameters: ["id": articleId])
//        }

//}
