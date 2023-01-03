//
//  GADNativeView.swift
//  ViaBrowser
//
//  Created by yangjian on 2023/1/3.
//

import UIKit
import GoogleMobileAds

class GADNativeView: GADNativeAdView {
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var placeholder: UIImageView = {
        let view = UIImageView(image: UIImage(named: "ad_placeholder"))
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var icon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var title: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.hex("#333333")
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var subTitle: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.hex("#737373")
        label.font = UIFont.systemFont(ofSize: 11.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var install: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.hex("#FE5F94")
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var adTag: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.hex("#FEB800")
        label.text = "AD"
        label.font = UIFont.systemFont(ofSize: 9.0)
        label.textColor = UIColor.white
        label.layer.cornerRadius = 6
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupUI() {
        self.addSubview(placeholder)
        NSLayoutConstraint.activate([
            placeholder.topAnchor.constraint(equalTo: self.topAnchor),
            placeholder.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            placeholder.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            placeholder.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        self.addSubview(icon)
        NSLayoutConstraint.activate([
            icon.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            icon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 14),
            icon.widthAnchor.constraint(equalToConstant: 44),
            icon.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        self.addSubview(title)
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: self.topAnchor, constant: 19),
            title.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 8),
            title.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -136)
        ])
        
        self.addSubview(adTag)
        NSLayoutConstraint.activate([
            adTag.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            adTag.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 10),
            adTag.widthAnchor.constraint(equalToConstant: 20.0)
        ])
        
        self.addSubview(subTitle)
        NSLayoutConstraint.activate([
            subTitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 9),
            subTitle.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            subTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -90)
        ])
        
        self.addSubview(install)
        NSLayoutConstraint.activate([
            install.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            install.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -14.0),
            install.widthAnchor.constraint(equalToConstant: 72)
        ])
        
        
    }

    override var nativeAd: GADNativeAd? {
        didSet {
            if let nativeAd = nativeAd {
                
                self.icon.isHidden = false
                self.title.isHidden = false
                self.subTitle.isHidden = false
                self.install.isHidden = false
                self.adTag.isHidden = false
                self.placeholder.isHidden = true
                
                if let image = nativeAd.images?.first?.image {
                    self.icon.image =  image
                }
                self.title.text = nativeAd.headline
                self.subTitle.text = nativeAd.body
                self.install.setTitle(nativeAd.callToAction, for: .normal)
                self.install.setTitleColor(.white, for: .normal)
            } else {
                self.icon.isHidden = true
                self.title.isHidden = true
                self.subTitle.isHidden = true
                self.install.isHidden = true
                self.adTag.isHidden = true
                self.placeholder.isHidden = false
            }
            
            callToActionView = install
            headlineView = title
            bodyView = subTitle
            advertiserView = adTag
            iconView = icon
        }
    }
    
}
