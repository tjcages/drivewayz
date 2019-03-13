//
//  ExpandedSpotViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 3/12/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ExpandedSpotViewController: UIViewController {
    
    var delegate: handleCheckoutParking?
    
    var mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -1)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.4
        
        return view
    }()
    
    lazy var blackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY
        let background = CAGradientLayer().customColor(topColor: Theme.DARK_GRAY.withAlphaComponent(0.5), bottomColor: Theme.DARK_GRAY)
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: 180)
        background.zPosition = -10
        view.layer.addSublayer(background)
        view.alpha = 0
        
        return view
    }()
    
    var spotLocatingLabel2: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "University Heights Avenue"
        label.font = Fonts.SSPRegularH1
        label.alpha = 0
        label.textContainerInset = UIEdgeInsets(top: 126, left: 24, bottom: 16, right: 24)
        label.backgroundColor = Theme.DARK_GRAY
        
        let white = UIView(frame: CGRect(x: 0, y: 179, width: phoneWidth, height: 1))
        white.backgroundColor = Theme.WHITE
        label.addSubview(white)
        
        return label
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.decelerationRate = .fast
        
        return view
    }()
    
    var parkingImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.clipsToBounds = true
        let image = UIImage(named: "background1")
        view.image = image
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    var darkView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.01)
        view.layer.shadowColor = Theme.DARK_GRAY.withAlphaComponent(0.6).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.2
        view.layer.cornerRadius = 4
        view.clipsToBounds = false
        
        return view
    }()
    
    var imageContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    var parkingBackButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(parkingHidden), for: .touchUpInside)
        button.clipsToBounds = true
        button.alpha = 0
        
        return button
    }()
    
    var spotLocatingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "One-Car Driveway"
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.text = "University Heights Avenue"
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    lazy var infoController: FullInfoViewController = {
        let controller = FullInfoViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var purchaseController: PurchaseDurationViewController = {
        let controller = PurchaseDurationViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var confirmDurationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Set Duration", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.BLUE
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.addTarget(self, action: #selector(confirmPurchasePressed(sender:)), for: .touchUpInside)
        button.layer.cornerRadius = 25
        
        return button
    }()
    
    lazy var reviewsController: ExpandedReviewsViewController = {
        let controller = ExpandedReviewsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        view.backgroundColor = UIColor.clear

        setupViews()
        setupInfo()
        setupInformation()
        setupPurchase()
    }
    
    var mainViewTopAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(mainView)
        mainViewTopAnchor = mainView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 260)
            mainViewTopAnchor.isActive = true
        mainView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        mainView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        mainView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(blackView)
        blackView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        blackView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        blackView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        blackView.bottomAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
        
        self.view.addSubview(spotLocatingLabel2)
        spotLocatingLabel2.leftAnchor.constraint(equalTo: blackView.leftAnchor).isActive = true
        spotLocatingLabel2.rightAnchor.constraint(equalTo: blackView.rightAnchor).isActive = true
        spotLocatingLabel2.bottomAnchor.constraint(equalTo: blackView.bottomAnchor).isActive = true
        spotLocatingLabel2.topAnchor.constraint(equalTo: blackView.topAnchor).isActive = true
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth, height: 1624.0)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.bringSubviewToFront(spotLocatingLabel2)
        self.view.addSubview(parkingBackButton)
        parkingBackButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        parkingBackButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        parkingBackButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        switch device {
        case .iphone8:
            parkingBackButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
        case .iphoneX:
            parkingBackButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true
        }
        
    }
    
    func setupInfo() {
        
        scrollView.addSubview(darkView)
        darkView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        darkView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 180).isActive = true
        darkView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -24).isActive = true
        darkView.heightAnchor.constraint(equalToConstant: 260).isActive = true
        
        darkView.addSubview(imageContainer)
        imageContainer.topAnchor.constraint(equalTo: darkView.topAnchor).isActive = true
        imageContainer.leftAnchor.constraint(equalTo: darkView.leftAnchor).isActive = true
        imageContainer.rightAnchor.constraint(equalTo: darkView.rightAnchor).isActive = true
        imageContainer.bottomAnchor.constraint(equalTo: darkView.bottomAnchor).isActive = true
        
        imageContainer.addSubview(parkingImageView)
        parkingImageView.topAnchor.constraint(equalTo: darkView.topAnchor).isActive = true
        parkingImageView.leftAnchor.constraint(equalTo: darkView.leftAnchor).isActive = true
        parkingImageView.rightAnchor.constraint(equalTo: darkView.rightAnchor).isActive = true
        parkingImageView.bottomAnchor.constraint(equalTo: darkView.bottomAnchor, constant: -70).isActive = true
        
        darkView.addSubview(spotLocatingLabel)
        spotLocatingLabel.leftAnchor.constraint(equalTo: parkingImageView.leftAnchor, constant: 20).isActive = true
        spotLocatingLabel.rightAnchor.constraint(equalTo: parkingImageView.rightAnchor, constant: -24).isActive = true
        spotLocatingLabel.topAnchor.constraint(equalTo: parkingImageView.bottomAnchor, constant: 2).isActive = true
        spotLocatingLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        darkView.addSubview(locationLabel)
        locationLabel.leftAnchor.constraint(equalTo: spotLocatingLabel.leftAnchor).isActive = true
        locationLabel.rightAnchor.constraint(equalTo: parkingImageView.rightAnchor, constant: -24).isActive = true
        locationLabel.topAnchor.constraint(equalTo: spotLocatingLabel.bottomAnchor, constant: -10).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
    }
    
    func setupInformation() {
        
        scrollView.addSubview(infoController.view)
        infoController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        infoController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        infoController.view.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 12).isActive = true
        infoController.view.heightAnchor.constraint(equalToConstant: 278).isActive = true
        
    }
    
    func setupPurchase() {
        
        scrollView.addSubview(purchaseController.view)
        purchaseController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        purchaseController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        purchaseController.view.topAnchor.constraint(equalTo: infoController.view.bottomAnchor).isActive = true
        purchaseController.view.heightAnchor.constraint(equalToConstant: 478).isActive = true
        
        self.view.addSubview(confirmDurationButton)
        confirmDurationButton.topAnchor.constraint(equalTo: purchaseController.view.bottomAnchor, constant: 12).isActive = true
        confirmDurationButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        confirmDurationButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        confirmDurationButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView.addSubview(reviewsController.view)
        reviewsController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        reviewsController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        reviewsController.view.topAnchor.constraint(equalTo: confirmDurationButton.bottomAnchor, constant: 72).isActive = true
        reviewsController.view.heightAnchor.constraint(equalToConstant: phoneHeight).isActive = true
        
    }
    
    @objc func confirmPurchasePressed(sender: UIButton) {
        
    }
    
    func openExpand(parking: ParkingSpots) {
        print(parking)
        self.purchaseController.startTiming()
        delayWithSeconds(animationOut) {
            UIView.animate(withDuration: animationOut) {
                self.parkingBackButton.alpha = 1
            }
        }
    }
    
    @objc func parkingHidden() {
        self.view.endEditing(true)
        scrollView.setContentOffset(CGPoint(x: 0, y: -46.0), animated: true)
        delayWithSeconds(1) {
            self.scrollView.setContentOffset(.zero, animated: true)
        }
    }
    
}


extension ExpandedSpotViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        if translation <= -46.0 && self.scrollView.isScrollEnabled == true && self.parkingBackButton.alpha == 1 {
            self.delegate?.didHideExpandedParking()
            UIView.animate(withDuration: animationOut) {
                self.parkingBackButton.alpha = 0
            }
        } else if translation > 0 && translation <= 80 {
            self.mainViewTopAnchor.constant = 260 - translation
            UIView.animate(withDuration: animationIn) {
                self.blackView.alpha = 0
                self.spotLocatingLabel2.alpha = 0
            }
        } else if translation > 80 {
            self.mainViewTopAnchor.constant = 180
            UIView.animate(withDuration: animationIn) {
                self.blackView.alpha = 1
                self.spotLocatingLabel2.alpha = 1
            }
        } else {
            self.mainViewTopAnchor.constant = 260
            UIView.animate(withDuration: animationIn) {
                self.blackView.alpha = 0
                self.spotLocatingLabel2.alpha = 0
            }
        }
        self.view.layoutIfNeeded()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = self.mainViewTopAnchor.constant
        UIView.animate(withDuration: animationIn) {
            if translation == 180 {
                self.blackView.alpha = 1
                self.spotLocatingLabel2.alpha = 1
            } else {
                self.blackView.alpha = 0
                self.spotLocatingLabel2.alpha = 0
            }
        }
    }
    
}
