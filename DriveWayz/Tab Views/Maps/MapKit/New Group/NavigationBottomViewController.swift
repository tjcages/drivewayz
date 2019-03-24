//
//  NavigationCurrentViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 3/17/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class NavigationBottomViewController: UIViewController {
    
    var delegate: handleCurrentNavigationViews?
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        view.backgroundColor = UIColor.clear
        view.isScrollEnabled = false
        
        return view
    }()
    
    var scrollBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        view.layer.cornerRadius = 2
        
        return view
    }()
    
    var spotLocatingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "1065 University Avenue"
        label.font = Fonts.SSPSemiBoldH2
        
        return label
    }()
    
    var distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "8 minute drive"
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var navigationIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let origImage = UIImage(named: "navigationIcon")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var navigationButtonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "Navigate"
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var navigationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.GREEN_PIGMENT.withAlphaComponent(0.8)
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        //        view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        return view
    }()
    
    var checkInButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Check in", for: .normal)
        button.backgroundColor = Theme.OFF_WHITE.withAlphaComponent(0.7)
        button.alpha = 0.8
        button.layer.cornerRadius = 4
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        
        return button
    }()
    
    var parkingImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.clipsToBounds = true
        let image = UIImage(named: "exampleParking")
        view.image = image
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    var parkingShadowView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.DARK_GRAY
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.6
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var infoController: FullInfoViewController = {
        let controller = FullInfoViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var paymentController: FullCostViewController = {
        let controller = FullCostViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.6
        
        setupViews()
        setupNavigationButton()
        setupParkingInfo()
        setupPayment()
    }
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 1340)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(scrollBar)
        scrollBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        scrollBar.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12).isActive = true
        scrollBar.widthAnchor.constraint(equalToConstant: 40).isActive = true
        scrollBar.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
        scrollView.addSubview(spotLocatingLabel)
        spotLocatingLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        spotLocatingLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        spotLocatingLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24).isActive = true
        spotLocatingLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(distanceLabel)
        distanceLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        distanceLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        distanceLabel.topAnchor.constraint(equalTo: spotLocatingLabel.bottomAnchor, constant: -8).isActive = true
        distanceLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
    }
    
    func setupNavigationButton() {
        
        scrollView.addSubview(navigationView)
        navigationView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        navigationView.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 16).isActive = true
        navigationView.widthAnchor.constraint(equalToConstant: 140).isActive = true
        navigationView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(navigationPressed))
        navigationView.addGestureRecognizer(tapGesture)
        
        navigationView.addSubview(navigationIcon)
        navigationIcon.leftAnchor.constraint(equalTo: navigationView.leftAnchor, constant: 4).isActive = true
        navigationIcon.topAnchor.constraint(equalTo: navigationView.topAnchor).isActive = true
        navigationIcon.bottomAnchor.constraint(equalTo: navigationView.bottomAnchor).isActive = true
        navigationIcon.widthAnchor.constraint(equalTo: navigationIcon.heightAnchor).isActive = true
        
        navigationView.addSubview(navigationButtonLabel)
        navigationButtonLabel.leftAnchor.constraint(equalTo: navigationIcon.rightAnchor, constant: 2).isActive = true
        navigationButtonLabel.rightAnchor.constraint(equalTo: navigationView.rightAnchor).isActive = true
        navigationButtonLabel.topAnchor.constraint(equalTo: navigationView.topAnchor).isActive = true
        navigationButtonLabel.bottomAnchor.constraint(equalTo: navigationView.bottomAnchor).isActive = true
        
        scrollView.addSubview(checkInButton)
        checkInButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        checkInButton.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor).isActive = true
        checkInButton.rightAnchor.constraint(equalTo: navigationView.leftAnchor, constant: -12).isActive = true
        checkInButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
    }
    
    func setupParkingInfo() {
        
        scrollView.addSubview(parkingShadowView)
        parkingShadowView.topAnchor.constraint(equalTo: checkInButton.bottomAnchor, constant: 24).isActive = true
        parkingShadowView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        parkingShadowView.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        parkingShadowView.heightAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        
        parkingShadowView.addSubview(parkingImageView)
        parkingImageView.topAnchor.constraint(equalTo: parkingShadowView.topAnchor).isActive = true
        parkingImageView.leftAnchor.constraint(equalTo: parkingShadowView.leftAnchor).isActive = true
        parkingImageView.rightAnchor.constraint(equalTo: parkingShadowView.rightAnchor).isActive = true
        parkingImageView.bottomAnchor.constraint(equalTo: parkingShadowView.bottomAnchor).isActive = true
        
        scrollView.addSubview(infoController.view)
        infoController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        infoController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 24).isActive = true
        infoController.view.topAnchor.constraint(equalTo: parkingImageView.bottomAnchor, constant: 12).isActive = true
        infoController.view.heightAnchor.constraint(equalToConstant: 280).isActive = true
        
    }
    
    func setupPayment() {
        
        scrollView.addSubview(paymentController.view)
        paymentController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        paymentController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -24).isActive = true
        paymentController.view.topAnchor.constraint(equalTo: infoController.view.bottomAnchor, constant: 0).isActive = true
        paymentController.view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        scrollView.addSubview(lineView)
        lineView.topAnchor.constraint(equalTo: paymentController.view.bottomAnchor).isActive = true
        lineView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        lineView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    @objc func navigationPressed() {
        self.delegate?.beginRouteNavigation()
    }
    
}

extension NavigationBottomViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        if translation <= -46 {
            self.delegate?.minimizeBottomView()
        }
    }
    
}
