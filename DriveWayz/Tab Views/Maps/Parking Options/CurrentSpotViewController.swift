//
//  CurrentSpotViewController
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 2/18/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol handleParkingImageHeight {
    func parkingImageScrolled(translation: CGFloat)
}

class CurrentSpotViewController: UIViewController {
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.decelerationRate = .fast
        view.backgroundColor = Theme.WHITE
        view.isScrollEnabled = false
        
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
        view.alpha = 0.3
        
        return view
    }()
    
    var darkView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY
        
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
        button.alpha = 0
        
        return button
    }()
    
    var parkingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "CURRENT PARKING"
        label.font = Fonts.SSPSemiBoldH2
        
        return label
    }()
    
    var spotLocatingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "1065 University Avenue"
        label.font = Fonts.SSPRegularH1
        
        return label
    }()
    
    var distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE.withAlphaComponent(0.8)
        label.text = "4 minute walk to Folsom Field"
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var durationShadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 3
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    lazy var durationController: CurrentTimeViewController = {
        let controller = CurrentTimeViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var fullCurrentController: FullCurrentViewController = {
        let controller = FullCurrentViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    var navigationIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let origImage = UIImage(named: "navigationIcon")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        
        return button
    }()
    
    var navigationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "GO"
        label.font = Fonts.SSPSemiBoldH2

        return label
    }()
    
    var navigationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PACIFIC_BLUE
        view.layer.cornerRadius = 3
        view.clipsToBounds = true
        
        return view
    }()
    
    var navigationShadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.6
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.6

        setupViews()
        setupInfo()
        setupDuration()
        setupNavigationButton()
        setupControllers()
    }
    

    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 940)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
    var parkingViewHeightAnchor: NSLayoutConstraint!
    var durationTopDistanceAnchor: NSLayoutConstraint!
    var durationLocationAnchor: NSLayoutConstraint!
    var spotLocationTopAnchor: NSLayoutConstraint!

    func setupInfo() {
        
        scrollView.addSubview(parkingImageView)
        parkingImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        parkingImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        parkingImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        parkingViewHeightAnchor = parkingImageView.heightAnchor.constraint(equalToConstant: 380)
            parkingViewHeightAnchor.isActive = true
        
        scrollView.addSubview(darkView)
        scrollView.bringSubviewToFront(parkingImageView)
        darkView.topAnchor.constraint(equalTo: parkingImageView.topAnchor).isActive = true
        darkView.leftAnchor.constraint(equalTo: parkingImageView.leftAnchor).isActive = true
        darkView.rightAnchor.constraint(equalTo: parkingImageView.rightAnchor).isActive = true
        darkView.bottomAnchor.constraint(equalTo: parkingImageView.bottomAnchor).isActive = true
        
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
        
        scrollView.addSubview(parkingLabel)
        parkingLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        parkingLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        parkingLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 18).isActive = true
        parkingLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(spotLocatingLabel)
        spotLocatingLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        spotLocatingLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        spotLocationTopAnchor = spotLocatingLabel.topAnchor.constraint(equalTo: parkingLabel.bottomAnchor, constant: 0)
            spotLocationTopAnchor.isActive = true
        spotLocatingLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(distanceLabel)
        distanceLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        distanceLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        distanceLabel.topAnchor.constraint(equalTo: spotLocatingLabel.bottomAnchor, constant: 0).isActive = true
        distanceLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true

    }
    
    func setupDuration() {
        
        scrollView.addSubview(durationShadowView)
        durationShadowView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        durationShadowView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        durationTopDistanceAnchor = durationShadowView.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 24)
            durationTopDistanceAnchor.isActive = true
        durationLocationAnchor = durationShadowView.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 24)
            durationLocationAnchor.isActive = false
        durationShadowView.heightAnchor.constraint(equalToConstant: 288).isActive = true
        
        durationShadowView.addSubview(durationController.view)
        durationController.view.leftAnchor.constraint(equalTo: durationShadowView.leftAnchor).isActive = true
        durationController.view.rightAnchor.constraint(equalTo: durationShadowView.rightAnchor).isActive = true
        durationController.view.bottomAnchor.constraint(equalTo: durationShadowView.bottomAnchor).isActive = true
        durationController.view.topAnchor.constraint(equalTo: durationShadowView.topAnchor).isActive = true

    }
    
    func setupNavigationButton() {
        
        scrollView.addSubview(navigationShadowView)
        navigationShadowView.rightAnchor.constraint(equalTo: durationShadowView.rightAnchor).isActive = true
        navigationShadowView.centerYAnchor.constraint(equalTo: parkingLabel.centerYAnchor, constant: 0).isActive = true
        navigationShadowView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        navigationShadowView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        navigationShadowView.addSubview(navigationView)
        navigationView.topAnchor.constraint(equalTo: navigationShadowView.topAnchor).isActive = true
        navigationView.leftAnchor.constraint(equalTo: navigationShadowView.leftAnchor).isActive = true
        navigationView.rightAnchor.constraint(equalTo: navigationShadowView.rightAnchor).isActive = true
        navigationView.bottomAnchor.constraint(equalTo: navigationShadowView.bottomAnchor).isActive = true
        
        navigationView.addSubview(navigationIcon)
        navigationIcon.leftAnchor.constraint(equalTo: navigationView.leftAnchor, constant: 4).isActive = true
        navigationIcon.topAnchor.constraint(equalTo: navigationView.topAnchor).isActive = true
        navigationIcon.bottomAnchor.constraint(equalTo: navigationView.bottomAnchor).isActive = true
        navigationIcon.widthAnchor.constraint(equalTo: navigationIcon.heightAnchor).isActive = true
        
        navigationView.addSubview(navigationLabel)
        navigationLabel.leftAnchor.constraint(equalTo: navigationIcon.rightAnchor, constant: 2).isActive = true
        navigationLabel.rightAnchor.constraint(equalTo: navigationView.rightAnchor).isActive = true
        navigationLabel.topAnchor.constraint(equalTo: navigationView.topAnchor).isActive = true
        navigationLabel.bottomAnchor.constraint(equalTo: navigationView.bottomAnchor).isActive = true
        
    }
    
    func setupControllers() {
        
        self.view.addSubview(fullCurrentController.view)
        fullCurrentController.view.topAnchor.constraint(equalTo: parkingImageView.bottomAnchor).isActive = true
        fullCurrentController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        fullCurrentController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        fullCurrentController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
    @objc func parkingHidden() {
        
    }
    
}


extension CurrentSpotViewController: handleParkingImageHeight {
    
    func didTranslate(translation: CGFloat) {
        let percent = (translation - 380)/(phoneHeight - 380)
        self.parkingLabel.alpha = 1 - 1 * percent
        self.parkingViewHeightAnchor.constant = 380 - 120 * percent
        self.durationTopDistanceAnchor.constant = 24 + phoneHeight * percent
        self.spotLocationTopAnchor.constant = 120 * percent
        self.view.layoutIfNeeded()
    }
    
    func parkingImageScrolled(translation: CGFloat) {
        let percent = translation/160
        self.parkingViewHeightAnchor.constant = 260 - 160 * percent
        self.parkingImageView.alpha = 0.5 - 0.5 * percent
        self.view.layoutIfNeeded()
    }
    
    func topController() {
        UIView.animate(withDuration: animationOut) {
            self.parkingImageView.alpha = 0.5
            self.durationController.view.alpha = 1
            self.spotLocatingLabel.alpha = 1
            self.distanceLabel.alpha = 1
            self.parkingBackButton.alpha = 1
            self.parkingLabel.alpha = 0
            self.parkingViewHeightAnchor.constant = 260
            self.durationTopDistanceAnchor.constant = phoneHeight + 24
            self.spotLocationTopAnchor.constant = 120
            self.view.layoutIfNeeded()
        }
    }
    
    func middleController() {
        UIView.animate(withDuration: animationOut) {
            self.parkingImageView.alpha = 0.3
            self.durationController.view.alpha = 1
            self.spotLocatingLabel.alpha = 1
            self.distanceLabel.alpha = 1
            self.parkingBackButton.alpha = 0
            self.parkingLabel.alpha = 1
            self.parkingViewHeightAnchor.constant = 380
            self.durationTopDistanceAnchor.constant = 24
            self.spotLocationTopAnchor.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func bottomController() {
        UIView.animate(withDuration: animationOut) {
            self.parkingImageView.alpha = 0
            self.durationController.view.alpha = 0
            self.spotLocatingLabel.alpha = 0
            self.distanceLabel.alpha = 0
            self.parkingBackButton.alpha = 0
            self.parkingLabel.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
}
