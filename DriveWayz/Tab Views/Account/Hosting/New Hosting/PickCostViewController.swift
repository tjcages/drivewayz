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
    
    var dynamicPrice: Double = 3.0
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
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
                                                         attributes: [NSAttributedString.Key.foregroundColor: Theme.DARK_GRAY.withAlphaComponent(0.5)])
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH2
        label.keyboardType = .numberPad
        label.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        
        return label
    }()

    var hourLabel: UILabel = {
        let label = UILabel()
        label.text = "per hour"
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH2
        
        return label
    }()
    
    var dynamicPriceButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Set standard rate", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.addTarget(self, action: #selector(setDynamicPricePressed), for: .touchUpInside)
        
        return button
    }()
    
    var standardLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPLightH5
        label.numberOfLines = 2
        label.text = "The standard rate will maximize your profitability while providing competitively priced parking"
        label.textAlignment = .center
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCosts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var informationHeightAnchor: NSLayoutConstraint!
    
    func setupCosts() {
        
        self.view.addSubview(informationLabel)
        informationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        informationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        informationLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -20).isActive = true
        informationLabel.sizeToFit()
        
        self.view.addSubview(costTextField)
        costTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -34).isActive = true
        costTextField.topAnchor.constraint(equalTo: informationLabel.bottomAnchor, constant: 20).isActive = true
        costTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        costTextField.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.view.addSubview(hourLabel)
        hourLabel.leftAnchor.constraint(equalTo: costTextField.rightAnchor, constant: -20).isActive = true
        hourLabel.centerYAnchor.constraint(equalTo: costTextField.centerYAnchor, constant: -4).isActive = true
        hourLabel.sizeToFit()
        
        self.view.addSubview(dynamicPriceButton)
        dynamicPriceButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        dynamicPriceButton.topAnchor.constraint(equalTo: costTextField.bottomAnchor, constant: 12).isActive = true
        dynamicPriceButton.widthAnchor.constraint(equalToConstant: 240).isActive = true
        dynamicPriceButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(standardLabel)
        standardLabel.topAnchor.constraint(equalTo: dynamicPriceButton.bottomAnchor, constant: 32).isActive = true
        standardLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        standardLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        standardLabel.sizeToFit()
        
    }
    
    func configureCustomPricing(state: String, city: String) {
        var stateAbrv = state
        if state.first == " " { stateAbrv.removeFirst() }
        let ref = Database.database().reference().child("Average Prices").child("\(stateAbrv)")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                if let cost = dictionary["\(city)"] as? Double {
                    let costValue = NSString(format: "%.2f", cost) as String
                    self.dynamicPrice = cost
                    self.dynamicPriceButton.setTitle("Set standard rate: $\(costValue)", for: .normal)
                } else {
                    if let average = dictionary["Standard"] as? Double {
                        let costValue = NSString(format: "%.2f", average) as String
                        self.dynamicPrice = average
                        self.dynamicPriceButton.setTitle("Set standard rate: $ \(costValue)", for: .normal)
                    }
                }
            }
        }
    }
    
    @objc func setDynamicPricePressed() {
        self.view.endEditing(true)
        let costValue = NSString(format: "$ %.2f", self.dynamicPrice) as String
        self.costTextField.text = "\(costValue)"
    }
    
    func addPropertiesToDatabase(parkingID: String) {
        let ref = Database.database().reference().child("parking").child(parkingID)
        let cost = self.dynamicPrice
        ref.updateChildValues(["parkingCost": cost])
    }
    
    @objc func myTextFieldDidChange(_ textField: UITextField) {
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
            textField.sizeToFit()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
