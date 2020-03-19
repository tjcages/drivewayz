//
//  AnalyticsViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/11/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class AnalyticsViewController: UIViewController {

    var delegate: moveControllers?
    let transition = CircularTransition()
    
    var unreadMessages: Int = 0 {
        didSet {
            if self.unreadMessages == 0 {
                self.newMessageNumber.setTitle("", for: .normal)
            } else {
                self.newMessageNumber.setTitle("\(self.unreadMessages)", for: .normal)
            }
        }
    }
    
    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.BLACK
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Analytics"
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
    
    lazy var notificationButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "settingsEmail")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
//        button.addTarget(self, action: #selector(drivewayzMessagePressed), for: .touchUpInside)
        
        return button
    }()

    var newMessageNumber: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.SALMON
        button.layer.cornerRadius = 8
        button.setTitle("", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH6
        button.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        button.isUserInteractionEnabled = false
        button.alpha = 0
        
        return button
    }()
    
    var totalUsersLabel: UILabel = {
        let label = UILabel()
        label.text = "Total users"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = Fonts.SSPSemiBoldH4
        label.textColor = Theme.BLACK
        
        return label
    }()
    
    var totalHostsLabel: UILabel = {
        let label = UILabel()
        label.text = "Total hosts"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = Fonts.SSPSemiBoldH4
        label.textColor = Theme.BLACK
        
        return label
    }()
    
    var loadingLine: LoadingLine = {
        let view = LoadingLine()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        view.backgroundColor = Theme.WHITE
        
        setupViews()
        setupInfo()
        setData()
        observeUnreadMessages()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var gradientHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
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
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 975)
        scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: -16).isActive = true
        
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
        
        gradientContainer.addSubview(loadingLine)
        loadingLine.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        loadingLine.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        loadingLine.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        loadingLine.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
    }
    
    func setupInfo() {
        
        gradientContainer.addSubview(notificationButton)
        notificationButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        notificationButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true
        notificationButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        notificationButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        notificationButton.addSubview(newMessageNumber)
        newMessageNumber.centerYAnchor.constraint(equalTo: notificationButton.bottomAnchor, constant: -4).isActive = true
        newMessageNumber.centerXAnchor.constraint(equalTo: notificationButton.leftAnchor, constant: 4).isActive = true
        newMessageNumber.widthAnchor.constraint(equalToConstant: 20).isActive = true
        newMessageNumber.heightAnchor.constraint(equalTo: newMessageNumber.widthAnchor).isActive = true
        
        scrollView.addSubview(totalUsersLabel)
        totalUsersLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        totalUsersLabel.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: 32).isActive = true
        totalUsersLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        totalUsersLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(totalHostsLabel)
        totalHostsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        totalHostsLabel.topAnchor.constraint(equalTo: totalUsersLabel.bottomAnchor, constant: 4).isActive = true
        totalHostsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        totalHostsLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    func observeUnreadMessages() {
        self.loadingLine.startAnimating()
        let ref = Database.database().reference().child("Messages")
        ref.observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                let message = Message(dictionary: dictionary)
                if let status = message.communicationsStatus, status == "Recent" {
                    self.unreadMessages += 1
                    self.newMessageNumber.alpha = 1
                }
            }
        }
    }
    
    func setData() {
        let ref = Database.database().reference()
        ref.child("users").observeSingleEvent(of: .value) { (snapshot) in
            let count = snapshot.childrenCount
            self.totalUsersLabel.text = "Total users: \(count)"
            self.loadingLine.endAnimating()
        }
        ref.child("ParkingSpots").observeSingleEvent(of: .value) { (snapshot) in
            let count = snapshot.childrenCount
            self.totalHostsLabel.text = "Total hosts: \(count)"
        }
    }
    
    @objc func backButtonPressed() {
        self.loadingLine.endAnimating()
        self.delegate?.dismissActiveController()
        self.dismiss(animated: true) {
            self.backButton.alpha = 0
        }
    }
    
}

extension AnalyticsViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = notificationButton.center
        transition.circleColor = Theme.BLACK
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = notificationButton.center
        transition.circleColor = Theme.BLACK
        delayWithSeconds(animationOut) {
            self.delegate?.defaultContentStatusBar()
        }
        
        return transition
    }
    
}


extension AnalyticsViewController: UIScrollViewDelegate {
    
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}








