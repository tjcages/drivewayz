//
//  SelectCostViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 9/10/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import CoreLocation

class PickCostViewController: UIViewController {
    
    var minPrice: Double = 1.32
    var selectedPrice: Double = 3.0
    var dynamicPrice: Double = 3.0 {
        didSet {
            let standardValue = NSString(format: "$%.2f", self.dynamicPrice) as String
            let maxCostValue = NSString(format: "$%.2f", (self.dynamicPrice * 2)) as String
            let minCostValue = "$\(self.minPrice)"
            
            let standardString = "Set standard rate: \(standardValue)"
            let maxString = "Set max rate: \(maxCostValue)"
            let minString = "Set min rate: \(minCostValue)"
            
            let standardRange = (standardString as NSString).range(of: standardValue)
            let maxRange = (maxString as NSString).range(of: maxCostValue)
            let minRange = (minString as NSString).range(of: minCostValue)
            
            let standardStringRange = (standardString as NSString).range(of: standardString)
            let maxStringRange = (maxString as NSString).range(of: maxString)
            let minStringRange = (minString as NSString).range(of: minString)
            
            let standardAttribution = NSMutableAttributedString(string: standardString)
            let maxAttribution = NSMutableAttributedString(string: maxString)
            let minAttribution = NSMutableAttributedString(string: minString)
            
            standardAttribution.addAttributes([NSAttributedString.Key.foregroundColor: Theme.BLACK, NSAttributedString.Key.font: Fonts.SSPRegularH4], range: standardStringRange)
            standardAttribution.addAttributes([NSAttributedString.Key.foregroundColor: Theme.BLUE, NSAttributedString.Key.font: Fonts.SSPRegularH4], range: standardRange)
            maxAttribution.addAttributes([NSAttributedString.Key.foregroundColor: Theme.BLACK, NSAttributedString.Key.font: Fonts.SSPRegularH4], range: maxStringRange)
            maxAttribution.addAttributes([NSAttributedString.Key.foregroundColor: Theme.BLUE, NSAttributedString.Key.font: Fonts.SSPRegularH4], range: maxRange)
            minAttribution.addAttributes([NSAttributedString.Key.foregroundColor: Theme.BLACK, NSAttributedString.Key.font: Fonts.SSPRegularH4], range: minStringRange)
            minAttribution.addAttributes([NSAttributedString.Key.foregroundColor: Theme.BLUE, NSAttributedString.Key.font: Fonts.SSPRegularH4], range: minRange)
            
            self.dynamicPriceButton.setAttributedTitle(standardAttribution, for: .normal)
            self.maxPriceButton.setAttributedTitle(maxAttribution, for: .normal)
            self.minPriceButton.setAttributedTitle(minAttribution, for: .normal)
        }
    }
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentSize = CGSize(width: self.view.frame.width, height: 800)
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        
        return view
    }()
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK.withAlphaComponent(0.8)
        label.font = Fonts.SSPLightH4
        label.numberOfLines = 9
        label.text = """
        We allow our hosts to choose their hourly price range as long as it is within a certain determined price range based on location.
        
        This price is subject to change based on proximity to events, time of day, and surge demand.
        
        """
        
        return label
    }()
    
    var costTextField: UITextField = {
        let label = UITextField()
        label.text = ""
        label.attributedPlaceholder = NSAttributedString(string: " $ 0.00",
                                                         attributes: [NSAttributedString.Key.foregroundColor: Theme.BLACK.withAlphaComponent(0.5)])
        label.textColor = Theme.BLACK
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH2
        label.keyboardType = .numberPad
        label.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        label.keyboardAppearance = .dark
        
        return label
    }()

    var hourLabel: UIButton = {
        let label = UIButton()
        label.setTitle("per hour", for: .normal)
        label.setTitleColor(Theme.BLACK, for: .normal)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.titleLabel?.font = Fonts.SSPRegularH3
        label.contentHorizontalAlignment = .right
        label.addTarget(self, action: #selector(hourLabelTapped), for: .touchUpInside)

        return label
    }()
    
    var costBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.GRAY_WHITE_4.withAlphaComponent(0.2)
        
        return view
    }()
    
    var costLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        
        return view
    }()
    
    var dynamicPriceButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Set standard rate", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.addTarget(self, action: #selector(setDynamicPricePressed), for: .touchUpInside)
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    var maxPriceButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Set max rate", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.addTarget(self, action: #selector(setDynamicPricePressed), for: .touchUpInside)
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    var minPriceButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Set min rate", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.addTarget(self, action: #selector(setDynamicPricePressed), for: .touchUpInside)
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    var standardLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK.withAlphaComponent(0.6)
        label.font = Fonts.SSPLightH5
        label.numberOfLines = 2
        label.text = "The standard rate will maximize your profitability while providing competitively priced parking."
        label.textAlignment = .center
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        costTextField.delegate = self

        setupCosts()
        createToolbar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var informationHeightAnchor: NSLayoutConstraint!
    
    func setupCosts() {
        
        self.view.addSubview(scrollView)
        scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        let price = self.dynamicPrice
        self.dynamicPrice = price
        
        scrollView.addSubview(informationLabel)
        informationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        informationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        informationLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16).isActive = true
        informationLabel.sizeToFit()
        
        scrollView.addSubview(costBackground)
        scrollView.addSubview(costTextField)
        scrollView.addSubview(hourLabel)
        
        costTextField.rightAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -12).isActive = true
        costTextField.topAnchor.constraint(equalTo: informationLabel.bottomAnchor, constant: 24).isActive = true
        costTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        costTextField.sizeToFit()
        
        hourLabel.leftAnchor.constraint(equalTo: costTextField.rightAnchor, constant: 12).isActive = true
        hourLabel.centerYAnchor.constraint(equalTo: costTextField.centerYAnchor).isActive = true
        hourLabel.sizeToFit()
        
        costBackground.leftAnchor.constraint(equalTo: costTextField.leftAnchor, constant: -12).isActive = true
        costBackground.rightAnchor.constraint(equalTo: hourLabel.rightAnchor, constant: 12).isActive = true
        costBackground.topAnchor.constraint(equalTo: costTextField.topAnchor, constant: -8).isActive = true
        costBackground.bottomAnchor.constraint(equalTo: costTextField.bottomAnchor, constant: 4).isActive = true

        scrollView.addSubview(costLine)
        costLine.leftAnchor.constraint(equalTo: costBackground.leftAnchor).isActive = true
        costLine.rightAnchor.constraint(equalTo: costBackground.rightAnchor).isActive = true
        costLine.topAnchor.constraint(equalTo: costBackground.bottomAnchor).isActive = true
        costLine.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        scrollView.addSubview(dynamicPriceButton)
        dynamicPriceButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        dynamicPriceButton.topAnchor.constraint(equalTo: costTextField.bottomAnchor, constant: 24).isActive = true
        dynamicPriceButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        dynamicPriceButton.sizeToFit()
        
        scrollView.addSubview(maxPriceButton)
        maxPriceButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        maxPriceButton.topAnchor.constraint(equalTo: dynamicPriceButton.bottomAnchor, constant: 0).isActive = true
        maxPriceButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        maxPriceButton.sizeToFit()
        
        scrollView.addSubview(minPriceButton)
        minPriceButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        minPriceButton.topAnchor.constraint(equalTo: maxPriceButton.bottomAnchor, constant: 0).isActive = true
        minPriceButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        minPriceButton.sizeToFit()
        
        scrollView.addSubview(standardLabel)
        standardLabel.topAnchor.constraint(equalTo: minPriceButton.bottomAnchor, constant: 32).isActive = true
        standardLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        standardLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        standardLabel.sizeToFit()
        
    }
    
    func configureCustomPricing(state: String, city: String) {
        var stateAbrv = state
        stateAbrv = stateAbrv.replacingOccurrences(of: " ", with: "")
        if state.count > 2 {
            if let state = statesDictionary[stateAbrv] {
                stateAbrv = state
            }
        }
        let ref = Database.database().reference().child("Average Prices").child("\(stateAbrv)")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                if let cost = dictionary["\(city)"] as? Double {
                    self.dynamicPrice = cost
                } else {
                    if let average = dictionary["Standard"] as? Double {
                        self.dynamicPrice = average
                    }
                }
            }
        }
    }
    
    @objc func setDynamicPricePressed(sender: UIButton) {
        if sender == self.dynamicPriceButton {
            self.view.endEditing(true)
            let costValue = NSString(format: "$ %.2f", self.dynamicPrice) as String
            self.costTextField.text = "\(costValue)"
            self.selectedPrice = self.dynamicPrice
        } else if sender == self.maxPriceButton {
            self.view.endEditing(true)
            let costValue = NSString(format: "$ %.2f", self.dynamicPrice * 2) as String
            self.costTextField.text = "\(costValue)"
            self.selectedPrice = self.dynamicPrice * 2
        } else if sender == self.minPriceButton {
            self.view.endEditing(true)
            let costValue = NSString(format: "$ %.2f", self.minPrice) as String
            self.costTextField.text = "\(costValue)"
            self.selectedPrice = self.minPrice
        }
    }
    
    func addPropertiesToDatabase(parkingID: String) {
        let ref = Database.database().reference().child("parking").child(parkingID)
        let cost = self.dynamicPrice
        ref.updateChildValues(["parkingCost": cost])
    }
    
    @objc func hourLabelTapped() {
        self.costTextField.becomeFirstResponder()
    }
    
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = Theme.BLACK
        toolBar.tintColor = Theme.WHITE
        toolBar.layer.borderColor = Theme.BLACK.withAlphaComponent(0.4).cgColor
        toolBar.layer.borderWidth = 0.5
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        doneButton.setTitleTextAttributes([ NSAttributedString.Key.font: Fonts.SSPSemiBoldH4], for: UIControl.State.normal)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.costTextField.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}


extension PickCostViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.costBackground.backgroundColor = Theme.BLUE.withAlphaComponent(0.1)
        self.costLine.backgroundColor = Theme.BLUE
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.costBackground.backgroundColor = Theme.GRAY_WHITE_4.withAlphaComponent(0.2)
        self.costLine.backgroundColor = Theme.LINE_GRAY
    }
    
    @objc func myTextFieldDidChange(_ textField: UITextField) {
        if let amountString = textField.text?.currencyInputFormatting() {
            if let cost = Double(amountString.replacingOccurrences(of: "$ ", with: "")) {
                self.selectedPrice = cost
            }
            textField.text = amountString
            textField.sizeToFit()
        }
    }
    
}


extension String {
    
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$ "
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.maximumIntegerDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
}
