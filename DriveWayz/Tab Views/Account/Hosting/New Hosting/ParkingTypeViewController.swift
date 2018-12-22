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
        
        return view
    }()
    
    var checkmark: UIButton = {
        let image = UIImage(named: "Checkmark")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.layer.borderColor = Theme.GREEN_PIGMENT.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = Theme.GREEN_PIGMENT
        
        return button
    }()
    
    var houseImageView: UIImageView = {
        let image = UIImage(named: "Home")
        let view = UIImageView(image: image)
        view.image = view.image!.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.PACIFIC_BLUE
        view.translatesAutoresizingMaskIntoConstraints = false
        view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        
        return view
    }()
    
    var houseIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Residential", for: .normal)
        label.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
        label.titleLabel?.font = Fonts.SSPSemiBoldH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var houseLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var apartmentImageView: UIImageView = {
        let image = UIImage(named: "apartmentIcon")
        let view = UIImageView(image: image)
        view.image = view.image!.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var apartmentIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Apartment", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY, for: .normal)
        label.titleLabel?.font = Fonts.SSPLightH3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var apartmentLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var lotImageView: UIImageView = {
        let image = UIImage(named: "parkinglotIcon")
        let view = UIImageView(image: image)
        view.image = view.image!.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var lotIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Business/Parking lot", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY, for: .normal)
        label.titleLabel?.font = Fonts.SSPLightH3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var lotLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var otherImageView: UIImageView = {
        let image = UIImage(named: "otherParkingIcon")
        let view = UIImageView(image: image)
        view.image = view.image!.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var otherIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Other", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY, for: .normal)
        label.titleLabel?.font = Fonts.SSPLightH3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var alleyLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var houseInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "Our most common parking space. The spot is usually owned or leased by the host and can be a driveway or shared parking lot."
        label.numberOfLines = 4
        label.font = Fonts.SSPLightH6
        
        return label
    }()
    
    var apartmentInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "A parking space that is owned by the property owner and leased by then tennant. Usually associated with one spot number in a lot."
        label.numberOfLines = 4
        label.font = Fonts.SSPLightH6
        label.alpha = 0
        
        return label
    }()
    
    var lotInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "A large area for parking with multiple parking spaces for customers. Must own the parking lot to list with Drivewayz."
        label.numberOfLines = 4
        label.font = Fonts.SSPLightH6
        label.alpha = 0
        
        return label
    }()
    
    var alleyInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "A large area for parking with multiple parking spaces for customers. Must own the parking lot to list with Drivewayz."
        label.numberOfLines = 4
        label.font = Fonts.SSPLightH6
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
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.width * 2)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -5).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(houseImageView)
        houseImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 5).isActive = true
        houseImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        houseImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        houseImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(houseIconLabel)
        houseIconLabel.leftAnchor.constraint(equalTo: houseImageView.rightAnchor, constant: 24).isActive = true
        houseIconLabel.centerYAnchor.constraint(equalTo: houseImageView.centerYAnchor).isActive = true
        houseIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        houseIconLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(houseLine)
        houseLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        houseLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        houseAnchor = houseLine.topAnchor.constraint(equalTo: houseIconLabel.bottomAnchor, constant: 100)
        houseAnchor.isActive = true
        houseLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(apartmentImageView)
        apartmentImageView.topAnchor.constraint(equalTo: houseLine.bottomAnchor, constant: 10).isActive = true
        apartmentImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        apartmentImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        apartmentImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(apartmentIconLabel)
        apartmentIconLabel.leftAnchor.constraint(equalTo: apartmentImageView.rightAnchor, constant: 24).isActive = true
        apartmentIconLabel.centerYAnchor.constraint(equalTo: apartmentImageView.centerYAnchor).isActive = true
        apartmentIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        apartmentIconLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(apartmentLine)
        apartmentLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        apartmentLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        apartmentAnchor = apartmentLine.topAnchor.constraint(equalTo: apartmentIconLabel.bottomAnchor, constant: 5)
        apartmentAnchor.isActive = true
        apartmentLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(lotImageView)
        lotImageView.topAnchor.constraint(equalTo: apartmentLine.bottomAnchor, constant: 5).isActive = true
        lotImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        lotImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        lotImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(lotIconLabel)
        lotIconLabel.leftAnchor.constraint(equalTo: lotImageView.rightAnchor, constant: 24).isActive = true
        lotIconLabel.centerYAnchor.constraint(equalTo: lotImageView.centerYAnchor).isActive = true
        lotIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        lotIconLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(lotLine)
        lotLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        lotLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        parkingLotAnchor = lotLine.topAnchor.constraint(equalTo: lotIconLabel.bottomAnchor, constant: 5)
        parkingLotAnchor.isActive = true
        lotLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(otherImageView)
        otherImageView.topAnchor.constraint(equalTo: lotLine.bottomAnchor, constant: 5).isActive = true
        otherImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        otherImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        otherImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(otherIconLabel)
        otherIconLabel.leftAnchor.constraint(equalTo: otherImageView.rightAnchor, constant: 24).isActive = true
        otherIconLabel.centerYAnchor.constraint(equalTo: otherImageView.centerYAnchor).isActive = true
        otherIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        otherIconLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(alleyLine)
        alleyLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        alleyLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        alleyAnchor = alleyLine.topAnchor.constraint(equalTo: otherIconLabel.bottomAnchor, constant: 5)
        alleyAnchor.isActive = true
        alleyLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        setupExtraInformation()
    }
    
    func setupExtraInformation() {
        
        scrollView.addSubview(houseInformation)
        houseInformation.leftAnchor.constraint(equalTo: houseIconLabel.leftAnchor).isActive = true
        houseInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        houseInformation.topAnchor.constraint(equalTo: houseIconLabel.bottomAnchor, constant: -10).isActive = true
        houseInformation.bottomAnchor.constraint(equalTo: houseLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(apartmentInformation)
        apartmentInformation.leftAnchor.constraint(equalTo: apartmentIconLabel.leftAnchor).isActive = true
        apartmentInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        apartmentInformation.topAnchor.constraint(equalTo: apartmentIconLabel.bottomAnchor, constant: -10).isActive = true
        apartmentInformation.bottomAnchor.constraint(equalTo: apartmentLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(lotInformation)
        lotInformation.leftAnchor.constraint(equalTo: lotIconLabel.leftAnchor).isActive = true
        lotInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        lotInformation.topAnchor.constraint(equalTo: lotIconLabel.bottomAnchor, constant: -10).isActive = true
        lotInformation.bottomAnchor.constraint(equalTo: lotLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(alleyInformation)
        alleyInformation.leftAnchor.constraint(equalTo: otherIconLabel.leftAnchor).isActive = true
        alleyInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        alleyInformation.topAnchor.constraint(equalTo: otherIconLabel.bottomAnchor, constant: -10).isActive = true
        alleyInformation.bottomAnchor.constraint(equalTo: alleyLine.topAnchor, constant: -12).isActive = true
        
        setupCheckmark()
    }
    
    var checkHouseAnchor: NSLayoutConstraint!
    var checkApartmentAnchor: NSLayoutConstraint!
    var checkLotAnchor: NSLayoutConstraint!
    var checkOtherAnchor: NSLayoutConstraint!
    var previousCheckAnchor: NSLayoutConstraint!
    
    func setupCheckmark() {
        
        scrollView.addSubview(checkmark)
        checkmark.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        checkmark.widthAnchor.constraint(equalToConstant: 30).isActive = true
        checkmark.heightAnchor.constraint(equalTo: checkmark.widthAnchor).isActive = true
        checkHouseAnchor = checkmark.centerYAnchor.constraint(equalTo: houseIconLabel.centerYAnchor)
            checkHouseAnchor.isActive = true
        checkApartmentAnchor = checkmark.centerYAnchor.constraint(equalTo: apartmentIconLabel.centerYAnchor)
            checkApartmentAnchor.isActive = false
        checkLotAnchor = checkmark.centerYAnchor.constraint(equalTo: lotIconLabel.centerYAnchor)
            checkLotAnchor.isActive = false
        checkOtherAnchor = checkmark.centerYAnchor.constraint(equalTo: otherIconLabel.centerYAnchor)
            checkOtherAnchor.isActive = false
        
        self.previousCheckAnchor = checkHouseAnchor
    }
    
    var parkingType: String = "house"
    
    @objc func optionTapped(sender: UIButton) {
        if sender == houseIconLabel {
            self.parkingType = "house"
            UIView.animate(withDuration: 0.1) {
                self.houseIconLabel.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
                self.houseIconLabel.titleLabel?.font = Fonts.SSPSemiBoldH3
                self.houseImageView.tintColor = Theme.PACIFIC_BLUE
                self.houseImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.houseAnchor.constant = 100
                self.houseInformation.alpha = 1
                self.view.layoutIfNeeded()
                
                self.resetApartment()
                self.resetLot()
                self.resetAlley()
                self.checkMarkSwitched(checkAnchor: self.checkHouseAnchor)
            }
        } else if sender == apartmentIconLabel {
            self.parkingType = "apartment"
            UIView.animate(withDuration: 0.1) {
                self.apartmentIconLabel.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
                self.apartmentIconLabel.titleLabel?.font = Fonts.SSPSemiBoldH3
                self.apartmentImageView.tintColor = Theme.PACIFIC_BLUE
                self.apartmentImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.apartmentAnchor.constant = 100
                self.apartmentInformation.alpha = 1
                self.view.layoutIfNeeded()
                
                self.resetHouse()
                self.resetLot()
                self.resetAlley()
                self.checkMarkSwitched(checkAnchor: self.checkApartmentAnchor)
            }
        } else if sender == lotIconLabel {
            self.parkingType = "parkingLot"
            UIView.animate(withDuration: 0.1) {
                self.lotIconLabel.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
                self.lotIconLabel.titleLabel?.font = Fonts.SSPSemiBoldH3
                self.lotImageView.tintColor = Theme.PACIFIC_BLUE
                self.lotImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.parkingLotAnchor.constant = 100
                self.lotInformation.alpha = 1
                self.view.layoutIfNeeded()
                
                self.resetHouse()
                self.resetApartment()
                self.resetAlley()
                self.checkMarkSwitched(checkAnchor: self.checkLotAnchor)
            }
        } else if sender == otherIconLabel {
            self.parkingType = "other"
            UIView.animate(withDuration: 0.1) {
                self.otherIconLabel.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
                self.otherIconLabel.titleLabel?.font = Fonts.SSPSemiBoldH3
                self.otherImageView.tintColor = Theme.PACIFIC_BLUE
                self.otherImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.alleyAnchor.constant = 100
                self.alleyInformation.alpha = 1
                self.view.layoutIfNeeded()
                
                self.resetHouse()
                self.resetApartment()
                self.resetLot()
                self.checkMarkSwitched(checkAnchor: self.checkOtherAnchor)
            }
        }
    }
    
    func checkMarkSwitched(checkAnchor: NSLayoutConstraint) {
        UIView.animate(withDuration: animationIn, animations: {
            self.checkmark.alpha = 0
        }) { (success) in
            self.previousCheckAnchor.isActive = false
            self.view.layoutIfNeeded()
            checkAnchor.isActive = true
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: animationIn, animations: {
                self.checkmark.alpha = 1
            })
            self.previousCheckAnchor = checkAnchor
        }
    }
    
    func resetHouse() {
        UIView.animate(withDuration: 0.1) {
            self.houseIconLabel.setTitleColor(Theme.DARK_GRAY, for: .normal)
            self.houseIconLabel.titleLabel?.font = Fonts.SSPLightH3
            self.houseImageView.tintColor = Theme.DARK_GRAY
            self.houseImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.houseAnchor.constant = 5
            self.houseInformation.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func resetApartment() {
        UIView.animate(withDuration: 0.1) {
            self.apartmentIconLabel.setTitleColor(Theme.DARK_GRAY, for: .normal)
            self.apartmentIconLabel.titleLabel?.font = Fonts.SSPLightH3
            self.apartmentImageView.tintColor = Theme.DARK_GRAY
            self.apartmentImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.apartmentAnchor.constant = 5
            self.apartmentInformation.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func resetLot() {
        UIView.animate(withDuration: 0.1) {
            self.lotIconLabel.setTitleColor(Theme.DARK_GRAY, for: .normal)
            self.lotIconLabel.titleLabel?.font = Fonts.SSPLightH3
            self.lotImageView.tintColor = Theme.DARK_GRAY
            self.lotImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.parkingLotAnchor.constant = 5
            self.lotInformation.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func resetAlley() {
        UIView.animate(withDuration: 0.1) {
            self.otherIconLabel.setTitleColor(Theme.DARK_GRAY, for: .normal)
            self.otherIconLabel.titleLabel?.font = Fonts.SSPLightH3
            self.otherImageView.tintColor = Theme.DARK_GRAY
            self.otherImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.alleyAnchor.constant = 5
            self.alleyInformation.alpha = 0
            self.view.layoutIfNeeded()
        }
    }

}
