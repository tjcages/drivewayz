//
//  ParkingTypeViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 10/23/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class ParkingTypeViewController: UIViewController {
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        
        return view
    }()
    
    var houseButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "home-1")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.PACIFIC_BLUE
        button.layer.cornerRadius = 4
        button.layer.shadowColor = Theme.DARK_GRAY.cgColor
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.2
        button.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var houseIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Residential", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY, for: .normal)
        label.titleLabel?.font = Fonts.SSPSemiBoldH2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var houseLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        
        return view
    }()
    
    var apartmentButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "apartmentIcon");
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.4)
        button.layer.cornerRadius = 4
        button.layer.shadowColor = Theme.DARK_GRAY.cgColor
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0
        button.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var apartmentIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Apartment", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.6), for: .normal)
        label.titleLabel?.font = Fonts.SSPRegularH2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var apartmentLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        
        return view
    }()
    
    var lotButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "parkinglotIcon");
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.4)
        button.layer.cornerRadius = 4
        button.layer.shadowColor = Theme.DARK_GRAY.cgColor
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0
        button.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var lotIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Business/Parking lot", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.6), for: .normal)
        label.titleLabel?.font = Fonts.SSPRegularH2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var lotLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        
        return view
    }()
    
    var otherButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "otherParkingIcon");
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.4)
        button.layer.cornerRadius = 4
        button.layer.shadowColor = Theme.DARK_GRAY.cgColor
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0
        button.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var otherIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Other", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.6), for: .normal)
        label.titleLabel?.font = Fonts.SSPRegularH2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var otherLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        
        return view
    }()
    
    var houseInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "Our most common parking space. The spot is usually owned or leased by the host and can be a driveway or shared parking lot."
        label.numberOfLines = 4
        label.font = Fonts.SSPLightH5
        
        return label
    }()
    
    var apartmentInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "A parking space that is owned by the property owner and leased by then tennant. Usually associated with one spot number in a lot."
        label.numberOfLines = 4
        label.font = Fonts.SSPLightH5
        label.alpha = 0
        
        return label
    }()
    
    var lotInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "A large area for parking with multiple parking spaces for customers. Must own the parking lot to list with Drivewayz."
        label.numberOfLines = 3
        label.font = Fonts.SSPLightH5
        label.alpha = 0
        
        return label
    }()
    
    var otherInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "None of the above options. Drivewayz will contact you before the spot will become live."
        label.numberOfLines = 3
        label.font = Fonts.SSPLightH5
        label.alpha = 0
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    var houseAnchor: NSLayoutConstraint!
    var apartmentAnchor: NSLayoutConstraint!
    var streetAnchor: NSLayoutConstraint!
    var coveredAnchor: NSLayoutConstraint!
    var parkingLotAnchor: NSLayoutConstraint!
    var alleyAnchor: NSLayoutConstraint!
    var gatedAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.width * 1.2)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -5).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(houseButton)
        houseButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 15).isActive = true
        houseButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        houseButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        houseButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView.addSubview(houseIconLabel)
        houseIconLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        houseIconLabel.topAnchor.constraint(equalTo: houseButton.topAnchor).isActive = true
        houseIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        houseIconLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(houseLine)
        houseLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        houseLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        houseAnchor = houseLine.topAnchor.constraint(equalTo: houseIconLabel.bottomAnchor, constant: 95)
        houseAnchor.isActive = true
        houseLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(apartmentButton)
        apartmentButton.topAnchor.constraint(equalTo: houseLine.bottomAnchor, constant: 15).isActive = true
        apartmentButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        apartmentButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        apartmentButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView.addSubview(apartmentIconLabel)
        apartmentIconLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        apartmentIconLabel.topAnchor.constraint(equalTo: apartmentButton.topAnchor).isActive = true
        apartmentIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        apartmentIconLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(apartmentLine)
        apartmentLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        apartmentLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        apartmentAnchor = apartmentLine.topAnchor.constraint(equalTo: apartmentIconLabel.bottomAnchor, constant: 35)
        apartmentAnchor.isActive = true
        apartmentLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(lotButton)
        lotButton.topAnchor.constraint(equalTo: apartmentLine.bottomAnchor, constant: 15).isActive = true
        lotButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        lotButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        lotButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView.addSubview(lotIconLabel)
        lotIconLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        lotIconLabel.topAnchor.constraint(equalTo: lotButton.topAnchor).isActive = true
        lotIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        lotIconLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(lotLine)
        lotLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        lotLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        parkingLotAnchor = lotLine.topAnchor.constraint(equalTo: lotIconLabel.bottomAnchor, constant: 35)
        parkingLotAnchor.isActive = true
        lotLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(otherButton)
        otherButton.topAnchor.constraint(equalTo: lotLine.bottomAnchor, constant: 15).isActive = true
        otherButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        otherButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        otherButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView.addSubview(otherIconLabel)
        otherIconLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        otherIconLabel.topAnchor.constraint(equalTo: otherButton.topAnchor).isActive = true
        otherIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        otherIconLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(otherLine)
        otherLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        otherLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        alleyAnchor = otherLine.topAnchor.constraint(equalTo: otherIconLabel.bottomAnchor, constant: 35)
        alleyAnchor.isActive = true
        otherLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        setupExtraInformation()
    }
    
    func setupExtraInformation() {
        
        scrollView.addSubview(houseInformation)
        houseInformation.leftAnchor.constraint(equalTo: houseIconLabel.leftAnchor).isActive = true
        houseInformation.rightAnchor.constraint(equalTo: houseButton.leftAnchor, constant: -10).isActive = true
        houseInformation.topAnchor.constraint(equalTo: houseIconLabel.bottomAnchor).isActive = true
        houseInformation.bottomAnchor.constraint(equalTo: houseLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(apartmentInformation)
        apartmentInformation.leftAnchor.constraint(equalTo: apartmentIconLabel.leftAnchor).isActive = true
        apartmentInformation.rightAnchor.constraint(equalTo: apartmentButton.leftAnchor, constant: -10).isActive = true
        apartmentInformation.topAnchor.constraint(equalTo: apartmentIconLabel.bottomAnchor).isActive = true
        apartmentInformation.bottomAnchor.constraint(equalTo: apartmentLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(lotInformation)
        lotInformation.leftAnchor.constraint(equalTo: lotIconLabel.leftAnchor).isActive = true
        lotInformation.rightAnchor.constraint(equalTo: lotButton.leftAnchor, constant: -10).isActive = true
        lotInformation.topAnchor.constraint(equalTo: lotIconLabel.bottomAnchor).isActive = true
        lotInformation.bottomAnchor.constraint(equalTo: lotLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(otherInformation)
        otherInformation.leftAnchor.constraint(equalTo: otherIconLabel.leftAnchor).isActive = true
        otherInformation.rightAnchor.constraint(equalTo: otherButton.leftAnchor, constant: -10).isActive = true
        otherInformation.topAnchor.constraint(equalTo: otherIconLabel.bottomAnchor).isActive = true
        otherInformation.bottomAnchor.constraint(equalTo: otherLine.topAnchor, constant: -12).isActive = true
        
    }
    
    var parkingType: String = "residential"
    
    @objc func optionTapped(sender: UIButton) {
        if sender == houseIconLabel || sender == houseButton {
            self.parkingType = "residential"
            UIView.animate(withDuration: 0.1) {
                self.houseIconLabel.setTitleColor(Theme.DARK_GRAY, for: .normal)
                self.houseIconLabel.titleLabel?.font = Fonts.SSPSemiBoldH2
                self.houseButton.backgroundColor = Theme.PACIFIC_BLUE
                self.houseButton.tintColor = Theme.WHITE
                self.houseButton.layer.shadowOpacity = 0.2
                self.houseAnchor.constant = 95
                self.houseInformation.alpha = 1
                self.view.layoutIfNeeded()
                
                self.resetApartment()
                self.resetLot()
                self.resetAlley()
            }
        } else if sender == apartmentIconLabel || sender == apartmentButton {
            self.parkingType = "apartment"
            UIView.animate(withDuration: 0.1) {
                self.apartmentIconLabel.setTitleColor(Theme.DARK_GRAY, for: .normal)
                self.apartmentIconLabel.titleLabel?.font = Fonts.SSPSemiBoldH2
                self.apartmentButton.backgroundColor = Theme.PACIFIC_BLUE
                self.apartmentButton.tintColor = Theme.WHITE
                self.apartmentButton.layer.shadowOpacity = 0.2
                self.apartmentAnchor.constant = 95
                self.apartmentInformation.alpha = 1
                self.view.layoutIfNeeded()
                
                self.resetHouse()
                self.resetLot()
                self.resetAlley()
            }
        } else if sender == lotIconLabel || sender == lotButton {
            self.parkingType = "parking lot"
            UIView.animate(withDuration: 0.1) {
                self.lotIconLabel.setTitleColor(Theme.DARK_GRAY, for: .normal)
                self.lotIconLabel.titleLabel?.font = Fonts.SSPSemiBoldH2
                self.lotButton.backgroundColor = Theme.PACIFIC_BLUE
                self.lotButton.tintColor = Theme.WHITE
                self.lotButton.layer.shadowOpacity = 0.2
                self.parkingLotAnchor.constant = 80
                self.lotInformation.alpha = 1
                self.view.layoutIfNeeded()
                
                self.resetHouse()
                self.resetApartment()
                self.resetAlley()
            }
        } else if sender == otherIconLabel || sender == otherButton {
            self.parkingType = "other"
            UIView.animate(withDuration: 0.1) {
                self.otherIconLabel.setTitleColor(Theme.DARK_GRAY, for: .normal)
                self.otherIconLabel.titleLabel?.font = Fonts.SSPSemiBoldH2
                self.otherButton.backgroundColor = Theme.PACIFIC_BLUE
                self.otherButton.tintColor = Theme.WHITE
                self.otherButton.layer.shadowOpacity = 0.2
                self.alleyAnchor.constant = 80
                self.otherInformation.alpha = 1
                self.view.layoutIfNeeded()
                
                self.resetHouse()
                self.resetApartment()
                self.resetLot()
            }
        }
    }
    
    func resetHouse() {
        UIView.animate(withDuration: 0.1) {
            self.houseIconLabel.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.6), for: .normal)
            self.houseIconLabel.titleLabel?.font = Fonts.SSPRegularH2
            self.houseButton.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.4)
            self.houseButton.tintColor = Theme.WHITE
            self.houseButton.layer.shadowOpacity = 0
            self.houseAnchor.constant = 35
            self.houseInformation.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func resetApartment() {
        UIView.animate(withDuration: 0.1) {
            self.apartmentIconLabel.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.6), for: .normal)
            self.apartmentIconLabel.titleLabel?.font = Fonts.SSPRegularH2
            self.apartmentButton.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.4)
            self.apartmentButton.tintColor = Theme.WHITE
            self.apartmentButton.layer.shadowOpacity = 0
            self.apartmentAnchor.constant = 35
            self.apartmentInformation.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func resetLot() {
        UIView.animate(withDuration: 0.1) {
            self.lotIconLabel.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.6), for: .normal)
            self.lotIconLabel.titleLabel?.font = Fonts.SSPRegularH2
            self.lotButton.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.4)
            self.lotButton.tintColor = Theme.WHITE
            self.lotButton.layer.shadowOpacity = 0
            self.parkingLotAnchor.constant = 35
            self.lotInformation.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func resetAlley() {
        UIView.animate(withDuration: 0.1) {
            self.otherIconLabel.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.6), for: .normal)
            self.otherIconLabel.titleLabel?.font = Fonts.SSPRegularH2
            self.otherButton.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.4)
            self.otherButton.tintColor = Theme.WHITE
            self.otherButton.layer.shadowOpacity = 0
            self.alleyAnchor.constant = 35
            self.otherInformation.alpha = 0
            self.view.layoutIfNeeded()
        }
    }

}
