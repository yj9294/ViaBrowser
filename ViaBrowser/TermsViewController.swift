//
//  TermsViewController.swift
//  ViaBrowser
//
//  Created by yangjian on 2022/12/28.
//

import UIKit

class TermsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        self.title = "Terms of Use"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "common_back"), style: .plain, target: self, action: #selector(backAction))
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    func setupUI() {
        view.backgroundColor = UIColor.hex("#FAFAFA")
        let textView = UITextView()
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.text = """
Please read these Terms of Use in detail
Use of the application
You accept that you may not use this application for illegal purposes
You accept that we may discontinue the service of the application at any time without prior notice to you
You accept using our application in accordance with the terms of this page, if you reject the terms of this page, please do not use our services
Update
We may update our Terms of Use from time to time. We recommend that you review these Terms of Use periodically for changes.
Contact us
If you have any questions about these Terms of Use, please contact us
viab123456@outlook.com
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
