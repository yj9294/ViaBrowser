//
//  CleanAlertView.swift
//  ViaBrowser
//
//  Created by yangjian on 2022/12/29.
//

import UIKit

class CleanAlertView: UIView {
    
    var cleanHandle: (()->Void)? = nil

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
        
        let bg = UIImageView(image: UIImage(named: "clean_content"))
        bg.contentMode = .scaleAspectFill
        bg.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bg)
        NSLayoutConstraint.activate([
            bg.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            bg.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            bg.widthAnchor.constraint(equalToConstant: 288),
            bg.heightAnchor.constraint(equalToConstant: 233)
        ])
        
        let icon = UIImageView(image: UIImage(named: "clean_icon"))
        icon.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(icon)
        NSLayoutConstraint.activate([
            icon.topAnchor.constraint(equalTo: bg.topAnchor, constant: 28),
            icon.centerXAnchor.constraint(equalTo: bg.centerXAnchor)
        ])

        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.hex("#FE5F94")
        button.layer.cornerRadius = 22
        button.layer.masksToBounds = true
        button.setTitle("Clean", for: .normal)
        button.addTarget(self, action: #selector(cleanAction), for: .touchUpInside)
        self.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 24),
            button.widthAnchor.constraint(equalToConstant: 152),
            button.heightAnchor.constraint(equalToConstant: 44),
            button.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    
    @objc func cleanAction() {
        dismiss()
        cleanHandle?()
    }
    
    @objc func dismiss() {
        self.removeFromSuperview()
    }
}
