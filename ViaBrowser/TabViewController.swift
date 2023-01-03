//
//  TabViewController.swift
//  ViaBrowser
//
//  Created by yangjian on 2022/12/28.
//

import UIKit

class TabViewController: UIViewController {
    
    var willAppear = false
    
    lazy var adView: GADNativeView = {
        let view = GADNativeView()
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        NotificationCenter.default.addObserver(forName: .nativeUpdate, object: nil, queue: .main) { [weak self] noti in
            if let ad = noti.object as? NativeADModel, self?.willAppear == true {
                if Date().timeIntervalSince1970 - (GADHelper.share.tabNativeAdImpressionDate ?? Date(timeIntervalSinceNow: -11)).timeIntervalSince1970 > 10 {
                    self?.adView.nativeAd = ad.nativeAd
                    GADHelper.share.tabNativeAdImpressionDate = Date()
                } else {
                    NSLog("[ad] 10s tab 原生广告刷新或数据填充间隔.")
                }
            } else {
                self?.adView.nativeAd = nil
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        willAppear = true
        GADHelper.share.load(.interstitial)
        GADHelper.share.load(.native)
        AnalyticsHelper.log(event: .tabShow)
    }
    
    func setupUI() {
        
        view.backgroundColor = UIColor.hex("#FAFAFA")
        
        view.addSubview(adView)
        NSLayoutConstraint.activate([
            adView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            adView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            adView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        let flowLayout = UICollectionViewFlowLayout()
        let width = ((view.window?.bounds.width ?? 375.0) - 16 * 2 - 14) / 2.0
        flowLayout.itemSize = CGSize(width: width, height: width * 1.33)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(TabItemCell.classForCoder(), forCellWithReuseIdentifier: "TabItemCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: adView.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        let bottomView = UIView()
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomView)
        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 64)
        ])
        
        let backButton = UIButton()
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(named: "tab_back"), for: .normal)
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor)
        ])
        
        let addButton = UIButton()
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setImage(UIImage(named: "tab_add"), for: .normal)
        addButton.addTarget(self, action: #selector(newAction), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            addButton.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor)
        ])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        willAppear = false
        GADHelper.share.close(.native)
    }
    

}

extension TabViewController {
    @objc func backAction() {
        self.dismiss(animated: true)
    }
    
    @objc func newAction() {
        BrowserUtil.shared.add()
        self.dismiss(animated: true)
        
        AnalyticsHelper.log(event: .tabNew, params: ["lig": "tab"])
    }
}

extension TabViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return BrowserUtil.shared.webItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabItemCell", for: indexPath)
        if let cell = cell as? TabItemCell {
            let item = BrowserUtil.shared.webItems[indexPath.row]
            cell.item = item
            cell.closeHandle = { [weak collectionView] in
                BrowserUtil.shared.removeItem(item)
                collectionView?.reloadData()
            }
        }
        cell.layer.cornerRadius = 12
        cell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = BrowserUtil.shared.webItems[indexPath.row]
        BrowserUtil.shared.select(item)
        self.dismiss(animated: true)
    }
}

class TabItemCell: UICollectionViewCell {
    
    var closeHandle: (()->Void)? = nil
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.hex("#737373")
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var icon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "tab_icon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var close: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "tab_close"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(title)
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            title.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32)
        ])
        
        addSubview(close)
        NSLayoutConstraint.activate([
            close.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            close.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
        
        addSubview(icon)
        NSLayoutConstraint.activate([
            icon.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    var item: WebViewItem? = nil {
        didSet {
            title.text = item?.webView.url?.absoluteString
            
            if item?.isSelect == true {
                self.backgroundColor = UIColor.hex("#FD3D7E")
            } else {
                self.backgroundColor = .gray
            }
            
            if BrowserUtil.shared.webItems.count == 1 {
                close.isHidden = true
            } else {
                close.isHidden = false
            }
            
        }
    }
    
    @objc func closeAction() {
        closeHandle?()
    }
}
