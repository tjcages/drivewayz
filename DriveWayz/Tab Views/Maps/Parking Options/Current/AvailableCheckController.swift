//
//  AvailableCheckController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 2/28/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit
import SVGKit

class AvailableCheckController: UIViewController {

    var delegate: handleCheckoutParking?
    lazy var bottomAnchor: CGFloat = cancelBottomHeight
    var shouldDismiss: Bool = true

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
    
    var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        let image = UIImage(named: "exit")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        button.alpha = 0
        
        return button
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
    
    var mainIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "pin_filled")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.backgroundColor = Theme.BLACK
        button.layer.cornerRadius = 32
        button.isUserInteractionEnabled = false
        button.imageEdgeInsets = UIEdgeInsets(top: -8, left: -8, bottom: -8, right: -8)
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH1
        label.text = "Did you find an \navailable space?"
        label.numberOfLines = 2
        label.textAlignment = .center
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLUE
        label.font = Fonts.SSPSemiBoldH4
        label.text = "Pay at kiosk • 5 min walk"
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLACK
        button.setTitle("Found parking", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 2
        button.addTarget(self, action: #selector(mainButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.LINE_GRAY
        button.setTitle("Go to next lot", for: .normal)
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 2
        button.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animateOut(withDuration: animationOut, animations: {
            self.backButton.alpha = 1
        }, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        backButton.alpha = 0
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
        
        view.addSubview(nextButton)
        view.addSubview(mainButton)
        view.addSubview(backButton)
        
        nextButton.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 56)
        panBottomAnchor = nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: cancelBottomHeight)
            panBottomAnchor.isActive = true
        
        mainButton.anchor(top: nil, left: view.leftAnchor, bottom: nextButton.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 16, paddingRight: 20, width: 0, height: 56)
        
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
    }
    
    func setupInformation() {
        
        view.addSubview(subLabel)
        view.addSubview(mainLabel)
        view.addSubview(mainIcon)
        
        subLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subLabel.bottomAnchor.constraint(equalTo: mainButton.topAnchor, constant: -32).isActive = true
        subLabel.sizeToFit()
        
        mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: subLabel.topAnchor, constant: -20).isActive = true
        mainLabel.sizeToFit()
        
        mainIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainIcon.bottomAnchor.constraint(equalTo: mainLabel.topAnchor, constant: -20).isActive = true
        mainIcon.heightAnchor.constraint(equalToConstant: 64).isActive = true
        mainIcon.widthAnchor.constraint(equalTo: mainIcon.heightAnchor).isActive = true
        
        container.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 80).isActive = true
        container.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        container.topAnchor.constraint(equalTo: mainIcon.topAnchor, constant: -20).isActive = true
        
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
    
    @objc func mainButtonPressed() {
        dismiss(animated: true, completion: nil)
        delegate?.startBooking()
    }
    
    @objc func nextButtonPressed() {
        dismiss(animated: true, completion: nil)
        delegate?.startNavigation()
    }
    
    @objc func dismissView() {
        UIView.animateOut(withDuration: animationOut, animations: {
            tabDimmingView.alpha = 0
        }, completion: nil)
        dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

}
