//
//  SelectCostViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 9/10/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import CoreLocation

class PickCostViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var costParking: String = "3.00"
    
    private var costValues: [String] = ["$1.00","$1.50","$2.00","$2.50","$3.00","$3.50","$4.00","$4.50","$5.00"]
    
    var costPicker: UIPickerView = {
        let cost = UIPickerView()
        cost.backgroundColor = UIColor.clear
        cost.tintColor = Theme.WHITE
        cost.translatesAutoresizingMaskIntoConstraints = false
        cost.setValue(Theme.WHITE, forKeyPath: "textColor")
        
        return cost
    }()
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE.withAlphaComponent(0.8)
        label.font = Fonts.SSPLightH4
        label.numberOfLines = 8
        label.text = """
        There currently aren't enough parking spaces in your location to accurately give an average price. Please select one that you believe is cheap and fair.
        
        You can always adjust the price later.
        """
        
        return label
    }()

    var hourLabel: UILabel = {
        let label = UILabel()
        label.text = "/hour"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH2
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        costPicker.delegate = self
        costPicker.dataSource = self

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
        informationHeightAnchor = informationLabel.heightAnchor.constraint(equalToConstant: 160)
            informationHeightAnchor.isActive = true
        
        self.view.addSubview(costPicker)
        costPicker.topAnchor.constraint(equalTo: informationLabel.bottomAnchor, constant: 20).isActive = true
        costPicker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -30).isActive = true
        costPicker.widthAnchor.constraint(equalToConstant: 160).isActive = true
        costPicker.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        self.view.addSubview(hourLabel)
        hourLabel.leftAnchor.constraint(equalTo: costPicker.rightAnchor, constant: -35).isActive = true
        hourLabel.centerYAnchor.constraint(equalTo: costPicker.centerYAnchor, constant: 4).isActive = true
        hourLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        hourLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    func configureCustomPricing(state: String, city: String) {
        var stateAbrv = state
        if state.first == " " { stateAbrv.removeFirst() }
        let ref = Database.database().reference().child("CostLocations")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                if let cities = dictionary["\(stateAbrv)"] as? [String:AnyObject] {
                    for cit in cities {
                        let key = cit.key
                        if key == city {
                            if let cost = cit.value as? Double {
                                let costValue = NSString(format: "%.2f", cost) as String
                                self.informationLabel.text = """
                                The average price for parking in \(city), \(stateAbrv) is $\(costValue)/hour. Staying close to this price will increase your likelyhood of earning money.
                                
                                You can always adjust the price later.
                                """
                                self.informationHeightAnchor.constant = (self.informationLabel.text?.height(withConstrainedWidth: self.view.frame.width - 48, font: Fonts.SSPLightH4))!
                                self.costValues = []
                                var i = cost - 1
                                while i <= cost + 1 {
                                    let value = NSString(format: "%.2f", i) as String
                                    self.costValues.append("$\(value)")
                                    i = i + 0.25
                                }
                                self.costPicker.reloadAllComponents()
                            } else {
                                self.informationLabel.text = """
                                There currently aren't enough parking spaces in your location to accurately give an average price. Please select one that you believe is cheap and fair.
                                
                                You can always adjust the price later.
                                """
                                self.informationHeightAnchor.constant = (self.informationLabel.text?.height(withConstrainedWidth: self.view.frame.width - 48, font: Fonts.SSPLightH4))!
                            }
                        }
                    }
                }
            }
        }
    }
    
    func removeTutorial() {
        self.costPicker.selectRow(4, inComponent: 0, animated: true)
        self.costPicker.reloadAllComponents()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        pickerView.subviews.forEach({
            $0.isHidden = $0.frame.height < 1.0
        })
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 160
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return costValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return costValues[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 160, height: 60)
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 160, height: 60)
        label.textAlignment = .center
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH1
        label.text = costValues[row]
        view.addSubview(label)
        
        return view
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let string = costValues[row]
        self.costParking = string.replacingOccurrences(of: "$", with: "")
    }
    
    func addPropertiesToDatabase(parkingID: String) {
        let ref = Database.database().reference().child("parking").child(parkingID)
//        let perHour = "/hour"
        let cost = self.costParking
        ref.updateChildValues(["parkingCost": cost])
    }
    
}
