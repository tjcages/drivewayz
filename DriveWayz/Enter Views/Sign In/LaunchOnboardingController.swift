//
//  LaunchOnboardingController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 1/28/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit
import SVGKit

protocol OnboardingDelegate {
    func dismissNumberController()
}

class LaunchOnboardingController: UIViewController {
    
    var delegate: handleStatusBarHide?
    var illustrationHeight: CGFloat = 0.0
    let firstBackground: UIColor = Theme.BLUE_DARK
    let secondBackground: UIColor = Theme.COOL_1_MED
    let thirdBackground: UIColor = Theme.COOL_2_MED
    
    lazy var box: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK

        return view
    }()
    
    var drivewayzIcon_white: SVGKImageView = {
        let image = SVGKImage(named: "DrivewayzLogo_white")
        let view = SVGKFastImageView(svgkImage: image)!
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var drivewayzIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        let image = SVGKImage(named: "DrivewayzLogo")?.uiImage.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.alpha = 0
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE_DARK
        view.delegate = self
        view.isPagingEnabled = true
        view.bounces = false
        
        return view
    }()
    
    var privateIllustration: SVGKImageView = {
        let image = SVGKImage(named: "Private_Parking_Illustration")
        let view = SVGKFastImageView(svgkImage: image)!
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        
        return view
    }()
    
    var carIllustration: SVGKImageView = {
        let image = SVGKImage(named: "Car_Illustration")
        let view = SVGKFastImageView(svgkImage: image)!
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        
        return view
    }()
    
    var bikeIllustration: SVGKImageView = {
        let image = SVGKImage(named: "Bike&Door_Illustration")
        let view = SVGKFastImageView(svgkImage: image)!
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var buildingIllustration: SVGKImageView = {
        let image = SVGKImage(named: "Building_Illustration")
        let view = SVGKFastImageView(svgkImage: image)!
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        view.isUserInteractionEnabled = false

        return view
    }()
    
    let paging: HorizontalPagingDisplay = {
        let view = HorizontalPagingDisplay()
        view.leftSelectionLine.backgroundColor = Theme.GRAY_WHITE_2
        view.centerSelectionLine.backgroundColor = Theme.GRAY_WHITE_2
        view.rightSelectionLine.backgroundColor = Theme.GRAY_WHITE_2
        view.alpha = 0
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Building a more \nconnected future"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH25
        label.numberOfLines = 2
        label.alpha = 0
        
        return label
    }()
    
    var searchView: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.LINE_GRAY
        button.clipsToBounds = true
        button.layer.cornerRadius = 2
        button.alpha = 0
        button.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var searchLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Enter your mobile number"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "phone_filled")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.backgroundColor = Theme.GRAY_WHITE_4
        button.layer.cornerRadius = 16
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var socialButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Or connect with a social network", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(socialButtonPressed), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.BLACK

        setupViews()
        setupLogo()
        setupContainer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animateOut(withDuration: animationOut, animations: {
            self.drivewayzIcon_white.alpha = 0
            self.drivewayzIcon.alpha = 1
            self.box.backgroundColor = Theme.WHITE
            self.container.backgroundColor = Theme.WHITE
            self.view.backgroundColor = Theme.WHITE
        }) { (success) in
            delayWithSeconds(animationOut) {
                self.animate()
            }
        }
    }
    
    var privateBottomAnchor: NSLayoutConstraint!
    var carRightAnchor: NSLayoutConstraint!
    var mainLabelTopAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth * 3, height: phoneHeight)
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        scrollView.addSubview(privateIllustration)
        scrollView.addSubview(carIllustration)
        scrollView.addSubview(bikeIllustration)
        scrollView.addSubview(buildingIllustration)
        
        let height = privateIllustration.image.size.height/privateIllustration.image.size.width * phoneWidth
        illustrationHeight = height
        privateIllustration.anchor(top: nil, left: scrollView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: phoneWidth, height: height)
        privateBottomAnchor = privateIllustration.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            privateBottomAnchor.isActive = true
        
        carIllustration.widthAnchor.constraint(equalTo: privateIllustration.widthAnchor, multiplier: 0.45).isActive = true
        carIllustration.heightAnchor.constraint(equalTo: carIllustration.widthAnchor, multiplier: 0.294).isActive = true
        carRightAnchor = carIllustration.rightAnchor.constraint(equalTo: privateIllustration.rightAnchor, constant: -phoneWidth)
            carRightAnchor.isActive = true
        carIllustration.bottomAnchor.constraint(equalTo: privateIllustration.bottomAnchor).isActive = true
        
        bikeIllustration.anchor(top: nil, left: privateIllustration.rightAnchor, bottom: privateIllustration.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: phoneWidth, height: height)
        
        buildingIllustration.anchor(top: nil, left: bikeIllustration.rightAnchor, bottom: privateIllustration.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: -1, paddingRight: 0, width: phoneWidth, height: height)
        
    }
    
    var containerWidthAnchor: NSLayoutConstraint!
    var boxHeightAnchor: NSLayoutConstraint!
    var containerSmallWidthAnchor: NSLayoutConstraint!
    var containerSmallHeightAnchor: NSLayoutConstraint!
    var containerCenterAnchor: NSLayoutConstraint!
    var logoHeightAnchor: NSLayoutConstraint!

    func setupLogo() {
        
        view.addSubview(box)
        box.addSubview(drivewayzIcon_white)
        box.addSubview(drivewayzIcon)
        
        box.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerCenterAnchor = box.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            containerCenterAnchor.isActive = true
        containerWidthAnchor = box.widthAnchor.constraint(equalTo: view.widthAnchor)
            containerWidthAnchor.isActive = true
        boxHeightAnchor = box.heightAnchor.constraint(equalTo: view.heightAnchor)
            boxHeightAnchor.isActive = true
        containerSmallWidthAnchor = box.widthAnchor.constraint(equalToConstant: 160)
            containerSmallWidthAnchor.isActive = false
        containerSmallHeightAnchor = box.heightAnchor.constraint(equalToConstant: 200)
            containerSmallHeightAnchor.isActive = false
        
        drivewayzIcon.centerXAnchor.constraint(equalTo: box.centerXAnchor).isActive = true
        drivewayzIcon.centerYAnchor.constraint(equalTo: box.centerYAnchor).isActive = true
        logoHeightAnchor = drivewayzIcon.heightAnchor.constraint(equalToConstant: 60)
            logoHeightAnchor.isActive = true
        drivewayzIcon.widthAnchor.constraint(equalTo: drivewayzIcon.heightAnchor).isActive = true
        
        drivewayzIcon_white.centerXAnchor.constraint(equalTo: box.centerXAnchor).isActive = true
        drivewayzIcon_white.centerYAnchor.constraint(equalTo: box.centerYAnchor).isActive = true
        drivewayzIcon_white.heightAnchor.constraint(equalTo: drivewayzIcon.heightAnchor).isActive = true
        drivewayzIcon_white.widthAnchor.constraint(equalTo: drivewayzIcon.heightAnchor).isActive = true
        
    }
    
    var containerHeightAnchor: NSLayoutConstraint!
    var searchLeftAnchor: NSLayoutConstraint!
    var searchHeightAnchor: NSLayoutConstraint!
    
    func setupContainer() {
        
        view.addSubview(container)
        container.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        containerHeightAnchor = container.heightAnchor.constraint(equalToConstant: bottomSafeArea + 20)
            containerHeightAnchor.isActive = true
        
        container.addSubview(paging)
        paging.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        paging.topAnchor.constraint(equalTo: container.topAnchor, constant: 16).isActive = true
        paging.widthAnchor.constraint(equalToConstant: 53).isActive = true
        paging.heightAnchor.constraint(equalToConstant: 8).isActive = true
        
        container.addSubview(mainLabel)
        
        mainLabelTopAnchor = mainLabel.topAnchor.constraint(equalTo: paging.bottomAnchor, constant: 64)
            mainLabelTopAnchor.isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()
        
        view.addSubview(searchView)
        searchView.addSubview(searchLabel)
        searchView.addSubview(searchButton)
        
        searchView.anchor(top: mainLabel.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 32, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        searchHeightAnchor = searchView.heightAnchor.constraint(equalToConstant: 60)
            searchHeightAnchor.isActive = true
        searchLeftAnchor = searchView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20)
            searchLeftAnchor.isActive = true
        
        searchLabel.leftAnchor.constraint(equalTo: searchView.leftAnchor, constant: 20).isActive = true
        searchLabel.centerYAnchor.constraint(equalTo: searchView.centerYAnchor).isActive = true
        searchLabel.sizeToFit()
        
        searchButton.centerYAnchor.constraint(equalTo: searchView.centerYAnchor).isActive = true
        searchButton.anchor(top: nil, left: nil, bottom: nil, right: searchView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 32, height: 32)
        
        view.addSubview(socialButton)
        socialButton.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 32).isActive = true
        socialButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        socialButton.sizeToFit()
        
    }
    
    func animate() {
        logoHeightAnchor.constant = 40
        containerWidthAnchor.isActive = false
        boxHeightAnchor.isActive = false
        containerSmallWidthAnchor.isActive = true
        containerSmallHeightAnchor.isActive = true
        containerCenterAnchor.constant = 64
        UIView.animateKeyframes(withDuration: 0.6, delay: 0, options: [.calculationModeCubic], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                self.drivewayzIcon.tintColor = self.firstBackground
                self.privateIllustration.alpha = 1
                self.containerSmallHeightAnchor.constant = 100
                self.containerSmallWidthAnchor.constant = 100
                self.privateBottomAnchor.constant = -300
                self.containerHeightAnchor.constant = 300 + bottomSafeArea
                self.containerCenterAnchor.constant = -150 - self.illustrationHeight/2
                self.view.layoutIfNeeded()
            }
        }) { (success) in
            self.mainLabelTopAnchor.constant = 32
            UIView.animateOut(withDuration: animationOut, animations: {
                self.mainLabel.alpha = 1
                self.paging.alpha = 1
                self.searchView.alpha = 1
                self.socialButton.alpha = 1
                self.view.layoutIfNeeded()
            }, completion: nil)
            self.animateCar()
        }
    }

    func animateCar() {
        if carIllustration.alpha == 0 {
            carIllustration.alpha = 1
            carRightAnchor.constant = -120
            UIView.animateOut(withDuration: 1, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @objc func searchButtonPressed() {
        containerHeightAnchor.constant = phoneHeight
        mainLabelTopAnchor.constant = topSafeArea + 68
        searchLeftAnchor.constant = 104
        searchHeightAnchor.constant = 50
        mainLabel.text = "Enter your \nphone number"
        UIView.animate(withDuration: 0.3, animations: {
//            self.mainLabel.alpha = 0
//            self.searchView.alpha = 0
            self.socialButton.alpha = 0
            self.paging.alpha = 0
            self.searchButton.alpha = 0
            self.searchLabel.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            let controller = OnboardingNumberController()
            controller.delegate = self
            let navigation = UINavigationController(rootViewController: controller)
            navigation.navigationBar.isHidden = true
            navigation.modalPresentationStyle = .overFullScreen
            self.present(navigation, animated: false, completion: nil)
        }
    }
    
    @objc func socialButtonPressed() {
        let controller = OnboardingSocialController()
        let navigation = UINavigationController(rootViewController: controller)
        navigation.navigationBar.isHidden = true
        navigation.modalPresentationStyle = .overFullScreen
        present(navigation, animated: true, completion: nil)
    }
    
}

extension LaunchOnboardingController: OnboardingDelegate {
    
    func dismissNumberController() {
        containerHeightAnchor.constant = 300 + bottomSafeArea
        mainLabelTopAnchor.constant = 32
        searchLeftAnchor.constant = 20
        searchHeightAnchor.constant = 60
        UIView.animateOut(withDuration: animationOut, animations: {
            self.mainLabel.alpha = 1
            self.searchView.alpha = 1
            self.socialButton.alpha = 1
            self.paging.alpha = 1
            self.searchButton.alpha = 1
            self.searchLabel.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            self.mainLabel.text = "Building a more \nconnected future"
        }
    }
    
}

extension LaunchOnboardingController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.x
        var percentage = translation/phoneWidth
        paging.changeScroll(percentage: percentage)
        
        if percentage >= 0 && percentage <= 1.0 {
            let color = fadeFromColor(fromColor: firstBackground, toColor: secondBackground, withPercentage: percentage)
            scrollView.backgroundColor = color
            drivewayzIcon.tintColor = color
        } else if percentage > 1.0 && percentage <= 2.0 {
            percentage -= 1.0
            let color = fadeFromColor(fromColor: secondBackground, toColor: thirdBackground, withPercentage: percentage)
            scrollView.backgroundColor = color
            drivewayzIcon.tintColor = color
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.x
        let percentage = round(translation/phoneWidth)
        paging.changeScroll(percentage: percentage)
        
        if percentage != 0 {
            carRightAnchor.constant = -phoneWidth
        }
        view.layoutIfNeeded()
        if percentage != 0 {
            carIllustration.alpha = 0
        } else {
            animateCar()
        }
        
        UIView.animate(withDuration: animationIn) {
            if percentage == 0 {
                scrollView.backgroundColor = self.firstBackground
                self.drivewayzIcon.tintColor = self.firstBackground
            } else if percentage == 1 {
                scrollView.backgroundColor = self.secondBackground
                self.drivewayzIcon.tintColor = self.secondBackground
            } else if percentage == 2 {
                scrollView.backgroundColor = self.thirdBackground
                self.drivewayzIcon.tintColor = self.thirdBackground
            }
        }
    }
    
}
