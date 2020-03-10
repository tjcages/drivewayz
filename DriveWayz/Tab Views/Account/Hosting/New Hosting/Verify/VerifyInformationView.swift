//
//  VerifyInformationView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/4/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class VerifyInformationView: UIViewController {

    var delegate: HostVerifyDelegate?
    lazy var bottomAnchor: CGFloat = cancelBottomHeight
    var shouldDismiss: Bool = true
    
    var information: [ListingInformation] = [ListingInformation(main: "Please provide driver instructions if the space is difficult to find", sub: "After the spot is booked, drivers will see the instructions to help navigation. \n\nDo not include gate codes or spot numbers in the description.", information: "You can always edit later."), ListingInformation(main: "The instructional message will be shown as a driver is navigating", sub: "Describe what to look for when pulling in or any specific directions on where the vehicle should be aligned.", information: "You can always edit later."), ListingInformation(main: "A promotional message includes points of interest or gives the driver more details on the space", sub: "Example: \nA secure and affordable parking spot in the heart of downtown Boulder. A quick 5 minute walk to Pearl St. makes this a great location for browsing stores or getting a bite to eat.", information: "You can always edit later.")]
    
    var informationIndex: Int = 0 {
        didSet {
            let option = information[informationIndex]
            mainLabel.text = option.main
            subLabel.text = option.sub
            informationLabel.text = option.information
            view.layoutIfNeeded()
        }
    }
    
    lazy var dimView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight))
        
        return view
    }()
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true
        
        return view
    }()
    
    lazy var pullButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "pull-up")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLACK
        button.setTitle("Got it", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH2
        label.numberOfLines = 10
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH3
        label.numberOfLines = 10
        
        return label
    }()
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .center
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(sender:)))
        view.addGestureRecognizer(pan)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        dimView.addGestureRecognizer(tap)
        
        setupViews()
    }
    
    var profitsBottomAnchor: NSLayoutConstraint!
    var tableViewHeight: NSLayoutConstraint!
    var containerTopAnchor: NSLayoutConstraint!
    var emptyContainerTopAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(dimView)
        view.addSubview(container)
        
        view.addSubview(pullButton)
        pullButton.bottomAnchor.constraint(equalTo: container.topAnchor, constant: -16).isActive = true
        pullButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pullButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        pullButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        pullButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        view.addSubview(mainButton)
        profitsBottomAnchor = mainButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: cancelBottomHeight)
            profitsBottomAnchor.isActive = true
        mainButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        container.addSubview(informationLabel)
        container.addSubview(subLabel)
        container.addSubview(mainLabel)
        
        informationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        informationLabel.bottomAnchor.constraint(equalTo: mainButton.topAnchor, constant: -16).isActive = true
        informationLabel.sizeToFit()
        
        subLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        subLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        subLabel.bottomAnchor.constraint(equalTo: informationLabel.topAnchor, constant: -48).isActive = true
        subLabel.sizeToFit()
        
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: subLabel.topAnchor, constant: -16).isActive = true
        mainLabel.sizeToFit()
        
        container.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 80).isActive = true
        container.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        container.topAnchor.constraint(equalTo: mainLabel.topAnchor, constant: -32).isActive = true
        
        view.layoutIfNeeded()
    }
    
    @objc func viewPanned(sender: UIPanGestureRecognizer) {
        let state = sender.state
        let translation = sender.translation(in: self.view).y
        if state == .changed {
            self.profitsBottomAnchor.constant = self.bottomAnchor + translation/1.5
            self.view.layoutIfNeeded()
            if translation >= 160 || translation <= -320 {
                self.profitsBottomAnchor.constant = self.bottomAnchor
                UIView.animate(withDuration: animationOut) {
                    self.view.layoutIfNeeded()
                }
                if self.shouldDismiss == true {
                    self.dismissView()
                }
            }
        } else if state == .ended {
            self.view.endEditing(true)
            let difference = abs(self.profitsBottomAnchor.constant) + self.bottomAnchor
            if difference >= 160 {
                if self.shouldDismiss == true {
                    self.dismissView()
                    self.profitsBottomAnchor.constant = self.bottomAnchor
                    UIView.animate(withDuration: animationOut) {
                        self.view.layoutIfNeeded()
                    }
                }
            } else {
                self.profitsBottomAnchor.constant = self.bottomAnchor
                UIView.animate(withDuration: animationOut) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc func dismissView() {
        delegate?.removeDim()
        self.dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

