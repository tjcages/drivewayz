//
//  ConfirmBookingController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 12/15/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

var confirmNormalHeight: CGFloat = 393

class ConfirmBookingController: UIViewController {
    
    var delegate: HandleMapBooking?
    var bottomAnchor: CGFloat = -8
    
    lazy var dimView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight))
        
        return view
    }()
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        view.layer.cornerRadius = 4
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -6)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    var checkInButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLACK
        button.layer.cornerRadius = 4
        button.setTitle("Dismiss", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        let image = UIImage(named: "exit")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.contentHorizontalAlignment = .left
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    var starImageView: UIImageView = {
        let image = UIImage(named: "successStar")
        let button = UIImageView(image: image)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 40
        button.clipsToBounds = true
        button.contentMode = .scaleAspectFill
        button.alpha = 0
        
        return button
    }()
    
    var spotIcon: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BACKGROUND_GRAY
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 60
        let image = UIImage(named: "Apartment Parking")
        view.image = image
        view.alpha = 0
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "13 min"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPBoldH0
        label.textAlignment = .center
        label.alpha = 0
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1.6 mi  •  9:45pm"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH3
        label.textAlignment = .center
        label.alpha = 0
        
        return label
    }()
    
    var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BACKGROUND_GRAY
        button.setTitle("Start Navigation", for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.layer.cornerRadius = 2
        button.alpha = 0
//        button.addTarget(self, action: #selector(mainButtonPressed), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(sender:)))
        view.addGestureRecognizer(pan)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        dimView.addGestureRecognizer(tap)

        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateSuccess()
        UIView.animate(withDuration: animationIn) {
            self.checkInButton.alpha = 1
        }
    }
    
    var profitsBottomAnchor: NSLayoutConstraint!
    var starHeightAnchor: NSLayoutConstraint!
    var starWidthAnchor: NSLayoutConstraint!
    var starCenterAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(dimView)
        view.addSubview(container)
        view.addSubview(checkInButton)
        
        container.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 332)
        profitsBottomAnchor = container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
            profitsBottomAnchor.isActive = true
        
        checkInButton.anchor(top: nil, left: view.leftAnchor, bottom: container.topAnchor, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 140, height: 45)
        
        container.addSubview(spotIcon)
        container.addSubview(starImageView)
        
        starCenterAnchor = starImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            starCenterAnchor.isActive = true
        starHeightAnchor = starImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 60)
            starHeightAnchor.isActive = true
        starWidthAnchor = starImageView.widthAnchor.constraint(equalToConstant: 80)
            starWidthAnchor.isActive = true
        starImageView.heightAnchor.constraint(equalTo: starImageView.widthAnchor).isActive = true
        
        spotIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spotIcon.centerYAnchor.constraint(equalTo: starImageView.centerYAnchor).isActive = true
        spotIcon.widthAnchor.constraint(equalToConstant: 120).isActive = true
        spotIcon.heightAnchor.constraint(equalTo: spotIcon.widthAnchor).isActive = true
        
        container.addSubview(mainLabel)
        container.addSubview(subLabel)
        container.addSubview(mainButton)
        
        mainLabel.topAnchor.constraint(equalTo: starImageView.bottomAnchor, constant: 20).isActive = true
        mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainLabel.sizeToFit()
        
        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 8).isActive = true
        subLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subLabel.sizeToFit()
        
        mainButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -32).isActive = true
        mainButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -32).isActive = true
        mainButton.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 32).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
    }
    
    @objc func mainButtonPressed() {
        dismissView()
    }

    func animateSuccess() {
        starWidthAnchor.constant = 120
        UIView.animate(withDuration: animationIn, animations: {
            self.starImageView.layer.cornerRadius = 60
            self.starImageView.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: { (success) in
            self.starWidthAnchor.constant = 84
            self.starCenterAnchor.constant = 15
            UIView.animate(withDuration: animationOut, animations: {
                self.starImageView.layer.cornerRadius = 42
                self.starImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                self.view.layoutIfNeeded()
            }, completion: nil)
            UIView.animate(withDuration: animationOut, delay: animationOut - 0.05, options: .curveEaseOut, animations: { () -> Void in
                self.starCenterAnchor.constant = 30
                self.starImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2)
                self.view.layoutIfNeeded()
            }, completion: { (success) in
                self.starHeightAnchor.constant = 32
                UIView.animate(withDuration: animationIn) {
                    self.mainLabel.alpha = 1
                    self.subLabel.alpha = 1
                    self.mainButton.alpha = 1
                    self.view.layoutIfNeeded()
                }
            })
            UIView.animate(withDuration: animationOut * 2) {
                var transform = CGAffineTransform.identity
                transform = transform.translatedBy(x: -30, y: 0)
                transform = transform.scaledBy(x: 0.65, y: 0.65)
                self.spotIcon.transform = transform
                self.spotIcon.alpha = 1
            }
        })
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
                 self.dismissView()
             }
         } else if state == .ended {
             self.view.endEditing(true)
             let difference = abs(self.profitsBottomAnchor.constant) + self.bottomAnchor
             if difference >= 160 {
                 self.dismissView()
                 self.profitsBottomAnchor.constant = self.bottomAnchor
                 UIView.animate(withDuration: animationOut) {
                     self.view.layoutIfNeeded()
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
//        delegate?.startCurrentBooking()
        dismiss(animated: true, completion: nil)
    }
    
}
