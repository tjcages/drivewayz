//
//  optionsCell.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 9/16/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation
import UIKit

class OptionsCell: UITableViewCell {
    
    var message: String? {
        didSet {
            self.messageTextView.text = message
            self.messageTextView.textColor = Theme.BLACK
            self.messageTextView.font = Fonts.SSPRegularH3
            UIView.animate(withDuration: animationIn) {
                self.selectionLeftAnchor.constant = phoneWidth
                self.layoutIfNeeded()
            }
        }
    }
    
    var profileImageView: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "feed")
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var messageTextView: UILabel = {
        let view = UILabel()
        view.text = ""
        view.font = Fonts.SSPRegularH3
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLACK
        
        return view
    }()
    
    var subTextView: UILabel = {
        let view = UILabel()
        view.text = ""
        view.font = Fonts.SSPRegularH5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.GREEN_PIGMENT
        view.alpha = 0
        
        return view
    }()
    
    var selectionLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.STRAWBERRY_PINK
        view.layer.cornerRadius = 2
        
        return view
    }()
    
    var selectionLeftAnchor: NSLayoutConstraint!
    var messageTopAnchor: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.clipsToBounds = false
        self.backgroundColor = UIColor.clear
    
        addSubview(messageTextView)
        addSubview(selectionLine)
        addSubview(subTextView)
        
        messageTopAnchor = messageTextView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            messageTopAnchor.isActive = true
        messageTextView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 36).isActive = true
        messageTextView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        messageTextView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        subTextView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 16).isActive = true
        subTextView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 36).isActive = true
        subTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        subTextView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        selectionLine.centerYAnchor.constraint(equalTo: messageTextView.centerYAnchor).isActive = true
        selectionLine.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        selectionLine.heightAnchor.constraint(equalToConstant: 4).isActive = true
        selectionLeftAnchor = selectionLine.leftAnchor.constraint(equalTo: messageTextView.leftAnchor)
            selectionLeftAnchor.isActive = true
    
    }
    
    func openSubText() {
        self.messageTopAnchor.constant = -8
        self.subTextView.alpha = 1
        self.layoutIfNeeded()
    }
    
    func closeSubText() {
        self.messageTopAnchor.constant = 0
        self.subTextView.alpha = 0
        self.layoutIfNeeded()
    }
    
    func animate() {
        self.selectionLeftAnchor.constant = phoneWidth
        self.messageTextView.font = Fonts.SSPSemiBoldH3
        self.layoutIfNeeded()
        UIView.animate(withDuration: animationOut) {
            self.selectionLeftAnchor.constant = self.message!.width(withConstrainedHeight: 40, font: Fonts.SSPRegularH3) + 24
            self.layoutIfNeeded()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
