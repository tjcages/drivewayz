//
//  UserMessages.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 10/10/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation
import UIKit

class UserMessages: UITableViewCell {
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "background4")
        imageView.image = image
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 25
        
        return imageView
    }()
    
    var recentRing: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 29
        view.layer.borderColor = Theme.GREEN.cgColor
        view.layer.borderWidth = 2
        view.alpha = 0
        
        return view
    }()
    
    var hostTextView: UILabel = {
        let view = UILabel()
        view.text = "Host"
        view.font = Fonts.SSPRegularH4
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLACK
        
        return view
    }()
    
    var messageTextView: UILabel = {
        let view = UILabel()
        view.text = "Left a message"
        view.font = Fonts.SSPRegularH6
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.GRAY_WHITE
        
        return view
    }()
    
    var dateTextView: UILabel = {
        let view = UILabel()
        view.text = "10/10/18"
        view.font = Fonts.SSPLightH5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.GRAY_WHITE.withAlphaComponent(0.7)
        view.textAlignment = .right
        
        return view
    }()
    
    var contextView: UILabel = {
        let view = UILabel()
        view.text = "Context"
        view.font = Fonts.SSPRegularH5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.GRAY_WHITE
        view.textAlignment = .right
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = Theme.WHITE
        
        addSubview(recentRing)
        addSubview(profileImageView)
        addSubview(hostTextView)
        addSubview(messageTextView)
        addSubview(dateTextView)
        addSubview(contextView)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        recentRing.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        recentRing.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        recentRing.heightAnchor.constraint(equalToConstant: 58).isActive = true
        recentRing.widthAnchor.constraint(equalToConstant: 58).isActive = true
        
        hostTextView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -8).isActive = true
        hostTextView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        hostTextView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        hostTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -82).isActive = true
        
        messageTextView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 12).isActive = true
        messageTextView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        messageTextView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        messageTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -82).isActive = true
        
        dateTextView.centerYAnchor.constraint(equalTo: hostTextView.centerYAnchor).isActive = true
        dateTextView.leftAnchor.constraint(equalTo: hostTextView.rightAnchor, constant: 4).isActive = true
        dateTextView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        dateTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        
        contextView.centerYAnchor.constraint(equalTo: messageTextView.centerYAnchor).isActive = true
        contextView.leftAnchor.constraint(equalTo: hostTextView.rightAnchor, constant: 4).isActive = true
        contextView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        contextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
