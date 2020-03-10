//
//  SuccessfulDisputeHelpView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/20/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SuccessfulDisputeHelpView: UIViewController {
    
    var delegate: EarningsDisputeDelegate?
            
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    var starImageView: UIImageView = {
        let image = UIImage(named: "hostSuccess")
        let button = UIImageView(image: image)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFill
        button.alpha = 0
        button.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Successfully opened \ndispute claim"
        label.textColor = Theme.BLACK
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH2
        label.textAlignment = .center
        label.numberOfLines = 3
        label.alpha = 0
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.text = "Drivewayz will send a follow up email \nwith details on how to continue.  "
        label.textColor = Theme.GRAY_WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .center
        label.numberOfLines = 3
        label.alpha = 0
        
        return label
    }()

    var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Got it", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.backgroundColor = Theme.BLACK
        button.layer.cornerRadius = 4
        button.isUserInteractionEnabled = false
        button.alpha = 0
        
        return button
    }()
    
    var loadingActivity: NVActivityIndicatorView = {
        let loading = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballPulse, color: Theme.BLACK, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        
        return loading
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.BLACK.withAlphaComponent(0.8)
        
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
        
        container.addSubview(starImageView)
        starImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        starImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 32).isActive = true
        starImageView.widthAnchor.constraint(equalToConstant: 92).isActive = true
        starImageView.heightAnchor.constraint(equalTo: starImageView.widthAnchor).isActive = true
        
        container.addSubview(mainLabel)
        mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainLabel.topAnchor.constraint(equalTo: starImageView.bottomAnchor, constant: 32).isActive = true
        mainLabel.sizeToFit()
        
        container.addSubview(subLabel)
        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 16).isActive = true
        subLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        subLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        subLabel.sizeToFit()
        
        container.addSubview(mainButton)
        mainButton.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 32).isActive = true
        mainButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainButton.widthAnchor.constraint(equalToConstant: 112).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
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
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationIn, animations: {
                self.mainLabel.alpha = 1
                self.subLabel.alpha = 1
                self.mainButton.alpha = 1
                self.starImageView.alpha = 1
                self.starImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }) { (success) in
                
            }

        }
    }
    
    func closeSuccess() {
        UIView.animate(withDuration: animationIn, animations: {
            self.mainLabel.alpha = 0
            self.subLabel.alpha = 0
            self.mainButton.alpha = 0
            self.starImageView.alpha = 0
            self.starImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
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
            closeSuccess()
            delayWithSeconds(animationIn) {
                self.delegate?.removeDim()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
