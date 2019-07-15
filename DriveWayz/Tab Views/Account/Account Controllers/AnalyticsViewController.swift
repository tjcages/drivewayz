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
    var statusBarColor = false
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
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Analytics"
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPBoldH1
        
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY
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
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        button.addTarget(self, action: #selector(drivewayzMessagePressed), for: .touchUpInside)
        button.backgroundColor = Theme.WHITE
        
        return button
    }()
    
    var backgroundCircle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.borderColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.05).cgColor
        view.layer.borderWidth = 80
        view.layer.cornerRadius = 180
        
        return view
    }()
    
    var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsHorizontalScrollIndicator = false
        
        return scroll
    }()
    
    var newMessageNumber: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.STRAWBERRY_PINK
        button.layer.cornerRadius = 10
        button.setTitle("", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH6
        button.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        button.isUserInteractionEnabled = false
        button.alpha = 0
        
        return button
    }()
    
//    lazy var retentionController: RetentionViewController = {
//        let controller = RetentionViewController()
//        self.addChild(controller)
//        controller.view.translatesAutoresizingMaskIntoConstraints = false
//        controller.title = "Retention"
//
//        return controller
//    }()
//
//    lazy var newUsersController: NewUsersViewController = {
//        let controller = NewUsersViewController()
//        self.addChild(controller)
//        controller.view.translatesAutoresizingMaskIntoConstraints = false
//        controller.title = "New Users"
//
//        return controller
//    }()
//
//    var newUsersLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "New Users"
//        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
//        label.font = Fonts.SSPRegularH2
//
//        return label
//    }()
//
//    lazy var profitsController: ProfitsViewController = {
//        let controller = ProfitsViewController()
//        self.addChild(controller)
//        controller.view.translatesAutoresizingMaskIntoConstraints = false
//        controller.title = "Profits"
//
//        return controller
//    }()
//
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        view.backgroundColor = Theme.WHITE
        
        setupViews()
        setData()
        observeUnreadMessages()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var gradientHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(backgroundCircle)
        backgroundCircle.centerXAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        backgroundCircle.centerYAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
        backgroundCircle.widthAnchor.constraint(equalToConstant: 360).isActive = true
        backgroundCircle.heightAnchor.constraint(equalTo: backgroundCircle.widthAnchor).isActive = true
        
        self.view.addSubview(scrollView)
        self.view.addSubview(gradientContainer)
        scrollView.contentSize = CGSize(width: phoneWidth, height: 600)
        scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: 500).isActive = true
        scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        gradientContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        switch device {
        case .iphone8:
            gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: 160)
                gradientHeightAnchor.isActive = true
        case .iphoneX:
            gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: 180)
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
        
        self.view.addSubview(notificationButton)
        notificationButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        notificationButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true
        notificationButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        notificationButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        notificationButton.addSubview(newMessageNumber)
        newMessageNumber.centerYAnchor.constraint(equalTo: notificationButton.bottomAnchor, constant: -4).isActive = true
        newMessageNumber.centerXAnchor.constraint(equalTo: notificationButton.leftAnchor, constant: 4).isActive = true
        newMessageNumber.widthAnchor.constraint(equalToConstant: 20).isActive = true
        newMessageNumber.heightAnchor.constraint(equalTo: newMessageNumber.widthAnchor).isActive = true
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: -16).isActive = true
        
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
        }
        ref.child("ParkingSpots").observeSingleEvent(of: .value) { (snapshot) in
            let count = snapshot.childrenCount
            self.totalHostsLabel.text = "Total hosts: \(count)"
        }
    }
    
    @objc func backButtonPressed() {
        self.delegate?.dismissActiveController()
        self.dismiss(animated: true) {
            self.backButton.alpha = 0
        }
    }
    
}


extension AnalyticsViewController: UIViewControllerTransitioningDelegate {
    
    @objc func drivewayzMessagePressed() {
        let secondVC = OpenMessageViewController()
//        secondVC.delegate = self
        let navigation = UINavigationController(rootViewController: secondVC)
        navigation.transitioningDelegate = self
        navigation.modalPresentationStyle = .custom
        navigation.navigationBar.isHidden = true
        self.present(navigation, animated: true) {
            self.lightContentStatusBar()
            secondVC.openMessages()
            self.unreadMessages = 0
            self.newMessageNumber.alpha = 0
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = notificationButton.center
        transition.circleColor = Theme.WHITE
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = notificationButton.center
        transition.circleColor = Theme.WHITE
        delayWithSeconds(animationOut) {
            self.delegate?.defaultContentStatusBar()
        }
        
        return transition
    }
    
}


extension AnalyticsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var totalHeight: CGFloat = 0.0
        switch device {
        case .iphone8:
            totalHeight = 160
        case .iphoneX:
            totalHeight = 180
        }
        let translation = scrollView.contentOffset.y
        if translation > 0 && translation < 80 {
            let percent = translation/80
            self.gradientHeightAnchor.constant = totalHeight - percent * 80
            self.mainLabel.transform = CGAffineTransform(scaleX: 1 - 0.2 * percent, y: 1 - 0.2 * percent)
            if self.backgroundCircle.alpha == 0 {
                UIView.animate(withDuration: animationIn) {
                    self.gradientContainer.layer.shadowOpacity = 0
                    self.backgroundCircle.alpha = 1
                }
            }
            if self.gradientContainer.backgroundColor == Theme.DARK_GRAY {
                self.scrollExpanded()
            }
        } else if translation >= 40 && self.backgroundCircle.alpha == 1 {
            UIView.animate(withDuration: animationIn) {
                self.gradientContainer.layer.shadowOpacity = 0.2
                self.backgroundCircle.alpha = 0
            }
        } else if translation >= 80 {
            self.gradientHeightAnchor.constant = totalHeight - 80
            self.mainLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            if self.gradientContainer.backgroundColor != Theme.DARK_GRAY {
                self.scrollMinimized()
            }
        } else if translation <= 0 {
            self.gradientHeightAnchor.constant = totalHeight
            self.mainLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.contentOffset.y
        if translation >= 75 {
            self.scrollMinimized()
        } else {
            self.scrollExpanded()
        }
    }
    
    func scrollExpanded() {
        self.defaultContentStatusBar()
        self.scrollView.setContentOffset(.zero, animated: true)
        UIView.animate(withDuration: animationIn) {
            self.backgroundCircle.alpha = 1
            self.gradientContainer.backgroundColor = UIColor.clear
            self.backButton.tintColor = Theme.DARK_GRAY
            self.mainLabel.textColor = Theme.DARK_GRAY
        }
    }
    
    func scrollMinimized() {
        self.lightContentStatusBar()
        UIView.animate(withDuration: animationIn) {
            self.backgroundCircle.alpha = 0
            self.gradientContainer.backgroundColor = Theme.DARK_GRAY
            self.backButton.tintColor = Theme.WHITE
            self.mainLabel.textColor = Theme.WHITE
        }
    }
    
    func lightContentStatusBar() {
        self.statusBarColor = true
        UIView.animate(withDuration: animationIn) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    func defaultContentStatusBar() {
        self.statusBarColor = false
        UIView.animate(withDuration: animationIn) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if statusBarColor == true {
            return .lightContent
        } else {
            return .default
        }
    }
    
}






