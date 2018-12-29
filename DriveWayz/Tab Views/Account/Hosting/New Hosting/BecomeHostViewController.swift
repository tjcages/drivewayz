//
//  BecomeHostViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 11/1/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class BecomeHostViewController: UIViewController {
    
    var drivewayzCar: UIImageView = {
        let image = UIImage(named: "drivewayzLogo")
        let view = UIImageView(image: image)
        view.image = view.image!.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.WHITE
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    var morphingLabel: UILabel = {
        let label = UILabel()
        label.text = "Park smarter."
        label.textAlignment = .center
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPLightH0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        
        return label
    }()
    
    lazy var purpleGradient: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().purpleColor()
        background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        background.zPosition = -10
        view.layer.addSublayer(background)
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(purpleGradient)
        purpleGradient.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        purpleGradient.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        purpleGradient.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        purpleGradient.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        self.view.addSubview(drivewayzCar)
        drivewayzCar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        drivewayzCar.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -20).isActive = true
        drivewayzCar.heightAnchor.constraint(equalToConstant: 200).isActive = true
        drivewayzCar.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        self.view.addSubview(morphingLabel)
        morphingLabel.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 20).isActive = true
        morphingLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        morphingLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        morphingLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width - 42).isActive = true
        
    }
    
    func startAnimations() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            UIView.animate(withDuration: animationIn, animations: {
                self.drivewayzCar.alpha = 1
                self.morphingLabel.alpha = 1
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                UIView.animate(withDuration: animationIn, animations: {
                    self.drivewayzCar.alpha = 0
                    self.morphingLabel.alpha = 0
                }, completion: { (success) in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        UIView.animate(withDuration: animationIn, animations: {
                            self.view.alpha = 0
                        })
                    }
                })
            }
        }
    }
    

}