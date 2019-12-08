//
//  QuickNotificationsViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/26/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class QuickNotificationsViewController: UIViewController {
    
    var delegate: handleHostNotifications?
    var height: CGFloat = 196.0
    var previousSubtitleHeight: CGFloat = 0.0
    var notification: HostNotifications?

    lazy var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    var iconImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.alpha = 0
        
        return view
    }()
    
    var iconShimmerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 40
        
        return view
    }()
    
    var notificationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "Welcome new host!"
        label.font = Fonts.SSPSemiBoldH2
        label.textAlignment = .center
        
        return label
    }()
    
    var notificationSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "Contact us if you have any issues"
        label.font = Fonts.SSPRegularH4
        label.numberOfLines = 2
        label.textAlignment = .center
        
        return label
    }()
    
    func setData(notification: HostNotifications) {
        self.container.stopShining()
        self.iconImageView.alpha = 1
        self.iconShimmerView.alpha = 0
        self.notification = notification
        if let title = notification.title, let subTitle = notification.subtitle, let image = notification.notificationImage, let colors = notification.containerGradient {
            self.notificationLabel.text = title
            self.notificationSubLabel.text = subTitle
            if let newHeight = notificationSubLabel.text?.height(withConstrainedWidth: phoneWidth - 68, font: Fonts.SSPRegularH4), newHeight > self.previousSubtitleHeight {
                self.height = 212
            } else {
                self.height = 196
            }
            self.containerHeightAnchor.constant = self.height
            self.delegate?.expandMainNotificationHeight(height: self.height)
            
            if self.container.tag == 1 {
                self.removeSublayer(self.container, layerIndex: 0)
            }
            if let mainColors = colors.first {
                let topColor = mainColors.key
                let bottomColor = mainColors.value
                let background = CAGradientLayer().customColor(topColor: topColor, bottomColor: bottomColor)
                background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: height)
                background.zPosition = -10
                self.container.layer.insertSublayer(background, at: 0)
                self.container.tag = 1
                self.iconImageView.image = image
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.notification == nil {
            container.startSmartShining()
        }
    }
    
    var containerHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        containerHeightAnchor = container.heightAnchor.constraint(equalToConstant: self.height)
            containerHeightAnchor.isActive = true
        
        container.addSubview(iconImageView)
        iconImageView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        iconImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 24).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor).isActive = true
        
        container.addSubview(iconShimmerView)
        iconShimmerView.topAnchor.constraint(equalTo: iconImageView.topAnchor).isActive = true
        iconShimmerView.leftAnchor.constraint(equalTo: iconImageView.leftAnchor).isActive = true
        iconShimmerView.rightAnchor.constraint(equalTo: iconImageView.rightAnchor).isActive = true
        iconShimmerView.bottomAnchor.constraint(equalTo: iconImageView.bottomAnchor).isActive = true
        
        container.addSubview(notificationLabel)
        notificationLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 12).isActive = true
        notificationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        notificationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        notificationLabel.sizeToFit()
        
        container.addSubview(notificationSubLabel)
        notificationSubLabel.topAnchor.constraint(equalTo: notificationLabel.bottomAnchor).isActive = true
        notificationSubLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        notificationSubLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        notificationSubLabel.sizeToFit()
        
        self.previousSubtitleHeight = (notificationSubLabel.text?.height(withConstrainedWidth: phoneWidth - 68, font: Fonts.SSPRegularH4))!
        
    }
    
    func removeSublayer(_ view: UIView, layerIndex index: Int) {
        guard let sublayers = view.layer.sublayers else { return }
        if sublayers.count > index {
            view.layer.sublayers!.remove(at: index)
        }
    }
    
}
