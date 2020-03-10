//
//  LaunchMainController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 1/30/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit
import SVGKit

class LaunchMainController: UIViewController {
    
    var delegate: handleStatusBarHide?
    
    lazy var tabController: TabViewController = {
        let controller = TabViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(controller)
        controller.view.isUserInteractionEnabled = false
        controller.delegate = self.delegate

        return controller
    }()
    
    var whiteView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var box: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        view.layer.borderColor = Theme.WHITE.cgColor

        return view
    }()
    
    var boxWhite: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE

        return view
    }()
    
    var locationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.GOOGLE_BLUE
        view.alpha = 0

        return view
    }()
    
    var drivewayzIcon: SVGKImageView = {
        let image = SVGKImage(named: "DrivewayzLogo_white")
        let view = SVGKFastImageView(svgkImage: image)!
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE

        setupViews()
        setupLogo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        delayWithSeconds(animationOut * 3) {
            self.animate()
        }
    }
    
    func setupViews() {
        
        view.addSubview(tabController.view)
        view.addSubview(whiteView)
        
        tabController.view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 00, paddingRight: 0, width: 0, height: 0)
        
        whiteView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 00, paddingRight: 0, width: 0, height: 0)
        
    }
    
    var containerCenterAnchor: NSLayoutConstraint!

    func setupLogo() {
        
        view.addSubview(locationView)
        view.addSubview(boxWhite)
        view.addSubview(box)
        box.addSubview(drivewayzIcon)
        
        box.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerCenterAnchor = box.centerYAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/2)
            containerCenterAnchor.isActive = true
        box.widthAnchor.constraint(equalTo: box.heightAnchor).isActive = true
        box.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2).isActive = true
        box.layer.cornerRadius = view.frame.height

        boxWhite.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        boxWhite.centerYAnchor.constraint(equalTo: box.centerYAnchor).isActive = true
        boxWhite.widthAnchor.constraint(equalTo: boxWhite.heightAnchor).isActive = true
        boxWhite.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2).isActive = true
        boxWhite.layer.cornerRadius = view.frame.height
        
        locationView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        locationView.centerYAnchor.constraint(equalTo: box.centerYAnchor).isActive = true
        locationView.widthAnchor.constraint(equalTo: locationView.heightAnchor).isActive = true
        locationView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2).isActive = true
        locationView.layer.cornerRadius = view.frame.height
        
        drivewayzIcon.centerXAnchor.constraint(equalTo: box.centerXAnchor).isActive = true
        drivewayzIcon.centerYAnchor.constraint(equalTo: box.centerYAnchor).isActive = true
        drivewayzIcon.heightAnchor.constraint(equalToConstant: 60).isActive = true
        drivewayzIcon.widthAnchor.constraint(equalTo: drivewayzIcon.heightAnchor).isActive = true
        
    }
    
    func animate() {
        let scale = 13/(view.frame.height * 2)
        let scale2 = 16/(view.frame.height * 2)
        let displacement = self.view.frame.height/2 - (mainBarNormalHeight + statusHeight - bottomSafeArea - 8)/2
        
        delayWithSeconds(0.4) {
            self.tabController.mapController.mainViewState = .startup
        }
        delayWithSeconds(1.65) {
            self.tabController.mapController.mapView.isMyLocationEnabled = true
        }
        UIView.animateKeyframes(withDuration: 2, delay: 0, options: [.calculationModeCubic], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.15) {
                self.drivewayzIcon.alpha = 0
                self.drivewayzIcon.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                self.box.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.boxWhite.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.locationView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                self.locationView.alpha = 0.1
            }
            UIView.addKeyframe(withRelativeStartTime: 0.15, relativeDuration: 0.15) {
                self.box.transform = CGAffineTransform(scaleX: scale2, y: scale2)
                self.boxWhite.transform = CGAffineTransform(scaleX: scale2, y: scale2)
                self.locationView.transform = CGAffineTransform(scaleX: scale * 4, y: scale * 4)
                self.locationView.alpha = 0.2
                self.whiteView.alpha = 0.66
                self.containerCenterAnchor.constant = self.view.frame.height/2 - 16
                self.view.layoutIfNeeded()
            }
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.4) {
                self.locationView.transform = CGAffineTransform(scaleX: scale * 2.1, y: scale * 2.1)
                self.tabController.mapController.backgroundImageView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                self.containerCenterAnchor.constant = displacement
                self.locationView.alpha = 0.3
                
                self.whiteView.alpha = 0
                self.box.backgroundColor = Theme.GOOGLE_BLUE
                self.view.layoutIfNeeded()
            }
            UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.3) {
                self.box.transform = CGAffineTransform(scaleX: scale, y: scale)
                self.tabController.mapController.backgroundImageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self.tabController.mapController.backgroundImageView.alpha = 0
                self.locationView.alpha = 0
            }
        }) { (success) in
            self.delegate?.defaultStatusBar()
            self.delegate?.bringStatusBar()
            self.box.alpha = 0
            self.boxWhite.alpha = 0
            self.tabController.view.isUserInteractionEnabled = true
            self.tabController.bringHamburger()
            self.tabController.checkOpens()
        }
    }
    
}
