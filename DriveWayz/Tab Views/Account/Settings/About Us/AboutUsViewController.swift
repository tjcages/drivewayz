//
//  AboutUsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/11/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    var delegate: changeSettingsHandler?
    let cellId = "cellId"
    var options: [String] = ["Frequently Asked Questions", "Host Policies", "Host Regulations","Terms & Conditions", "Privacy Policy"]
    
    var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "About us"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH1
        label.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var optionsTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(BookingIssuesCell.self, forCellReuseIdentifier: "cellId")
        view.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 48, right: 0)
        view.separatorColor = .clear
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        
        view.backgroundColor = Theme.WHITE
        
        setupViews()
    }
    
    var gradientHeightAnchor: CGFloat = 160
    
    func setupViews() {
        
        self.view.addSubview(gradientContainer)
        gradientContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        switch device {
        case .iphone8:
            gradientContainer.heightAnchor.constraint(equalToConstant: gradientHeightAnchor).isActive = true
        case .iphoneX:
            gradientContainer.heightAnchor.constraint(equalToConstant: gradientHeightAnchor).isActive = true
        }
        
        self.view.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        switch device {
        case .iphone8:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 28).isActive = true
        case .iphoneX:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 48).isActive = true
        }
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: -16).isActive = true
        
        self.view.addSubview(optionsTableView)
        optionsTableView.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        optionsTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        optionsTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        optionsTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
    func moveToTerms() {
        let controller = ReadPoliciesViewController()
        controller.Url = URL(string: "http://www.drivewayz.io/terms.html")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func moveToPrivacy() {
        let controller = ReadPoliciesViewController()
        controller.Url = URL(string: "http://www.drivewayz.io/privacy.html")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func moveToFAQ() {
        let controller = ReadPoliciesViewController()
        controller.Url = URL(string: "http://www.drivewayz.io/faqs.html")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func moveToHostPolicies() {
        let controller = ReadPoliciesViewController()
        controller.Url = URL(string: "http://www.drivewayz.io/host-policies.html")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func moveToHostRegulations() {
        let controller = ReadPoliciesViewController()
        controller.Url = URL(string: "http://www.drivewayz.io/rules--regulations.html")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}


extension AboutUsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = optionsTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! BookingIssuesCell
        cell.selectionStyle = .none
        tableView.separatorStyle = .singleLine
        cell.separatorInset = UIEdgeInsets(top: 0, left: 58, bottom: 0, right: 0)
        if indexPath.row == 1 {
            tableView.separatorStyle = .none
        }
        if options.count > indexPath.row {
            cell.titleLabel.text = options[indexPath.row]
            cell.titleLabel.font = Fonts.SSPRegularH3
            cell.expandButton.alpha = 1
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if options.count > indexPath.row {
            let title = options[indexPath.row]
            if title == "Terms & Conditions" {
                self.moveToTerms()
            } else if title == "Privacy Policy" {
                self.moveToPrivacy()
            } else if title == "Frequently Asked Questions" {
                self.moveToFAQ()
            } else if title == "Host Policies" {
                self.moveToHostPolicies()
            } else if title == "Host Regulations" {
                self.moveToHostRegulations()
            }
        }
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
