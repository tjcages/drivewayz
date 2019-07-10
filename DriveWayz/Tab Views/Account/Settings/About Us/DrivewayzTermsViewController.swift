//
//  DrivewayzTermsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 11/28/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class DrivewayzTermsViewController: UIViewController, UIScrollViewDelegate {
    
    var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Terms & Conditions"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPBoldH1
        label.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true
        view.showsHorizontalScrollIndicator = false
        view.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 20, right: 0)
        
        return view
    }()
    
    var scrollToBottom: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "arrow")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.transform = CGAffineTransform.identity.rotated(by: CGFloat(-Double.pi/2))
        button.tintColor = Theme.WHITE
        button.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        button.alpha = 0.9
        button.layer.cornerRadius = 20
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(scrollToBottom(sender:)), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        
        setupViews()
    }
    
    var agreementHeight: CGFloat!
    
    func setupViews() {
        
        self.view.addSubview(gradientContainer)
        gradientContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        switch device {
        case .iphone8:
            gradientContainer.heightAnchor.constraint(equalToConstant: 80).isActive = true
        case .iphoneX:
            gradientContainer.heightAnchor.constraint(equalToConstant: 90).isActive = true
        }
        
        self.view.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        switch device {
        case .iphone8:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 28).isActive = true
        case .iphoneX:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 48).isActive = true
        }
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mainLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true
        
        agreementHeight = agreement.text?.height(withConstrainedWidth: phoneWidth - 24, font: Fonts.SSPRegularH6)
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: agreementHeight! + 200)
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(scrollToBottom)
        scrollToBottom.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -35).isActive = true
        scrollToBottom.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        scrollToBottom.widthAnchor.constraint(equalToConstant: 40).isActive = true
        scrollToBottom.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(agreement)
        agreement.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        agreement.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        agreement.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        agreement.heightAnchor.constraint(equalToConstant: agreementHeight!).isActive = true
        
    }
    
    @objc func scrollToBottom(sender: UIButton) {
        let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height-self.view.frame.height)
        self.scrollView.setContentOffset(bottomOffset, animated: true)
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
