//
//  ConfirmPurchaseViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 3/12/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ConfirmTestPurchaseViewController: UIViewController {
    
    var totalCostLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "$9.10"
        label.font = Fonts.SSPRegularH2
        label.textAlignment = .right
        
        return label
    }()
    
    var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "One-Car Driveway"
        label.font = Fonts.SSPRegularH2
        
        return label
    }()
    
    var durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLUE
        label.text = "Parking until 9:45"
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .center
        
        return label
    }()
    
    var distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.alpha = 0.7
        label.text = "4 minute walk to Folsom Field"
        label.font = Fonts.SSPLightH5
        
        return label
    }()
    
    lazy var cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel(frame: CGRect(x: 36, y: 10, width: 100, height: 30))
        label.text = "Visa 4422"
        label.font = Fonts.SSPRegularH4
        view.addSubview(label)
        
        let line = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 1))
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        view.addSubview(line)
        
        return view
    }()
    
    var carIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let img = UIImage(named: "singleCarIcon")
        var image = UIImage(cgImage: img!.cgImage!, scale: 1.0, orientation: UIImage.Orientation.upMirrored)
        button.setImage(image, for: .normal)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var carLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "Toyota 4Runner"
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .right
        
        return label
    }()
    
    lazy var confirmDurationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Set Duration", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.BLUE
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.addTarget(self, action: #selector(confirmPurchasePressed(sender:)), for: .touchUpInside)
        button.layer.cornerRadius = 30
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -1)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.4
        
        setupViews()
        setupPayment()
    }
    

    func setupViews() {
        
        self.view.addSubview(totalCostLabel)
        totalCostLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        totalCostLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        totalCostLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        totalCostLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.view.addSubview(locationLabel)
        locationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        locationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        locationLabel.topAnchor.constraint(equalTo: totalCostLabel.topAnchor).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(distanceLabel)
        distanceLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        distanceLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        distanceLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 0).isActive = true
        distanceLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.view.addSubview(durationLabel)
        durationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        durationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        durationLabel.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 24).isActive = true
        durationLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.view.addSubview(confirmDurationButton)
        confirmDurationButton.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: 80).isActive = true
        confirmDurationButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        confirmDurationButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        confirmDurationButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    
    func setupPayment() {
        
        self.view.addSubview(cardView)
        cardView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: -1).isActive = true
        cardView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 1).isActive = true
        cardView.bottomAnchor.constraint(equalTo: confirmDurationButton.topAnchor).isActive = true
        cardView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        cardView.addSubview(carIcon)
        carIcon.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        carIcon.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 15).isActive = true
        carIcon.widthAnchor.constraint(equalToConstant: 25).isActive = true
        carIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        cardView.addSubview(carLabel)
        carLabel.rightAnchor.constraint(equalTo: carIcon.leftAnchor, constant: -4).isActive = true
        carLabel.centerYAnchor.constraint(equalTo: carIcon.centerYAnchor).isActive = true
        carLabel.leftAnchor.constraint(equalTo: cardView.leftAnchor, constant: 36).isActive = true
        carLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    @objc func confirmPurchasePressed(sender: UIButton) {
        
    }

}
