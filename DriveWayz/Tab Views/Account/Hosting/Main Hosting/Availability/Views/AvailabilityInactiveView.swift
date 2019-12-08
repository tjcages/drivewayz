//
//  AvailabilityInactiveView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/27/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class AvailabilityInactiveView: UIViewController {
    
    var delegate: HostHelpDelegate?

    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    var starImageView: UIButton = {
        let image = UIImage(named: "hostInactive")?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.HARMONY_RED
        button.layer.cornerRadius = 50
        button.alpha = 0
        button.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Listing was \nmarked inactive"
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH2
        label.textAlignment = .center
        label.numberOfLines = 3
        label.alpha = 0
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.text = "You can reactivate your spot at \nany time in the Host Portal."
        label.textColor = Theme.PRUSSIAN_BLUE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .center
        label.numberOfLines = 3
        label.alpha = 0
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        
        setupViews()
    }
    
    var containerWidthAnchor: NSLayoutConstraint!
    var containerHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(container)
        container.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerWidthAnchor = container.widthAnchor.constraint(equalToConstant: 192)
            containerWidthAnchor.isActive = true
        containerHeightAnchor = container.heightAnchor.constraint(equalToConstant: 184)
            containerHeightAnchor.isActive = true
        
        container.addSubview(starImageView)
        starImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        starImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 32).isActive = true
        starImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        starImageView.heightAnchor.constraint(equalTo: starImageView.widthAnchor).isActive = true
        
        container.addSubview(mainLabel)
        mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainLabel.topAnchor.constraint(equalTo: starImageView.bottomAnchor, constant: 32).isActive = true
        mainLabel.sizeToFit()
        
        container.addSubview(subLabel)
        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 16).isActive = true
        subLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        subLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        subLabel.sizeToFit()
        
    }
   
    func animateSuccess() {
        containerWidthAnchor.constant = phoneWidth - 48
        containerHeightAnchor.constant = 328
        UIView.animate(withDuration: animationOut, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationIn, animations: {
                self.mainLabel.alpha = 1
                self.subLabel.alpha = 1
                self.starImageView.alpha = 1
                self.starImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }) { (success) in
                
            }

        }
    }
    
    func closeSuccess() {
        UIView.animate(withDuration: animationIn, animations: {
            self.mainLabel.alpha = 0
            self.subLabel.alpha = 0
            self.starImageView.alpha = 0
            self.starImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }) { (success) in
            self.containerWidthAnchor.constant = 168
            self.containerHeightAnchor.constant = 184
            UIView.animate(withDuration: animationIn, animations: {
                self.starImageView.alpha = 0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if mainLabel.alpha == 1 {
            closeSuccess()
            delegate?.removeDim()
            delayWithSeconds(animationIn) {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
