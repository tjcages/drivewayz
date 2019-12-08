//
//  NotificationsCell.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/12/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class NotificationsCell: UITableViewCell {
    
    var notification: HostNotifications? {
        didSet {
            if let notification = notification, let title = notification.title, let subTitle = notification.subtitle, let timeString = notification.date, let image = notification.notificationImage, let type = notification.notificationType {
                mainLabel.text = title
                subLabel.text = subTitle
//                if type == "userParked" {
//                    self.mainLabel.text = title
//                    self.subLabel.text = timeString
//                } else {
//                    self.mainLabel.text = title
//                    self.subLabel.text = subTitle
//                }
                iconButton.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
            }
        }
    }
    
    var iconButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.HOST_DARK_BLUE
        button.layer.cornerRadius = 45/2
        button.clipsToBounds = true
        button.tintColor = Theme.WHITE
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPSemiBoldH3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.numberOfLines = 2
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH5
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.PRUSSIAN_BLUE
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Theme.WHITE
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(iconButton)
        addSubview(mainLabel)
        addSubview(subLabel)
        
        iconButton.anchor(top: nil, left: leftAnchor, bottom: nil, right:  nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 45, height: 45)
        iconButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        mainLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: iconButton.rightAnchor, constant: 20).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        mainLabel.sizeToFit()
        
        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor).isActive = true
        subLabel.leftAnchor.constraint(equalTo: iconButton.rightAnchor, constant: 20).isActive = true
        subLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        subLabel.sizeToFit()
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: 1))
        view.backgroundColor = lineColor
        addSubview(view)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



class NotificationsHeader: UIView {
    
    var mainLabel: UILabel = {
        let view = UILabel()
        view.text = "Notifications"
        view.font = Fonts.SSPSemiBoldH2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.DARK_GRAY
        
        return view
    }()
    
    var separatorLabel: UILabel = {
        let view = UILabel()
        view.text = "•"
        view.font = Fonts.SSPRegularH4
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.DARK_GRAY
        
        return view
    }()
    
    var newLabel: UILabel = {
        let view = UILabel()
        view.text = "2 new"
        view.font = Fonts.SSPRegularH4
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLUE
        
        return view
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
        return view
    }()
    
    override func draw(_ rect: CGRect) {
        
        backgroundColor = Theme.WHITE
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(mainLabel)
        addSubview(separatorLabel)
        addSubview(newLabel)
        
        mainLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()
        
        separatorLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        separatorLabel.leftAnchor.constraint(equalTo: mainLabel.rightAnchor, constant: 12).isActive = true
        separatorLabel.sizeToFit()
        
        newLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        newLabel.leftAnchor.constraint(equalTo: separatorLabel.rightAnchor, constant: 12).isActive = true
        newLabel.sizeToFit()
        
        addSubview(line)
        line.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
    }
    
}

class NotificationsDateHeader: UIView {
    
    var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "TODAY"
        view.font = Fonts.SSPRegularH5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.PRUSSIAN_BLUE
        
        return view
    }()
    
    var moreButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "openDots")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.contentMode = .scaleAspectFit
        button.tintColor = Theme.DARK_GRAY
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
        return view
    }()
    
    override func draw(_ rect: CGRect) {
        
        backgroundColor = Theme.OFF_WHITE
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        titleLabel.sizeToFit()
        
        addSubview(moreButton)
        moreButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        moreButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 24, height: 6)
        
        addSubview(line)
        line.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
    }
    
}
