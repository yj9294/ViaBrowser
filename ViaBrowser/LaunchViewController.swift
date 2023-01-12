//
//  LaunchViewController.swift
//  ViaBrowser
//
//  Created by yangjian on 2022/12/27.
//

import UIKit

class LaunchViewController: UIViewController {
    
    var timer: Timer? = nil
    
    var adTimer: Timer? = nil
    
    var progress: Double = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        launching()
    }
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "loading…0%"
        label.textColor = UIColor.hex("#FFAAC7")
        return label
    }()
    
    lazy var progressView: UIProgressView = {
        let progress = UIProgressView()
        progress.backgroundColor = UIColor.hex("#FFFFFF", alpha: 0.2)
        progress.tintColor = UIColor.white
        progress.layer.cornerRadius = 4
        progress.layer.masksToBounds = true
        return progress
    }()
    
    func setupUI (){
        let background = UIImageView(image: UIImage(named: "launch_bg"))
        background.contentMode = .scaleAspectFill
        view.addSubview(background)
        background.frame = view.bounds
        
        let icon = UIImageView(image: UIImage(named: "launch_icon"))
        icon.contentMode = .scaleAspectFill
        icon.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(icon)
        NSLayoutConstraint.activate([
            icon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            icon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 140)
        ])
        
        let title = UIImageView(image: UIImage(named: "launch_title"))
        title.contentMode = .scaleAspectFill
        title.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(title)
        NSLayoutConstraint.activate([
            title.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -150),
            title.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -49),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -37),
            progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressView.widthAnchor.constraint(equalToConstant: 280),
            progressView.heightAnchor.constraint(equalToConstant: 4)
        ])
    }
    
    
    func launching() {
        
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        
        if adTimer != nil {
            adTimer?.invalidate()
            adTimer = nil
        }
        
        progress = 0.0
        var duration = 2.5 / 0.6
        var isNeedShowAd = false
        
        self.progressView.progress = Float(progress)
        self.label.text = "loading…0%"
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] t in
            guard let self  = self else { return }
            if self.progress >= 1.0 {
                t.invalidate()
                GADHelper.share.show(.interstitial, from: self) { _ in
                    if self.progress >= 1.0 {
                        rootViewController?.launched()
                    }
                }
            } else {
                self.progress += 1.0 / (duration * 100)
            }
            self.progressView.progress = Float(self.progress)
            if Int(self.progress * 100) >= 100 {
                self.progress = 1.0
            }
            self.label.text = "loading…\(Int(self.progress * 100))%"
            
            if isNeedShowAd, GADHelper.share.isLoaded(.interstitial) {
                duration = 0.1
            }
        }
        
        adTimer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true, block: { t in
            t.invalidate()
            isNeedShowAd = true
            duration = 16.0
        })
        
        GADHelper.share.load(.interstitial)
        GADHelper.share.load(.native)
        
    }

}
