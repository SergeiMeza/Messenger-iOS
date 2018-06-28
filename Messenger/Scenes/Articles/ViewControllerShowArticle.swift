import UIKit
import TTTAttributedLabel
import IGListKit
import RxCocoa
import RxSwift

class ViewControllerShowArticle: UIViewController, MovableNavBar {
    
    var articleId: String = ""
    var article: Article?
    
    @IBOutlet weak var loadingStateView: LoadingStateView!
    @IBOutlet weak var errorStateView: ErrorStateView!
    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var collectionViewArticle: ListCollectionView!
    
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
        fetchArticle()
        extendedLayoutIncludesOpaqueBars = true
        successView.addSubview(backButton)
        successView.addSubview(shareButton)
        navigationController?.interactivePopGestureRecognizer?.delegate = (self as? UIGestureRecognizerDelegate)
        shareButton.anchor(top: backButton.topAnchor, right: successView.rightAnchor, inset: UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 8))
        shareButton.heightAnchor.constraint(equalToConstant: 41).isActive = true
        shareButton.widthAnchor.constraint(equalToConstant: 41).isActive = true
        
        errorStateView.setupButtonClickListener(handler: { [weak self] in
            self?.fetchArticle()
        })
    }
    
    private func setupSubviews() {
    
    }
    
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(TableViewCellShowArticleImage.self)
            tableView.register(TableViewCellShowArticleTitle.self)
            tableView.register(TableViewCellShowArticleText.self)
            tableView.register(TableViewCellShowArticleTopItems.self)
            tableView.register(TableViewCellShowArticleQuotation.self)
            tableView.register(TableViewCellShowArticleLinkImage.self)
            tableView.register(TableViewCellShowArticleSubtitle.self)
            
            tableView.delegate = self
            tableView.dataSource = self
            tableView.allowsSelection = false
            tableView.backgroundColor = .white
            tableView.separatorColor = .white
            tableView.estimatedRowHeight = 30
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.sectionHeaderHeight = UITableViewAutomaticDimension
            tableView.estimatedSectionHeaderHeight = 80
        }
    }
    
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
    
    private var state: LoadingState = .loading {
        didSet {
            DispatchQueue.main.async {
                self.view.bringSubview(toFront: self.stateViews[self.state.rawValue])
            }
        }
    }

    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavBar(animated: true)
        setupListener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeListener()
        tabBarController?.tabBar.isHidden = false
        appearNavBar(animated: true)
        super.viewWillDisappear(animated)
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
    
    private func setupListener() {
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
    
    
    private func fetchArticle() {
        state = .loading
        Service.articles.show(objectId: articleId, completion: { [weak self] result in
            switch result {
            case .success(let article):
                self?.state = .success
                self?.article = article
                DispatchQueue.main.async {
                    self?.title = article.title
                    self?.tableView.reloadData()
                }
            case .error:
                self?.state = .failure
            }
        })
    }
}

extension ViewControllerShowArticle: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return article?.articleItems.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else { return UIView()}
        let headerCell: TableViewCellShowArticleTopItems = tableView.dequeueReusableCell(forIndexPath: IndexPath())
        guard article != nil else { return UIView()}
        headerCell.setTopItems(article: article!)
        headerCell.backgroundColor = UIColor.white
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == 0 else { return UIView()}
        let footerCell = UIView()
        footerCell.backgroundColor = UIColor.white
        return footerCell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item: ArticleItem = article!.articleItems[indexPath.row]
        let isLast = indexPath.row == article!.articleItems.count - 1
        
        if isLast {
//            LipsAnalytics.logEvent(.articleFinishedReading, parameters: ["id": articleId])
        }
        
        switch item.type {
        case .image:
            let cell: TableViewCellShowArticleImage = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.setImage(item: item)
            return cell
            
        case .text:
            let cell: TableViewCellShowArticleText = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.setText(item: item)
            return cell
            
        case .subTitle:
            let cell: TableViewCellShowArticleTitle = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.setSubTitle(item: item)
            return cell
            
        case .quotation:
            let cell: TableViewCellShowArticleQuotation = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.setQuotation(item: item)
            return cell
            
        case .linkImage:
            let cell: TableViewCellShowArticleLinkImage = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.setup(item: item)
            return cell
            
        case .subSubTitle:
            let cell: TableViewCellShowArticleSubtitle = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.setupTitle(item: item)
            return cell
            
        default:
            let cell: TableViewCellShowArticleText = tableView.dequeueReusableCell(forIndexPath: indexPath)
            return cell
        }
    }
}
