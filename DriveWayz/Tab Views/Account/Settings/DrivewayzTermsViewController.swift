//
//  DrivewayzTermsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 11/28/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class DrivewayzTermsViewController: UIViewController, UIScrollViewDelegate {
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true
        view.showsHorizontalScrollIndicator = false
        view.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
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
        button.imageEdgeInsets = UIEdgeInsets(top: 12.5, left: 10, bottom: 12.5, right: 10)
        button.addTarget(self, action: #selector(scrollToBottom(sender:)), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        
        setupViews()
    }
    
    var agreementHeight: CGFloat!
    var agreement2Height: CGFloat!
    
    func setupViews() {
        
        agreementHeight = agreement.text?.height(withConstrainedWidth: self.view.frame.width - 24, font: Fonts.SSPRegularH6)
        agreement2Height = agreement2.text?.height(withConstrainedWidth: self.view.frame.width - 24, font: Fonts.SSPRegularH6)
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: agreementHeight! + agreement2Height!)
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(scrollToBottom)
        scrollToBottom.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -35).isActive = true
        scrollToBottom.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        scrollToBottom.widthAnchor.constraint(equalToConstant: 40).isActive = true
        scrollToBottom.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(agreement)
        agreement.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        agreement.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        agreement.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true
        agreement.heightAnchor.constraint(equalToConstant: agreementHeight!)
        
        scrollView.addSubview(agreement2)
        agreement2.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        agreement2.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        agreement2.topAnchor.constraint(equalTo: agreement.bottomAnchor).isActive = true
        agreement2.heightAnchor.constraint(equalToConstant: agreement2Height!)
        
    }
    
    @objc func scrollToBottom(sender: UIButton) {
        let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height-self.view.frame.height)
        self.scrollView.setContentOffset(bottomOffset, animated: true)
    }

}
