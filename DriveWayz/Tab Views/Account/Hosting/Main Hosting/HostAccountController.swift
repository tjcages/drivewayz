//
//  HostAccountController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/14/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol HostAccountDelegate {
    func removeDim()
}

class HostAccountController: UIViewController {

    var delegate: HandleHostPortal?
    var hostListing: ParkingSpots? {
        didSet {
            if let parking = hostListing {
                
            }
        }
    }
        
    lazy var gradientController: GradientContainerView = {
        let controller = GradientContainerView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        controller.scrollView.isHidden = true
        controller.setBackButton()
        
        return controller
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        view.backgroundColor = UIColor.clear
        
        return view
    }()
    
    var helpIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "filledHelpIcon")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(informationPressed), for: .touchUpInside)
        
        return button
    }()
    
    var helpButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Help", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.addTarget(self, action: #selector(helpPressed), for: .touchUpInside)
        
        return button
    }()
    
    var listingsController: AccountListingView = {
        let controller = AccountListingView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var dimView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight))
        view.backgroundColor = Theme.DARK_GRAY
        view.alpha = 0
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        view.backgroundColor = Theme.OFF_WHITE
        view.clipsToBounds = true
        
        setupViews()
        setupControllers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        gradientController.setMainLabel(text: "Account")
    }

    func setupViews() {
        
        view.addSubview(gradientController.view)
        view.addSubview(scrollView)
        
        gradientController.view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        scrollView.contentSize = CGSize(width: phoneWidth, height: 1120)
        scrollView.anchor(top: gradientController.gradientContainer.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(helpIcon)
        view.addSubview(helpButton)
        
        helpIcon.anchor(top: nil, left: nil, bottom: gradientController.backButton.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 32, height: 32)
        
        helpButton.rightAnchor.constraint(equalTo: helpIcon.leftAnchor, constant: -12).isActive = true
        helpButton.bottomAnchor.constraint(equalTo: helpIcon.bottomAnchor).isActive = true
        helpButton.sizeToFit()
        
    }
    
    func setupControllers() {
    
        scrollView.addSubview(listingsController.view)
        listingsController.view.anchor(top: scrollView.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 316)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(expandPressed))
        listingsController.view.addGestureRecognizer(tap)
        
        view.addSubview(dimView)
    }
    
    @objc func expandPressed() {
        UIView.animate(withDuration: animationIn, animations: {
            self.dimView.alpha = 1
        }) { (success) in
            let controller = ListingExpandedController()
            controller.delegate = self
            controller.modalPresentationStyle = .overFullScreen
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @objc func helpPressed() {
        UIView.animate(withDuration: animationIn, animations: {
            self.dimView.alpha = 0.7
        }) { (success) in
            let controller = HelpMenuController()
            controller.optionIndex = 3
            controller.delegate = self
            controller.modalPresentationStyle = .overFullScreen
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @objc func informationPressed() {
        UIView.animate(withDuration: animationIn, animations: {
            self.dimView.alpha = 0.7
        }) { (success) in
            let controller = HelpAccountController()
            controller.delegate = self
            controller.modalPresentationStyle = .overFullScreen
            self.present(controller, animated: true, completion: nil)
        }
    }

    @objc func backButtonPressed() {
        self.dismiss(animated: true) {
            self.delegate?.controllerDismissed()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension HostAccountController: HostHelpDelegate, HostAccountDelegate {
    
    func removeDim() {
        UIView.animate(withDuration: animationOut) {
            self.dimView.alpha = 0
        }
    }
    
    func changeDimLevel(amount: CGFloat) {
        UIView.animate(withDuration: animationOut) {
            self.dimView.alpha = amount
        }
    }
    
}

extension HostAccountController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        let state = scrollView.panGestureRecognizer.state
        if state == .changed {
            if translation > 0 && translation < 60 {
                let percent = translation/60
                gradientController.gradientHeightAnchor.constant = gradientHeight - percent * 60
                gradientController.mainLabel.transform = CGAffineTransform(scaleX: 1 - 0.2 * percent, y: 1 - 0.2 * percent)
            }
        } else {
            if translation < 0 && gradientController.gradientHeightAnchor.constant != gradientHeight {
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
        gradientController.gradientHeightAnchor.constant = gradientHeight
        UIView.animate(withDuration: animationOut, animations: {
            self.gradientController.mainLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func scrollMinimized() {
        gradientController.gradientHeightAnchor.constant = gradientHeight - 60
        UIView.animate(withDuration: animationOut, animations: {
            self.gradientController.mainLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
}

