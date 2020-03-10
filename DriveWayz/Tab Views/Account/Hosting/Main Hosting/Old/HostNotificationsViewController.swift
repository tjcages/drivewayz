//
//  TestHostNotificationsViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/26/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol handleHostNotifications {
    func expandNotificationsHeight(height: CGFloat)
    func expandMainNotificationHeight(height: CGFloat)
    func notificationInformation(notification: HostNotifications)
    func observeData()
    func moveToInbox()
    
    func closeBackground()
}

class HostNotificationsViewController: UIViewController, handleHostNotifications {
    
    var delegate: handleHostingControllers?
    // Monitor and categorize notifications before passing on
    var testTimer: Timer?
    var testNotifications: [HostNotifications] = [] {
        didSet {
            if self.testTimer != nil {
                self.testTimer?.invalidate()
            }
            self.testTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(endLoading), userInfo: nil, repeats: false)
        }
    }
    
    @objc func endLoading() {
        self.notifications = self.testNotifications
    }
    
    var notifications: [HostNotifications] = [] {
        didSet {
            self.sortData()
            for i in 0...7 {
                if let type = NotificationSection(rawValue: i), let notificationData = data[type], notificationData.count > 0 {
                    if notificationData.count > 1 {
                        let sortedUrgent = notificationData.sorted { $0.timestamp! > $1.timestamp! }
                        if let urgentData = sortedUrgent.first {
                            let restNotifications = self.notifications.filter { $0 != urgentData }
                            self.listNotifications.notifications = restNotifications
                            self.quickNotifications.setData(notification: urgentData)
                            if let timestamp = urgentData.timestamp {
                                let date = Date(timeIntervalSince1970: timestamp)
                                if date.isInToday || date.isInYesterday {
                                    // Exit for-loop is the urgent data is recent
                                    return
                                }
                            }
                        }
                    } else {
                        if let urgentData = notificationData.first {
                            let restNotifications = self.notifications.filter { $0 != urgentData }
                            self.listNotifications.notifications = restNotifications
                            self.quickNotifications.setData(notification: urgentData)
                            if let timestamp = urgentData.timestamp {
                                let date = Date(timeIntervalSince1970: timestamp)
                                if date.isInToday || date.isInYesterday {
                                    return
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Data variable to sort notifications based on urgency
    var data = [NotificationSection: [HostNotifications]]()
    
    // Sorting function
    func sortData() {
        data[.urgent] = notifications.filter({ $0.type == .urgent })
        data[.important] = notifications.filter({ $0.type == .important })
        data[.moderate] = notifications.filter({ $0.type == .moderate })
        data[.mild] = notifications.filter({ $0.type == .mild })
        data[.soft] = notifications.filter({ $0.type == .soft })
        data[.unimportant] = notifications.filter({ $0.type == .unimportant })
        data[.none] = notifications.filter({ $0.type == .none })
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
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Notifications"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH1
        
        return label
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        
        return view
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.alpha = 0
//        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var dimmingView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        
        return view
    }()
    
    lazy var quickNotifications: QuickNotificationsViewController = {
        let controller = QuickNotificationsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        
        return controller
    }()
    
    lazy var listNotifications: ListNotificationsViewController = {
        let controller = ListNotificationsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        
        return controller
    }()
    
    var loadingLine: LoadingLine = {
        let view = LoadingLine()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // Observe Notifications data
    func observeData() {
        self.loadingLine.startAnimating()
        self.notifications = []
        self.testNotifications = []
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(userID).child("Hosting Spots")
        ref.observe(.childAdded) { (snapshot) in
            if let key = snapshot.value as? String {
                let hostRef = Database.database().reference().child("ParkingSpots").child(key).child("Notifications")
                hostRef.observe(.childAdded, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String: Any] {
                        let notification = HostNotifications(dictionary: dictionary)
                        notification.key = snapshot.key
                        self.testNotifications.append(notification)
                        
                        self.loadingLine.endAnimating()
                    }
                })
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        view.backgroundColor = Theme.BACKGROUND_GRAY
        
        setupViews()
        setupControllers()
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
        
        scrollView.contentSize = CGSize(width: phoneWidth, height: phoneHeight + 280)
        scrollView.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        gradientContainer.addSubview(loadingLine)
        loadingLine.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        loadingLine.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        loadingLine.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        loadingLine.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        self.view.addSubview(dimmingView)
        dimmingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        dimmingView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        dimmingView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        dimmingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
    var mainHeight: NSLayoutConstraint!
    var notificationsHeight: NSLayoutConstraint!
    
    func setupControllers() {
        
        scrollView.addSubview(quickNotifications.view)
        quickNotifications.view.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16).isActive = true
        quickNotifications.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        quickNotifications.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        mainHeight = quickNotifications.view.heightAnchor.constraint(equalToConstant: 196)
            mainHeight.isActive = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(checkNotificationInformation))
        quickNotifications.view.addGestureRecognizer(tap)
        
        scrollView.addSubview(listNotifications.view)
        listNotifications.view.topAnchor.constraint(equalTo: quickNotifications.view.bottomAnchor, constant: 16).isActive = true
        listNotifications.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        listNotifications.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        notificationsHeight = listNotifications.view.heightAnchor.constraint(equalToConstant: 0)
            notificationsHeight.isActive = true
        
    }
    
    func expandNotificationsHeight(height: CGFloat) {
        let size = self.mainHeight.constant + height + 240
        self.scrollView.contentSize = CGSize(width: phoneWidth, height: size)
        self.notificationsHeight.constant = height
        self.view.layoutIfNeeded()
    }
    
    func expandMainNotificationHeight(height: CGFloat) {
        self.mainHeight.constant = height
        self.view.layoutIfNeeded()
    }
    
    func closeBackground() {
        self.delegate?.openTabBar()
        UIView.animate(withDuration: animationOut) {
            self.dimmingView.alpha = 0
        }
    }
    
}

extension HostNotificationsViewController {
    
    @objc func checkNotificationInformation() {
        if let notification = self.quickNotifications.notification {
            self.notificationInformation(notification: notification)
        }
    }
    
    // Open notification options
    func notificationInformation(notification: HostNotifications) {
        self.delegate?.closeTabBar()
        UIView.animate(withDuration: animationIn, animations: {
            self.dimmingView.alpha = 0.6
        }) { (success) in
            let controller = GeneralNotificationViewController()
            controller.notification = notification
            controller.delegate = self
            let navigation = UINavigationController(rootViewController: controller)
            navigation.modalPresentationStyle = .overFullScreen
            navigation.navigationBar.isHidden = true
            self.present(navigation, animated: true, completion: nil)
        }
    }
    
    func moveToInbox() {
        self.delegate?.moveToInbox()
    }
    
}


extension HostNotificationsViewController: UIScrollViewDelegate {
    
    func resetScrolls() {
//        self.profitsWallet.scrollView.setContentOffset(.zero, animated: true)
//        self.profitsChart.scrollView.setContentOffset(.zero, animated: true)
//        self.profitsRefund.scrollView.setContentOffset(.zero, animated: true)
    }
    
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
        self.resetScrolls()
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
    
    func dismissAll() {
        delayWithSeconds(0.4) {
            self.closeBackground()
            self.dismiss(animated: true, completion: {
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
}
