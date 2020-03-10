//
//  PublicInformationController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 2/18/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit
import SVGKit

enum PublicInformation {
    case kiosk
    case availability
}

class PublicInformationController: UIViewController {

    var delegate: PublicDelegate?
    lazy var bottomAnchor: CGFloat = cancelBottomHeight
    var shouldDismiss: Bool = true
    
    var publicInformation: PublicInformation = .kiosk {
        didSet {
            switch publicInformation {
            case .kiosk:
                mainLabel.text = "Pay at kiosk"
                informationLabel.text = "Payment processing through the app is not currently available for parking lots managed by ACE Parking. \n\nWe are actively working to integrate our payment processing methods with ACE Parking servers to provide a seamless process. We thank you for your patience and will be sure to provide updates as  the integration process continues."
                let image = SVGKImage(named: "Circle_Kiosk_Illustration")
                svgIllustration.image = image
            case .availability:
                mainLabel.text = "Predicted availability"
                informationLabel.text = "Our predicted availability comes from standard traffic congestion values combined with machine learning to provide semi-accurate predictions on how busy lots will be. \n\nAs usage increases and more lots integrate payment processing we will continue to improve our algorithms to provide more accurate availability predictions."
                let image = SVGKImage(named: "Calendar_Illustration")
                svgIllustration.image = image
            }
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
    
    var pullButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "pull-up")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH2
        label.text = "Pay at kiosk"
        
        return label
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        
        return view
    }()
    
    var svgIllustration: SVGKImageView = {
        let image = SVGKImage(named: "Circle_Kiosk_Illustration")
        let view = SVGKFastImageView(svgkImage: image)!
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Payment processing through the app is not currently available for parking lots managed by ACE Parking. \n\nWe are actively working to integrate our payment processing methods with ACE Parking servers to provide a seamless process. We thank you for your patience and will be sure to provide updates as  the integration process continues."
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        label.numberOfLines = 40
        
        return label
    }()
        
    lazy var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLACK
        button.setTitle("Got it", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 2
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        return button
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
        setupInformation()
        setupContainer()
    }
    
    var panBottomAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(dimView)
        view.addSubview(container)
        
        view.addSubview(pullButton)
        pullButton.bottomAnchor.constraint(equalTo: container.topAnchor, constant: -16).isActive = true
        pullButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pullButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        pullButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        view.addSubview(mainButton)
        panBottomAnchor = mainButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: cancelBottomHeight)
            panBottomAnchor.isActive = true
        mainButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
    }
    
    func setupInformation() {
        
        view.addSubview(informationLabel)
        view.addSubview(svgIllustration)
        
        informationLabel.anchor(top: nil, left: view.leftAnchor, bottom: mainButton.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 32, paddingRight: 20, width: 0, height: 0)
        informationLabel.sizeToFit()
        
        svgIllustration.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        svgIllustration.bottomAnchor.constraint(equalTo: informationLabel.topAnchor, constant: -20).isActive = true
        svgIllustration.heightAnchor.constraint(equalToConstant: 120).isActive = true
        svgIllustration.widthAnchor.constraint(equalTo: svgIllustration.heightAnchor).isActive = true
        
    }
    
    func setupContainer() {
        
        container.addSubview(line)
        container.addSubview(mainLabel)
        
        line.anchor(top: nil, left: view.leftAnchor, bottom: svgIllustration.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 32, paddingRight: 0, width: 0, height: 1)
        
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: line.topAnchor, constant: -20).isActive = true
        mainLabel.sizeToFit()
        
        container.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 80).isActive = true
        container.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        container.topAnchor.constraint(equalTo: mainLabel.topAnchor, constant: -20).isActive = true
        
    }

    @objc func viewPanned(sender: UIPanGestureRecognizer) {
        let state = sender.state
        let translation = sender.translation(in: self.view).y
        if state == .changed {
            self.panBottomAnchor.constant = self.bottomAnchor + translation/1.5
            self.view.layoutIfNeeded()
            if translation >= 160 || translation <= -320 {
                self.panBottomAnchor.constant = self.bottomAnchor
                UIView.animate(withDuration: animationOut) {
                    self.view.layoutIfNeeded()
                }
                if self.shouldDismiss == true {
                    self.dismissView()
                }
            }
        } else if state == .ended {
            self.view.endEditing(true)
            let difference = abs(self.panBottomAnchor.constant) + self.bottomAnchor
            if difference >= 160 {
                if self.shouldDismiss == true {
                    self.dismissView()
                    self.panBottomAnchor.constant = self.bottomAnchor
                    UIView.animate(withDuration: animationOut) {
                        self.view.layoutIfNeeded()
                    }
                }
            } else {
                self.panBottomAnchor.constant = self.bottomAnchor
                UIView.animate(withDuration: animationOut) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc func dismissView() {
        delegate?.removeDim()
        dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
