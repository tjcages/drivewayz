//
//  CurrentVehicleViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 11/28/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class CurrentVehicleViewController: UIViewController, UITextFieldDelegate {
    
    var activeTextField = UITextField()
    var delegate: handleChangeVehicle?
    var selectedKey: String = ""
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Your vehicles"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH1
        
        return label
    }()
    
    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        view.clipsToBounds = false
        
        return view
    }()
    
    var detailLabel: UILabel = {
        let label = UILabel()
        label.text = "Details"
        label.textColor = Theme.BLACK
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH2
        
        return label
    }()
    
    var vehicleMakeLabel: UITextField = {
        let label = UITextField()
        label.text = ""
        label.textColor = Theme.BLACK
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH3
        label.clearButtonMode = .whileEditing
        label.placeholder = "Toyota"
        label.autocapitalizationType = .words
        label.isUserInteractionEnabled = false
        label.keyboardAppearance = .dark
        
        return label
    }()
    
    var makeLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LIGHT_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var vehicleModelLabel: UITextField = {
        let label = UITextField()
        label.text = ""
        label.textColor = Theme.BLACK
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH3
        label.clearButtonMode = .whileEditing
        label.placeholder = "4Runner"
        label.autocapitalizationType = .words
        label.isUserInteractionEnabled = false
        label.keyboardAppearance = .dark
        
        return label
    }()
    
    var modelLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LIGHT_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var vehicleYearLabel: UITextField = {
        let label = UITextField()
        label.text = ""
        label.textColor = Theme.BLACK
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH3
        label.clearButtonMode = .whileEditing
        label.placeholder = "2015"
        label.keyboardType = .numberPad
        label.isUserInteractionEnabled = false
        label.keyboardAppearance = .dark
        
        return label
    }()
    
    var yearLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LIGHT_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var vehicleLicenseLabel: UITextField = {
        let label = UITextField()
        label.text = ""
        label.textColor = Theme.BLACK
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH3
        label.clearButtonMode = .whileEditing
        label.placeholder = "000-XXX"
        label.isUserInteractionEnabled = false
        label.keyboardAppearance = .dark
        
        return label
    }()
    
    var licenseLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LIGHT_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var makeLabel: UILabel = {
        let label = UILabel()
        label.text = "Make"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var modelLabel: UILabel = {
        let label = UILabel()
        label.text = "Model"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var yearLabel: UILabel = {
        let label = UILabel()
        label.text = "Year"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var licenseLabel: UILabel = {
        let label = UILabel()
        label.text = "Plate"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var currentLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var currentButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Make current vehicle", for: .normal)
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.addTarget(self, action: #selector(handleCurrentButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Delete vehicle", for: .normal)
        button.setTitleColor(Theme.HARMONY_RED, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.addTarget(self, action: #selector(deleteVehiclePressed), for: .touchUpInside)
        
        return button
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
        button.addTarget(self, action: #selector(handleCurrentButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var grayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LIGHT_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    func setData(type: String, license: String, key: String) {
        self.vehicleLicenseLabel.text = license
        self.selectedKey = key
        let split = type.split(separator: " ")
        if let year = split.first {
            self.vehicleYearLabel.text = String(year)
        }
        if let make = split.dropFirst().first {
            self.vehicleMakeLabel.text = String(make)
        }
        if let model = split.dropFirst().dropFirst().first {
            self.vehicleModelLabel.text = String(model)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        view.backgroundColor = Theme.WHITE
        
        vehicleMakeLabel.delegate = self
        vehicleModelLabel.delegate = self
        vehicleYearLabel.delegate = self
        vehicleLicenseLabel.delegate = self
        
        setupViews()
        createToolbar()
    }
    
    var gradientHeight: CGFloat = 140
    var gradientHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        self.view.addSubview(gradientContainer)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 800)
        scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        gradientContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: gradientHeight)
            gradientHeightAnchor.isActive = true
        
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
        
        scrollView.addSubview(detailLabel)
        detailLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        detailLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        detailLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24).isActive = true
        detailLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(makeLabel)
        scrollView.addSubview(vehicleMakeLabel)
        makeLabel.leftAnchor.constraint(equalTo: detailLabel.leftAnchor, constant: 8).isActive = true
        makeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        makeLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 14).isActive = true
        makeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(modelLabel)
        scrollView.addSubview(vehicleModelLabel)
        modelLabel.leftAnchor.constraint(equalTo: detailLabel.leftAnchor, constant: 8).isActive = true
        modelLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        modelLabel.topAnchor.constraint(equalTo: vehicleMakeLabel.bottomAnchor, constant: 20).isActive = true
        modelLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(yearLabel)
        scrollView.addSubview(vehicleYearLabel)
        yearLabel.leftAnchor.constraint(equalTo: detailLabel.leftAnchor, constant: 8).isActive = true
        yearLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        yearLabel.topAnchor.constraint(equalTo: vehicleModelLabel.bottomAnchor, constant: 20).isActive = true
        yearLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(licenseLabel)
        scrollView.addSubview(vehicleLicenseLabel)
        licenseLabel.leftAnchor.constraint(equalTo: detailLabel.leftAnchor, constant: 8).isActive = true
        licenseLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        licenseLabel.topAnchor.constraint(equalTo: vehicleYearLabel.bottomAnchor, constant: 20).isActive = true
        licenseLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        vehicleMakeLabel.leftAnchor.constraint(equalTo: makeLabel.leftAnchor).isActive = true
        vehicleMakeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        vehicleMakeLabel.topAnchor.constraint(equalTo: makeLabel.bottomAnchor).isActive = true
        vehicleMakeLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        scrollView.addSubview(makeLine)
        makeLine.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        makeLine.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        makeLine.topAnchor.constraint(equalTo: vehicleMakeLabel.bottomAnchor, constant: 10).isActive = true
        makeLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        vehicleModelLabel.leftAnchor.constraint(equalTo: modelLabel.leftAnchor).isActive = true
        vehicleModelLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        vehicleModelLabel.topAnchor.constraint(equalTo: modelLabel.bottomAnchor).isActive = true
        vehicleModelLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        scrollView.addSubview(modelLine)
        modelLine.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        modelLine.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        modelLine.topAnchor.constraint(equalTo: vehicleModelLabel.bottomAnchor, constant: 10).isActive = true
        modelLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        vehicleYearLabel.leftAnchor.constraint(equalTo: yearLabel.leftAnchor).isActive = true
        vehicleYearLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        vehicleYearLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor).isActive = true
        vehicleYearLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        scrollView.addSubview(yearLine)
        yearLine.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        yearLine.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        yearLine.topAnchor.constraint(equalTo: vehicleYearLabel.bottomAnchor, constant: 10).isActive = true
        yearLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        vehicleLicenseLabel.leftAnchor.constraint(equalTo: licenseLabel.leftAnchor).isActive = true
        vehicleLicenseLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        vehicleLicenseLabel.topAnchor.constraint(equalTo: licenseLabel.bottomAnchor).isActive = true
        vehicleLicenseLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        scrollView.addSubview(grayView)
        grayView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: -1).isActive = true
        grayView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 1).isActive = true
        grayView.topAnchor.constraint(equalTo: vehicleLicenseLabel.bottomAnchor, constant: 10).isActive = true
        grayView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(currentButton)
        currentButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        currentButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32).isActive = true
        currentButton.topAnchor.constraint(equalTo: grayView.bottomAnchor).isActive = true
        currentButton.heightAnchor.constraint(equalToConstant: 60).isActive = true

        scrollView.addSubview(deleteButton)
        deleteButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        deleteButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32).isActive = true
        deleteButton.topAnchor.constraint(equalTo: currentButton.bottomAnchor).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        scrollView.addSubview(checkmark)
        checkmark.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        checkmark.widthAnchor.constraint(equalToConstant: 30).isActive = true
        checkmark.heightAnchor.constraint(equalTo: checkmark.widthAnchor).isActive = true
        checkmark.centerYAnchor.constraint(equalTo: currentButton.centerYAnchor).isActive = true
        
    }
    
    func setupNewVehicle() {
        self.deleteButton.alpha = 0
        self.checkmark.alpha = 0
        self.vehicleMakeLabel.text = ""
        self.vehicleModelLabel.text = ""
        self.vehicleYearLabel.text = ""
        self.vehicleLicenseLabel.text = ""
        self.currentButton.setTitle("Confirm vehicle", for: .normal)
        self.currentButton.setTitleColor(Theme.BLUE, for: .normal)
        self.detailLabel.text = "Enter details"
        self.doneButton?.title = "Next"
        self.makeLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        self.modelLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        self.yearLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        self.licenseLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        self.vehicleMakeLabel.becomeFirstResponder()
        self.vehicleMakeLabel.isUserInteractionEnabled = true
        self.vehicleModelLabel.isUserInteractionEnabled = true
        self.vehicleYearLabel.isUserInteractionEnabled = true
        self.vehicleLicenseLabel.isUserInteractionEnabled = true
    }
    
    func setupCurrentVehicle() {
        self.deleteButton.alpha = 1
        self.checkmark.alpha = 1
        self.currentButton.setTitle("Make current vehicle", for: .normal)
        self.currentButton.setTitleColor(Theme.BLACK, for: .normal)
        self.detailLabel.text = "Details"
        self.doneButton?.title = "Done"
        self.makeLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        self.modelLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        self.yearLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        self.licenseLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        self.vehicleMakeLabel.isUserInteractionEnabled = false
        self.vehicleModelLabel.isUserInteractionEnabled = false
        self.vehicleYearLabel.isUserInteractionEnabled = false
        self.vehicleLicenseLabel.isUserInteractionEnabled = false
    }
    
    var doneButton: UIBarButtonItem?
    
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = Theme.DARK_GRAY
        toolBar.tintColor = Theme.WHITE
        toolBar.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.4).cgColor
        toolBar.layer.borderWidth = 0.5
        
        doneButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(moveToNext))
        doneButton?.setTitleTextAttributes([ NSAttributedString.Key.font: Fonts.SSPSemiBoldH4], for: UIControl.State.normal)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace, doneButton!], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.vehicleMakeLabel.inputAccessoryView = toolBar
        self.vehicleModelLabel.inputAccessoryView = toolBar
        self.vehicleYearLabel.inputAccessoryView = toolBar
        self.vehicleLicenseLabel.inputAccessoryView = toolBar
    }
    
    @objc func moveToNext() {
        if doneButton?.title == "Done" {
            self.makeLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
            self.modelLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
            self.yearLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
            self.licenseLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
            self.makeLine.backgroundColor = Theme.LIGHT_GRAY.withAlphaComponent(0.4)
            self.modelLine.backgroundColor = Theme.LIGHT_GRAY.withAlphaComponent(0.4)
            self.yearLine.backgroundColor = Theme.LIGHT_GRAY.withAlphaComponent(0.4)
            self.licenseLine.backgroundColor = Theme.LIGHT_GRAY.withAlphaComponent(0.4)
            self.view.endEditing(true)
        } else if self.activeTextField == vehicleMakeLabel {
            self.vehicleModelLabel.becomeFirstResponder()
        } else if self.activeTextField == vehicleModelLabel {
            self.vehicleYearLabel.becomeFirstResponder()
        } else if self.activeTextField == vehicleYearLabel {
            self.vehicleLicenseLabel.becomeFirstResponder()
        } else if self.activeTextField == vehicleLicenseLabel {
            self.makeLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
            self.modelLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
            self.yearLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
            self.licenseLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
            self.makeLine.backgroundColor = Theme.LIGHT_GRAY.withAlphaComponent(0.4)
            self.modelLine.backgroundColor = Theme.LIGHT_GRAY.withAlphaComponent(0.4)
            self.yearLine.backgroundColor = Theme.LIGHT_GRAY.withAlphaComponent(0.4)
            self.licenseLine.backgroundColor = Theme.LIGHT_GRAY.withAlphaComponent(0.4)
            self.view.endEditing(true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.makeLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        self.modelLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        self.yearLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        self.licenseLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        self.makeLine.backgroundColor = Theme.LIGHT_GRAY.withAlphaComponent(0.4)
        self.modelLine.backgroundColor = Theme.LIGHT_GRAY.withAlphaComponent(0.4)
        self.yearLine.backgroundColor = Theme.LIGHT_GRAY.withAlphaComponent(0.4)
        self.licenseLine.backgroundColor = Theme.LIGHT_GRAY.withAlphaComponent(0.4)
        self.view.endEditing(true)
        scrollView.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
        self.makeLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        self.modelLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        self.yearLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        self.licenseLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        self.makeLine.backgroundColor = Theme.LIGHT_GRAY.withAlphaComponent(0.4)
        self.modelLine.backgroundColor = Theme.LIGHT_GRAY.withAlphaComponent(0.4)
        self.yearLine.backgroundColor = Theme.LIGHT_GRAY.withAlphaComponent(0.4)
        self.licenseLine.backgroundColor = Theme.LIGHT_GRAY.withAlphaComponent(0.4)
        if textField == vehicleYearLabel {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: self.view.frame.height * 0.2), animated: true)
            self.yearLabel.textColor = Theme.BLUE
            self.yearLine.backgroundColor = Theme.BLUE
        } else if textField == vehicleLicenseLabel {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: self.view.frame.height * 0.3), animated: true)
            self.licenseLabel.textColor = Theme.BLUE
            self.licenseLine.backgroundColor = Theme.BLUE
        } else if textField == vehicleModelLabel {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: self.view.frame.height * 0.1), animated: true)
            self.modelLabel.textColor = Theme.BLUE
            self.modelLine.backgroundColor = Theme.BLUE
        } else if textField == vehicleMakeLabel {
            self.makeLabel.textColor = Theme.BLUE
            self.makeLine.backgroundColor = Theme.BLUE
        }
    }
    
    @objc func handleCurrentButtonPressed() {
        self.backButtonPressed()
        let timestamp = Date().timeIntervalSince1970
        if let userID = Auth.auth().currentUser?.uid {
            let userRef = Database.database().reference().child("users").child(userID)
            if currentButton.titleLabel!.text == "Confirm vehicle" {
                let ref = Database.database().reference().child("UserVehicles")
                let uid = ref.childByAutoId()
                userRef.updateChildValues(["selectedVehicle": selectedKey])
                if let vehicleMake = self.vehicleMakeLabel.text, let vehicleModel = self.vehicleModelLabel.text, let vehicleYear = self.vehicleYearLabel.text, let vehicleLicense = self.vehicleLicenseLabel.text, let uidKey = uid.key {
                    if vehicleMake != "", vehicleModel != "", vehicleYear != "", vehicleLicense != "", uidKey != "" {
                        uid.updateChildValues(["userID": userID, "timestamp": timestamp, "vehicleID": uidKey, "vehicleMake": vehicleMake, "vehicleModel": vehicleModel, "vehicleYear": vehicleYear, "licensePlate": vehicleLicense])
                        userRef.child("Vehicles").updateChildValues([uidKey: uidKey])
                        userRef.updateChildValues(["selectedVehicle": uidKey])
                        self.scrollView.setContentOffset(.zero, animated: true)
                    }
                }
            } else if currentButton.titleLabel!.text == "Make current vehicle" {
                userRef.updateChildValues(["selectedVehicle": selectedKey])
                let ref = Database.database().reference().child("UserVehicles").child(selectedKey)
                if let vehicleMake = self.vehicleMakeLabel.text, let vehicleModel = self.vehicleModelLabel.text, let vehicleYear = self.vehicleYearLabel.text, let vehicleLicense = self.vehicleLicenseLabel.text {
                    if vehicleMake != "", vehicleModel != "", vehicleYear != "", vehicleLicense != "", selectedKey != "" {
                        ref.updateChildValues(["vehicleMake": vehicleMake, "vehicleModel": vehicleModel, "vehicleYear": vehicleYear, "licensePlate": vehicleLicense])
                        self.scrollView.setContentOffset(.zero, animated: true)
                    }
                }
            }
        }
    }
    
    @objc func deleteVehiclePressed() {
        if let vehicleMake = self.vehicleMakeLabel.text, let vehicleModel = self.vehicleModelLabel.text, let vehicleYear = self.vehicleYearLabel.text {
            let vehicle = "\(vehicleYear) \(vehicleMake) \(vehicleModel)"
            let alert = UIAlertController(title: "Are you sure?", message: "Delete \(vehicle)", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (success) in
                self.backButtonPressed()
                if let userID = Auth.auth().currentUser?.uid {
                    let ref = Database.database().reference().child("users").child(userID).child("Vehicles").child(self.selectedKey)
                    ref.removeValue()
                    let vehicleRef = Database.database().reference().child("UserVehicles").child(self.selectedKey)
                    vehicleRef.removeValue()
                    
                    self.scrollView.setContentOffset(.zero, animated: true)
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        }
    }

    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }

}


extension CurrentVehicleViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        let state = scrollView.panGestureRecognizer.state
        var totalHeight: CGFloat = 0.0
        switch device {
        case .iphone8:
            totalHeight = 140
        case .iphoneX:
            totalHeight = 160
        }
        if state == .changed {
            if translation > 0 && translation < 60 {
                let percent = translation/60
                self.gradientHeightAnchor.constant = totalHeight - percent * 60
                self.mainLabel.transform = CGAffineTransform(scaleX: 1 - 0.2 * percent, y: 1 - 0.2 * percent)
            }
        } else {
            let translation = scrollView.contentOffset.y
            if translation < 0 && self.gradientHeightAnchor.constant != totalHeight {
                self.scrollExpanded()
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.contentOffset.y
        if translation >= 55 {
            self.scrollMinimized()
        } else {
            self.scrollExpanded()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        if translation >= 55 {
            self.scrollMinimized()
        } else {
            self.scrollExpanded()
        }
    }
    
    func scrollExpanded() {
        switch device {
        case .iphone8:
            self.gradientHeightAnchor.constant = 140
        case .iphoneX:
            self.gradientHeightAnchor.constant = 160
        }
        UIView.animate(withDuration: animationOut, animations: {
            self.mainLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func scrollMinimized() {
        switch device {
        case .iphone8:
            self.gradientHeightAnchor.constant = 80
        case .iphoneX:
            self.gradientHeightAnchor.constant = 100
        }
        UIView.animate(withDuration: animationOut, animations: {
            self.mainLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
