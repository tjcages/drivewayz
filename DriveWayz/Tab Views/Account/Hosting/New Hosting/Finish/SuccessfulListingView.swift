//
//  SuccessfulListingView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/7/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SuccessfulListingView: UIViewController {

   var delegate: handleMinimizingFullController?
        
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    var starImageView: UIImageView = {
        let image = UIImage(named: "successStar")
        let button = UIImageView(image: image)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 60
        button.clipsToBounds = true
        button.contentMode = .scaleAspectFill
        button.alpha = 0
        
        return button
    }()
    
    var spotIcon: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.1)
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 60
        let image = UIImage(named: "Apartment Parking")
        view.image = image
        view.alpha = 0
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Listing was successful!"
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH2
        label.textAlignment = .center
        label.alpha = 0
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.text = "Check your email for a verification code \nand complete the host tutorial."
        label.textColor = Theme.PRUSSIAN_BLUE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .center
        label.numberOfLines = 3
        label.alpha = 0
        
        return label
    }()

    var loadingActivity: NVActivityIndicatorView = {
        let loading = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballPulse, color: Theme.BLACK, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        
        return loading
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadingActivity.startAnimating()
    }
    
    var containerWidthAnchor: NSLayoutConstraint!
    var containerHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(container)
        container.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerWidthAnchor = container.widthAnchor.constraint(equalToConstant: 192)
            containerWidthAnchor.isActive = true
        containerHeightAnchor = container.heightAnchor.constraint(equalToConstant: 184)
            containerHeightAnchor.isActive = true
        
        container.addSubview(spotIcon)
        container.addSubview(starImageView)
        starImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        starImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 64).isActive = true
        starImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        starImageView.heightAnchor.constraint(equalTo: starImageView.widthAnchor).isActive = true
        
        spotIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spotIcon.centerYAnchor.constraint(equalTo: starImageView.centerYAnchor).isActive = true
        spotIcon.widthAnchor.constraint(equalToConstant: 120).isActive = true
        spotIcon.heightAnchor.constraint(equalTo: spotIcon.widthAnchor).isActive = true
        
        container.addSubview(mainLabel)
        mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainLabel.topAnchor.constraint(equalTo: starImageView.bottomAnchor, constant: 32).isActive = true
        mainLabel.sizeToFit()
        
        container.addSubview(subLabel)
        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 4).isActive = true
        subLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        subLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        subLabel.sizeToFit()
        
        view.addSubview(loadingActivity)
        loadingActivity.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingActivity.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingActivity.widthAnchor.constraint(equalToConstant: 40).isActive = true
        loadingActivity.heightAnchor.constraint(equalTo: loadingActivity.widthAnchor).isActive = true
        
    }
   
    func animateSuccess() {
        containerWidthAnchor.constant = phoneWidth - 48
        containerHeightAnchor.constant = 380
        UIView.animate(withDuration: animationOut, animations: {
            self.loadingActivity.alpha = 0
            self.starImageView.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationIn, animations: {
                self.starImageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.starImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }, completion: { (success) in
                    UIView.animate(withDuration: animationOut * 2, animations: {
                        self.mainLabel.alpha = 1
                        self.subLabel.alpha = 1
                        
                        var transform = CGAffineTransform.identity
                        transform = transform.translatedBy(x: 30, y: 0)
                        transform = transform.rotated(by: CGFloat.pi * 0.8)
                        transform = transform.scaledBy(x: 0.8, y: 0.8)
                        self.starImageView.transform = transform
                        var transform2 = CGAffineTransform.identity
                        transform2 = transform2.translatedBy(x: -30, y: 0)
                        transform2 = transform2.scaledBy(x: 0.75, y: 0.75)
                        self.spotIcon.transform = transform2
                        self.spotIcon.alpha = 1
                    }, completion: { (success) in
                        
                    })
                })
            }

        }
    }
    
    func closeSuccess() {
        UIView.animate(withDuration: animationIn, animations: {
            self.mainLabel.alpha = 0
            self.subLabel.alpha = 0
            self.spotIcon.alpha = 0
            self.starImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.spotIcon.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { (success) in
            self.containerWidthAnchor.constant = 168
            self.containerHeightAnchor.constant = 184
            self.loadingActivity.stopAnimating()
            UIView.animate(withDuration: animationIn, animations: {
                self.loadingActivity.alpha = 1
                self.starImageView.alpha = 0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if mainLabel.alpha == 1 {
            dismiss(animated: true, completion: nil)
        }
    }
    
}
