//
//  EditCostViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/16/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class EditCostViewController: UIViewController {

    var delegate: handleHostEditing?
    var selectedParking: ParkingSpots?
    
    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.BLACK
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Hourly cost"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH1
        
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(exitButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.BLUE
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(savePressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var darkBlurView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().customVerticalColor(topColor: Theme.WHITE.withAlphaComponent(0), bottomColor: Theme.WHITE.withAlphaComponent(1))
        background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 72)
        background.zPosition = -10
        view.layer.insertSublayer(background, at: 0)
        
        return view
    }()
    
    lazy var costController: PickCostViewController = {
        let controller = PickCostViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    func setData(parking: ParkingSpots) {
        self.selectedParking = parking
        if let state = parking.stateAddress, let city = parking.cityAddress, let cost = parking.parkingCost {
            self.costController.configureCustomPricing(state: state, city: city)
            self.costController.costTextField.text = String(format:"$ %.02f", cost)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        
        setupViews()
        setupTopbar()
    }
    
    func setupViews() {
        
        self.view.addSubview(gradientContainer)
        gradientContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        switch device {
        case .iphone8:
            gradientContainer.heightAnchor.constraint(equalToConstant: 140).isActive = true
        case .iphoneX:
            gradientContainer.heightAnchor.constraint(equalToConstant: 160).isActive = true
        }
        
        self.view.addSubview(costController.view)
        costController.view.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        costController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        costController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        costController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        self.view.addSubview(darkBlurView)
        darkBlurView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        darkBlurView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        darkBlurView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        darkBlurView.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
    }
    
    func setupTopbar() {
        
        self.view.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        switch device {
        case .iphone8:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 28).isActive = true
        case .iphoneX:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 48).isActive = true
        }
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: -16).isActive = true
        
        self.view.addSubview(nextButton)
        nextButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        nextButton.leftAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 32).isActive = true
        switch device {
        case .iphone8:
            nextButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -12).isActive = true
        case .iphoneX:
            nextButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -60).isActive = true
        }
        
    }
    
    @objc func savePressed() {
        self.nextButton.alpha = 0.5
        self.nextButton.isUserInteractionEnabled = false
        if let parking = self.selectedParking, let parkingID = parking.parkingID {
            var parkingCost = self.costController.costTextField.text?.replacingOccurrences(of: "$", with: "")
            parkingCost = parkingCost!.replacingOccurrences(of: " ", with: "")
            let ref = Database.database().reference().child("ParkingSpots").child(parkingID)
            ref.updateChildValues(["parkingCost": Double(parkingCost!) as Any])
            
            self.delegate?.resetParking()
            delayWithSeconds(0.8) {
                self.nextButton.alpha = 1
                self.nextButton.isUserInteractionEnabled = true
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc func exitButtonPressed(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
