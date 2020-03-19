//
//  Teststs.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/22/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class HorizontalPagingDisplay: UIView {
    
    var leftSelectionLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    var centerSelectionLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        view.layer.cornerRadius = 4
        view.alpha = 0.2
        
        return view
    }()
    
    var rightSelectionLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        view.layer.cornerRadius = 4
        view.alpha = 0.2
        
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        setupViews()
    }
    
    var leftWidth: NSLayoutConstraint!
    var centerWidth: NSLayoutConstraint!
    var rightWidth: NSLayoutConstraint!
    
    func setupViews() {
        
        addSubview(leftSelectionLine)
        addSubview(centerSelectionLine)
        addSubview(rightSelectionLine)
        
        leftSelectionLine.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        leftSelectionLine.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        leftSelectionLine.heightAnchor.constraint(equalToConstant: 8).isActive = true
        leftWidth = leftSelectionLine.widthAnchor.constraint(equalToConstant: 20)
            leftWidth.isActive = true
        
        centerSelectionLine.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        centerSelectionLine.leftAnchor.constraint(equalTo: leftSelectionLine.rightAnchor, constant: 6.5).isActive = true
        centerSelectionLine.heightAnchor.constraint(equalToConstant: 8).isActive = true
        centerWidth = centerSelectionLine.widthAnchor.constraint(equalToConstant: 10)
            centerWidth.isActive = true
        
        rightSelectionLine.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        rightSelectionLine.leftAnchor.constraint(equalTo: centerSelectionLine.rightAnchor, constant: 6.5).isActive = true
        rightSelectionLine.heightAnchor.constraint(equalToConstant: 8).isActive = true
        rightWidth = rightSelectionLine.widthAnchor.constraint(equalToConstant: 10)
            rightWidth.isActive = true
        
    }
    
    func changeScroll(percentage: CGFloat) {
        var percent = percentage
        if percent < 0 {
            leftWidth.constant = 20
            leftSelectionLine.alpha = 1
        } else if percent >= 0 && percent <= 1.0 {
            leftWidth.constant = 20 - 10 * percent
            centerWidth.constant = 10 + 10 * percent
            leftSelectionLine.alpha = 1 - 0.8 * percent
            centerSelectionLine.alpha = 0.2 + 0.8 * percent
        } else if percent > 1.0 && percent <= 2.0 {
            percent -= 1.0
            centerWidth.constant = 20 - 10 * percent
            rightWidth.constant = 10 + 10 * percent
            centerSelectionLine.alpha = 1 - 0.8 * percent
            rightSelectionLine.alpha = 0.2 + 0.8 * percent
        } else if percent >= 2.0 {
            rightWidth.constant = 20
            rightSelectionLine.alpha = 1
        }
        layoutIfNeeded()
    }
    
    func changeTint(color: UIColor) {
        leftSelectionLine.backgroundColor = color
        centerSelectionLine.backgroundColor = color
        rightSelectionLine.backgroundColor = color
    }
    
    func lightPaging() {
        leftSelectionLine.backgroundColor = Theme.WHITE
        centerSelectionLine.backgroundColor = Theme.WHITE
        rightSelectionLine.backgroundColor = Theme.WHITE
    }
    
    func darkPaging() {
        leftSelectionLine.backgroundColor = Theme.BLACK
        centerSelectionLine.backgroundColor = Theme.BLACK
        rightSelectionLine.backgroundColor = Theme.BLACK
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
