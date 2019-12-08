//
//  LocationParkingViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 10/24/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import MapKit

class LocationParkingViewController: UIViewController, handleChangingAddress {
    
    var delegate: handleConfigureProcess?
    var newHostAddress: String?
    var goodToGo: Bool = false
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        
        return view
    }()
    
    var countryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.text = "Country/Region"
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var countryField: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = Fonts.SSPRegularH3
        view.tintColor = Theme.SEA_BLUE
        view.textColor = Theme.DARK_GRAY
        view.keyboardAppearance = .dark
        view.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        view.text = "USA"
        view.autocapitalizationType = .words
        
        return view
    }()
    
    var countryLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
        return view
    }()
    
    var streetLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.text = "Street Address"
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var streetField: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = Fonts.SSPRegularH3
        view.tintColor = Theme.PACIFIC_BLUE
        view.textColor = Theme.DARK_GRAY
        view.returnKeyType = .done
        view.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        view.keyboardAppearance = .dark
        view.autocapitalizationType = .words
        
        return view
    }()
    
    var streetLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
        return view
    }()
    
    var cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.text = "City"
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var cityField: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = Fonts.SSPRegularH3
        view.tintColor = Theme.PACIFIC_BLUE
        view.textColor = Theme.DARK_GRAY
        view.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        view.keyboardAppearance = .dark
        view.autocapitalizationType = .words
        
        return view
    }()
    
    var cityLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
        return view
    }()
    
    var stateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.text = "State"
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var stateField: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = Fonts.SSPRegularH3
        view.tintColor = Theme.PACIFIC_BLUE
        view.textColor = Theme.DARK_GRAY
        view.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        view.keyboardAppearance = .dark
        view.autocapitalizationType = .words
        
        return view
    }()
    
    var stateLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
        return view
    }()
    
    var zipLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.text = "Zipcode"
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var zipField: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = Fonts.SSPRegularH3
        view.tintColor = Theme.PACIFIC_BLUE
        view.textColor = Theme.DARK_GRAY
        view.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        view.keyboardAppearance = .dark
        view.keyboardType = .numberPad
        view.autocapitalizationType = .words
        
        return view
    }()
    
    var zipLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
        return view
    }()
    
    lazy var searchContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        view.alpha = 0
        
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
        
        setupViews()
        setupStreet()
        setupCity()
        setupState()
        setupZip()
        setupSearch()
    }
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        scrollView.addGestureRecognizer(gesture)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 750)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(countryLabel)
        countryLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16).isActive = true
        countryLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        countryLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        countryLabel.sizeToFit()
        
        scrollView.addSubview(countryField)
        countryField.topAnchor.constraint(equalTo: countryLabel.bottomAnchor, constant: 8).isActive = true
        countryField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        countryField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        countryField.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        scrollView.addSubview(countryLine)
        countryLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        countryLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -48).isActive = true
        countryLine.topAnchor.constraint(equalTo: countryField.bottomAnchor).isActive = true
        countryLine.heightAnchor.constraint(equalToConstant: 2).isActive = true

    }
    
    func setupStreet() {
        
        scrollView.addSubview(streetLabel)
        streetLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        streetLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        streetLabel.topAnchor.constraint(equalTo: countryLine.topAnchor, constant: 24).isActive = true
        streetLabel.sizeToFit()
        
        scrollView.addSubview(streetField)
        streetField.topAnchor.constraint(equalTo: streetLabel.bottomAnchor, constant: 8).isActive = true
        streetField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        streetField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        streetField.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        scrollView.addSubview(streetLine)
        streetLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        streetLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -48).isActive = true
        streetLine.topAnchor.constraint(equalTo: streetField.bottomAnchor).isActive = true
        streetLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
    }
    
    func setupCity() {
        
        scrollView.addSubview(cityLabel)
        cityLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        cityLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        cityLabel.topAnchor.constraint(equalTo: streetLine.topAnchor, constant: 24).isActive = true
        cityLabel.sizeToFit()
        
        scrollView.addSubview(cityField)
        cityField.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 8).isActive = true
        cityField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        cityField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        cityField.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        scrollView.addSubview(cityLine)
        cityLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        cityLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -48).isActive = true
        cityLine.topAnchor.constraint(equalTo: cityField.bottomAnchor).isActive = true
        cityLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
    }
    
    func setupState() {
        
        scrollView.addSubview(stateLabel)
        stateLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        stateLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        stateLabel.topAnchor.constraint(equalTo: cityLine.topAnchor, constant: 24).isActive = true
        stateLabel.sizeToFit()
        
        scrollView.addSubview(stateField)
        stateField.topAnchor.constraint(equalTo: stateLabel.bottomAnchor, constant: 8).isActive = true
        stateField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        stateField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        stateField.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        scrollView.addSubview(stateLine)
        stateLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stateLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -48).isActive = true
        stateLine.topAnchor.constraint(equalTo: stateField.bottomAnchor).isActive = true
        stateLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
    }
    
    func setupZip() {
        
        scrollView.addSubview(zipLabel)
        zipLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        zipLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        zipLabel.topAnchor.constraint(equalTo: stateLine.topAnchor, constant: 24).isActive = true
        zipLabel.sizeToFit()
        
        scrollView.addSubview(zipField)
        zipField.topAnchor.constraint(equalTo: zipLabel.bottomAnchor, constant: 8).isActive = true
        zipField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        zipField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        zipField.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        scrollView.addSubview(zipLine)
        zipLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        zipLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -48).isActive = true
        zipLine.topAnchor.constraint(equalTo: zipField.bottomAnchor).isActive = true
        zipLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
    }
    
    func setupSearch() {
        
        self.view.addSubview(searchContainer)
        searchContainer.leftAnchor.constraint(equalTo: streetLine.leftAnchor).isActive = true
        searchContainer.rightAnchor.constraint(equalTo: streetLine.rightAnchor).isActive = true
        searchContainer.topAnchor.constraint(equalTo: streetLine.bottomAnchor).isActive = true
        searchContainer.heightAnchor.constraint(equalToConstant: 199).isActive = true
        
        searchContainer.addSubview(locationsSearchResults.view)
        locationsSearchResults.view.topAnchor.constraint(equalTo: searchContainer.topAnchor).isActive = true
        locationsSearchResults.view.leftAnchor.constraint(equalTo: searchContainer.leftAnchor).isActive = true
        locationsSearchResults.view.rightAnchor.constraint(equalTo: searchContainer.rightAnchor).isActive = true
        locationsSearchResults.view.bottomAnchor.constraint(equalTo: searchContainer.bottomAnchor).isActive = true
        
        createToolbar()
        
    }
    
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = Theme.DARK_GRAY
        toolBar.tintColor = Theme.WHITE
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
    }

    @objc func scrollViewTapped() {
        self.view.endEditing(true)
    }
    
    func checkIfGood() -> Bool {
        if self.streetField.text == "" {
            self.streetLabel.textColor = Theme.HARMONY_RED
            self.streetLine.backgroundColor = Theme.HARMONY_RED
            return false
        }
        if self.cityField.text == "" {
            self.cityLabel.textColor = Theme.HARMONY_RED
            self.cityLine.backgroundColor = Theme.HARMONY_RED
            return false
        }
        if self.stateField.text == "" {
            self.stateLabel.textColor = Theme.HARMONY_RED
            self.stateLine.backgroundColor = Theme.HARMONY_RED
            return false
        }
        if self.countryField.text == "" {
            self.countryLabel.textColor = Theme.HARMONY_RED
            self.countryLine.backgroundColor = Theme.HARMONY_RED
            return false
        }
        if self.zipField.text == "" {
            self.zipLabel.textColor = Theme.HARMONY_RED
            self.zipLine.backgroundColor = Theme.HARMONY_RED
            return false
        }
        self.combineAddress()
        return true
    }

}


extension LocationParkingViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == self.streetField {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: handleTextChangeNotification), object: nil, userInfo: ["text": textView.text!])
            if self.searchContainer.alpha == 0 {
                UIView.animate(withDuration: animationIn) {
                    self.searchContainer.alpha = 1
                }
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.locationsSearchResults.view.alpha = 0
        self.searchContainer.alpha = 0
        if textView == self.countryField {
            self.countryLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
            self.countryField.backgroundColor = Theme.BLUE.withAlphaComponent(0.1)
            self.countryLine.backgroundColor = Theme.BLUE
            self.scrollView.scrollToView(view: countryLabel, animated: true, offset: 16)
        } else if textView == self.streetField {
            self.streetLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
            self.streetField.backgroundColor = Theme.BLUE.withAlphaComponent(0.1)
            self.streetLine.backgroundColor = Theme.BLUE
            self.scrollView.scrollToView(view: streetLabel, animated: true, offset: 16)
        } else if textView == self.cityField {
            self.cityLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
            self.cityField.backgroundColor = Theme.BLUE.withAlphaComponent(0.1)
            self.cityLine.backgroundColor = Theme.BLUE
            self.scrollView.scrollToView(view: cityLabel, animated: true, offset: 16)
        } else if textView == self.stateField {
            self.stateLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
            self.stateField.backgroundColor = Theme.BLUE.withAlphaComponent(0.1)
            self.stateLine.backgroundColor = Theme.BLUE
            self.scrollView.scrollToView(view: stateLabel, animated: true, offset: 16)
        } else if textView == self.zipField {
            self.zipLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
            self.zipField.backgroundColor = Theme.BLUE.withAlphaComponent(0.1)
            self.zipLine.backgroundColor = Theme.BLUE
            self.scrollView.scrollToView(view: zipLabel, animated: true, offset: 16)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.locationsSearchResults.view.alpha = 0
        self.searchContainer.alpha = 0
        if textView == self.countryField {
            self.countryField.backgroundColor = UIColor.clear
            self.countryLine.backgroundColor = lineColor
        } else if textView == self.streetField {
            self.streetField.backgroundColor = UIColor.clear
            self.streetLine.backgroundColor = lineColor
        } else if textView == self.cityField {
            self.cityField.backgroundColor = UIColor.clear
            self.cityLine.backgroundColor = lineColor
        } else if textView == self.stateField {
            self.stateField.backgroundColor = UIColor.clear
            self.stateLine.backgroundColor = lineColor
        } else if textView == self.zipField {
            self.zipField.backgroundColor = UIColor.clear
            self.zipLine.backgroundColor = lineColor
        }
    }
    
    func handleStreetAddress(text: String) {
        self.streetField.text = text
    }
    
    func handleCityAddress(text: String) {
        self.cityField.text = text
    }
    
    func handleStateAddress(text: String) {
        self.stateField.text = text
    }
    
    func handleZipAddress(text: String) {
        self.zipField.text = text
    }
    
    func handleCountryAddress(text: String) {
        self.countryField.text = text
        self.scrollView.setContentOffset(.zero, animated: true)
    }
    
    func combineAddress() {
        guard let street = streetField.text, let city = cityField.text, let state = stateField.text, let zip = zipField.text, let country = countryField.text else { return }
        self.newHostAddress = "\(street), \(city), \(state) \(zip), \(country)"
    }

}



