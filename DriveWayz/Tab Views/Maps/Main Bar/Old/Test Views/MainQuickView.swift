//
//  MainQuickView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/9/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class MainQuickView: UIViewController {
    
    var buttonWidth: CGFloat = 52
    var transform = CGAffineTransform.identity
    
    var dragBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BACKGROUND_GRAY.withAlphaComponent(0.8)
        view.layer.cornerRadius = 2
        
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = buttonWidth + 16
        view.alignment = .center
        view.distribution = .fillEqually
        view.transform = transform
        
        return view
    }()

    lazy var firstButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BACKGROUND_GRAY
        button.layer.cornerRadius = buttonWidth/2
        let image = UIImage(named: "mainQuickHelp")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        
        return button
    }()
    
    lazy var secondButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BACKGROUND_GRAY
        button.layer.cornerRadius = buttonWidth/2
        let image = UIImage(named: "mainQuickHost")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        
        return button
    }()
    
    lazy var thirdButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BACKGROUND_GRAY
        button.layer.cornerRadius = buttonWidth/2
        let image = UIImage(named: "mainQuickAccount")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        
        return button
    }()
    
    var firstLabel: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.setTitle("Help", for: .normal)
        button.alpha = 0
        button.transform = CGAffineTransform(translationX: 0.0, y: 8.0)
        
        return button
    }()

    var secondLabel: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.setTitle("Hosting", for: .normal)
        button.alpha = 0
        button.transform = CGAffineTransform(translationX: 0.0, y: 8.0)
        
        return button
    }()
    
    var thirdLabel: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.setTitle("Account", for: .normal)
        button.alpha = 0
        button.transform = CGAffineTransform(translationX: 0.0, y: 8.0)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        transform = transform.translatedBy(x: 0.0, y: -40.0)
        transform = transform.scaledBy(x: 0.6, y: 0.6)
        transform = transform.rotated(by: CGFloat.pi/8)
        
        setupViews()
    }
    
    func setupViews() {
        
        view.addSubview(stackView)
        view.addSubview(dragBar)
        
        stackView.anchor(top: dragBar.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 32, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: buttonWidth * 5 + 32, height: buttonWidth)
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        dragBar.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 48, height: 4)
        dragBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        stackView.addArrangedSubview(firstButton)
        stackView.addArrangedSubview(secondButton)
        stackView.addArrangedSubview(thirdButton)
        
        firstButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        firstButton.heightAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        
        secondButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        secondButton.heightAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        
        thirdButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        thirdButton.heightAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        
        view.addSubview(firstLabel)
        firstLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8).isActive = true
        firstLabel.centerXAnchor.constraint(equalTo: firstButton.centerXAnchor).isActive = true
        firstLabel.sizeToFit()
        
        view.addSubview(secondLabel)
        secondLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8).isActive = true
        secondLabel.centerXAnchor.constraint(equalTo: secondButton.centerXAnchor).isActive = true
        secondLabel.sizeToFit()
        
        view.addSubview(thirdLabel)
        thirdLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8).isActive = true
        thirdLabel.centerXAnchor.constraint(equalTo: thirdButton.centerXAnchor).isActive = true
        thirdLabel.sizeToFit()
        
    }
    
    func animateQuickViews() {
        UIView.animate(withDuration: animationOut * 2, delay: 0, usingSpringWithDamping: 3, initialSpringVelocity: 3, options: .curveEaseInOut, animations: {
            self.stackView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.view.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: { (success) in
            //
        })
        delayWithSeconds(animationOut) {
            UIView.animate(withDuration: animationIn, animations: {
                self.firstLabel.alpha = 1
                self.secondLabel.alpha = 1
                self.thirdLabel.alpha = 1
                self.firstLabel.transform = CGAffineTransform(translationX: 0.0, y: 0.0)
                self.secondLabel.transform = CGAffineTransform(translationX: 0.0, y: 0.0)
                self.thirdLabel.transform = CGAffineTransform(translationX: 0.0, y: 0.0)
            })
        }
    }
    
    func dismissQuickViews() {
        UIView.animate(withDuration: animationOut, delay: 0, usingSpringWithDamping: 3, initialSpringVelocity: 3, options: .curveEaseInOut, animations: {
            self.stackView.transform = self.transform
            self.firstLabel.alpha = 0
            self.secondLabel.alpha = 0
            self.thirdLabel.alpha = 0
            self.firstLabel.transform = CGAffineTransform(translationX: 0.0, y: 8.0)
            self.secondLabel.transform = CGAffineTransform(translationX: 0.0, y: 8.0)
            self.thirdLabel.transform = CGAffineTransform(translationX: 0.0, y: 8.0)
            
            self.view.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
}
