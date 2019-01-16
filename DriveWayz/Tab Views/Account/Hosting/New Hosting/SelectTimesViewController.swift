//
//  SelectTimesViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 9/10/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class SelectTimesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var monday: Int = 1
    var tuesday: Int = 1
    var wednesday: Int = 1
    var thursday: Int = 1
    var friday: Int = 1
    var saturday: Int = 1
    var sunday: Int = 1
    
    var mondayFrom: String = "All day"
    var mondayTo: String = "All day"
    var tuesdayFrom: String = "All day"
    var tuesdayTo: String = "All day"
    var wednesdayFrom: String = "All day"
    var wednesdayTo: String = "All day"
    var thursdayFrom: String = "All day"
    var thursdayTo: String = "All day"
    var fridayFrom: String = "All day"
    var fridayTo: String = "All day"
    var saturdayFrom: String = "All day"
    var saturdayTo: String = "All day"
    var sundayFrom: String = "All day"
    var sundayTo: String = "All day"
    
    lazy var scrollViewParking: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentSize = CGSize(width: self.view.frame.width, height: 940)
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTimePickers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTimePickers() {
        
        self.view.addSubview(scrollViewParking)
        scrollViewParking.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        scrollViewParking.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        scrollViewParking.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        scrollViewParking.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollViewParking.addSubview(mondayTimeView)
        mondayTimeView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        mondayTimeView.topAnchor.constraint(equalTo: scrollViewParking.topAnchor).isActive = true
        mondayTimeView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -48).isActive = true
        mondayTimeView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        mondayTimePicker()
        
        scrollViewParking.addSubview(tuesdayTimeView)
        tuesdayTimeView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        tuesdayTimeView.topAnchor.constraint(equalTo: mondayTimeView.bottomAnchor, constant: 90).isActive = true
        tuesdayTimeView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -48).isActive = true
        tuesdayTimeView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        tuesdayTimePicker()
        
        scrollViewParking.addSubview(wednesdayTimeView)
        wednesdayTimeView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        wednesdayTimeView.topAnchor.constraint(equalTo: tuesdayTimeView.bottomAnchor, constant: 90).isActive = true
        wednesdayTimeView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -48).isActive = true
        wednesdayTimeView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        wednesdayTimePicker()
        
        scrollViewParking.addSubview(thursdayTimeView)
        thursdayTimeView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        thursdayTimeView.topAnchor.constraint(equalTo: wednesdayTimeView.bottomAnchor, constant: 90).isActive = true
        thursdayTimeView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -48).isActive = true
        thursdayTimeView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        thursdayTimePicker()
        
        scrollViewParking.addSubview(fridayTimeView)
        fridayTimeView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        fridayTimeView.topAnchor.constraint(equalTo: thursdayTimeView.bottomAnchor, constant: 90).isActive = true
        fridayTimeView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -48).isActive = true
        fridayTimeView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        fridayTimePicker()
        
        scrollViewParking.addSubview(saturdayTimeView)
        saturdayTimeView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        saturdayTimeView.topAnchor.constraint(equalTo: fridayTimeView.bottomAnchor, constant: 90).isActive = true
        saturdayTimeView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -48).isActive = true
        saturdayTimeView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        saturdayTimePicker()
        
        scrollViewParking.addSubview(sundayTimeView)
        sundayTimeView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        sundayTimeView.topAnchor.constraint(equalTo: saturdayTimeView.bottomAnchor, constant: 90).isActive = true
        sundayTimeView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -48).isActive = true
        sundayTimeView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        sundayTimePicker()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        pickerView.subviews.forEach({
            $0.isHidden = $0.frame.height < 1.0
        })
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == mondayToPicker || pickerView == tuesdayToPicker || pickerView == wednesdayToPicker || pickerView == thursdayToPicker || pickerView == fridayToPicker || pickerView == saturdayToPicker || pickerView == sundayToPicker {
            return pmTimeValues.count
        } else {
            return amTimeValues.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == mondayToPicker || pickerView == tuesdayToPicker || pickerView == wednesdayToPicker || pickerView == thursdayToPicker || pickerView == fridayToPicker || pickerView == saturdayToPicker || pickerView == sundayToPicker {
            return pmTimeValues[row] as? String
        } else {
            return amTimeValues[row] as? String
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if pickerView == mondayToPicker || pickerView == tuesdayToPicker || pickerView == wednesdayToPicker || pickerView == thursdayToPicker || pickerView == fridayToPicker || pickerView == saturdayToPicker || pickerView == sundayToPicker {
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: 140, height: 80)
            
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: 140, height: 80)
            label.textAlignment = .center
            label.textColor = Theme.WHITE
            label.font = Fonts.SSPRegularH2
            label.text = pmTimeValues[row] as? String
            view.addSubview(label)
            
            return view
        } else {
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: 140, height: 80)
            
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: 140, height: 80)
            label.textAlignment = .center
            label.textColor = Theme.WHITE
            label.font = Fonts.SSPRegularH2
            label.text = amTimeValues[row] as? String
            view.addSubview(label)
            
            return view
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == mondayFromPicker {
            mondayFrom = amTimeValues[row] as! String
        } else if pickerView == mondayToPicker {
            mondayTo = pmTimeValues[row] as! String
        } else if pickerView == tuesdayFromPicker {
            tuesdayFrom = amTimeValues[row] as! String
        } else if pickerView == tuesdayToPicker {
            tuesdayTo = pmTimeValues[row] as! String
        } else if pickerView == wednesdayFromPicker {
            wednesdayFrom = amTimeValues[row] as! String
        } else if pickerView == wednesdayToPicker {
            wednesdayTo = pmTimeValues[row] as! String
        } else if pickerView == thursdayFromPicker {
            thursdayFrom = amTimeValues[row] as! String
        } else if pickerView == thursdayToPicker {
            thursdayTo = pmTimeValues[row] as! String
        } else if pickerView == fridayFromPicker {
            fridayFrom = amTimeValues[row] as! String
        } else if pickerView == fridayToPicker {
            fridayTo = pmTimeValues[row] as! String
        } else if pickerView == saturdayFromPicker {
            saturdayFrom = amTimeValues[row] as! String
        } else if pickerView == saturdayToPicker {
            saturdayTo = pmTimeValues[row] as! String
        } else if pickerView == sundayFromPicker {
            sundayFrom = amTimeValues[row] as! String
        } else if pickerView == sundayToPicker {
            sundayTo = pmTimeValues[row] as! String
        } else {
            print("something else")
        }
    }
    
    var mondayTimeView: UILabel = {
        let label = UILabel()
        label.text = "Monday"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPLightH3
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    var mondayFromPicker: UIPickerView = {
        let mondayFromPicker = UIPickerView()
        mondayFromPicker.backgroundColor = UIColor.clear
        mondayFromPicker.tintColor = Theme.WHITE
        mondayFromPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        mondayFromPicker.translatesAutoresizingMaskIntoConstraints = false
        mondayFromPicker.setValue(Theme.WHITE, forKeyPath: "textColor")
        
        return mondayFromPicker
    }()
    
    var mondayToPicker: UIPickerView = {
        let mondayToPicker = UIPickerView()
        mondayToPicker.backgroundColor = UIColor.clear
        mondayToPicker.tintColor = Theme.WHITE
        mondayToPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        mondayToPicker.translatesAutoresizingMaskIntoConstraints = false
        mondayToPicker.setValue(Theme.WHITE, forKeyPath: "textColor")
        
        return mondayToPicker
    }()
    
    func mondayTimePicker() {
        scrollViewParking.addSubview(mondayFromPicker)
        mondayFromPicker.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 48).isActive = true
        mondayFromPicker.topAnchor.constraint(equalTo: mondayTimeView.bottomAnchor).isActive = true
        mondayFromPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        mondayFromPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let toLabel = UILabel()
        toLabel.text = "to"
        toLabel.textColor = Theme.WHITE.withAlphaComponent(0.7)
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        toLabel.font = Fonts.SSPLightH4
        toLabel.contentMode = .center
        mondayTimeView.addSubview(toLabel)
        
        toLabel.leftAnchor.constraint(equalTo: mondayFromPicker.rightAnchor, constant: 8).isActive = true
        toLabel.centerYAnchor.constraint(equalTo: mondayFromPicker.centerYAnchor).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        toLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollViewParking.addSubview(mondayToPicker)
        mondayToPicker.leftAnchor.constraint(equalTo: toLabel.rightAnchor).isActive = true
        mondayToPicker.centerYAnchor.constraint(equalTo: mondayFromPicker.centerYAnchor).isActive = true
        mondayToPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        mondayToPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    var tuesdayTimeView: UILabel = {
        let label = UILabel()
        label.text = "Tuesday"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPLightH3
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var tuesdayFromPicker: UIPickerView = {
        let tuesdayFromPicker = UIPickerView()
        tuesdayFromPicker.backgroundColor = UIColor.clear
        tuesdayFromPicker.tintColor = Theme.WHITE
        tuesdayFromPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        tuesdayFromPicker.translatesAutoresizingMaskIntoConstraints = false
        tuesdayFromPicker.setValue(Theme.WHITE, forKeyPath: "textColor")
        
        return tuesdayFromPicker
    }()
    
    var tuesdayToPicker: UIPickerView = {
        let tuesdayToPicker = UIPickerView()
        tuesdayToPicker.backgroundColor = UIColor.clear
        tuesdayToPicker.tintColor = Theme.WHITE
        tuesdayToPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        tuesdayToPicker.translatesAutoresizingMaskIntoConstraints = false
        tuesdayToPicker.setValue(Theme.WHITE, forKeyPath: "textColor")
        
        return tuesdayToPicker
    }()
    
    func tuesdayTimePicker() {
        
        scrollViewParking.addSubview(tuesdayFromPicker)
        tuesdayFromPicker.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 48).isActive = true
        tuesdayFromPicker.topAnchor.constraint(equalTo: tuesdayTimeView.bottomAnchor).isActive = true
        tuesdayFromPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        tuesdayFromPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let toLabel = UILabel()
        toLabel.text = "to"
        toLabel.textColor = Theme.WHITE.withAlphaComponent(0.7)
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        toLabel.font = Fonts.SSPLightH4
        toLabel.contentMode = .center
        tuesdayTimeView.addSubview(toLabel)
        
        toLabel.leftAnchor.constraint(equalTo: tuesdayFromPicker.rightAnchor, constant: 8).isActive = true
        toLabel.centerYAnchor.constraint(equalTo: tuesdayFromPicker.centerYAnchor).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        toLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollViewParking.addSubview(tuesdayToPicker)
        tuesdayToPicker.leftAnchor.constraint(equalTo: toLabel.rightAnchor).isActive = true
        tuesdayToPicker.centerYAnchor.constraint(equalTo: tuesdayFromPicker.centerYAnchor).isActive = true
        tuesdayToPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        tuesdayToPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    var wednesdayTimeView: UILabel = {
        let label = UILabel()
        label.text = "Wednesday"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPLightH3
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    var wednesdayFromPicker: UIPickerView = {
        let wednesdayFromPicker = UIPickerView()
        wednesdayFromPicker.backgroundColor = UIColor.clear
        wednesdayFromPicker.tintColor = Theme.WHITE
        wednesdayFromPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        wednesdayFromPicker.translatesAutoresizingMaskIntoConstraints = false
        wednesdayFromPicker.setValue(Theme.WHITE, forKeyPath: "textColor")
        
        return wednesdayFromPicker
    }()
    
    var wednesdayToPicker: UIPickerView = {
        let wednesdayToPicker = UIPickerView()
        wednesdayToPicker.backgroundColor = UIColor.clear
        wednesdayToPicker.tintColor = Theme.WHITE
        wednesdayToPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        wednesdayToPicker.translatesAutoresizingMaskIntoConstraints = false
        wednesdayToPicker.setValue(Theme.WHITE, forKeyPath: "textColor")
        
        return wednesdayToPicker
    }()
    
    func wednesdayTimePicker() {
        
        scrollViewParking.addSubview(wednesdayFromPicker)
        wednesdayFromPicker.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 48).isActive = true
        wednesdayFromPicker.topAnchor.constraint(equalTo: wednesdayTimeView.bottomAnchor).isActive = true
        wednesdayFromPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        wednesdayFromPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let toLabel = UILabel()
        toLabel.text = "to"
        toLabel.textColor = Theme.WHITE.withAlphaComponent(0.7)
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        toLabel.font = Fonts.SSPLightH4
        toLabel.contentMode = .center
        wednesdayTimeView.addSubview(toLabel)
        
        toLabel.leftAnchor.constraint(equalTo: wednesdayFromPicker.rightAnchor, constant: 8).isActive = true
        toLabel.centerYAnchor.constraint(equalTo: wednesdayFromPicker.centerYAnchor).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        toLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollViewParking.addSubview(wednesdayToPicker)
        wednesdayToPicker.leftAnchor.constraint(equalTo: toLabel.rightAnchor).isActive = true
        wednesdayToPicker.centerYAnchor.constraint(equalTo: wednesdayFromPicker.centerYAnchor).isActive = true
        wednesdayToPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        wednesdayToPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    var thursdayTimeView: UIView = {
        let label = UILabel()
        label.text = "Thursday"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPLightH3
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    var thursdayFromPicker: UIPickerView = {
        let thursdayFromPicker = UIPickerView()
        thursdayFromPicker.backgroundColor = UIColor.clear
        thursdayFromPicker.tintColor = Theme.WHITE
        thursdayFromPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        thursdayFromPicker.translatesAutoresizingMaskIntoConstraints = false
        thursdayFromPicker.setValue(Theme.WHITE, forKeyPath: "textColor")
        
        return thursdayFromPicker
    }()
    
    var thursdayToPicker: UIPickerView = {
        let thursdayToPicker = UIPickerView()
        thursdayToPicker.backgroundColor = UIColor.clear
        thursdayToPicker.tintColor = Theme.WHITE
        thursdayToPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        thursdayToPicker.translatesAutoresizingMaskIntoConstraints = false
        thursdayToPicker.setValue(Theme.WHITE, forKeyPath: "textColor")
        
        return thursdayToPicker
    }()
    
    func thursdayTimePicker() {
        
        scrollViewParking.addSubview(thursdayFromPicker)
        thursdayFromPicker.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 48).isActive = true
        thursdayFromPicker.topAnchor.constraint(equalTo: thursdayTimeView.bottomAnchor).isActive = true
        thursdayFromPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        thursdayFromPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let toLabel = UILabel()
        toLabel.text = "to"
        toLabel.textColor = Theme.WHITE.withAlphaComponent(0.7)
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        toLabel.font = Fonts.SSPLightH4
        toLabel.contentMode = .center
        thursdayTimeView.addSubview(toLabel)
        
        toLabel.leftAnchor.constraint(equalTo: thursdayFromPicker.rightAnchor, constant: 8).isActive = true
        toLabel.centerYAnchor.constraint(equalTo: thursdayFromPicker.centerYAnchor).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        toLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollViewParking.addSubview(thursdayToPicker)
        thursdayToPicker.leftAnchor.constraint(equalTo: toLabel.rightAnchor).isActive = true
        thursdayToPicker.centerYAnchor.constraint(equalTo: thursdayFromPicker.centerYAnchor).isActive = true
        thursdayToPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        thursdayToPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    var fridayTimeView: UILabel = {
        let label = UILabel()
        label.text = "Friday"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPLightH3
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var fridayFromPicker: UIPickerView = {
        let fridayFromPicker = UIPickerView()
        fridayFromPicker.backgroundColor = UIColor.clear
        fridayFromPicker.tintColor = Theme.WHITE
        fridayFromPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        fridayFromPicker.translatesAutoresizingMaskIntoConstraints = false
        fridayFromPicker.setValue(Theme.WHITE, forKeyPath: "textColor")
        
        return fridayFromPicker
    }()
    
    var fridayToPicker: UIPickerView = {
        let fridayToPicker = UIPickerView()
        fridayToPicker.backgroundColor = UIColor.clear
        fridayToPicker.tintColor = Theme.WHITE
        fridayToPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        fridayToPicker.translatesAutoresizingMaskIntoConstraints = false
        fridayToPicker.setValue(Theme.WHITE, forKeyPath: "textColor")
        
        return fridayToPicker
    }()
    
    func fridayTimePicker() {
        
        scrollViewParking.addSubview(fridayFromPicker)
        fridayFromPicker.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 48).isActive = true
        fridayFromPicker.topAnchor.constraint(equalTo: fridayTimeView.bottomAnchor).isActive = true
        fridayFromPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        fridayFromPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let toLabel = UILabel()
        toLabel.text = "to"
        toLabel.textColor = Theme.WHITE.withAlphaComponent(0.7)
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        toLabel.font = Fonts.SSPLightH4
        toLabel.contentMode = .center
        fridayTimeView.addSubview(toLabel)
        
        toLabel.leftAnchor.constraint(equalTo: fridayFromPicker.rightAnchor, constant: 8).isActive = true
        toLabel.centerYAnchor.constraint(equalTo: fridayFromPicker.centerYAnchor).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        toLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollViewParking.addSubview(fridayToPicker)
        fridayToPicker.leftAnchor.constraint(equalTo: toLabel.rightAnchor).isActive = true
        fridayToPicker.centerYAnchor.constraint(equalTo: fridayFromPicker.centerYAnchor).isActive = true
        fridayToPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        fridayToPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    var saturdayTimeView: UILabel = {
        let label = UILabel()
        label.text = "Saturday"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPLightH3
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var saturdayFromPicker: UIPickerView = {
        let saturdayFromPicker = UIPickerView()
        saturdayFromPicker.backgroundColor = UIColor.clear
        saturdayFromPicker.tintColor = Theme.BLACK
        saturdayFromPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        saturdayFromPicker.translatesAutoresizingMaskIntoConstraints = false
        saturdayFromPicker.setValue(Theme.WHITE, forKeyPath: "textColor")
        
        return saturdayFromPicker
    }()
    
    var saturdayToPicker: UIPickerView = {
        let saturdayToPicker = UIPickerView()
        saturdayToPicker.backgroundColor = UIColor.clear
        saturdayToPicker.tintColor = Theme.WHITE
        saturdayToPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        saturdayToPicker.translatesAutoresizingMaskIntoConstraints = false
        saturdayToPicker.setValue(Theme.WHITE, forKeyPath: "textColor")
        
        return saturdayToPicker
    }()
    
    func saturdayTimePicker() {
        
        scrollViewParking.addSubview(saturdayFromPicker)
        saturdayFromPicker.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 48).isActive = true
        saturdayFromPicker.topAnchor.constraint(equalTo: saturdayTimeView.bottomAnchor).isActive = true
        saturdayFromPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        saturdayFromPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let toLabel = UILabel()
        toLabel.text = "to"
        toLabel.textColor = Theme.WHITE.withAlphaComponent(0.7)
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        toLabel.font = Fonts.SSPLightH4
        toLabel.contentMode = .center
        saturdayTimeView.addSubview(toLabel)
        
        toLabel.leftAnchor.constraint(equalTo: saturdayFromPicker.rightAnchor, constant: 8).isActive = true
        toLabel.centerYAnchor.constraint(equalTo: saturdayFromPicker.centerYAnchor).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        toLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollViewParking.addSubview(saturdayToPicker)
        saturdayToPicker.leftAnchor.constraint(equalTo: toLabel.rightAnchor).isActive = true
        saturdayToPicker.centerYAnchor.constraint(equalTo: saturdayFromPicker.centerYAnchor).isActive = true
        saturdayToPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        saturdayToPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    var sundayTimeView: UILabel = {
        let label = UILabel()
        label.text = "Sunday"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPLightH3
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var sundayFromPicker: UIPickerView = {
        let sundayFromPicker = UIPickerView()
        sundayFromPicker.backgroundColor = UIColor.clear
        sundayFromPicker.tintColor = Theme.BLACK
        sundayFromPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        sundayFromPicker.translatesAutoresizingMaskIntoConstraints = false
        sundayFromPicker.setValue(Theme.WHITE, forKeyPath: "textColor")
        
        return sundayFromPicker
    }()
    
    var sundayToPicker: UIPickerView = {
        let sundayToPicker = UIPickerView()
        sundayToPicker.backgroundColor = UIColor.clear
        sundayToPicker.tintColor = Theme.BLACK
        sundayToPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        sundayToPicker.translatesAutoresizingMaskIntoConstraints = false
        sundayToPicker.setValue(Theme.WHITE, forKeyPath: "textColor")
        
        return sundayToPicker
    }()
    
    func sundayTimePicker() {
        
        scrollViewParking.addSubview(sundayFromPicker)
        sundayFromPicker.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 48).isActive = true
        sundayFromPicker.topAnchor.constraint(equalTo: sundayTimeView.bottomAnchor).isActive = true
        sundayFromPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        sundayFromPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let toLabel = UILabel()
        toLabel.text = "to"
        toLabel.textColor = Theme.WHITE.withAlphaComponent(0.7)
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        toLabel.font = Fonts.SSPLightH4
        toLabel.contentMode = .center
        sundayTimeView.addSubview(toLabel)
        
        toLabel.leftAnchor.constraint(equalTo: sundayFromPicker.rightAnchor, constant: 8).isActive = true
        toLabel.centerYAnchor.constraint(equalTo: sundayFromPicker.centerYAnchor).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        toLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollViewParking.addSubview(sundayToPicker)
        sundayToPicker.leftAnchor.constraint(equalTo: toLabel.rightAnchor).isActive = true
        sundayToPicker.centerYAnchor.constraint(equalTo: sundayFromPicker.centerYAnchor).isActive = true
        sundayToPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        sundayToPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        mondayFromPicker.delegate = self
        mondayFromPicker.dataSource = self
        mondayToPicker.delegate = self
        mondayToPicker.dataSource = self
        tuesdayFromPicker.delegate = self
        tuesdayFromPicker.dataSource = self
        tuesdayToPicker.delegate = self
        tuesdayToPicker.dataSource = self
        wednesdayFromPicker.delegate = self
        wednesdayFromPicker.dataSource = self
        wednesdayToPicker.delegate = self
        wednesdayToPicker.dataSource = self
        thursdayFromPicker.dataSource = self
        thursdayToPicker.delegate = self
        thursdayToPicker.dataSource = self
        thursdayFromPicker.delegate = self
        fridayFromPicker.dataSource = self
        fridayToPicker.delegate = self
        fridayToPicker.dataSource = self
        fridayFromPicker.delegate = self
        saturdayFromPicker.dataSource = self
        saturdayToPicker.delegate = self
        saturdayToPicker.dataSource = self
        saturdayFromPicker.delegate = self
        sundayFromPicker.delegate = self
        sundayFromPicker.dataSource = self
        sundayToPicker.delegate = self
        sundayToPicker.dataSource = self
        
    }
    
    private let amTimeValues: NSArray = ["All day","1:00 AM","2:00 AM","3:00 AM","4:00 AM","5:00 AM","6:00 AM","7:00 AM","8:00 AM","9:00 AM","10:00 AM","11:00 AM","12:00 PM","1:00 PM","2:00 PM","3:00 PM","4:00 PM","5:00 PM","6:00 PM","7:00 PM","8:00 PM"]
    private let pmTimeValues: NSArray = ["All day","12:00 PM","1:00 PM","2:00 PM","3:00 PM","4:00 PM","5:00 PM","6:00 PM","7:00 PM","8:00 PM","9:00 PM","10:00 PM","11:00 PM","12:00 AM"]
    

}
