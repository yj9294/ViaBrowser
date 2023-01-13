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
Please read this Privacy Policy in detail
Collection of information
Via Browser collects the following information about you.
Personally Identifiable Information: When using our Services, we may ask you to provide us with certain personally identifiable information that can be used to contact or identify you
Usage Data: Data about you when you visit our website. This includes, but is not limited to, your IP address, browser type, browser version, the pages of our services you visit, the time and date of your visit, and the time spent on those pages
Usage and Diagnostic Data: Data collected when you use our applications. This may include the type of mobile device you use, your mobile device unique identifier, the IP address of your mobile device, your mobile operating system, the type of mobile Internet browser you use, unique device identifier
Use and Disclosure of Information
To maintain and improve our Apps
Get in touch with you when you need it
Provide analysis or valuable information on how our application is being used so that we can improve the service
monitor the use of the Service and detect, prevent and resolve technical problems
We may disclose your information for the following purposes.
comply with our obligations under the law and to protect our rights or property
Our third party partners and service providers have access to your information, and we do not control and are not responsible for the actions of these third parties. If you wish, please visit the Privacy Policy for yourself
Children's Privacy
Our services are not directed to persons under the age of 18. We do not knowingly collect personally identifiable information from people under the age of 18. If you are a parent or guardian and you are aware that your child has provided personal data to us, please contact us. If we become aware that we have collected personal data from a child without verifying parental consent, we will take steps to remove that information from our servers.
Update
We may update our privacy policy from time to time. We recommend that you review this Privacy Policy periodically for changes.
Contact us
If you have any questions about this Privacy Policy, please contact us
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
