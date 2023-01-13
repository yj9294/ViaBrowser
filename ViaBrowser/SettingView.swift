//
//  SettingView.swift
//  ViaBrowser
//
//  Created by yangjian on 2022/12/28.
//

import UIKit
import MobileCoreServices

class SettingView: UIView {
    
    var layoutHandle: (()->Void)? = nil
    
    enum Item: String, CaseIterable {
        case new, share, copy, terms, rate, privacy
        var title: String {
            if self == .terms {
                return "Terms of Use"
            } else if self == .privacy {
                return "Privacy Policy"
            } else if self == .rate {
                return "Rate us"
            }
            return "\(self)".capitalized
        }
        var icon: String {
            return "setting_\(self)"
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        self.backgroundColor = UIColor.hex("#000000", alpha: 0.7)
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
        self.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        
        let contentView = UIImageView(image: UIImage(named: "setting_bg"))
        contentView.contentMode = .scaleAspectFill
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -90),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            contentView.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        let layout = UICollectionViewFlowLayout()
        let width = (kWidth - 10 * 2 - 114 * 3) / 2.0
        layout.itemSize = CGSize(width: 114, height: 70)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = width
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(SettingItemCell.classForCoder(), forCellWithReuseIdentifier: "SettingItemCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        self.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    @objc func dismiss() {
        self.removeFromSuperview()
    }
    

}

extension SettingView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Item.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SettingItemCell", for: indexPath)
        if let cell = cell as? SettingItemCell {
            cell.item = Item.allCases[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = Item.allCases[indexPath.row]
        switch item {
        case .new:
            BrowserUtil.shared.add()
            layoutHandle?()
            AnalyticsHelper.log(event: .tabNew, params: ["lig": "setting"])
        case .share:
            var url = "https://itunes.apple.com/cn/app/id1664695100"
            if !BrowserUtil.shared.webItem.isNavigation {
                url = BrowserUtil.shared.webItem.webView.url?.absoluteString ?? "https://itunes.apple.com/cn/app/id1664695100"
            }
            let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            rootViewController?.present(vc, animated: true)
            AnalyticsHelper.log(event: .shareClick)
        case .copy:
            if !BrowserUtil.shared.webItem.isNavigation {
                UIPasteboard.general.setValue(BrowserUtil.shared.webItem.webView.url?.absoluteString ?? "", forPasteboardType: kUTTypePlainText as String)
                rootViewController?.alert("Copy successfully.")
            } else {
                UIPasteboard.general.setValue("", forPasteboardType: kUTTypePlainText as String)
                rootViewController?.alert("Copy successfully.")
            }
            AnalyticsHelper.log(event: .copyClick)
        case .terms:
            let vc = TermsViewController()
            rootViewController?.home.pushViewController(vc, animated: true)
        case .rate:
            let url = URL(string: "https://itunes.apple.com/cn/app/id1664695100")
            if let url = url {
                UIApplication.shared.open(url)
            }
        case .privacy:
            let vc = PrivacyViewController()
            rootViewController?.home.pushViewController(vc, animated: true)
        }
        self.dismiss()
    }
}

class SettingItemCell: UICollectionViewCell {
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.backgroundColor = .clear
        addSubview(icon)
        NSLayoutConstraint.activate([
            icon.topAnchor.constraint(equalTo: self.topAnchor),
            icon.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            icon.widthAnchor.constraint(equalTo: icon.heightAnchor)
        ])
        
        addSubview(title)
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            title.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 10)
        ])
    }
    
    var item: SettingView.Item? = nil {
        didSet {
            icon.image = UIImage(named: item?.icon ?? "")
            title.text = item?.title
        }
    }
}
