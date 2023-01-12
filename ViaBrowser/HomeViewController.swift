//
//  HomeViewController.swift
//  ViaBrowser
//
//  Created by yangjian on 2022/12/28.
//

import UIKit
import WebKit
import AppTrackingTransparency

class HomeViewController: UIViewController {
    
    enum Item: String, CaseIterable {
        case facebook, google, youtube, twitter, instagram, amazon, tiktok, yahoo
        var title: String {
            return "\(self)".capitalized
        }
        var url: String {
            return "https://www.\(self).com"
        }
        var icon: String {
            return "home_\(self)"
        }
    }
    
    var startDate: Date? = nil
    
    var willAppear: Bool = false
    
    var webView: WKWebView {
        BrowserUtil.shared.webItem.webView
    }
    
    lazy var adView: GADNativeView = {
        let view = GADNativeView()
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search or enter URL"
        textField.textColor = UIColor.hex("#FF6292")
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "home_search"), for: .normal)
        button.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "home_cancel"), for: .normal)
        button.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.backgroundColor = UIColor.hex("#B29EA4")
        progressView.tintColor = UIColor.hex("#FD3D7E")
        progressView.isHidden = true
        return progressView
    }()
    
    lazy var navigationView: UIView = {
        let navigationView = UIView()
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        return navigationView
    }()
    
    lazy var lastButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "home_last"), for: .normal)
        button.setImage(UIImage(named: "home_last_1"), for: .disabled)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(lastAction), for: .touchUpInside)
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "home_next"), for: .normal)
        button.setImage(UIImage(named: "home_next_1"), for: .disabled)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        return button
    }()
    
    lazy var cleanButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "home_clean"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cleanAction), for: .touchUpInside)
        return button
    }()
    
    lazy var tabButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "home_tab"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tabAction), for: .touchUpInside)
        return button
    }()
    
    lazy var settingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "home_setting"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(settingAction), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setupUI()
        layoutViews()
        NotificationCenter.default.addObserver(forName: .nativeUpdate, object: nil, queue: .main) { [weak self] noti in
            if let ad = noti.object as? NativeADModel, self?.willAppear == true {
                if Date().timeIntervalSince1970 - (GADHelper.share.homeNativeAdImpressionDate ?? Date(timeIntervalSinceNow: -11)).timeIntervalSince1970 > 10 {
                    self?.adView.nativeAd = ad.nativeAd
                    GADHelper.share.homeNativeAdImpressionDate = Date()
                } else {
                    NSLog("[ad] 10s home 原生广告刷新或数据填充间隔.")
                }
            } else {
                self?.adView.nativeAd = nil
            }
        }
        ATTrackingManager.requestTrackingAuthorization { _ in
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if webView.superview != nil {
            webView.frame = navigationView.frame
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        willAppear = true
        
        layoutViews()
        GADHelper.share.load(.native)
        GADHelper.share.load(.interstitial)
        
        AnalyticsHelper.log(event: .homeShow)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        willAppear = false
        
        GADHelper.share.close(.native)
    }
    
    func setupUI() {
        view.backgroundColor = UIColor.hex("#FAFAFA")
        
        let searchView = UIView()
        searchView.backgroundColor = UIColor.hex("#FFE5ED")
        searchView.layer.cornerRadius = 12
        searchView.layer.masksToBounds = true
        searchView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchView)
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            searchView.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        searchView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.centerYAnchor.constraint(equalTo: searchView.centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: searchView.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: searchView.trailingAnchor, constant: -52)
        ])
        
        searchView.addSubview(searchButton)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchButton.centerYAnchor.constraint(equalTo: searchView.centerYAnchor),
            searchButton.trailingAnchor.constraint(equalTo: searchView.trailingAnchor, constant: -16)
        ])
        
        searchView.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelButton.centerYAnchor.constraint(equalTo: searchView.centerYAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: searchView.trailingAnchor, constant: -16)
        ])
        
        view.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 12),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2)
        ])
        
        view.addSubview(navigationView)
        NSLayoutConstraint.activate([
            navigationView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 5),
            navigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -64)
        ])
        
        
        let icon = UIImageView(image: UIImage(named: "home_title"))
        icon.translatesAutoresizingMaskIntoConstraints = false
        navigationView.addSubview(icon)
        NSLayoutConstraint.activate([
            icon.topAnchor.constraint(equalTo: navigationView.topAnchor, constant: 10),
            icon.centerXAnchor.constraint(equalTo: navigationView.centerXAnchor)
        ])
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 60, height: 70)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 30
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(HomeItemCell.classForCoder(), forCellWithReuseIdentifier: "HomeItemCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        navigationView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: -60),
            collectionView.leadingAnchor.constraint(equalTo: navigationView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: navigationView.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        
        navigationView.addSubview(adView)
        NSLayoutConstraint.activate([
            adView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            adView.leadingAnchor.constraint(equalTo: navigationView.leadingAnchor, constant: 16),
            adView.trailingAnchor.constraint(equalTo: navigationView.trailingAnchor, constant: -16),
            adView.heightAnchor.constraint(equalToConstant: 76)
        ])
        
        let bottomView = UIView()
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomView)
        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 64)
        ])
        
        bottomView.addSubview(lastButton)
        NSLayoutConstraint.activate([
            lastButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            lastButton.topAnchor.constraint(equalTo: bottomView.topAnchor),
            lastButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor),
        ])
        
        bottomView.addSubview(nextButton)
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: lastButton.trailingAnchor),
            nextButton.topAnchor.constraint(equalTo: bottomView.topAnchor),
            nextButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor),
        ])
        
        bottomView.addSubview(cleanButton)
        NSLayoutConstraint.activate([
            cleanButton.leadingAnchor.constraint(equalTo: nextButton.trailingAnchor),
            cleanButton.topAnchor.constraint(equalTo: bottomView.topAnchor),
            cleanButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor),
        ])
        
        bottomView.addSubview(tabButton)
        NSLayoutConstraint.activate([
            tabButton.leadingAnchor.constraint(equalTo: cleanButton.trailingAnchor),
            tabButton.topAnchor.constraint(equalTo: bottomView.topAnchor),
            tabButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor),
        ])
        
        bottomView.addSubview(settingButton)
        NSLayoutConstraint.activate([
            settingButton.leadingAnchor.constraint(equalTo: tabButton.trailingAnchor),
            settingButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            settingButton.topAnchor.constraint(equalTo: bottomView.topAnchor),
            settingButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor),
            settingButton.widthAnchor.constraint(equalTo: lastButton.widthAnchor),
            settingButton.widthAnchor.constraint(equalTo: nextButton.widthAnchor),
            settingButton.widthAnchor.constraint(equalTo: cleanButton.widthAnchor),
            settingButton.widthAnchor.constraint(equalTo: tabButton.widthAnchor),
        ])
        
    }
    
    func layoutViews() {
        lastButton.isEnabled = webView.canGoBack
        nextButton.isEnabled = webView.canGoForward
        
        progressView.isHidden = !webView.isLoading
        textField.text = webView.url?.absoluteString ?? ""
        searchButton.isHidden = webView.isLoading
        cancelButton.isHidden = !webView.isLoading
        
        tabButton.setTitle("\(BrowserUtil.shared.webItems.count)", for: .normal)
        tabButton.setTitleColor(.black, for: .normal)
        tabButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -35, bottom: 0, right: 0)
        
        view.subviews.forEach {
            if $0 is WKWebView {
                $0.removeFromSuperview()
            }
        }
        if !BrowserUtil.shared.webItem.isNavigation, webView.url != nil {
            view.insertSubview(webView, aboveSubview: navigationView)
            webView.navigationDelegate = self
            webView.uiDelegate = self
            webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
            webView.addObserver(self, forKeyPath: #keyPath(WKWebView.url), context: nil)
        }
    }
}

extension HomeViewController {
    @objc func searchAction() {
        textField.resignFirstResponder()
        guard let url = textField.text, url.count != 0 else {
            self.alert("Please enter your search content.")
            return
        }
        searchButton.isHidden = true
        cancelButton.isHidden = false
        progressView.isHidden = false
        BrowserUtil.shared.webItem.loadUrl(url, from: self)
        
        AnalyticsHelper.log(event: .navigaSearch, params: ["lig": textField.text ?? ""])
    }
    
    @objc func cancelAction() {
        searchButton.isHidden = false
        cancelButton.isHidden = true
        BrowserUtil.shared.webItem.stopLoad()
        BrowserUtil.shared.webItem.webView.removeFromSuperview()
    }
    
    @objc func lastAction() {
        textField.resignFirstResponder()
        BrowserUtil.shared.webItem.webView.goBack()
    }
    
    
    @objc func nextAction() {
        textField.resignFirstResponder()
        BrowserUtil.shared.webItem.webView.goForward()
    }
    
    @objc func cleanAction() {
        textField.resignFirstResponder()
        let settingView = CleanAlertView()
        view.addSubview(settingView)
        settingView.cleanHandle = {
            let vc = CleanViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.cleanHandle = {
                AnalyticsHelper.log(event: .cleanSuccess)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if rootViewController?.selectedIndex == 1 {
                        self.alert("Cleaned Successfully.")
                        AnalyticsHelper.log(event: .cleanAlert)
                    }
                }
                BrowserUtil.shared.clean(from: self)
            }
            self.present(vc, animated: true)
        }
        settingView.frame = self.view.bounds
        
        AnalyticsHelper.log(event: .cleanClick)
    }
    
    @objc func tabAction() {
        textField.resignFirstResponder()
        let vc = TabViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc func settingAction() {
        textField.resignFirstResponder()
        let settingView = SettingView()
        view.addSubview(settingView)
        settingView.layoutHandle = {
            self.layoutViews()
        }
        settingView.frame = self.view.bounds
    }
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Item.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeItemCell", for: indexPath)
        if let cell = cell as? HomeItemCell {
            cell.item = Item.allCases[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        textField.text = Item.allCases[indexPath.row].url
        searchButton.isHidden = true
        cancelButton.isHidden = false
        progressView.isHidden = false
        BrowserUtil.shared.webItem.loadUrl(textField.text ?? "", from: self)
        AnalyticsHelper.log(event: .navigaClick, params: ["lig": textField.text ?? ""])
    }
}


class HomeItemCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    lazy var icon: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.hex("#333333")
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.backgroundColor = .clear
        addSubview(icon)
        NSLayoutConstraint.activate([
            icon.topAnchor.constraint(equalTo: self.topAnchor),
            icon.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            icon.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            icon.widthAnchor.constraint(equalTo: icon.heightAnchor)
        ])
        
        addSubview(title)
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            title.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 10)
        ])
    }
    
    var item: HomeViewController.Item? = nil {
        didSet {
            icon.image = UIImage(named: item?.icon ?? "")
            title.text = item?.title
        }
    }
}

extension HomeViewController {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // url重定向
        if keyPath == #keyPath(WKWebView.url) {
            textField.text = webView.url?.absoluteString
        }
        
        // 进度
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            let progress: Float = Float(webView.estimatedProgress)
            debugPrint(progress)
            searchButton.isSelected = true
            UIView.animate(withDuration: 0.25) {
                self.progressView.progress = progress
            }
            
            if progress == 0.1 {
                startDate = Date()
                AnalyticsHelper.log(event: .webStart)
            }
            
            // 加载完成
            if progress == 1.0 {
                progressView.isHidden = true
                progressView.progress = 0.0
                searchButton.isSelected = false
                let time = Date().timeIntervalSince1970 - startDate!.timeIntervalSince1970
                AnalyticsHelper.log(event: .webSuccess, params: ["lig": "\(ceil(time))"])
            } else {
                progressView.isHidden = false
            }
        }
    }
}

extension HomeViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchAction()
        return true
    }
}


extension HomeViewController: WKUIDelegate, WKNavigationDelegate {
    /// 跳转链接前是否允许请求url
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
        lastButton.isEnabled = webView.canGoBack
        nextButton.isEnabled = webView.canGoForward
        return .allow
    }
    
    /// 响应后是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse) async -> WKNavigationResponsePolicy {
        lastButton.isEnabled = webView.canGoBack
        nextButton.isEnabled = webView.canGoForward
        return .allow
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        /// 打开新的窗口
        lastButton.isEnabled = webView.canGoBack
        nextButton.isEnabled = webView.canGoForward

        webView.load(navigationAction.request)
        return nil
    }
}
