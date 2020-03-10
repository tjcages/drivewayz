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
            var transform = CGAffineTransform.identity
            transform = transform.rotated(by: CGFloat.pi)
            transform = transform.scaledBy(x: 0.0, y: 0.0)
            
            self.messageTextView.text = message
            self.messageTextView.font = Fonts.SSPRegularH2
//            UIView.animate(withDuration: animationIn) {
//                self.selectionLine.layer.cornerRadius = 3
//                self.selectionLine.transform = transform
//                self.layoutIfNeeded()
//            }
        }
    }
    
    var messageTextView: UILabel = {
        let view = UILabel()
        view.text = ""
        view.font = Fonts.SSPRegularH2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLACK
        
        return view
    }()
    
    var subTextView: UILabel = {
        let view = UILabel()
        view.text = ""
        view.font = Fonts.SSPRegularH5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLUE
        view.alpha = 0
        
        return view
    }()
    
    var messageTopAnchor: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        clipsToBounds = false
        backgroundColor = UIColor.clear
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(messageTextView)
        addSubview(subTextView)
        
        messageTopAnchor = messageTextView.centerYAnchor.constraint(equalTo: centerYAnchor)
            messageTopAnchor.isActive = true
        messageTextView.leftAnchor.constraint(equalTo: leftAnchor, constant: 36).isActive = true
        messageTextView.sizeToFit()
        
        subTextView.topAnchor.constraint(equalTo: messageTextView.bottomAnchor, constant: 4).isActive = true
        subTextView.leftAnchor.constraint(equalTo: leftAnchor, constant: 36).isActive = true
        subTextView.sizeToFit()
        
    }
    
    func openSubText() {
        messageTopAnchor.constant = -8
        subTextView.alpha = 1
        layoutIfNeeded()
    }
    
    func closeSubText() {
        messageTopAnchor.constant = 0
        subTextView.alpha = 0
        layoutIfNeeded()
    }
    
    func animate() {
        messageTextView.font = Fonts.SSPSemiBoldH2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
