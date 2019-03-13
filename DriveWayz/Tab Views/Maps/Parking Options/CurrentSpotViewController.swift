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
    
    var shouldDarken: Bool = true
    
    var delegate: handleMinimizingFullController?
    var driveTime: Double = 0.0 {
        didSet {
            self.fullCurrentController.driveTime = driveTime
        }
    }
    
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
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.6
        
        return view
    }()
    
    var blackContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY
        view.alpha = 0
        
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
        
        return view
    }()
    
    var parkingBackButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(parkingHidden), for: .touchUpInside)
        button.alpha = 0
        button.clipsToBounds = true
        
        return button
    }()
    
    var parkingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "CURRENT PARKING"
        label.font = Fonts.SSPSemiBoldH3
        
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
    
    var spotLocatingLabel2: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "1065 University Avenue"
        label.font = Fonts.SSPRegularH1
        label.alpha = 0
        label.textContainerInset = UIEdgeInsets(top: 158, left: 24, bottom: 16, right: 24)
        label.backgroundColor = Theme.DARK_GRAY
        
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
    
    lazy var infoController: FullInfoViewController = {
        let controller = FullInfoViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
        
        return controller
    }()
    
    lazy var paymentController: FullCostViewController = {
        let controller = FullCostViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var durationController: CurrentTimeViewController = {
        let controller = CurrentTimeViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var fullDurationController: FullDurationViewController = {
        let controller = FullDurationViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var fullCurrentController: FullInfoViewController = {
        let controller = FullInfoViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        
        return view
    }()
    
    var lineView2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        
        return view
    }()
    
    var lineView3: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        view.backgroundColor = UIColor.clear
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.6
        
        setupViews()
        setupInfo()
        setupInformation()
        setupDuration()
        setupPayment()
        setupControllers()
    }
    
    var containerTopAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(container)
        containerTopAnchor = container.topAnchor.constraint(equalTo: self.view.topAnchor)
        containerTopAnchor.isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(blackContainer)
        blackContainer.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -10).isActive = true
        blackContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        blackContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        blackContainer.bottomAnchor.constraint(equalTo: container.topAnchor).isActive = true
        
        self.view.addSubview(spotLocatingLabel2)
        spotLocatingLabel2.leftAnchor.constraint(equalTo: blackContainer.leftAnchor).isActive = true
        spotLocatingLabel2.rightAnchor.constraint(equalTo: blackContainer.rightAnchor).isActive = true
        spotLocatingLabel2.bottomAnchor.constraint(equalTo: blackContainer.bottomAnchor).isActive = true
        spotLocatingLabel2.topAnchor.constraint(equalTo: blackContainer.topAnchor).isActive = true
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 1340)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
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
    
    var parkingViewHeightAnchor: NSLayoutConstraint!
    var parkingViewWidthAnchor: NSLayoutConstraint!
    var parkingViewTopAnchor: NSLayoutConstraint!
    var darkViewHeightAnchor: NSLayoutConstraint!
    var spotLocationTopAnchor: NSLayoutConstraint!
    
    func setupInfo() {
        
        scrollView.addSubview(darkView)
        darkView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        parkingViewTopAnchor = darkView.topAnchor.constraint(equalTo: scrollView.topAnchor)
        parkingViewTopAnchor.isActive = true
        parkingViewWidthAnchor = darkView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        parkingViewWidthAnchor.isActive = true
        darkViewHeightAnchor = darkView.heightAnchor.constraint(equalToConstant: 320)
        darkViewHeightAnchor.isActive = true
        
        darkView.addSubview(imageContainer)
        imageContainer.topAnchor.constraint(equalTo: darkView.topAnchor).isActive = true
        imageContainer.leftAnchor.constraint(equalTo: darkView.leftAnchor).isActive = true
        imageContainer.rightAnchor.constraint(equalTo: darkView.rightAnchor).isActive = true
        imageContainer.bottomAnchor.constraint(equalTo: darkView.bottomAnchor).isActive = true
        
        imageContainer.addSubview(parkingImageView)
        parkingImageView.topAnchor.constraint(equalTo: darkView.topAnchor).isActive = true
        parkingImageView.leftAnchor.constraint(equalTo: darkView.leftAnchor).isActive = true
        parkingImageView.rightAnchor.constraint(equalTo: darkView.rightAnchor).isActive = true
        parkingViewHeightAnchor = parkingImageView.bottomAnchor.constraint(equalTo: darkView.bottomAnchor)
        parkingViewHeightAnchor.isActive = true
        
        darkView.addSubview(parkingLabel)
        parkingLabel.leftAnchor.constraint(equalTo: parkingImageView.leftAnchor, constant: 24).isActive = true
        parkingLabel.rightAnchor.constraint(equalTo: parkingImageView.rightAnchor, constant: -24).isActive = true
        parkingLabel.topAnchor.constraint(equalTo: parkingImageView.topAnchor, constant: 18).isActive = true
        parkingLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        darkView.addSubview(spotLocatingLabel)
        spotLocatingLabel.leftAnchor.constraint(equalTo: parkingImageView.leftAnchor, constant: 24).isActive = true
        spotLocatingLabel.rightAnchor.constraint(equalTo: parkingImageView.rightAnchor, constant: -24).isActive = true
        spotLocationTopAnchor = spotLocatingLabel.topAnchor.constraint(equalTo: parkingLabel.bottomAnchor, constant: 0)
        spotLocationTopAnchor.isActive = true
        spotLocatingLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        darkView.addSubview(distanceLabel)
        distanceLabel.leftAnchor.constraint(equalTo: parkingImageView.leftAnchor, constant: 24).isActive = true
        distanceLabel.rightAnchor.constraint(equalTo: parkingImageView.rightAnchor, constant: -24).isActive = true
        distanceLabel.topAnchor.constraint(equalTo: spotLocatingLabel.bottomAnchor, constant: -8).isActive = true
        distanceLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
    }
    
    func setupInformation() {
        
        scrollView.addSubview(infoController.view)
        infoController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        infoController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        infoController.view.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 12).isActive = true
        infoController.view.heightAnchor.constraint(equalToConstant: 400).isActive = true
        
        scrollView.addSubview(lineView)
        lineView.topAnchor.constraint(equalTo: infoController.view.bottomAnchor).isActive = true
        lineView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        lineView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    var durationTopDistanceAnchor: NSLayoutConstraint!
    var durationWidthAnchor: NSLayoutConstraint!
    
    func setupDuration() {
        
        scrollView.addSubview(durationController.view)
        durationController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        durationWidthAnchor = durationController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -48)
        durationWidthAnchor.isActive = true
        durationTopDistanceAnchor = durationController.view.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 24)
        durationTopDistanceAnchor.isActive = true
        durationController.view.heightAnchor.constraint(equalToConstant: 288).isActive = true
        
        scrollView.addSubview(fullDurationController.view)
        fullDurationController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        fullDurationController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -24).isActive = true
        fullDurationController.view.topAnchor.constraint(equalTo: infoController.view.bottomAnchor, constant: 0).isActive = true
        fullDurationController.view.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        scrollView.addSubview(lineView2)
        lineView2.topAnchor.constraint(equalTo: fullDurationController.view.bottomAnchor).isActive = true
        lineView2.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        lineView2.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        lineView2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    func setupPayment() {
        
        scrollView.addSubview(paymentController.view)
        paymentController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        paymentController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -48).isActive = true
        paymentController.view.topAnchor.constraint(equalTo: fullDurationController.view.bottomAnchor, constant: 0).isActive = true
        paymentController.view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        scrollView.addSubview(lineView3)
        lineView3.topAnchor.constraint(equalTo: paymentController.view.bottomAnchor).isActive = true
        lineView3.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        lineView3.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        lineView3.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    func setupControllers() {

        self.view.bringSubviewToFront(spotLocatingLabel2)
        self.view.bringSubviewToFront(parkingBackButton)
        
    }
    
}


extension CurrentSpotViewController: handleParkingImageHeight {
    
    @objc func parkingHidden() {
        scrollView.setContentOffset(CGPoint(x: 0, y: -46.0), animated: true)
    }
    
    func didTranslate(translation: CGFloat) {
        let percent = (translation - 320)/(phoneHeight - 320)
        if percent <= 0.2 { self.parkingLabel.alpha = 1 - 5 * percent }
        self.containerTopAnchor.constant = 280 * percent
        self.darkViewHeightAnchor.constant = 320 - 80 * percent
        self.parkingViewWidthAnchor.constant = -24 * percent
        self.parkingViewHeightAnchor.constant = -70 * percent
        self.parkingViewTopAnchor.constant = 240 * percent
        //        self.durationTopDistanceAnchor.constant = 24 + 12 * percent
        self.spotLocationTopAnchor.constant = 18 + 116 * percent
        self.view.layoutIfNeeded()
    }
    
    func parkingImageScrolled(translation: CGFloat) {
        
    }
    
    func topController() {
        self.scrollView.isScrollEnabled = true
        UIView.animate(withDuration: animationOut, animations: {
            self.parkingLabel.alpha = 0
            self.containerTopAnchor.constant = 280
            self.darkViewHeightAnchor.constant = 260
            self.parkingViewWidthAnchor.constant = -24
            self.parkingViewHeightAnchor.constant = -70
            self.parkingViewTopAnchor.constant = 240
            //            self.durationTopDistanceAnchor.constant = 36
            self.durationWidthAnchor.constant = -24
            self.spotLocationTopAnchor.constant = 134
            self.durationController.view.alpha = 0
            self.infoController.view.alpha = 1
            self.imageContainer.layer.cornerRadius = 4
            self.spotLocatingLabel.font = Fonts.SSPRegularH2
            self.distanceLabel.font = Fonts.SSPRegularH5
            self.spotLocatingLabel.textColor = Theme.BLACK
            self.distanceLabel.textColor = Theme.BLACK
            self.view.layoutIfNeeded()
        }) { (success) in
            self.scrollView.setContentOffset(.zero, animated: true)
            UIView.animate(withDuration: animationIn, animations: {
                self.parkingBackButton.alpha = 1
            })
        }
    }
    
    func middleController() {
        //        self.scrollView.setContentOffset(CGPoint(x: 0, y: -44.0), animated: false)
        self.parkingBackButton.alpha = 0
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: animationOut, animations: {
            self.parkingLabel.alpha = 1
            self.containerTopAnchor.constant = 0
            self.darkViewHeightAnchor.constant = 320
            self.parkingViewWidthAnchor.constant = 0
            self.parkingViewHeightAnchor.constant = 0
            self.parkingViewTopAnchor.constant = 0
            //            self.durationTopDistanceAnchor.constant = 24
            self.durationWidthAnchor.constant = -48
            self.spotLocationTopAnchor.constant = 18
            self.durationController.view.alpha = 1
            self.infoController.view.alpha = 0
            self.spotLocatingLabel.font = Fonts.SSPRegularH1
            self.distanceLabel.font = Fonts.SSPRegularH4
            self.spotLocatingLabel.textColor = Theme.WHITE
            self.distanceLabel.textColor = Theme.WHITE
            self.imageContainer.layer.cornerRadius = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.scrollView.isScrollEnabled = false
        }
    }
    
    func bottomController() {
        //        UIView.animate(withDuration: animationOut) {
        //            self.parkingImageView.alpha = 0
        //            self.durationController.view.alpha = 0
        //            self.spotLocatingLabel.alpha = 0
        //            self.distanceLabel.alpha = 0
        //            self.parkingBackButton.alpha = 0
        //            self.parkingLabel.alpha = 0
        //            self.view.layoutIfNeeded()
        //        }
    }
    
}


extension CurrentSpotViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        if translation <= -46.0 && self.scrollView.isScrollEnabled == true && self.parkingBackButton.alpha == 1 {
            self.middleController()
            self.delegate?.minimizeFullController()
        } else {
            UIView.animate(withDuration: animationOut) {
                if translation > 90 && translation < 230 {
                    if self.shouldDarken { self.blackContainer.alpha = 1 }
                    self.containerTopAnchor.constant = 200
                    self.darkView.alpha = 1
                    self.spotLocatingLabel2.alpha = 0
                    self.parkingBackButton.tintColor = Theme.WHITE
                    self.delegate?.setLightStatusBar()
                } else if translation > 240 {
                    self.darkView.alpha = 0
                    delayWithSeconds(animationOut, completion: {
                        if self.darkView.alpha == 0 {
                            UIView.animate(withDuration: animationIn, animations: {
                                self.spotLocatingLabel2.alpha = 1
                            })
                        }
                    })
                } else if translation < 80 {
                    self.darkView.alpha = 1
                    self.spotLocatingLabel2.alpha = 0
                    self.containerTopAnchor.constant = 280
                    self.blackContainer.alpha = 0
                    self.parkingBackButton.tintColor = Theme.BLACK
                    self.delegate?.setDefaultStatusBar()
                    delayWithSeconds(0.6, completion: {
                        self.shouldDarken = true
                    })
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
}
