//
//  LocationParkingViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 10/24/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import MapKit

let handleTextChangeNotification = "handleTextChangeNotification"

protocol handleChangingAddress {
    func handleStreetAddress(text: String)
    func handleCityAddress(text: String)
    func handleStateAddress(text: String)
    func handleZipAddress(text: String)
    func handleCountryAddress(text: String)
    func dismissKeyboard()
}

class LocationParkingViewController: UIViewController, handleChangingAddress {
    
    var newHostAddress: String?
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        
        return view
    }()
    
    var countryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE.withAlphaComponent(0.8)
        label.text = "Country/Region"
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var countryField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "United States"
        view.font = Fonts.SSPLightH3
        view.tintColor = Theme.SEA_BLUE
        view.textColor = Theme.WHITE
        view.clearButtonMode = .whileEditing
        
        return view
    }()
    
    var countryLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var streetLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE.withAlphaComponent(0.8)
        label.text = "Street Address"
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var streetField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "123 Kennedy Ave."
        view.font = Fonts.SSPLightH3
        view.tintColor = Theme.SEA_BLUE
        view.textColor = Theme.WHITE.withAlphaComponent(0.4)
        view.returnKeyType = .done
        view.clearButtonMode = .whileEditing
        view.addTarget(self, action: #selector(hideOtherOptions(sender:)), for: .editingDidBegin)
        
        return view
    }()
    
    var streetLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE.withAlphaComponent(0.8)
        label.text = "City"
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var cityField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Philadelphia"
        view.font = Fonts.SSPLightH3
        view.tintColor = Theme.SEA_BLUE
        view.textColor = Theme.WHITE.withAlphaComponent(0.4)
        view.clearButtonMode = .whileEditing
        view.addTarget(self, action: #selector(hideOtherOptions(sender:)), for: .editingDidBegin)
        
        return view
    }()
    
    var cityLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var stateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE.withAlphaComponent(0.8)
        label.text = "State"
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var stateField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Pennsylvania"
        view.font = Fonts.SSPLightH3
        view.tintColor = Theme.SEA_BLUE
        view.textColor = Theme.WHITE.withAlphaComponent(0.4)
        view.clearButtonMode = .whileEditing
        view.addTarget(self, action: #selector(hideOtherOptions(sender:)), for: .editingDidBegin)
        
        return view
    }()
    
    var stateLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var zipLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE.withAlphaComponent(0.8)
        label.text = "Zipcode (optional)"
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var zipField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = ""
        view.font = Fonts.SSPLightH3
        view.tintColor = Theme.SEA_BLUE
        view.textColor = Theme.WHITE.withAlphaComponent(0.4)
        view.clearButtonMode = .whileEditing
        view.addTarget(self, action: #selector(hideOtherOptions(sender:)), for: .editingDidBegin)
        
        return view
    }()
    
    var zipLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    lazy var locationsSearchResults: LocationSearchTableViewController = {
        let controller = LocationSearchTableViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
        controller.delegate = self
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryField.delegate = self
        streetField.delegate = self
        cityField.delegate = self
        stateField.delegate = self
        zipField.delegate = self
        
        streetField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        setupViews()
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: handleTextChangeNotification), object: nil, userInfo: ["text":textField.text!])
    }
    
    var streetTypingAnchor: NSLayoutConstraint!
    var streetNotAnchor: NSLayoutConstraint!
    var cityTypingAnchor: NSLayoutConstraint!
    var cityNotAnchor: NSLayoutConstraint!
    var stateTypingAnchor: NSLayoutConstraint!
    var stateNotAnchor: NSLayoutConstraint!
    var zipTypingAnchor: NSLayoutConstraint!
    var zipNotAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        scrollView.addGestureRecognizer(gesture)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 750)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -5).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(countryLabel)
        countryLabel.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        countryLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        countryLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        countryLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(countryField)
        countryField.topAnchor.constraint(equalTo: countryLabel.bottomAnchor, constant: 10).isActive = true
        countryField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        countryField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        countryField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(countryLine)
        countryLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        countryLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        countryLine.topAnchor.constraint(equalTo: countryField.bottomAnchor, constant: 10).isActive = true
        countryLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(streetLabel)
        streetLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        streetLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        streetLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        streetNotAnchor = streetLabel.topAnchor.constraint(equalTo: countryLine.topAnchor, constant: 20)
            streetNotAnchor.isActive = true
        streetTypingAnchor = streetLabel.topAnchor.constraint(equalTo: scrollView.topAnchor)
            streetTypingAnchor.isActive = false
        
        scrollView.addSubview(streetField)
        streetField.topAnchor.constraint(equalTo: streetLabel.bottomAnchor, constant: 10).isActive = true
        streetField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        streetField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        streetField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(streetLine)
        streetLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        streetLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        streetLine.topAnchor.constraint(equalTo: streetField.bottomAnchor, constant: 10).isActive = true
        streetLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(cityLabel)
        cityLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        cityLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        cityLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        cityNotAnchor = cityLabel.topAnchor.constraint(equalTo: streetLine.topAnchor, constant: 20)
            cityNotAnchor.isActive = true
        cityTypingAnchor = cityLabel.topAnchor.constraint(equalTo: scrollView.topAnchor)
            cityTypingAnchor.isActive = false
        
        scrollView.addSubview(cityField)
        cityField.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 10).isActive = true
        cityField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        cityField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        cityField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(cityLine)
        cityLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        cityLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        cityLine.topAnchor.constraint(equalTo: cityField.bottomAnchor, constant: 10).isActive = true
        cityLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(stateLabel)
        stateLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        stateLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        stateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        stateNotAnchor = stateLabel.topAnchor.constraint(equalTo: cityLine.topAnchor, constant: 20)
            stateNotAnchor.isActive = true
        stateTypingAnchor = stateLabel.topAnchor.constraint(equalTo: scrollView.topAnchor)
            stateTypingAnchor.isActive = false
        
        scrollView.addSubview(stateField)
        stateField.topAnchor.constraint(equalTo: stateLabel.bottomAnchor, constant: 10).isActive = true
        stateField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        stateField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        stateField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(stateLine)
        stateLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stateLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        stateLine.topAnchor.constraint(equalTo: stateField.bottomAnchor, constant: 10).isActive = true
        stateLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(zipLabel)
        zipLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        zipLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        zipLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        zipNotAnchor = zipLabel.topAnchor.constraint(equalTo: stateLine.topAnchor, constant: 20)
            zipNotAnchor.isActive = true
        zipTypingAnchor = zipLabel.topAnchor.constraint(equalTo: scrollView.topAnchor)
            zipTypingAnchor.isActive = false
        
        scrollView.addSubview(zipField)
        zipField.topAnchor.constraint(equalTo: zipLabel.bottomAnchor, constant: 10).isActive = true
        zipField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        zipField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        zipField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(zipLine)
        zipLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        zipLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        zipLine.topAnchor.constraint(equalTo: zipField.bottomAnchor, constant: 10).isActive = true
        zipLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        self.view.addSubview(locationsSearchResults.view)
        locationsSearchResults.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        locationsSearchResults.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        locationsSearchResults.view.topAnchor.constraint(equalTo: streetLine.bottomAnchor).isActive = true
        locationsSearchResults.view.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        createToolbar()
    }
    
    @objc func hideOtherOptions(sender: UITextField) {
        if sender == streetField {
            UIView.animate(withDuration: animationIn) {
                self.countryLabel.alpha = 0
                self.countryField.alpha = 0
                self.countryLine.alpha = 0
                self.cityLabel.alpha = 0
                self.cityField.alpha = 0
                self.cityLine.alpha = 0
                self.stateLabel.alpha = 0
                self.stateField.alpha = 0
                self.stateLine.alpha = 0
                self.zipLabel.alpha = 0
                self.zipField.alpha = 0
                self.zipLine.alpha = 0
                self.streetNotAnchor.isActive = false
                self.streetTypingAnchor.isActive = true
                self.view.layoutIfNeeded()
            }
        } else if sender == cityField {
            UIView.animate(withDuration: animationIn) {
                self.countryLabel.alpha = 0
                self.countryField.alpha = 0
                self.countryLine.alpha = 0
                self.streetLabel.alpha = 0
                self.streetField.alpha = 0
                self.streetLine.alpha = 0
                self.stateLabel.alpha = 0
                self.stateField.alpha = 0
                self.stateLine.alpha = 0
                self.zipLabel.alpha = 0
                self.zipField.alpha = 0
                self.zipLine.alpha = 0
                self.cityNotAnchor.isActive = false
                self.cityTypingAnchor.isActive = true
                self.view.layoutIfNeeded()
            }
        } else if sender == stateField {
            UIView.animate(withDuration: animationIn) {
                self.countryLabel.alpha = 0
                self.countryField.alpha = 0
                self.countryLine.alpha = 0
                self.streetLabel.alpha = 0
                self.streetField.alpha = 0
                self.streetLine.alpha = 0
                self.cityLabel.alpha = 0
                self.cityField.alpha = 0
                self.cityLine.alpha = 0
                self.zipLabel.alpha = 0
                self.zipField.alpha = 0
                self.zipLine.alpha = 0
                self.stateNotAnchor.isActive = false
                self.stateTypingAnchor.isActive = true
                self.view.layoutIfNeeded()
            }
        } else if sender == zipField {
            UIView.animate(withDuration: animationIn) {
                self.countryLabel.alpha = 0
                self.countryField.alpha = 0
                self.countryLine.alpha = 0
                self.streetLabel.alpha = 0
                self.streetField.alpha = 0
                self.streetLine.alpha = 0
                self.cityLabel.alpha = 0
                self.cityField.alpha = 0
                self.cityLine.alpha = 0
                self.stateLabel.alpha = 0
                self.stateField.alpha = 0
                self.stateLine.alpha = 0
                self.zipNotAnchor.isActive = false
                self.zipTypingAnchor.isActive = true
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func bringOtherOptions() {
        UIView.animate(withDuration: animationIn) {
            self.countryLabel.alpha = 1
            self.countryField.alpha = 1
            self.countryLine.alpha = 1
            self.streetLabel.alpha = 1
            self.streetField.alpha = 1
            self.streetLine.alpha = 1
            self.cityLabel.alpha = 1
            self.cityField.alpha = 1
            self.cityLine.alpha = 1
            self.stateLabel.alpha = 1
            self.stateField.alpha = 1
            self.stateLine.alpha = 1
            self.stateLabel.alpha = 1
            self.stateField.alpha = 1
            self.stateLine.alpha = 1
            self.zipLabel.alpha = 1
            self.zipField.alpha = 1
            self.zipLine.alpha = 1
            self.locationsSearchResults.view.alpha = 0
            if self.streetTypingAnchor != nil {
                self.streetNotAnchor.isActive = true
                self.streetTypingAnchor.isActive = false
                self.cityNotAnchor.isActive = true
                self.cityTypingAnchor.isActive = false
                self.stateNotAnchor.isActive = true
                self.stateTypingAnchor.isActive = false
                self.zipNotAnchor.isActive = true
                self.zipTypingAnchor.isActive = false
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = Theme.WHITE
        toolBar.tintColor = Theme.BLUE
        toolBar.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.4).cgColor
        toolBar.layer.borderWidth = 0.5
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        doneButton.setTitleTextAttributes([ NSAttributedString.Key.font: Fonts.SSPSemiBoldH4], for: UIControl.State.normal)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        countryField.inputAccessoryView = toolBar
        streetField.inputAccessoryView = toolBar
        cityField.inputAccessoryView = toolBar
        stateField.inputAccessoryView = toolBar
        zipField.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
        self.bringOtherOptions()
    }

    @objc func scrollViewTapped() {
        self.view.endEditing(true)
        self.bringOtherOptions()
    }

}


extension LocationParkingViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == countryField {
            if textField.text == "United States" {
                textField.text = ""
            }
        } else if textField == streetField {
            if textField.text == "123 Kennedy Ave." {
                textField.text = ""
                textField.textColor = Theme.WHITE
            }
        } else if textField == cityField {
            if textField.text == "Philadelphia" {
                textField.text = ""
                textField.textColor = Theme.WHITE
            }
        } else if textField == stateField {
            if textField.text == "Pennsylvania" {
                textField.text = ""
                textField.textColor = Theme.WHITE
            }
        } else if textField == zipField {
            if textField.text == "19146" {
                textField.text = ""
                textField.textColor = Theme.WHITE
            }
        }
        self.scrollView.contentOffset = CGPoint.zero
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == countryField {
            if textField.text == "" {
                textField.text = "United States"
            }
        } else if textField == streetField {
            if textField.text == "" {
                textField.text = "123 Kennedy Ave."
                textField.textColor = Theme.WHITE.withAlphaComponent(0.4)
            }
        } else if textField == cityField {
            if textField.text == "" {
                textField.text = "Philadelphia"
                textField.textColor = Theme.WHITE.withAlphaComponent(0.4)
            }
        } else if textField == stateField {
            if textField.text == "" {
                textField.text = "Pennsylvania"
                textField.textColor = Theme.WHITE.withAlphaComponent(0.4)
            }
        } else if textField == zipField {
            if textField.text == "" {
                textField.text = ""
                textField.textColor = Theme.WHITE.withAlphaComponent(0.4)
            }
        }
    }
    
    func handleStreetAddress(text: String) {
        self.streetField.text = text
        self.streetField.textColor = Theme.WHITE
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.combineAddress()
        }
    }
    
    func handleCityAddress(text: String) {
        self.cityField.text = text
        self.cityField.textColor = Theme.WHITE
    }
    
    func handleStateAddress(text: String) {
        self.stateField.text = text
        self.stateField.textColor = Theme.WHITE
    }
    
    func handleZipAddress(text: String) {
        self.zipField.text = text
        self.zipField.textColor = Theme.WHITE
    }
    
    func handleCountryAddress(text: String) {
        self.countryField.text = text
        self.countryField.textColor = Theme.WHITE
    }
    
    func combineAddress() {
        guard let street = streetField.text, let city = cityField.text, let state = stateField.text, let country = countryField.text else { return }
        if zipField.textColor != Theme.WHITE {
            self.newHostAddress = "\(street), \(city), \(state), \(country)"
        } else {
            guard let zip = zipField.text else { return }
            self.newHostAddress = "\(street), \(city), \(state) \(zip), \(country)"
        }
    }

}



