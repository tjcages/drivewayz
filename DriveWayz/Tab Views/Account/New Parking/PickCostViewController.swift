//
//  SelectCostViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 9/10/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class PickCostViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var costParking: String = "$1.50"
    
    private let cheapCostValues: NSArray = ["$1.00","$1.50","$2.00","$2.50","$3.00","$3.50","$4.00","$4.50","$5.00","$5.50","$6.00","$6.50","$7.00","$7.50","$8.00","$8.50","$9.00","$9.50","$10.00", "$10.50", "$11.00", "$11.50", "$12.00"]
    private let expensiveCostValues: NSArray = ["$1.00","$1.50","$2.00","$2.50","$3.00","$3.50","$4.00","$4.50","$5.00","$5.50","$6.00","$6.50","$7.00","$7.50","$8.00","$8.50","$9.00","$9.50","$10.00", "$10.50","$11.00","$11.50","$12.00","$12.50","$13.00","$13.50","$14.00","$14.50","$15.00","$15.50","$16.00"]
    
    var costPicker: UIPickerView = {
        let cost = UIPickerView()
        cost.backgroundColor = UIColor.clear
        cost.tintColor = Theme.BLACK
        cost.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        cost.translatesAutoresizingMaskIntoConstraints = false
        cost.setValue(Theme.BLACK, forKeyPath: "textColor")
        
        return cost
    }()
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.text = "Please select a price per hour that users will think is cheap and fair. On average hosts near event lots charge $4.50/Hour."
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH5
        label.numberOfLines = 4
        label.textAlignment = .center
        
        return label
    }()
    
    var swipeLabel: UILabel = {
        let label = UILabel()
        label.text = "Swipe left"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .center
        
        return label
    }()
    
    var hourLabel: UILabel = {
        let label = UILabel()
        label.text = "/Hour"
        label.textColor = Theme.BLACK
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPBoldH3
        label.contentMode = .center
        label.backgroundColor = Theme.WHITE
        
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
    
    func setupCosts() {
        
        self.view.addSubview(informationLabel)
        informationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        informationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        informationLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -15).isActive = true
        informationLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        costPicker.transform = CGAffineTransform(rotationAngle: (-90 * (.pi/180)))
        self.view.addSubview(costPicker)
        costPicker.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        costPicker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        costPicker.widthAnchor.constraint(equalToConstant: 80).isActive = true
        costPicker.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        self.view.addSubview(hourLabel)
        hourLabel.leftAnchor.constraint(equalTo: costPicker.rightAnchor).isActive = true
        hourLabel.centerYAnchor.constraint(equalTo: costPicker.centerYAnchor).isActive = true
        hourLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        hourLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.view.addSubview(swipeLabel)
        swipeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 40).isActive = true
        swipeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -40).isActive = true
        swipeLabel.topAnchor.constraint(equalTo: hourLabel.bottomAnchor, constant: 0).isActive = true
        swipeLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    func removeTutorial() {
        self.costPicker.selectRow(1, inComponent: 0, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 0.3) {
                self.swipeLabel.alpha = 0
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        pickerView.subviews.forEach({
            $0.isHidden = $0.frame.height < 1.0
        })
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 70
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if expensesListing == 1 {
            return expensiveCostValues.count
        } else {
            return cheapCostValues.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if expensesListing == 1 {
            return expensiveCostValues[row] as? String
        } else {
            return cheapCostValues[row] as? String
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 120, height: 140)
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 120, height: 140)
        label.textAlignment = .center
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        
        if expensesListing == 1 {
            label.text = expensiveCostValues[row] as? String
        } else {
            label.text = cheapCostValues[row] as? String
        }
        
        view.addSubview(label)
        
        view.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))
        
        return view
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if expensesListing == 1 {
            costParking = expensiveCostValues[row] as! String
        } else {
            costParking = cheapCostValues[row] as! String
        }
    }
    
    func addPropertiesToDatabase(parkingID: String) {
        let ref = Database.database().reference().child("parking").child(parkingID)
        let perHour = "/hour"
        let cost = self.costParking + perHour
        ref.updateChildValues(["parkingCost": cost])
    }
    
    
    


}
