//
//  SecondHostingsController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/15/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class SecondHostingsController: UIViewController {

    var delegate: handleHostingScroll?
    
    lazy var mainInformationView: HostingInformationViewController = {
        let controller = HostingInformationViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    var pageControl: UIPageControl = {
        let page = UIPageControl(frame: CGRect(x: 50, y: 300, width: 200, height: 20))
        page.numberOfPages = 3
        page.currentPage = 1
        page.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.3)
        page.pageIndicatorTintColor = Theme.DARK_GRAY.withAlphaComponent(0.3)
        page.currentPageIndicatorTintColor = Theme.PURPLE
        page.translatesAutoresizingMaskIntoConstraints = false
        page.isUserInteractionEnabled = false
        page.numberOfPages = 3
        
        return page
    }()
    
    lazy var mainExpandedInformationView: HostingExpandedViewController = {
        let controller = HostingExpandedViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    var reviewsLabel: UILabel = {
        let label = UILabel()
        label.text = "Reviews"
        label.textColor = Theme.BLACK
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH2
        
        return label
    }()
    
    lazy var mainReviewsView: HostingReviewsViewController = {
        let controller = HostingReviewsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    var optionsLabel: UILabel = {
        let label = UILabel()
        label.text = "Options"
        label.textColor = Theme.BLACK
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH2
        
        return label
    }()
    
    lazy var mainOptionsView: HostingOptionsViewController = {
        let controller = HostingOptionsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    var informationHeightAnchor: NSLayoutConstraint!
    var optionsTopAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(mainInformationView.view)
        mainInformationView.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12).isActive = true
        mainInformationView.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        mainInformationView.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        mainInformationView.view.heightAnchor.constraint(equalToConstant: 165).isActive = true
        
        self.view.addSubview(pageControl)
        pageControl.widthAnchor.constraint(equalToConstant: 200).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        pageControl.topAnchor.constraint(equalTo: mainInformationView.view.bottomAnchor, constant: 12).isActive = true
        
        self.view.addSubview(mainExpandedInformationView.view)
        mainExpandedInformationView.view.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 12).isActive = true
        mainExpandedInformationView.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        mainExpandedInformationView.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        informationHeightAnchor = mainExpandedInformationView.view.heightAnchor.constraint(equalToConstant: 670)
        informationHeightAnchor.isActive = true
        
        self.view.addSubview(reviewsLabel)
        reviewsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        reviewsLabel.topAnchor.constraint(equalTo: mainExpandedInformationView.view.bottomAnchor, constant: 24).isActive = true
        reviewsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        reviewsLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(mainReviewsView.view)
        mainReviewsView.view.topAnchor.constraint(equalTo: reviewsLabel.bottomAnchor, constant: 12).isActive = true
        mainReviewsView.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        mainReviewsView.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        mainReviewsView.view.heightAnchor.constraint(equalToConstant: 174).isActive = true
        
        self.view.addSubview(optionsLabel)
        optionsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        optionsTopAnchor = optionsLabel.topAnchor.constraint(equalTo: mainReviewsView.view.bottomAnchor, constant: 24)
        optionsTopAnchor.isActive = true
        optionsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        optionsLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(mainOptionsView.view)
        mainOptionsView.view.topAnchor.constraint(equalTo: optionsLabel.bottomAnchor, constant: 12).isActive = true
        mainOptionsView.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        mainOptionsView.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        mainOptionsView.view.heightAnchor.constraint(equalToConstant: 257).isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(expandInformationPressed))
        mainInformationView.view.addGestureRecognizer(tapGesture)
        
        hideExpandedInformation()
    }
    
    @objc func expandInformationPressed() {
        UIView.animate(withDuration: animationOut) {
            if self.informationHeightAnchor.constant == 670 {
                self.informationHeightAnchor.constant = 0
                self.optionsTopAnchor.constant = -252
                self.mainExpandedInformationView.view.alpha = 0
                self.reviewsLabel.alpha = 0
                self.mainReviewsView.view.alpha = 0
                self.mainInformationView.editInformation.setTitle("Edit information", for: .normal)
                self.handleScroll(height: 1180, y: 610)
            } else if self.informationHeightAnchor.constant == 0 {
                self.informationHeightAnchor.constant = 670
                self.optionsTopAnchor.constant = 24
                self.mainExpandedInformationView.view.alpha = 1
                self.reviewsLabel.alpha = 1
                self.mainReviewsView.view.alpha = 1
                self.mainInformationView.editInformation.setTitle("Minimize information", for: .normal)
                self.handleScroll(height: 2160, y: 610)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func hideExpandedInformation() {
        self.informationHeightAnchor.constant = 0
        self.optionsTopAnchor.constant = -252
        self.mainExpandedInformationView.view.alpha = 0
        self.reviewsLabel.alpha = 0
        self.mainReviewsView.view.alpha = 0
        self.mainInformationView.editInformation.setTitle("Edit information", for: .normal)
        self.handleScroll(height: 1180, y: 610)
    }
    
    func handleScroll(height: CGFloat, y: CGFloat) {
        self.delegate?.handleScroll(height: height, y: y)
    }
    
}
