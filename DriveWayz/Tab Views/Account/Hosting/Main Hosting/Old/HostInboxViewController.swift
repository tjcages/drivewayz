//
//  HostInboxViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/31/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class HostInboxViewController: UIViewController {

    var delegate: handleHostingControllers?
    var messages: [UserMessages] = []
    
    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.BLACK
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Inbox"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH1
        
        return label
    }()
    
    lazy var dimmingView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        
        return view
    }()
    
    var messagesTable: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(InboxCell.self, forCellReuseIdentifier: "cellId")
        view.clipsToBounds = true
        view.separatorColor = .clear
        view.backgroundColor = .clear
        view.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 64, right: 0)
        
        return view
    }()
    
    lazy var hostPromotions: HostPromotionsViewController = {
        let controller = HostPromotionsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.view.alpha = 0
        
        return controller
    }()
    
    var loadingLine: LoadingLine = {
        let view = LoadingLine()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var noMessagesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No messages currently"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        label.alpha = 0
        
        return label
    }()
    
    func observeData() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesTable.delegate = self
        messagesTable.dataSource = self

        view.backgroundColor = Theme.WHITE
        
        setupViews()
        setupControllers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.messagesTable.setContentOffset(CGPoint(x: 0, y: -16), animated: true)
        self.hostPromotions.promotionsPicker.setContentOffset(CGPoint(x: -20, y: 0), animated: true)
        self.hostPromotions.pageControl.set(progress: 0, animated: true)
    }
    
    var gradientHeightAnchor: NSLayoutConstraint!
    var upcomingHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
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
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: -16).isActive = true
        
        gradientContainer.addSubview(loadingLine)
        loadingLine.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        loadingLine.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        loadingLine.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        loadingLine.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
    }
    
    func setupControllers() {
        
        self.view.addSubview(noMessagesLabel)
        noMessagesLabel.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: 32).isActive = true
        noMessagesLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        noMessagesLabel.sizeToFit()
        
        self.view.addSubview(messagesTable)
        messagesTable.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        messagesTable.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        messagesTable.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        messagesTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(hostPromotions.view)
        hostPromotions.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        hostPromotions.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        hostPromotions.view.heightAnchor.constraint(equalToConstant: 200).isActive = true
        switch device {
        case .iphone8:
            hostPromotions.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -64).isActive = true
        case .iphoneX:
            hostPromotions.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -76).isActive = true
        }
        
        self.view.addSubview(dimmingView)
        dimmingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        dimmingView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        dimmingView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        dimmingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
    func closeBackground() {
        self.delegate?.openTabBar()
        UIView.animate(withDuration: animationOut) {
            self.dimmingView.alpha = 0
        }
    }
    
}

// Set up messages tableview
extension HostInboxViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.messages.count == 0 {
            self.noMessagesLabel.alpha = 1
        } else {
            self.noMessagesLabel.alpha = 0
        }
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messagesTable.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! InboxCell
        cell.separatorInset = UIEdgeInsets(top: 0, left: phoneWidth, bottom: 0, right: 0)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = HostChatViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}

// Minimize gradientTop 
extension HostInboxViewController: UIScrollViewDelegate {
    
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
            } else if translation <= 0 {
                self.gradientHeightAnchor.constant = totalHeight
                self.mainLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
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
    
    func dismissAll() {
        delayWithSeconds(0.4) {
            self.closeBackground()
            self.dismiss(animated: true, completion: {
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
}

// Build out the inbox cell
class InboxCell: UITableViewCell {
    
    var notification: HostNotifications? {
        didSet {
            if let notification = self.notification, let title = notification.title, let subTitle = notification.subtitle, let timeString = notification.date, let image = notification.notificationImage {
                self.titleLabel.text = title
                self.subTitleLabel.text = subTitle
                
                let resize = resizeImage(image: image, targetSize: CGSize(width: 120, height: 120))
                self.profileImageView.image = resize
                
                self.dateLabel.setTitle("\(timeString)", for: .normal)
                let width = timeString.width(withConstrainedHeight: 20, font: Fonts.SSPRegularH6) + 16
                self.dateWidthAnchor.constant = width
                self.layoutIfNeeded()
            }
        }
    }
    
    var profileImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 55/2
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        let image = UIImage(named: "background4")
        view.image = image
        
        return view
    }()
    
    var titleLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.SSPSemiBoldH5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLACK
        view.text = "Expired  •  Martin"
        
        return view
    }()
    
    var subTitleLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.SSPRegularH6
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLACK
        view.text = "Any chance I can park a car in this area?"
        
        return view
    }()
    
    var durationLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.SSPRegularH6
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLACK.withAlphaComponent(0.4)
        view.text = "Jul 4, 8:00am - 10:00pm"
        
        return view
    }()
    
    var dateLabel: UIButton = {
        let view = UIButton()
        view.titleLabel?.font = Fonts.SSPRegularH6
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(Theme.BLACK, for: .normal)
        view.backgroundColor = Theme.LINE_GRAY
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        view.setTitle("2 days ago", for: .normal)
        
        return view
    }()
    
    var showMoreLabel: UILabel = {
        let view = UILabel()
        view.text = "Show more"
        view.font = Fonts.SSPRegularH5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLACK.withAlphaComponent(0.4)
        view.textAlignment = .center
        view.alpha = 0
        
        return view
    }()
    
    var dateWidthAnchor: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        
        addSubview(profileImageView)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(dateLabel)
        addSubview(durationLabel)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 55).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        subTitleLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 2).isActive = true
        subTitleLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        subTitleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        subTitleLabel.sizeToFit()
        
        titleLabel.bottomAnchor.constraint(equalTo: subTitleLabel.topAnchor, constant: -4).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -72).isActive = true
        titleLabel.sizeToFit()
        
        durationLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 2).isActive = true
        durationLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        durationLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -72).isActive = true
        durationLabel.sizeToFit()
        
        dateLabel.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -2).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        dateWidthAnchor = dateLabel.widthAnchor.constraint(equalToConstant: (dateLabel.titleLabel?.text?.width(withConstrainedHeight: 20, font: Fonts.SSPRegularH6))! + 16)
        dateWidthAnchor.isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
