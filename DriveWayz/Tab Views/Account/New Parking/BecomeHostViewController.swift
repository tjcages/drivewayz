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

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clear
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(drivewayzCar)
        drivewayzCar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        drivewayzCar.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -40).isActive = true
        drivewayzCar.heightAnchor.constraint(equalToConstant: 260).isActive = true
        drivewayzCar.widthAnchor.constraint(equalToConstant: 260).isActive = true
        
        self.view.addSubview(self.morphingLabel)
        self.morphingLabel.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 20).isActive = true
        self.morphingLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.morphingLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.morphingLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width - 42).isActive = true
        
    }
    
    func startAnimations() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            UIView.animate(withDuration: 0.3, animations: {
                self.drivewayzCar.alpha = 1
                self.morphingLabel.alpha = 1
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.alpha = 0
                }, completion: { (success) in
                    self.drivewayzCar.alpha = 0
                    self.morphingLabel.alpha = 0
                })
            }
        }
    }
    

}
