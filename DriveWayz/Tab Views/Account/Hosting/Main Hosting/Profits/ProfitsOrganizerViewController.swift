//
//  ProfitsOrganizerViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/20/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ProfitsOrganizerViewController: UIViewController {
    
    var translation: CGFloat = 0.0 {
        didSet {
            var percent = translation/phoneWidth
            if percent >= 0 && percent <= 1 {
                self.firstOption.alpha = 1 - 0.8 * percent
                self.secondOption.alpha = 0.2 + 0.8 * percent
            } else if percent >= 1 && percent <= 2 {
                percent = percent - 1
                self.secondOption.alpha = 1 - 0.8 * percent
                self.thirdOption.alpha = 0.2 + 0.8 * percent
            }
        }
    }
    
    var firstOption: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("WALLET", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH6
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    var secondOption: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("PAYMENTS", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH6
        button.contentHorizontalAlignment = .left
        button.alpha = 0.2
        
        return button
    }()
    
    var thirdOption: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("TRANSFERS", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH6
        button.contentHorizontalAlignment = .left
        button.alpha = 0.2
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func setupViews() {
        
        self.view.addSubview(firstOption)
        firstOption.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        firstOption.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        firstOption.widthAnchor.constraint(equalToConstant: (firstOption.titleLabel?.text?.width(withConstrainedHeight: 30, font: Fonts.SSPSemiBoldH6))! + 30).isActive = true
        firstOption.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(secondOption)
        secondOption.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        secondOption.leftAnchor.constraint(equalTo: firstOption.rightAnchor, constant: 0).isActive = true
        secondOption.widthAnchor.constraint(equalToConstant: (secondOption.titleLabel?.text?.width(withConstrainedHeight: 30, font: Fonts.SSPSemiBoldH6))! + 30).isActive = true
        secondOption.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(thirdOption)
        thirdOption.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        thirdOption.leftAnchor.constraint(equalTo: secondOption.rightAnchor, constant: 0).isActive = true
        thirdOption.widthAnchor.constraint(equalToConstant: (thirdOption.titleLabel?.text?.width(withConstrainedHeight: 30, font: Fonts.SSPSemiBoldH6))! + 30).isActive = true
        thirdOption.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }

}
