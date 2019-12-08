//
//  ListingExpandedController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/26/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ListingExpandedController: UIViewController {
    
    var delegate: HostAccountDelegate?
    
    lazy var gradientController: GradientContainerView = {
        let controller = GradientContainerView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.mainLabel.text = ""
        controller.setBackButton()
        controller.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        controller.scrollViewHeight = 2100
        controller.shouldDismiss = true
        controller.scrollView.alpha = 0
        
        return controller
    }()
    
    var helpIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "filledHelpIcon")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(informationPressed), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    var activeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLUE
        button.layer.cornerRadius = 13
        button.setTitle("Active", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.isUserInteractionEnabled = false
        button.alpha = 0
        
        return button
    }()
    
    var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 0
        
        return view
    }()
    
    var toDoView = ListingToDoView()
    var photosView = ListingPhotosView()
    var descriptionView = ListingDescriptionView()
    var priceView = ListingPriceView()
    var typeView = ListingTypeView()
    var infoView = ListingInfoView()
    var amenitiesView = ListingAmenitiesView()
    var locationView = ListingLocationView()
    var optionsView = ListingOptionsView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.OFF_WHITE
        
        gradientController.scrollView.delegate = self

        setupViews()
        setupStack()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if gradientController.mainLabel.text == "" {
            gradientController.animateText(text: "945 Diamond Street")
            delayWithSeconds(animationOut) {
                self.gradientController.setSublabel(text: "2-Car Residential")
                UIView.animate(withDuration: animationIn) {
                    self.helpIcon.alpha = 1
                    self.activeButton.alpha = 1
                    self.gradientController.scrollView.alpha = 1
                }
            }
        }
    }
    
    func setupViews() {
        
        view.addSubview(gradientController.view)
        gradientController.view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(helpIcon)
        helpIcon.anchor(top: nil, left: nil, bottom: gradientController.backButton.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 32, height: 32)
        
        view.addSubview(activeButton)
        activeButton.centerYAnchor.constraint(equalTo: helpIcon.centerYAnchor).isActive = true
        activeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activeButton.heightAnchor.constraint(equalToConstant: 26).isActive = true
        activeButton.widthAnchor.constraint(equalToConstant: 72).isActive = true
        
        gradientController.scrollView.addSubview(stackView)
        stackView.anchor(top: gradientController.scrollView.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    func setupStack() {
        
        stackView.addArrangedSubview(toDoView.view)
        toDoView.view.heightAnchor.constraint(equalToConstant: 264).isActive = true
        
        stackView.addArrangedSubview(photosView.view)
        photosView.view.heightAnchor.constraint(equalToConstant: 352).isActive = true
        
        stackView.addArrangedSubview(descriptionView.view)
        descriptionView.view.heightAnchor.constraint(equalToConstant: 188).isActive = true
        
        stackView.addArrangedSubview(priceView.view)
        priceView.view.heightAnchor.constraint(equalToConstant: 92).isActive = true
        
        stackView.addArrangedSubview(typeView.view)
        typeView.view.heightAnchor.constraint(equalToConstant: 92).isActive = true
        
        stackView.addArrangedSubview(infoView.view)
        infoView.view.heightAnchor.constraint(equalToConstant: 228).isActive = true
        
        stackView.addArrangedSubview(amenitiesView.view)
        amenitiesView.view.heightAnchor.constraint(equalToConstant: 148).isActive = true
        
        stackView.addArrangedSubview(locationView.view)
        locationView.view.heightAnchor.constraint(equalToConstant: 332).isActive = true
        
        stackView.addArrangedSubview(optionsView.view)
        optionsView.view.heightAnchor.constraint(equalToConstant: 236).isActive = true
        
    }
    
    @objc func informationPressed() {
        
    }
    
    @objc func backButtonPressed() {
        delegate?.removeDim()
        dismiss(animated: true, completion: nil)
    }

}

extension ListingExpandedController: UIScrollViewDelegate {
    
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
                    helpIcon.alpha = 1 - 1 * percentage
                    activeButton.alpha = 1 - 1 * percentage
                } else if percent >= 0 {
                    gradientController.subLabel.alpha = 0
                    helpIcon.alpha = 0
                    activeButton.alpha = 0
                }
            } else if translation <= -60 {
                gradientController.backButton.sendActions(for: .touchUpInside)
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
            self.helpIcon.alpha = 1
            self.activeButton.alpha = 1
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
            self.helpIcon.alpha = 0
            self.activeButton.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
}
