//
//  HostLocationView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/25/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol HandleHostLocation {
    func changeScroll(view: UIView)
    func dimBackground()
    func removeDim()
}

class HostLocationView: UIViewController {
    
    lazy var gradientController: GradientContainerView = {
        let controller = GradientContainerView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.mainLabel.text = ""
        controller.setBackButton()
        controller.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        controller.scrollViewHeight = 900
        controller.scrollView.delegate = self
        
        return controller
    }()
    
    var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLACK
        button.layer.cornerRadius = 35
        button.layer.shadowColor = Theme.BLACK.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 6
        button.layer.shadowOpacity = 0.2
        let image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.transform = CGAffineTransform(scaleX: -0.2, y: 0.2)
        button.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var locationController: LocationFieldsView = {
        let controller = LocationFieldsView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.view.alpha = 0
        controller.delegate = self
        
        return controller
    }()
    
    lazy var mapController: LocationMapView = {
        let controller = LocationMapView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.view.alpha = 0
        
        return controller
    }()
    
    lazy var picturesController: HostPicturesView = {
        let controller = HostPicturesView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.view.alpha = 0
        controller.delegate = self
        
        return controller
    }()
    
    lazy var helpButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "helpIcon")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(openHelp), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    lazy var dimView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight))
        view.backgroundColor = Theme.BLACK
        view.alpha = 0
        
        return view
    }()

    let paging: ProgressPagingDisplay = {
        let view = ProgressPagingDisplay()
        view.changeProgress(index: 1)
        view.alpha = 0
        
        return view
    }()
    
    // Rest of the Host Signup process
    var hostAvailabilityController = HostAvailabilityView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(progressTapped))
        paging.addGestureRecognizer(tap)

        setupViews()
        setupControllers()
    }
    
    @objc func progressTapped() {
        let controller = HostProgressView()
        controller.shouldDismiss = true
        controller.progressController.secondStep()
        present(controller, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        gradientController.scrollView.scrollToTop(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if mainTypeState == .location {
            if gradientController.mainLabel.text == "" {
                gradientController.animateText(text: "Location")
            }
            delayWithSeconds(animationOut) {
                UIView.animate(withDuration: animationIn) {
                    self.paging.alpha = 1
                    self.view.layoutIfNeeded()
                }
                if self.nextButton.tintColor != Theme.WHITE {
                    self.showNextButton()
                }
                self.animate()
            }
        } else {
            removeDim()
            showNextButton()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        view.endEditing(true)
        gradientController.scrollView.scrollToTop(animated: true)
        locationTopAnchor.constant = 108
        locationController.view.alpha = 0
        view.layoutIfNeeded()
    }
    
    var nextButtonBottomAnchor: NSLayoutConstraint!
    var nextButtonKeyboardAnchor: NSLayoutConstraint!
    var nextButtonRightAnchor: NSLayoutConstraint!

    func setupViews() {
        
        view.addSubview(gradientController.view)
        gradientController.view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        gradientController.view.addSubview(paging)
        paging.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        paging.centerYAnchor.constraint(equalTo: gradientController.backButton.centerYAnchor).isActive = true
        paging.widthAnchor.constraint(equalToConstant: 86).isActive = true
        paging.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        view.addSubview(nextButton)
        nextButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 70, height: 70)
        nextButtonBottomAnchor = nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
            nextButtonBottomAnchor.isActive = true
        nextButtonKeyboardAnchor = nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32)
            nextButtonKeyboardAnchor.isActive = false
        nextButtonRightAnchor = nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: phoneWidth/2)
            nextButtonRightAnchor.isActive = true
        
        gradientController.view.addSubview(helpButton)
        helpButton.centerYAnchor.constraint(equalTo: gradientController.backButton.centerYAnchor).isActive = true
        helpButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        helpButton.heightAnchor.constraint(equalTo: helpButton.widthAnchor).isActive = true
        helpButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
    }
    
    var locationTopAnchor: NSLayoutConstraint!
    var picturesHeightAnchor: NSLayoutConstraint!
    var picturesBottomAnchor: NSLayoutConstraint!
    
    func setupControllers() {
        
        gradientController.scrollView.addSubview(locationController.view)
        locationController.view.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        locationTopAnchor = locationController.view.topAnchor.constraint(equalTo: gradientController.scrollView.topAnchor, constant: 72)
            locationTopAnchor.isActive = true
        
        view.addSubview(locationsSearchResults.view)
        locationsSearchResults.view.leftAnchor.constraint(equalTo: locationController.streetLine.leftAnchor).isActive = true
        locationsSearchResults.view.rightAnchor.constraint(equalTo: locationController.streetLine.rightAnchor).isActive = true
        locationsSearchResults.view.topAnchor.constraint(equalTo: locationController.streetLine.bottomAnchor).isActive = true
        locationsSearchResults.view.heightAnchor.constraint(equalToConstant: 199).isActive = true
        
        gradientController.view.addSubview(mapController.view)
        mapController.view.anchor(top: gradientController.scrollView.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        gradientController.view.addSubview(picturesController.view)
        picturesController.view.anchor(top: gradientController.scrollView.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: -2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        picturesHeightAnchor = picturesController.view.heightAnchor.constraint(equalToConstant: 0)
            picturesHeightAnchor.isActive = true
        picturesBottomAnchor = picturesController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            picturesBottomAnchor.isActive = false
        
        view.addSubview(dimView)
    }
    
    @objc func nextButtonPressed() {
        view.endEditing(true)
        nextButton.isUserInteractionEnabled = false
        locationsSearchResults.view.alpha = 0
        switch mainTypeState {
        case .location:
            showMap(forward: true)
        case .map:
            showPictures()
        case .pictures:
            showAvailability()
        default:
            nextButton.isUserInteractionEnabled = false
            return
        }
    }
    
    func showLocation() {
        mainTypeState = .location
        mapController.shouldMonitor = false
        gradientController.setSublabel(text: "")
        mapController.hideMap()
        UIView.animate(withDuration: animationOut * 2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            //
            self.view.layoutIfNeeded()
        }) { (success) in
            self.locationTopAnchor.constant = 0
            self.mapController.view.alpha = 0
             UIView.animate(withDuration: animationOut, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.locationController.view.alpha = 1
                 self.view.layoutIfNeeded()
             }) { (success) in
                self.gradientController.backButton.isUserInteractionEnabled = true
             }
        }
    }
    
    func showMap(forward: Bool) {
        if forward {
            let check = locationController.checkTextFields()
            if check {
                mainTypeState = .map
                mapController.shouldMonitor = true
                
                let address = locationController.combineAddress()
                 mapController.zoomToAddress(address: address, street: locationController.streetField.text)
                 UIView.animate(withDuration: animationOut, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                    self.locationController.view.alpha = 0
                    self.view.layoutIfNeeded()
                }) { (success) in
                     self.mapController.view.alpha = 1
                     self.gradientController.setSublabel(text: "Move the map so the pin is above the correct spot")
                     self.mapController.showMap()
                     UIView.animate(withDuration: animationOut * 2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                         self.view.layoutIfNeeded()
                     }) { (success) in
                         self.nextButton.isUserInteractionEnabled = true
                     }
                }
            } else {
                nextButton.isUserInteractionEnabled = true
            }
        } else {
            mainTypeState = .map
            mapController.shouldMonitor = true
            
            UIView.animate(withDuration: animationOut, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.picturesController.container.alpha = 0
                self.helpButton.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                self.picturesHeightAnchor.isActive = true
                self.picturesBottomAnchor.isActive = false
                self.gradientController.animateText(text: "Location")
                self.gradientController.setSublabel(text: "Move the map so the pin is above the correct spot")
                UIView.animate(withDuration: animationOut, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                    self.mapController.mainLabel.alpha = 1
                    self.mapController.subLabel.alpha = 1
                    self.nextButton.backgroundColor = Theme.BLACK
                    self.nextButton.tintColor = Theme.WHITE
                    self.view.layoutIfNeeded()
                }) { (success) in
                    self.picturesController.view.alpha = 0
                    self.gradientController.backButton.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    func showPictures() {
        mainTypeState = .pictures
        mapController.shouldMonitor = false
        hideNextButton(completion: {})
        picturesController.visibleCoordinate = mapController.finalCoordinate
        UIView.animate(withDuration: animationOut, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.mapController.mainLabel.alpha = 0
            self.mapController.subLabel.alpha = 0
        }) { (success) in
            self.picturesController.view.alpha = 1
            self.gradientController.setSublabel(text: "")
            self.gradientController.animateText(text: "Pictures")
            self.picturesHeightAnchor.isActive = false
            self.picturesBottomAnchor.isActive = true
            UIView.animate(withDuration: animationOut * 2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.nextButton.backgroundColor = Theme.WHITE
                self.nextButton.tintColor = Theme.WHITE
                self.view.layoutIfNeeded()
            }) { (success) in
                self.showNextButton()
                self.gradientController.setSublabel(text: "Upload a picture for each spot")
                self.nextButton.isUserInteractionEnabled = true
                UIView.animate(withDuration: animationIn, animations: {
                    self.picturesController.container.alpha = 1
                    self.helpButton.alpha = 1
                }) { (success) in
                    self.openHelp()
                }
            }
        }
    }
    
    func showAvailability() {
        let check = picturesController.checkPictures()
        if check {
            mainTypeState = .availability
            hideNextButton(completion: {})
            delayWithSeconds(animationOut + animationIn/2) {
                self.dimBackground()
                self.nextButton.isUserInteractionEnabled = true
                self.navigationController?.pushViewController(self.hostAvailabilityController, animated: true)
                
                if let state = self.locationController.stateField.lineTextView?.text, let city = self.locationController.cityField.lineTextView?.text {
                    self.hostAvailabilityController.hostCostController.sliderController.configureCustomPricing(state: state, city: city)
                }
            }
        } else {
            nextButton.isUserInteractionEnabled = true
        }
    }
    
    @objc func backButtonPressed() {
        gradientController.backButton.isUserInteractionEnabled = false
        switch mainTypeState {
        case .location:
            mainTypeState = .amenities
            gradientController.backButton.isUserInteractionEnabled = true
            navigationController?.popViewController(animated: true)
        case .map:
            showLocation()
        case .pictures:
            showMap(forward: false)
        default:
            gradientController.backButton.isUserInteractionEnabled = true
            return
        }
    }
    
    @objc func openHelp() {
        dimBackground()
        let controller = PictureTutorialView()
        controller.delegate = picturesController
        controller.modalPresentationStyle = .overFullScreen
        present(controller, animated: true, completion: nil)
    }
    
    func showNextButton() {
        nextButton.alpha = 1
        nextButtonRightAnchor.constant = phoneWidth/2
        view.layoutIfNeeded()
        
        nextButtonRightAnchor.constant = -20
        UIView.animate(withDuration: animationOut, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationOut, delay: 0, options: .curveEaseOut, animations: {
                self.nextButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                if mainTypeState == .pictures {
                    self.nextButton.tintColor = Theme.BLACK
                } else {
                    self.nextButton.tintColor = Theme.WHITE
                }
            }) { (success) in
                self.nextButton.isUserInteractionEnabled = true
            }
        }
    }
    
    func hideNextButton(completion: @escaping() -> Void) {
        UIView.animate(withDuration: animationIn, delay: 0, options: .curveEaseOut, animations: {
            self.nextButton.transform = CGAffineTransform(scaleX: -0.2, y: 0.2)
            self.nextButton.tintColor = Theme.BLACK
        }) { (success) in
            self.nextButtonRightAnchor.constant = -phoneWidth * 1.5
            UIView.animate(withDuration: animationIn, delay: animationIn/2, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }) { (success) in
                completion()
            }
        }
    }
    
    func animate() {
        locationTopAnchor.constant = 0
        UIView.animate(withDuration: animationOut, animations: {
            self.locationController.view.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            if self.locationController.streetField.text == "" && mainTypeState == .location {
                self.locationController.streetField.becomeFirstResponder()
            }
        }
    }

}

extension HostLocationView: HandleHostLocation {
    
    func changeScroll(view: UIView) {
        if view != UIView() {
            gradientController.scrollView.scrollToView(view: view, animated: true, offset: 16)
        } else {
            gradientController.scrollView.scrollToTop(animated: true)
        }
    }
    
    func dimBackground() {
        UIView.animate(withDuration: animationIn) {
            self.dimView.alpha = 0.7
        }
    }
    
    func removeDim() {
        UIView.animate(withDuration: animationIn) {
            self.dimView.alpha = 0
        }
    }
    
}

extension HostLocationView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        let state = scrollView.panGestureRecognizer.state
        if state == .changed {
            if translation > 0 && translation < 60 {
                let percent = translation/60
                gradientController.gradientHeightAnchor.constant = gradientController.gradientNewHeight - (gradientController.gradientNewHeight - gradientHeight + 60) * percent
                gradientController.subLabelBottom.constant = gradientController.subHeight * percent
                gradientController.mainLabel.transform = CGAffineTransform(scaleX: 1 - 0.2 * percent, y: 1 - 0.2 * percent)
                if percent >= 0 && percent <= 0.3 {
                    let percentage = percent/0.3
                    gradientController.subLabel.alpha = 1 - 1 * percentage
                    paging.alpha = 1 - 1 * percentage
                } else if percent >= 0 {
                    gradientController.subLabel.alpha = 0
                    paging.alpha = 0
                }
            }
        } else {
            if translation < 0 && gradientController.gradientHeightAnchor.constant != gradientController.gradientNewHeight {
                scrollExpanded()
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.contentOffset.y
        if translation >= 55 {
            scrollMinimized()
        } else {
            scrollExpanded()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        if translation >= 55 {
            scrollMinimized()
        } else {
            scrollExpanded()
        }
    }
    
    func scrollExpanded() {
        gradientController.subLabelBottom.constant = 0
        gradientController.gradientHeightAnchor.constant = gradientController.gradientNewHeight
        UIView.animate(withDuration: animationOut, animations: {
            self.gradientController.mainLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.gradientController.subLabel.alpha = 1
            self.paging.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func scrollMinimized() {
        gradientController.subLabelBottom.constant = gradientController.subHeight
        gradientController.gradientHeightAnchor.constant = gradientHeight - 60
        UIView.animate(withDuration: animationOut, animations: {
            self.gradientController.mainLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.gradientController.subLabel.alpha = 0
            self.paging.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
}
