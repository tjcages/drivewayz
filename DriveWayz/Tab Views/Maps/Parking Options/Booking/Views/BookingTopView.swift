//
//  BookingTopView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 12/9/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class BookingTopView: UIView {
    
    let backButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        button.alpha = 0
        
        return button
    }()
    
    var mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        
        return view
    }()
    
    let mainLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH1
        label.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Theme.BLACK
        alpha = 0
        
        setupViews()
    }
    
    var mainLabelBottomAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        addSubview(mainView)
        mainView.addSubview(mainLabel)
        addSubview(backButton)
        
        backButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        switch device {
        case .iphone8:
            backButton.topAnchor.constraint(equalTo: topAnchor, constant: 28).isActive = true
        case .iphoneX:
            backButton.topAnchor.constraint(equalTo: topAnchor, constant: 48).isActive = true
        }
        
        mainLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        mainLabelBottomAnchor = mainLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor)
            mainLabelBottomAnchor.isActive = true
        mainLabel.sizeToFit()
        
        mainView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 16, paddingRight: 0, width: 0, height: 0)
        
    }
    
    func setMainLabel(text: String) {
        mainLabel.text = text
        mainLabelBottomAnchor.constant = 32
        layoutIfNeeded()
        
        mainLabelBottomAnchor.constant = 0
        UIView.animate(withDuration: animationOut, delay: 0, options: .curveEaseOut, animations: {
            self.mainLabel.alpha = 1
            self.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationIn) {
                self.backButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.backButton.alpha = 1
                self.layoutIfNeeded()
            }
        }
    }
    
    func reset() {
        mainLabel.alpha = 0
        mainLabelBottomAnchor.constant = 32
        backButton.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        backButton.alpha = 0
        layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
