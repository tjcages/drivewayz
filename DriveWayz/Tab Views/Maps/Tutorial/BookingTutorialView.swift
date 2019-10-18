//
//  BookingTutorialView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/29/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class BookingTutorialView: UIViewController {

    var delegate: handleMapTutorial?
    
    var dimViewHeight: CGFloat = phoneHeight - 372
    
    lazy var dimView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight))
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        
        return view
    }()
    
//    var mainLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "Compare parking"
//        label.textColor = Theme.WHITE
//        label.font = Fonts.SSPSemiBoldH2
//
//        return label
//    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Swipe to compare parking options"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH4
        label.numberOfLines = 3
        label.textAlignment = .right
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    var subLabelBottomAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(dimView)
        
//        view.addSubview(mainLabel)
        view.addSubview(subLabel)
        
        subLabelBottomAnchor = subLabel.bottomAnchor.constraint(equalTo: view.topAnchor, constant: dimViewHeight - 16)
            subLabelBottomAnchor.isActive = true
        subLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        subLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        subLabel.sizeToFit()
        
//        mainLabel.bottomAnchor.constraint(equalTo: subLabel.topAnchor, constant: -8).isActive = true
//        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
//        mainLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
//        mainLabel.sizeToFit()
        
    }
    
    func showView() {
        delayWithSeconds(3) {
            UIView.animate(withDuration: animationIn, animations: {
                self.view.alpha = 0
            }) { (success) in
                self.removeFromParent()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: animationIn, animations: {
            self.view.alpha = 0
        }) { (success) in
            self.removeFromParent()
        }
    }
    
}
