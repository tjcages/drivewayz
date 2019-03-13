//
//  SpotNumberViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 10/23/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class SpotNumberViewController: UIViewController {
    
    var numberOfSpots: Int = 1 {
        didSet {
            self.resetNumbers()
        }
    }
    var numbers = [1]
    var selectedDay: String?
    
    var numberInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE.withAlphaComponent(0.8)
        label.text = "Number of spots"
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var numberField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "1"
        view.textColor = Theme.WHITE
        view.font = Fonts.SSPLightH3
        view.tintColor = .clear
        view.addTarget(self, action: #selector(hideOtherOptions(sender:)), for: .editingDidBegin)
        
        return view
    }()
    
    var numberLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var spotNumberInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE.withAlphaComponent(0.8)
        label.text = "Does the spot have a number?"
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var spotNumberCheckmark: UIButton = {
        let image = UIImage(named: "Checkmark")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(tintedImage, for: .normal)
        button.tintColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.4).cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = Theme.OFF_WHITE
        button.addTarget(self, action: #selector(checkmarkPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var spotNumberField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "• • • •"
        view.font = Fonts.SSPLightH3
        view.textColor = Theme.WHITE
        view.tintColor = Theme.SEA_BLUE
        view.keyboardType = .numberPad
        view.addTarget(self, action: #selector(hideOtherOptions(sender:)), for: .editingDidBegin)
        
        return view
    }()
    
    var spotNumberLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var gateCodeInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE.withAlphaComponent(0.8)
        label.text = "Gate code?"
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var gateCodeCheckmark: UIButton = {
        let image = UIImage(named: "Checkmark")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(tintedImage, for: .normal)
        button.tintColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.4).cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = Theme.OFF_WHITE
        button.addTarget(self, action: #selector(checkmarkPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var gateCodeField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "• • • •"
        view.font = Fonts.SSPLightH3
        view.textColor = Theme.WHITE
        view.tintColor = Theme.SEA_BLUE
        view.keyboardType = .numberPad
        view.addTarget(self, action: #selector(hideOtherOptions(sender:)), for: .editingDidBegin)
        
        return view
    }()
    
    var gateCodeLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        
        numberField.delegate = self
        spotNumberField.delegate = self
        gateCodeField.delegate = self
        
        setupViews()
    }
    
    var spotNumberTypingAnchor: NSLayoutConstraint!
    var spotNumberNotAnchor: NSLayoutConstraint!
    var gateCodeTypingAnchor: NSLayoutConstraint!
    var gateCodeNotAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(numberInformation)
        numberInformation.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        numberInformation.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        numberInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        numberInformation.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(numberField)
        numberField.topAnchor.constraint(equalTo: numberInformation.bottomAnchor).isActive = true
        numberField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        numberField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        numberField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(numberLine)
        numberLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        numberLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        numberLine.topAnchor.constraint(equalTo: numberField.bottomAnchor, constant: 10).isActive = true
        numberLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        self.view.addSubview(spotNumberInformation)
        spotNumberInformation.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        spotNumberInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        spotNumberInformation.heightAnchor.constraint(equalToConstant: 20).isActive = true
        spotNumberNotAnchor = spotNumberInformation.topAnchor.constraint(equalTo: numberLine.bottomAnchor, constant: 30)
            spotNumberNotAnchor.isActive = true
        spotNumberTypingAnchor = spotNumberInformation.topAnchor.constraint(equalTo: numberInformation.topAnchor)
            spotNumberTypingAnchor.isActive = false
        
        self.view.addSubview(spotNumberCheckmark)
        spotNumberCheckmark.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        spotNumberCheckmark.centerYAnchor.constraint(equalTo: spotNumberInformation.centerYAnchor).isActive = true
        spotNumberCheckmark.widthAnchor.constraint(equalToConstant: 30).isActive = true
        spotNumberCheckmark.heightAnchor.constraint(equalTo: spotNumberCheckmark.widthAnchor).isActive = true
        
        self.view.addSubview(spotNumberField)
        spotNumberField.topAnchor.constraint(equalTo: spotNumberInformation.bottomAnchor).isActive = true
        spotNumberField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        spotNumberField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        spotNumberField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(spotNumberLine)
        spotNumberLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        spotNumberLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        spotNumberLine.topAnchor.constraint(equalTo: spotNumberInformation.bottomAnchor, constant: 50).isActive = true
        spotNumberLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        self.view.addSubview(gateCodeInformation)
        gateCodeInformation.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        gateCodeInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        gateCodeInformation.heightAnchor.constraint(equalToConstant: 20).isActive = true
        gateCodeNotAnchor = gateCodeInformation.topAnchor.constraint(equalTo: spotNumberLine.bottomAnchor, constant: 30)
            gateCodeNotAnchor.isActive = true
        gateCodeTypingAnchor = gateCodeInformation.topAnchor.constraint(equalTo: numberInformation.topAnchor)
            gateCodeTypingAnchor.isActive = false
        
        self.view.addSubview(gateCodeCheckmark)
        gateCodeCheckmark.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        gateCodeCheckmark.centerYAnchor.constraint(equalTo: gateCodeInformation.centerYAnchor).isActive = true
        gateCodeCheckmark.widthAnchor.constraint(equalToConstant: 30).isActive = true
        gateCodeCheckmark.heightAnchor.constraint(equalTo: gateCodeCheckmark.widthAnchor).isActive = true
        
        self.view.addSubview(gateCodeField)
        gateCodeField.topAnchor.constraint(equalTo: gateCodeInformation.bottomAnchor).isActive = true
        gateCodeField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        gateCodeField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        gateCodeField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(gateCodeLine)
        gateCodeLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        gateCodeLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        gateCodeLine.topAnchor.constraint(equalTo: gateCodeInformation.bottomAnchor, constant: 50).isActive = true
        gateCodeLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    
        createNumberPicker()
    }
    
    @objc func checkmarkPressed(sender: UIButton) {
        if sender == spotNumberCheckmark {
            self.spotNumberField.becomeFirstResponder()
        } else if sender == gateCodeCheckmark {
            self.gateCodeField.becomeFirstResponder()
        }
    }
    
    func checkmarkPressed(bool: Bool, sender: UIButton) {
        if bool == true {
            UIView.animate(withDuration: 0.1, animations: {
                sender.tintColor = Theme.WHITE
                sender.backgroundColor = Theme.GREEN_PIGMENT
                sender.layer.borderColor = Theme.GREEN_PIGMENT.cgColor
            }) { (success) in
            }
        } else {
            UIView.animate(withDuration: 0.1, animations: {
                sender.tintColor = .clear
                sender.backgroundColor = Theme.OFF_WHITE
                sender.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.4).cgColor
            }) { (success) in
            }
        }
    }
    
    @objc func hideOtherOptions(sender: UITextField) {
        if sender == numberField {
            UIView.animate(withDuration: animationIn) {
                self.spotNumberInformation.alpha = 0
                self.spotNumberField.alpha = 0
                self.spotNumberCheckmark.alpha = 0
                self.spotNumberLine.alpha = 0
                self.gateCodeInformation.alpha = 0
                self.gateCodeField.alpha = 0
                self.gateCodeCheckmark.alpha = 0
                self.gateCodeLine.alpha = 0
            }
        } else if sender == spotNumberField {
            UIView.animate(withDuration: animationIn) {
                self.numberInformation.alpha = 0
                self.numberField.alpha = 0
                self.numberLine.alpha = 0
                self.gateCodeField.alpha = 0
                self.gateCodeInformation.alpha = 0
                self.gateCodeCheckmark.alpha = 0
                self.gateCodeLine.alpha = 0
                self.spotNumberNotAnchor.isActive = false
                self.spotNumberTypingAnchor.isActive = true
                self.view.layoutIfNeeded()
            }
        } else if sender == gateCodeField {
            UIView.animate(withDuration: animationIn) {
                self.spotNumberInformation.alpha = 0
                self.spotNumberField.alpha = 0
                self.spotNumberCheckmark.alpha = 0
                self.spotNumberLine.alpha = 0
                self.numberInformation.alpha = 0
                self.numberField.alpha = 0
                self.numberLine.alpha = 0
                self.gateCodeNotAnchor.isActive = false
                self.gateCodeTypingAnchor.isActive = true
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func bringOtherOptions() {
        UIView.animate(withDuration: animationIn) {
            self.numberLine.alpha = 1
            self.numberInformation.alpha = 1
            self.numberField.alpha = 1
            self.spotNumberInformation.alpha = 1
            self.spotNumberField.alpha = 1
            self.spotNumberCheckmark.alpha = 1
            self.spotNumberLine.alpha = 1
            self.gateCodeInformation.alpha = 1
            self.gateCodeField.alpha = 1
            self.gateCodeCheckmark.alpha = 1
            self.gateCodeLine.alpha = 1
            self.spotNumberTypingAnchor.isActive = false
            self.gateCodeTypingAnchor.isActive = false
            self.spotNumberNotAnchor.isActive = true
            self.gateCodeNotAnchor.isActive = true
            self.view.layoutIfNeeded()
        }
    }
    
    func createNumberPicker() {
        let numberPicker = UIPickerView()
        numberPicker.delegate = self
        numberPicker.backgroundColor = Theme.OFF_WHITE
        numberField.inputView = numberPicker
        createToolbar()
    }
    
    
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = Theme.WHITE
        toolBar.tintColor = Theme.BLUE
        toolBar.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.4).cgColor
        toolBar.layer.borderWidth = 0.5
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        numberField.inputAccessoryView = toolBar
        spotNumberField.inputAccessoryView = toolBar
        gateCodeField.inputAccessoryView = toolBar
    }
    
    func resetNumbers() {
        self.numbers = []
        self.numberField.text = "1"
        for i in 1..<self.numberOfSpots+1 {
            self.numbers.append(i)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        bringOtherOptions()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        bringOtherOptions()
    }
}


extension SpotNumberViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numbers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numbers[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDay = "\(numbers[row])"
        numberField.text = selectedDay
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        label.textColor = Theme.BLACK
        label.textAlignment = .center
        label.font = Fonts.SSPLightH3
        label.text = "\(numbers[row])"
        
        return label
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "• • • •" {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            textField.text = "• • • •"
            if textField == spotNumberField {
                self.checkmarkPressed(bool: false, sender: self.spotNumberCheckmark)
            } else if textField == gateCodeField {
                self.checkmarkPressed(bool: false, sender: self.gateCodeCheckmark)
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == numberField {
            return false
        }
        if textField == spotNumberField {
            self.checkmarkPressed(bool: true, sender: self.spotNumberCheckmark)
        } else if textField == gateCodeField {
            self.checkmarkPressed(bool: true, sender: self.gateCodeCheckmark)
        }
        return true
    }
}
