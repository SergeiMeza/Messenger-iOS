import UIKit
import WebKit

class SiteWebViewController: UIViewController, WKUIDelegate {
    
    private let webView = WKWebView()
    private let progressView = UIProgressView()
    private let url: URL
    
    init(url: URL, title: String?) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigationBarBackButton()
        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        openURL()
    }
    
    private func setupViews() {
        navigationController?.navigationBar.addSubview(progressView)
        progressView.progressTintColor = UIColor.themeColor
        progressView.trackTintColor = UIColor.light100
        progressView.snp.makeConstraints { maker in
            maker.leading.trailing.bottom.equalToSuperview()
        }
        
        view.addSubview(webView)
        webView.snp.makeConstraints { maker in
            maker.trailing.leading.equalToSuperview()
            if #available(iOS 11, *) {
                maker.bottom.top.equalTo(view.safeAreaLayoutGuide)
            } else {
                maker.top.equalTo(topLayoutGuide.snp.bottom)
                maker.bottom.equalTo(bottomLayoutGuide.snp.top)
            }
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        webView.removeObserver(self, forKeyPath: "loading")
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        super.viewDidDisappear(animated)
    }
    
    private func openURL() {
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        
        switch keyPath ?? "" {
        case "loading":
            self.progressView.setProgress(webView.isLoading ? 0.1 : 0, animated: webView.isLoading)
        case "estimatedProgress":
            self.progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        default:
            break
        }
    }
    
}
