//
//  PrivacyViewController.swift
//  ViaBrowser
//
//  Created by yangjian on 2022/12/28.
//

import UIKit

class PrivacyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        self.title = "Privacy Policy"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "common_back"), style: .plain, target: self, action: #selector(backAction))
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    func setupUI(){
        view.backgroundColor = UIColor.hex("#FAFAFA")
        let textView = UITextView()
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.text = """
The following terms and conditions (the “Terms”) govern your use of the VPN services we provide (the “Service”) and their associated website domains (the “Site”). These Terms constitute a legally binding agreement (the “Agreement”) between you and Tap VPN. (the “Tap VPN”).

Activation of your account constitutes your agreement to be bound by the Terms and a representation that you are at least eighteen (18) years of age, and that the registration information you have provided is accurate and complete.

Tap VPN may update the Terms from time to time without notice. Any changes in the Terms will be incorporated into a revised Agreement that we will post on the Site. Unless otherwise specified, such changes shall be effective when they are posted. If we make material changes to these Terms, we will aim to notify you via email or when you log in at our Site.

By using Tap VPN
You agree to comply with all applicable laws and regulations in connection with your use of this service.regulations in connection with your use of this service.
"""
        view.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
            
        ])
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }

}
