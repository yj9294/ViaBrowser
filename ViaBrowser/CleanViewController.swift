//
//  CleanViewController.swift
//  ViaBrowser
//
//  Created by yangjian on 2022/12/29.
//

import UIKit

class CleanViewController: UIViewController {
    
    var timer: Timer? = nil
    var adTimer: Timer? = nil
    
    var cleanHandle: (()->Void)? = nil
    
    lazy var icon1: UIImageView = {
        let icon1 = UIImageView(image: UIImage(named: "clean_icon_1"))
        icon1.translatesAutoresizingMaskIntoConstraints = false
        return icon1
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        var progress = 0.0
        var duration = 2 / 0.6
        var isNeedShowAd = false
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] t in
            if progress >= 1.0 {
                t.invalidate()
                GADHelper.share.show(.interstitial, from: self) { _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self?.stopAnimation()
                        self?.dismiss()
                    }
                }
            } else {
                progress += 1.0 / (duration * 100)
            }
            
            if isNeedShowAd, GADHelper.share.isLoaded(.interstitial) {
                duration = 0.1
            }
        }
        
        adTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { t in
            t.invalidate()
            isNeedShowAd = true
            duration = 16.0
        })
        
        GADHelper.share.load(.interstitial)
        GADHelper.share.load(.native)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        starAnimation()
    }

    func setupUI(){
        let bg = UIImageView(image: UIImage(named: "clean_bg"))
        bg.contentMode = .scaleAspectFill
        bg.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bg)
        NSLayoutConstraint.activate([
            bg.topAnchor.constraint(equalTo: view.topAnchor),
            bg.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bg.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bg.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(icon1)
        NSLayoutConstraint.activate([
            icon1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            icon1.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100)
        ])
        
        
        
        let icon = UIImageView(image: UIImage(named: "clean_icon"))
        icon.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(icon)
        NSLayoutConstraint.activate([
            icon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100)
        ])
        
        
        
        
        let label = UILabel()
        label.textColor = .white
        label.text = "Cleaning..."
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 100),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func starAnimation() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.toValue = Double.pi * 2
        rotateAnimation.duration = 5
        rotateAnimation.repeatCount = .infinity
        icon1.layer.add(rotateAnimation, forKey: "rotate")
    }
    
    func stopAnimation() {
        icon1.layer.removeAllAnimations()
    }
    
    func dismiss() {
        self.dismiss(animated: true)
        cleanHandle?()
    }
}
