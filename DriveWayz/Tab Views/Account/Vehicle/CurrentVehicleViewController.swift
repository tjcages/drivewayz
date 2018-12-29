//
//  CurrentVehicleViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 11/28/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class CurrentVehicleViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
    var delegate: handlePercentage?
    var activeTextField = UITextField()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        
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
        
        return label
    }()
    
    var makeLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
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
        
        return label
    }()
    
    var modelLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
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
        
        return label
    }()
    
    var yearLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
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
        
        return label
    }()
    
    var licenseLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var makeLabel: UILabel = {
        let label = UILabel()
        label.text = "Make"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPLightH4
        
        return label
    }()
    
    var modelLabel: UILabel = {
        let label = UILabel()
        label.text = "Model"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPLightH4
        
        return label
    }()
    
    var yearLabel: UILabel = {
        let label = UILabel()
        label.text = "Year"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPLightH4
        
        return label
    }()
    
    var licenseLabel: UILabel = {
        let label = UILabel()
        label.text = "Plate"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPLightH4
        
        return label
    }()
    
    var currentLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var currentButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Make current vehicle", for: .normal)
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = Fonts.SSPRegularH4
        
        return button
    }()
    
    var deleteLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Delete vehicle", for: .normal)
        button.setTitleColor(Theme.HARMONY_RED, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = Fonts.SSPRegularH4
        
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
        
        return button
    }()
    
    var grayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE
        view.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.4).cgColor
        view.layer.borderWidth = 0.5
        
        return view
    }()
    
    func setData(type: String, license: String) {
        self.vehicleLicenseLabel.text = license
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
        
        view.backgroundColor = Theme.WHITE
        
        vehicleMakeLabel.delegate = self
        vehicleModelLabel.delegate = self
        vehicleYearLabel.delegate = self
        vehicleLicenseLabel.delegate = self
        scrollView.delegate = self
        
        setupViews()
        createToolbar()
    }
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.2)
        scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        scrollView.addSubview(detailLabel)
        detailLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        detailLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        detailLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24).isActive = true
        detailLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(makeLabel)
        scrollView.addSubview(vehicleMakeLabel)
        makeLabel.leftAnchor.constraint(equalTo: detailLabel.leftAnchor, constant: 8).isActive = true
        makeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        makeLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 14).isActive = true
        makeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(modelLabel)
        scrollView.addSubview(vehicleModelLabel)
        modelLabel.leftAnchor.constraint(equalTo: detailLabel.leftAnchor, constant: 8).isActive = true
        modelLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        modelLabel.topAnchor.constraint(equalTo: vehicleMakeLabel.bottomAnchor, constant: 20).isActive = true
        modelLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(yearLabel)
        scrollView.addSubview(vehicleYearLabel)
        yearLabel.leftAnchor.constraint(equalTo: detailLabel.leftAnchor, constant: 8).isActive = true
        yearLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        yearLabel.topAnchor.constraint(equalTo: vehicleModelLabel.bottomAnchor, constant: 20).isActive = true
        yearLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(licenseLabel)
        scrollView.addSubview(vehicleLicenseLabel)
        licenseLabel.leftAnchor.constraint(equalTo: detailLabel.leftAnchor, constant: 8).isActive = true
        licenseLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        licenseLabel.topAnchor.constraint(equalTo: vehicleYearLabel.bottomAnchor, constant: 20).isActive = true
        licenseLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        vehicleMakeLabel.leftAnchor.constraint(equalTo: makeLabel.leftAnchor).isActive = true
        vehicleMakeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        vehicleMakeLabel.topAnchor.constraint(equalTo: makeLabel.bottomAnchor).isActive = true
        vehicleMakeLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        scrollView.addSubview(makeLine)
        makeLine.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        makeLine.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        makeLine.topAnchor.constraint(equalTo: vehicleMakeLabel.bottomAnchor, constant: 10).isActive = true
        makeLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        vehicleModelLabel.leftAnchor.constraint(equalTo: modelLabel.leftAnchor).isActive = true
        vehicleModelLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        vehicleModelLabel.topAnchor.constraint(equalTo: modelLabel.bottomAnchor).isActive = true
        vehicleModelLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        scrollView.addSubview(modelLine)
        modelLine.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        modelLine.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        modelLine.topAnchor.constraint(equalTo: vehicleModelLabel.bottomAnchor, constant: 10).isActive = true
        modelLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        vehicleYearLabel.leftAnchor.constraint(equalTo: yearLabel.leftAnchor).isActive = true
        vehicleYearLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        vehicleYearLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor).isActive = true
        vehicleYearLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        scrollView.addSubview(yearLine)
        yearLine.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        yearLine.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        yearLine.topAnchor.constraint(equalTo: vehicleYearLabel.bottomAnchor, constant: 10).isActive = true
        yearLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        vehicleLicenseLabel.leftAnchor.constraint(equalTo: licenseLabel.leftAnchor).isActive = true
        vehicleLicenseLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        vehicleLicenseLabel.topAnchor.constraint(equalTo: licenseLabel.bottomAnchor).isActive = true
        vehicleLicenseLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        scrollView.addSubview(grayView)
        grayView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: -1).isActive = true
        grayView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 1).isActive = true
        grayView.topAnchor.constraint(equalTo: vehicleLicenseLabel.bottomAnchor, constant: 10).isActive = true
        grayView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(currentButton)
        currentButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        currentButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        currentButton.topAnchor.constraint(equalTo: grayView.bottomAnchor).isActive = true
        currentButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        scrollView.addSubview(deleteLine)
        deleteLine.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        deleteLine.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        deleteLine.topAnchor.constraint(equalTo: currentButton.bottomAnchor).isActive = true
        deleteLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(deleteButton)
        deleteButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        deleteButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        deleteButton.topAnchor.constraint(equalTo: deleteLine.bottomAnchor).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        scrollView.addSubview(checkmark)
        checkmark.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        checkmark.widthAnchor.constraint(equalToConstant: 30).isActive = true
        checkmark.heightAnchor.constraint(equalTo: checkmark.widthAnchor).isActive = true
        checkmark.centerYAnchor.constraint(equalTo: currentButton.centerYAnchor).isActive = true
        
    }
    
    func setupNewVehicle() {
        self.deleteButton.alpha = 0
        self.deleteLine.alpha = 0
        self.checkmark.alpha = 0
        self.vehicleMakeLabel.text = ""
        self.vehicleModelLabel.text = ""
        self.vehicleYearLabel.text = ""
        self.vehicleLicenseLabel.text = ""
        self.currentButton.setTitle("Confirm vehicle", for: .normal)
        self.currentButton.setTitleColor(Theme.SEA_BLUE, for: .normal)
        self.detailLabel.text = "Enter details"
        self.doneButton.title = "Next"
        self.makeLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        self.modelLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        self.yearLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        self.licenseLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        self.vehicleMakeLabel.becomeFirstResponder()
    }
    
    func setupCurrentVehicle() {
        self.deleteButton.alpha = 1
        self.deleteLine.alpha = 1
        self.checkmark.alpha = 1
        self.currentButton.setTitle("Make current vehicle", for: .normal)
        self.currentButton.setTitleColor(Theme.BLACK, for: .normal)
        self.detailLabel.text = "Details"
        self.doneButton.title = "Done"
        self.makeLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        self.modelLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        self.yearLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        self.licenseLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
    }
    
    var doneButton: UIBarButtonItem!
    
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = Theme.WHITE
        toolBar.tintColor = Theme.PRUSSIAN_BLUE
        toolBar.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.4).cgColor
        toolBar.layer.borderWidth = 0.5
        
        doneButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(moveToNext))
        doneButton.setTitleTextAttributes([ NSAttributedString.Key.font: Fonts.SSPSemiBoldH4], for: UIControl.State.normal)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.vehicleMakeLabel.inputAccessoryView = toolBar
        self.vehicleModelLabel.inputAccessoryView = toolBar
        self.vehicleYearLabel.inputAccessoryView = toolBar
        self.vehicleLicenseLabel.inputAccessoryView = toolBar
    }
    
    @objc func moveToNext() {
        if doneButton.title == "Done" {
            self.makeLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
            self.modelLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
            self.yearLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
            self.licenseLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
            self.makeLine.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
            self.modelLine.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
            self.yearLine.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
            self.licenseLine.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
            self.view.endEditing(true)
        } else if self.activeTextField == vehicleMakeLabel {
            self.vehicleModelLabel.becomeFirstResponder()
        } else if self.activeTextField == vehicleModelLabel {
            self.vehicleYearLabel.becomeFirstResponder()
        } else if self.activeTextField == vehicleYearLabel {
            self.vehicleLicenseLabel.becomeFirstResponder()
        } else if self.activeTextField == vehicleLicenseLabel {
            self.makeLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
            self.modelLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
            self.yearLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
            self.licenseLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
            self.makeLine.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
            self.modelLine.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
            self.yearLine.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
            self.licenseLine.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
            self.view.endEditing(true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        self.delegate?.changePercentage(translation: translation)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.contentOffset.y
        if translation < 30 {
            UIView.animate(withDuration: 0.2) {
                scrollView.contentOffset.y = 0
            }
        } else if translation >= 30 && translation <= 50 {
            UIView.animate(withDuration: 0.2) {
                scrollView.contentOffset.y = 50
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.makeLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        self.modelLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        self.yearLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        self.licenseLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        self.makeLine.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        self.modelLine.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        self.yearLine.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        self.licenseLine.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        self.view.endEditing(true)
        scrollView.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
        self.makeLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        self.modelLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        self.yearLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        self.licenseLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        self.makeLine.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        self.modelLine.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        self.yearLine.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        self.licenseLine.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        if textField == vehicleYearLabel {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: self.view.frame.height * 0.2), animated: true)
            self.yearLabel.textColor = Theme.SEA_BLUE
            self.yearLine.backgroundColor = Theme.SEA_BLUE
        } else if textField == vehicleLicenseLabel {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: self.view.frame.height * 0.3), animated: true)
            self.licenseLabel.textColor = Theme.SEA_BLUE
            self.licenseLine.backgroundColor = Theme.SEA_BLUE
        } else if textField == vehicleModelLabel {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: self.view.frame.height * 0.1), animated: true)
            self.modelLabel.textColor = Theme.SEA_BLUE
            self.modelLine.backgroundColor = Theme.SEA_BLUE
        } else if textField == vehicleMakeLabel {
            self.makeLabel.textColor = Theme.SEA_BLUE
            self.makeLine.backgroundColor = Theme.SEA_BLUE
        }
    }

}