//
//  LocationFieldsView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/25/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

let handleTextChangeNotification = "handleTextChangeNotification"

protocol handleChangingAddress {
    func handleStreetAddress(text: String)
    func handleCityAddress(text: String)
    func handleStateAddress(text: String)
    func handleZipAddress(text: String)
    func handleCountryAddress(text: String)
    func dismissKeyboard()
}

var locationsSearchResults: LocationSearchResults = {
    let controller = LocationSearchResults()
    controller.view.translatesAutoresizingMaskIntoConstraints = false
    controller.view.alpha = 0
    
    return controller
}()

class LocationFieldsView: UIViewController {
    
    var delegate: HostLocationView?
    var newHostAddress: String?
    
    var streetLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.PRUSSIAN_BLUE
        label.text = "Street Address"
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var streetField: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = Fonts.SSPRegularH2
        view.backgroundColor = Theme.OFF_WHITE
        view.tintColor = Theme.BLUE
        view.textColor = Theme.DARK_GRAY
        view.returnKeyType = .done
        view.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 4, right: 8)
        view.keyboardAppearance = .dark
        view.autocapitalizationType = .words
        view.isScrollEnabled = false
        
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
        label.textColor = Theme.PRUSSIAN_BLUE
        label.text = "City"
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var cityField: LineInputAccessoryView = {
        let view = LineInputAccessoryView()
        view.textViewFont = Fonts.SSPRegularH2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.lineUnselectedColor = lineColor
        view.backgroundUnselectedColor = Theme.OFF_WHITE
        view.lineTextView?.tintColor = Theme.BLUE
        view.backgroundColor = Theme.OFF_WHITE
        view.textViewKeyboardType = .default
        view.lineTextView?.keyboardAppearance = .dark
        view.lineTextView?.autocapitalizationType = .words
        view.lineTextView?.placeholderLabel.alpha = 0
        
        return view
    }()
    
    var stateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.PRUSSIAN_BLUE
        label.text = "State"
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var stateField: LineInputAccessoryView = {
        let view = LineInputAccessoryView()
        view.textViewFont = Fonts.SSPRegularH2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.lineUnselectedColor = lineColor
        view.backgroundUnselectedColor = Theme.OFF_WHITE
        view.lineTextView?.tintColor = Theme.BLUE
        view.backgroundColor = Theme.OFF_WHITE
        view.textViewKeyboardType = .default
        view.lineTextView?.keyboardAppearance = .dark
        view.lineTextView?.autocapitalizationType = .words
        view.lineTextView?.placeholderLabel.alpha = 0
        
        return view
    }()
    
    var zipLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.PRUSSIAN_BLUE
        label.text = "Zipcode"
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var zipField: LineInputAccessoryView = {
        let view = LineInputAccessoryView()
        view.textViewFont = Fonts.SSPRegularH2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.lineUnselectedColor = lineColor
        view.backgroundUnselectedColor = Theme.OFF_WHITE
        view.lineTextView?.tintColor = Theme.BLUE
        view.backgroundColor = Theme.OFF_WHITE
        view.textViewKeyboardType = .numberPad
        view.lineTextView?.keyboardAppearance = .dark
        view.lineTextView?.placeholderLabel.alpha = 0
        
        return view
    }()
    
    var countryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.PRUSSIAN_BLUE
        label.text = "Country/Region"
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var countryField: LineInputAccessoryView = {
        let view = LineInputAccessoryView()
        view.textViewFont = Fonts.SSPRegularH2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.lineUnselectedColor = lineColor
        view.backgroundUnselectedColor = Theme.OFF_WHITE
        view.lineTextView?.tintColor = Theme.BLUE
        view.backgroundColor = Theme.OFF_WHITE
        view.textViewKeyboardType = .default
        view.lineTextView?.keyboardAppearance = .dark
        view.lineTextView?.autocapitalizationType = .words
        view.lineTextView?.placeholderLabel.alpha = 0
        
        return view
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.layer.cornerRadius = 4
        let origImage = UIImage(named: "exit")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(deletePressed), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        
        streetField.delegate = self
        countryField.lineTextView?.delegate = self
        cityField.lineTextView?.delegate = self
        stateField.lineTextView?.delegate = self
        zipField.lineTextView?.delegate = self
        locationsSearchResults.delegate = self

        setupStreet()
        setupCity()
        setupState()
        setupZip()
        setupCountry()
        
        createToolbar()
    }
    
    func setupStreet() {
        
        view.addSubview(streetLabel)
        view.addSubview(streetField)
        view.addSubview(streetLine)
        view.addSubview(deleteButton)
        
        streetLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        streetLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 32).isActive = true
        streetLabel.sizeToFit()
        
        streetField.topAnchor.constraint(equalTo: streetLabel.bottomAnchor, constant: 8).isActive = true
        streetField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        streetField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        streetField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        streetLine.anchor(top: nil, left: streetField.leftAnchor, bottom: streetField.bottomAnchor, right: streetField.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 2)
        
        deleteButton.rightAnchor.constraint(equalTo: streetField.rightAnchor, constant: -12).isActive = true
        deleteButton.centerYAnchor.constraint(equalTo: streetField.centerYAnchor).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        deleteButton.widthAnchor.constraint(equalTo: deleteButton.heightAnchor).isActive = true
        
    }
    
    func setupCity() {
        
        view.addSubview(cityLabel)
        view.addSubview(cityField)
        
        cityLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        cityLabel.topAnchor.constraint(equalTo: streetLine.topAnchor, constant: 20).isActive = true
        cityLabel.sizeToFit()
        
        cityField.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 8).isActive = true
        cityField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        cityField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        cityField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
    }
    
    func setupState() {
        
        view.addSubview(stateLabel)
        view.addSubview(stateField)
        
        stateLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        stateLabel.topAnchor.constraint(equalTo: cityField.bottomAnchor, constant: 20).isActive = true
        stateLabel.sizeToFit()
        
        stateField.topAnchor.constraint(equalTo: stateLabel.bottomAnchor, constant: 8).isActive = true
        stateField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        stateField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        stateField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
    }
    
    func setupZip() {
        
        view.addSubview(zipLabel)
        view.addSubview(zipField)
        
        zipLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        zipLabel.topAnchor.constraint(equalTo: stateField.bottomAnchor, constant: 20).isActive = true
        zipLabel.sizeToFit()
        
        zipField.topAnchor.constraint(equalTo: zipLabel.bottomAnchor, constant: 8).isActive = true
        zipField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        zipField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        zipField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
    }
    
    func setupCountry() {
        
        view.addSubview(countryLabel)
        view.addSubview(countryField)
        
        countryLabel.topAnchor.constraint(equalTo: zipField.bottomAnchor, constant: 20).isActive = true
        countryLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        countryLabel.sizeToFit()
        
        countryField.topAnchor.constraint(equalTo: countryLabel.bottomAnchor, constant: 8).isActive = true
        countryField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        countryField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        countryField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
    }

    func checkTextFields() -> Bool {
        var check = true
        if streetField.text == "" {
            streetLine.backgroundColor = Theme.HARMONY_RED
            streetField.backgroundColor = Theme.HARMONY_RED.withAlphaComponent(0.1)
            check = false
        }
        if cityField.lineTextView?.text == "" {
            cityField.lineSeparatorView.backgroundColor = Theme.HARMONY_RED
            cityField.backgroundColor = Theme.HARMONY_RED.withAlphaComponent(0.1)
            check = false
        }
        if stateField.lineTextView?.text == "" {
            stateField.lineSeparatorView.backgroundColor = Theme.HARMONY_RED
            stateField.backgroundColor = Theme.HARMONY_RED.withAlphaComponent(0.1)
            check = false
        }
        if zipField.lineTextView?.text == "" {
            zipField.lineSeparatorView.backgroundColor = Theme.HARMONY_RED
            zipField.backgroundColor = Theme.HARMONY_RED.withAlphaComponent(0.1)
            check = false
        }
        if countryField.lineTextView?.text == "" {
            countryField.lineSeparatorView.backgroundColor = Theme.HARMONY_RED
            countryField.backgroundColor = Theme.HARMONY_RED.withAlphaComponent(0.1)
            check = false
        }
        return check
    }
    
}

extension LocationFieldsView: UITextViewDelegate {
    
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = Theme.DARK_GRAY
        toolBar.tintColor = Theme.WHITE
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        doneButton.setTitleTextAttributes([ NSAttributedString.Key.font: Fonts.SSPSemiBoldH4], for: UIControl.State.normal)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        streetField.inputAccessoryView = toolBar
        cityField.lineTextView?.inputAccessoryView = toolBar
        stateField.lineTextView?.inputAccessoryView = toolBar
        zipField.lineTextView?.inputAccessoryView = toolBar
        countryField.lineTextView?.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        delegate?.changeScroll(view: UIView())
        self.view.endEditing(true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        locationsSearchResults.view.alpha = 0
        if textView == streetField {
            streetField.backgroundColor = Theme.BLUE.withAlphaComponent(0.1)
            streetLine.backgroundColor = Theme.BLUE
            delegate?.changeScroll(view: streetLabel)
        } else if textView == countryField.lineTextView {
            delegate?.changeScroll(view: countryLabel)
        } else if textView == cityField.lineTextView {
            delegate?.changeScroll(view: cityLabel)
        } else if textView == stateField.lineTextView {
            delegate?.changeScroll(view: stateLabel)
        } else if textView == zipField.lineTextView {
            delegate?.changeScroll(view: zipLabel)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == streetField {
            streetField.backgroundColor = Theme.OFF_WHITE
            streetLine.backgroundColor = lineColor
        }
        UIView.animate(withDuration: animationIn) {
            locationsSearchResults.view.alpha = 0
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == streetField {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: handleTextChangeNotification), object: nil, userInfo: ["text": textView.text!])
            if locationsSearchResults.view.alpha == 0 {
                UIView.animate(withDuration: animationIn) {
                    locationsSearchResults.view.alpha = 1
                }
            }
            if textView.text.last == "\n" {
                textView.text = textView.text.replacingOccurrences(of: "\n", with: "")
                dismissKeyboard()
            }
            if textView.text != "" {
                if deleteButton.alpha == 0 {
                    UIView.animate(withDuration: animationIn) {
                        self.deleteButton.alpha = 1
                    }
                }
            } else {
                if deleteButton.alpha == 1 {
                    UIView.animate(withDuration: animationIn) {
                        self.deleteButton.alpha = 0
                    }
                }
            }
        }
    }
    
    @objc func deletePressed() {
        streetField.text = nil
        deleteButton.alpha = 0
        streetField.becomeFirstResponder()
    }
    
}

extension LocationFieldsView: handleChangingAddress {
    
    func handleStreetAddress(text: String) {
        streetField.text = text
    }
    
    func handleCityAddress(text: String) {
        cityField.textViewText = text
    }
    
    func handleStateAddress(text: String) {
        stateField.textViewText = text
    }
    
    func handleZipAddress(text: String) {
        zipField.textViewText = text
    }
    
    func handleCountryAddress(text: String) {
        countryField.textViewText = text
        dismissKeyboard()
    }
    
    func combineAddress() -> String {
        guard let street = streetField.text, let city = cityField.lineTextView?.text, let state = stateField.lineTextView?.text, let zip = zipField.lineTextView?.text, let country = countryField.lineTextView?.text else { return "" }
        let address = "\(street), \(city), \(state) \(zip), \(country)"
        newHostAddress = address
        return address
    }
    
}
