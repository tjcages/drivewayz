//
//  HelpViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 11/26/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class UserHelpViewController: UIViewController {
    
    var delegate: moveControllers?
    var issueKeys: [String: String] = [:]
    var issueOptions: [String] = [] {
        didSet {
            self.issuesTable.reloadData()
        }
    }
    
    lazy var gradientContainer: UIView = {
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
        label.text = "Help"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH1
        
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "exit")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()

    var issuesTable: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(BookingIssuesCell.self, forCellReuseIdentifier: "cellId")
        view.clipsToBounds = true
        view.separatorColor = .clear
        view.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 64, right: 0)
        
        return view
    }()
    
    var contactGraphic: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        let image = UIImage(named: "contactGraphic")
        view.image = image
        
        return view
    }()
    
    var contactGraphicHouse: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        let image = UIImage(named: "contactGraphicHouse")
        view.image = image
        
        return view
    }()
    
    var loadingLine: LoadingLine = {
        let view = LoadingLine()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    func setQuestions() {
        loadingLine.startAnimating()
        self.issueKeys = [:]
        self.issueOptions = []
        let ref = Database.database().reference().child("FrequentlyAskedQuestions").child("QuestionTopics")
        ref.observe(.childAdded) { (snapshot) in
            let key = snapshot.key
            if let value = snapshot.value as? String {
                self.issueKeys[value] = key
                self.issueOptions.append(value)
                self.loadingLine.endAnimating()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.OFF_WHITE
        view.clipsToBounds = true
        
        issuesTable.delegate = self
        issuesTable.dataSource = self
        
        setupViews()
        setupControllers()
        setQuestions()
    }
    
    var gradientHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(issuesTable)
        self.view.addSubview(gradientContainer)
        gradientContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        switch device {
        case .iphone8:
            gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: 140)
                gradientHeightAnchor.isActive = true
        case .iphoneX:
            gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: 160)
                gradientHeightAnchor.isActive = true
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
        
        issuesTable.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        issuesTable.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        issuesTable.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        issuesTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
    func setupControllers() {
        
        gradientContainer.addSubview(loadingLine)
        loadingLine.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        loadingLine.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        loadingLine.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        loadingLine.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        self.view.addSubview(contactGraphic)
        contactGraphic.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        contactGraphic.heightAnchor.constraint(equalToConstant: 160).isActive = true
        contactGraphic.sizeToFit()
        switch device {
        case .iphone8:
            contactGraphic.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -32).isActive = true
        case .iphoneX:
            contactGraphic.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -72).isActive = true
        }
        
        self.view.addSubview(contactGraphicHouse)
        contactGraphicHouse.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 48).isActive = true
        contactGraphicHouse.heightAnchor.constraint(equalToConstant: 160).isActive = true
        contactGraphicHouse.sizeToFit()
        switch device {
        case .iphone8:
            contactGraphicHouse.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -68).isActive = true
        case .iphoneX:
            contactGraphicHouse.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -88).isActive = true
        }
        
    }
    
}


// List all issues
extension UserHelpViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issueOptions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = issuesTable.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! BookingIssuesCell
        cell.selectionStyle = .none
        cell.backgroundColor = Theme.WHITE
        
        if indexPath.row < self.issueOptions.count {
            cell.titleLabel.text = self.issueOptions[indexPath.row]
            cell.titleLabel.font = Fonts.SSPRegularH3
            cell.expandButton.alpha = 1
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = BookingIssueViewController()
        let title = self.issueOptions[indexPath.row]
        if let key = self.issueKeys[title] {
            self.navigationController?.pushViewController(controller, animated: true)
            controller.mainIssue = title
            let question = key.components(separatedBy: CharacterSet.decimalDigits).joined()
            controller.setQuestions(question: question)
            controller.gradientHeightAnchor = self.gradientHeightAnchor.constant
            controller.mainLabel.transform = self.mainLabel.transform
        }
    }
    
}


extension UserHelpViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        let state = scrollView.panGestureRecognizer.state
        var totalHeight: CGFloat = 0.0
        switch device {
        case .iphone8:
            totalHeight = 140
        case .iphoneX:
            totalHeight = 160
        }
        if state == .changed {
            if translation > 0 && translation < 60 {
                let percent = translation/60
                self.gradientHeightAnchor.constant = totalHeight - percent * 60
                self.mainLabel.transform = CGAffineTransform(scaleX: 1 - 0.2 * percent, y: 1 - 0.2 * percent)
            }
        } else {
            let translation = scrollView.contentOffset.y
            if translation < 0 && self.gradientHeightAnchor.constant != totalHeight {
                self.scrollExpanded()
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.contentOffset.y
        if translation >= 55 {
            self.scrollMinimized()
        } else {
            self.scrollExpanded()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        if translation >= 55 {
            self.scrollMinimized()
        } else {
            self.scrollExpanded()
        }
    }
    
    func scrollExpanded() {
        switch device {
        case .iphone8:
            self.gradientHeightAnchor.constant = 140
        case .iphoneX:
            self.gradientHeightAnchor.constant = 160
        }
        UIView.animate(withDuration: animationOut, animations: {
            self.mainLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func scrollMinimized() {
        switch device {
        case .iphone8:
            self.gradientHeightAnchor.constant = 80
        case .iphoneX:
            self.gradientHeightAnchor.constant = 100
        }
        UIView.animate(withDuration: animationOut, animations: {
            self.mainLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    @objc func backButtonPressed() {
        self.delegate?.dismissActiveController()
        self.dismiss(animated: true) {
            self.backButton.alpha = 0
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
