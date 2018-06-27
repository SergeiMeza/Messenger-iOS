//
//  ViewControllerHome.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/27.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

extension Notification.Name {
    static let homeTabSelected: Notification.Name = Notification.Name("HomeTabSelected")
    static let userPosted: Notification.Name = Notification.Name("userPosted")
    static let homeTabScrollToTop: Notification.Name = Notification.Name("homeTabScrollToTop")
}

class ViewControllerHome: OriginalTabViewController, MovableNavBar {
    
    // TODO: アクセス修飾子を全体的に見直す。変数のスコープも見直す
    var parentView: UIView!
    var isBarHidden: Bool = false
    var scrollStartPoint: CGFloat! = 0.0
    var navigationBar: UINavigationBar!
    
    private var targetTab: Tab.TabType?
    private var tabs: [Tab] = []
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.backgroundColor
        setupLogo()
        setupProfileButton()
        
        navigationBar = navigationController?.navigationBar
        parentView = self.view
        
        let colorNormal: UIColor = UIColor.dark20
        let attributesNormal = [
            NSAttributedStringKey.foregroundColor: colorNormal
        ]
        
        UITabBarItem.appearance().setTitleTextAttributes(attributesNormal, for: .normal)
        view.bringSubview(toFront: tabView)
        
        // movablenavbarが下を通るようにするため、statusBarStyleableでは駄目
        let statusBarBgView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: UIApplication.shared.statusBarFrame.size.height))
        statusBarBgView.backgroundColor = UIColor.light100
        statusBarBgView.tag = DeviceConst.homeStatusBarBgViewTag
        UIApplication.shared.keyWindow?.addSubview(statusBarBgView)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTabIfNeeded), name: Notification.Name.homeTabSelected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveToTimeLine), name: Notification.Name.userPosted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToTop), name: .homeTabScrollToTop, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        // 通知起動時におかしくなるのでviewWillAppearで行う
        if tabs.isEmpty {
            request()
        }
    }
    
    override func viewControllers(for originalTabViewController: OriginalTabViewController) -> [UIViewController] {
        var controllers: [UIViewController] = []
        for tab in tabs {
            switch tab.type {
            case .popular:
                let users = ViewControllerUsers.instantiate()
                users.tab = tab
                controllers.append(users)
                
            case .discover:
                let users = ViewControllerUsers.instantiate()
                users.tab = tab
                controllers.append(users)
                
            case .latest:
                let users = ViewControllerUsers.instantiate()
                users.tab = tab
                controllers.append(users)
                
            case .skype:
                let users = ViewControllerUsers.instantiate()
                users.tab = tab
                controllers.append(users)
                
            case .event:
                let users = ViewControllerUsers.instantiate()
                users.tab = tab
                controllers.append(users)
                
            case .article:
                let users = ViewControllerUsers.instantiate()
                users.tab = tab
                controllers.append(users)
                
            default:
                let users = ViewControllerUsers.instantiate()
                users.tab = tab
                controllers.append(users)
            }
        }
        
        if controllers.count == 0 {
            let users = ViewControllerUsers.instantiate()
            users.tab = Tab()
            controllers.append(users)
        }
        return controllers
    }
    
    func setupLogo() {
        let logoSize = 36
        let logoFrame = CGRect(x: 0, y: 0, width: logoSize, height: logoSize)
        let logoImageView = UIImageView(frame: logoFrame)
//        logoImageView.image = #imageLiteral(resourceName: "ic_36_logo")
        let logoButtonItem = UIBarButtonItem(customView: logoImageView)
        navigationItem.leftBarButtonItem = logoButtonItem
    }
    
    func setupProfileButton() {
//        let profileImgString = MeStore.shared.me?.profileImgUrl ?? DeviceConst.userDefaultProfileImgUrl
//        guard let profileImgUrl = URL(string: profileImgString) else { return }
        
        let profileImgDiameter: CGFloat = 34.5
        let profileButton = UIButton(frame: CGRect(x: 0, y: 0, width: profileImgDiameter, height: profileImgDiameter))
        profileButton.layer.cornerRadius = profileImgDiameter / 2
        profileButton.clipsToBounds = true
//        profileButton.af_setImage(for: .normal, url: profileImgUrl)
        profileButton.addTarget(self, action: #selector(moveToProfile), for: .touchUpInside)
        if #available(iOS 11.0, *) {
            profileButton.snp.makeConstraints {
                $0.width.height.equalTo(profileImgDiameter)
            }
        }
        
        let profileButtonItem = UIBarButtonItem(customView: profileButton)
        navigationItem.rightBarButtonItem = profileButtonItem
    }
    
    @objc func moveToProfile() {
//        guard let me = MeStore.shared.me else { return }
//        let vc = ProfileViewController.instantiate()
//        vc.user = me
//        self.tabBarController?.tabBar.isHidden = true
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func scrollToTop() {
//
//        if viewControllers.count == 0 {
//            return
//        }
//
//        //TODO: 要確認
//        let viewController = viewControllers[index]//[currentIndex]
//
//        if let controller = viewController as? PostsViewController {
//            controller.collectionView?.setContentOffset(CGPoint.zero, animated: true)
//        } else if let controller = viewController as? UserRankingViewController {
//
//            if let ranking = controller.ranking, ranking.items.count > 0 {
//
//                controller.collectionView.setContentOffset(CGPoint.zero, animated: true)
//            }
//        } else if let controller = viewController as? ArticlesViewController {
//            controller.collectionViewArticle.setContentOffset(CGPoint.zero, animated: true)
//        }
    }
    
    @objc func moveToTimeLine() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
            if let index = self?.tabs.index(where: {$0.type == .discover}) {
                self?.move(to: index, isAnimated: true)
            }
        }
    }
    
    func moveToPrimaryTab() {
        if let tab = targetTab {
            if let index = tabs.index(where: { $0.type == tab }) {
                move(to: index, isAnimated: true)
            }
            targetTab = nil
            return
        }
        
        guard let primaryIndex = tabs.index(where: { $0.type == .mySpace }) else {
            print("tab index nil error")
            return
        }
        if openedByUniversalLink() { return }
        
        move(to: primaryIndex, isAnimated: false)
    }
    
    func moveToTabByType(_ tabType: Tab.TabType) {
        if let index = tabs.index(where: {$0.type == tabType}) {
            move(to: index, isAnimated: true)
        } else if tabs.isEmpty {
            targetTab = tabType
        }
    }
    
    private func request() {
        var tabs = [Tab]()
        
        let tab1: Tab = {
            let tab = Tab()
            tab.id = 1
            tab.title = "My Space"
            tab.codeString = "myspace"
            tab.bannerTypeString = "nothing"
            tab.supplementInfo = "Hello World"
            return tab
        }()
        
        let tab2: Tab = {
            let tab = Tab()
            tab.id = 2
            tab.title = "Skype Lesson"
            tab.codeString = "skype_teachers"
            tab.bannerTypeString = "nothing"
            tab.supplementInfo = "Hello World"
            return tab
        }()
        
        let tab3: Tab = {
            let tab = Tab()
            tab.id = 3
            tab.title = "Events"
            tab.codeString = "events"
            tab.bannerTypeString = "nothing"
            tab.supplementInfo = "Hello World"
            return tab
        }()
        
        let tab4: Tab = {
            let tab = Tab()
            tab.id = 4
            tab.title = "Learn"
            tab.codeString = "articles"
            tab.bannerTypeString = "nothing"
            tab.supplementInfo = "Hello World"
            return tab
        }()
        
        let tab5: Tab = {
            let tab = Tab()
            tab.id = 5
            tab.title = "Discover"
            tab.codeString = "timeline_posts"
            tab.bannerTypeString = "nothing"
            tab.supplementInfo = "Hello World"
            return tab
        }()
        
        let tab6: Tab = {
            let tab = Tab()
            tab.id = 6
            tab.title = "Popular Teachers"
            tab.codeString = "popular_teachers"
            tab.bannerTypeString = "nothing"
            tab.supplementInfo = "Hello World"
            return tab
        }()
        
        let tab7: Tab = {
            let tab = Tab()
            tab.id = 7
            tab.title = "New Teachers"
            tab.codeString = "latest_teachers"
            tab.bannerTypeString = "nothing"
            tab.supplementInfo = "Hello World"
            return tab
        }()
        
        tabs.append(tab1)
        tabs.append(tab2)
        tabs.append(tab3)
        tabs.append(tab4)
        tabs.append(tab5)
        tabs.append(tab6)
        tabs.append(tab7)
        
        self.tabs = tabs
        self.reloadTabs()
    }
    
    @objc private func updateTabIfNeeded() {
        var tabs = [Tab]()
        
        let tab1: Tab = {
            let tab = Tab()
            tab.id = 1
            tab.title = "My Space"
            tab.codeString = "myspace"
            tab.bannerTypeString = "nothing"
            tab.supplementInfo = "Hello World"
            tab.isPrimary = false
            return tab
        }()
        
        let tab2: Tab = {
            let tab = Tab()
            tab.id = 2
            tab.title = "Skype Lesson"
            tab.codeString = "skype_teachers"
            tab.bannerTypeString = "nothing"
            tab.supplementInfo = "Hello World"
            tab.isPrimary = false
            return tab
        }()
        
        let tab3: Tab = {
            let tab = Tab()
            tab.id = 3
            tab.title = "Events"
            tab.codeString = "events"
            tab.bannerTypeString = "nothing"
            tab.supplementInfo = "Hello World"
            tab.isPrimary = false
            return tab
        }()
        
        let tab4: Tab = {
            let tab = Tab()
            tab.id = 4
            tab.title = "Learn"
            tab.codeString = "articles"
            tab.bannerTypeString = "nothing"
            tab.supplementInfo = "Hello World"
            tab.isPrimary = false
            return tab
        }()
        
        let tab5: Tab = {
            let tab = Tab()
            tab.id = 5
            tab.title = "Discover"
            tab.codeString = "timeline_posts"
            tab.bannerTypeString = "nothing"
            tab.supplementInfo = "Hello World"
            tab.isPrimary = false
            return tab
        }()
        
        let tab6: Tab = {
            let tab = Tab()
            tab.id = 6
            tab.title = "Popular Teachers"
            tab.codeString = "popular_teachers"
            tab.bannerTypeString = "nothing"
            tab.supplementInfo = "Hello World"
            tab.isPrimary = false
            return tab
        }()
        
        let tab7: Tab = {
            let tab = Tab()
            tab.id = 7
            tab.title = "New Teachers"
            tab.codeString = "latest_teachers"
            tab.bannerTypeString = "nothing"
            tab.supplementInfo = "Hello World"
            tab.isPrimary = false
            return tab
        }()
        
        tabs.append(tab1)
        tabs.append(tab2)
        tabs.append(tab3)
        tabs.append(tab4)
        tabs.append(tab5)
        tabs.append(tab6)
        tabs.append(tab7)
        self.tabs = tabs
        self.reloadTabs()
        
        for (index, tab) in tabs.enumerated() {
            if !tab.isEqualTo(self.tabs[index]) {
                self.tabs = tabs
                self.reloadTabs()
                break
            }
        }
    }
    
    func reloadTabs() {
        DispatchQueue.main.async {
            self.reloadViewControllers()
            self.moveToPrimaryTab()
        }
    }
    
    func fixViews(_ scroll: CGFloat, _ scrollView: UIScrollView) {
        if scroll > 10 {
            if scrollView.contentOffset.y > 0 {
                if !isBarHidden {
                    self.hideNavBar(animated: true)
                }
            }
        } else if scroll < -10 {
            if isBarHidden {
                self.appearNavBar(animated: true)
            }
        }
    }
    
    func openedByUniversalLink() -> Bool {
        //HomeViewの初期設定がまだの時、moveToPriorityTabで再度呼ばれた時に対応
        if self.tabs.count == 0 {
            return false
        } else {
            guard let actionType = LoadingStore.shared.actionType else {return false}
            switch actionType {
            case "HVevent":
                self.moveToTabByType(.event)
            default:
                break
            }
            LoadingStore.shared.reset()
            return true
        }
    }
}
