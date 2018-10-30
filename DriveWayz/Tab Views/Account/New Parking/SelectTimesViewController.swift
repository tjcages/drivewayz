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
    
    var scrollViewParking = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTimePickers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setData(monday: Int, tuesday: Int, wednesday: Int, thursday: Int, friday: Int, saturday: Int, sunday: Int) {
        self.monday = monday
        self.tuesday = tuesday
        self.wednesday = wednesday
        self.thursday = thursday
        self.friday = friday
        self.saturday = saturday
        self.sunday = sunday
        
        self.mondayHeightAnchor.constant = 0
        self.tuesdayHeightAnchor.constant = 0
        self.wednesdayHeightAnchor.constant = 0
        self.thursdayHeightAnchor.constant = 0
        self.fridayHeightAnchor.constant = 0
        self.saturdayHeightAnchor.constant = 0
        self.sundayHeightAnchor.constant = 0
        self.view.layoutIfNeeded()
        
        let count = monday + tuesday + wednesday + thursday + friday + saturday + sunday
        self.scrollViewParking.contentSize = CGSize(width: self.view.frame.width, height: CGFloat(count * 120))
        self.scrollViewParking.alpha = 0
        self.segmentedControl.selectedSegmentIndex = 0
        self.hideDays()
    }
    
    var weekContainer: UIView!
    var mondayHeightAnchor: NSLayoutConstraint!
    var tuesdayHeightAnchor: NSLayoutConstraint!
    var wednesdayHeightAnchor: NSLayoutConstraint!
    var thursdayHeightAnchor: NSLayoutConstraint!
    var fridayHeightAnchor: NSLayoutConstraint!
    var saturdayHeightAnchor: NSLayoutConstraint!
    var sundayHeightAnchor: NSLayoutConstraint!
    
    func setupTimePickers() {
        
        weekContainer = UIView()
        weekContainer.backgroundColor = UIColor.clear
        weekContainer.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(weekContainer)
        
        weekContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        weekContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        weekContainer.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        weekContainer.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        self.view.addSubview(segmentedControl)
        segmentedControl.centerXAnchor.constraint(equalTo: weekContainer.centerXAnchor).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        segmentedControl.widthAnchor.constraint(equalToConstant: 200).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        everydayTimePicker()
        
        self.view.addSubview(pickerView)
        pickerView.centerXAnchor.constraint(equalTo: weekContainer.centerXAnchor).isActive = true
        pickerView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 40).isActive = true
        pickerView.widthAnchor.constraint(equalTo: weekContainer.widthAnchor).isActive = true
        pickerView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        scrollViewParking.translatesAutoresizingMaskIntoConstraints = false
        scrollViewParking.contentSize = CGSize(width: self.view.frame.width, height: 840)
        scrollViewParking.showsHorizontalScrollIndicator = false
        scrollViewParking.showsVerticalScrollIndicator = false
        
        self.view.addSubview(scrollViewParking)
        scrollViewParking.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        scrollViewParking.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        scrollViewParking.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20).isActive = true
        scrollViewParking.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        mondayTimePicker()
        
        scrollViewParking.addSubview(mondayTimeView)
        mondayTimeView.centerXAnchor.constraint(equalTo: weekContainer.centerXAnchor).isActive = true
        mondayTimeView.topAnchor.constraint(equalTo: scrollViewParking.topAnchor, constant: 10).isActive = true
        mondayTimeView.widthAnchor.constraint(equalTo: weekContainer.widthAnchor).isActive = true
        mondayHeightAnchor = mondayTimeView.heightAnchor.constraint(equalToConstant: 120)
            mondayHeightAnchor.isActive = true
        
        tuesdayTimePicker()
        
        scrollViewParking.addSubview(tuesdayTimeView)
        tuesdayTimeView.centerXAnchor.constraint(equalTo: weekContainer.centerXAnchor).isActive = true
        tuesdayTimeView.topAnchor.constraint(equalTo: mondayTimeView.bottomAnchor, constant: 5).isActive = true
        tuesdayTimeView.widthAnchor.constraint(equalTo: weekContainer.widthAnchor).isActive = true
        tuesdayHeightAnchor = tuesdayTimeView.heightAnchor.constraint(equalToConstant: 120)
            tuesdayHeightAnchor.isActive = true
        
        wednesdayTimePicker()
        
        scrollViewParking.addSubview(wednesdayTimeView)
        wednesdayTimeView.centerXAnchor.constraint(equalTo: weekContainer.centerXAnchor).isActive = true
        wednesdayTimeView.topAnchor.constraint(equalTo: tuesdayTimeView.bottomAnchor, constant: 5).isActive = true
        wednesdayTimeView.widthAnchor.constraint(equalTo: weekContainer.widthAnchor).isActive = true
        wednesdayHeightAnchor = wednesdayTimeView.heightAnchor.constraint(equalToConstant: 120)
            wednesdayHeightAnchor.isActive = true
        
        thursdayTimePicker()
        
        scrollViewParking.addSubview(thursdayTimeView)
        thursdayTimeView.centerXAnchor.constraint(equalTo: weekContainer.centerXAnchor).isActive = true
        thursdayTimeView.topAnchor.constraint(equalTo: wednesdayTimeView.bottomAnchor, constant: 5).isActive = true
        thursdayTimeView.widthAnchor.constraint(equalTo: weekContainer.widthAnchor).isActive = true
        thursdayHeightAnchor = thursdayTimeView.heightAnchor.constraint(equalToConstant: 120)
            thursdayHeightAnchor.isActive = true
        
        fridayTimePicker()
        
        scrollViewParking.addSubview(fridayTimeView)
        fridayTimeView.centerXAnchor.constraint(equalTo: weekContainer.centerXAnchor).isActive = true
        fridayTimeView.topAnchor.constraint(equalTo: thursdayTimeView.bottomAnchor, constant: 5).isActive = true
        fridayTimeView.widthAnchor.constraint(equalTo: weekContainer.widthAnchor).isActive = true
        fridayHeightAnchor = fridayTimeView.heightAnchor.constraint(equalToConstant: 120)
            fridayHeightAnchor.isActive = true
        
        saturdayTimePicker()
        
        scrollViewParking.addSubview(saturdayTimeView)
        saturdayTimeView.centerXAnchor.constraint(equalTo: weekContainer.centerXAnchor).isActive = true
        saturdayTimeView.topAnchor.constraint(equalTo: fridayTimeView.bottomAnchor, constant: 5).isActive = true
        saturdayTimeView.widthAnchor.constraint(equalTo: weekContainer.widthAnchor).isActive = true
        saturdayHeightAnchor = saturdayTimeView.heightAnchor.constraint(equalToConstant: 120)
            saturdayHeightAnchor.isActive = true
        
        sundayTimePicker()
        
        scrollViewParking.addSubview(sundayTimeView)
        sundayTimeView.centerXAnchor.constraint(equalTo: weekContainer.centerXAnchor).isActive = true
        sundayTimeView.topAnchor.constraint(equalTo: saturdayTimeView.bottomAnchor, constant: 5).isActive = true
        sundayTimeView.widthAnchor.constraint(equalTo: weekContainer.widthAnchor).isActive = true
        sundayHeightAnchor = sundayTimeView.heightAnchor.constraint(equalToConstant: 120)
            sundayHeightAnchor.isActive = true
        
    }
    
    var calendarLabel: UILabel = {
        let calendar = UILabel()
        calendar.text = "Select the days of availability:"
        calendar.textColor = Theme.BLACK
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        return calendar
    }()
    
    var segmentedControl: UISegmentedControl = {
        let items = ["Everyday", "Specific Days"]
        let segment = UISegmentedControl(items: items)
        segment.selectedSegmentIndex = 0
        segment.layer.cornerRadius = 5
        segment.backgroundColor = Theme.WHITE
        segment.tintColor = Theme.SEA_BLUE
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.addTarget(self, action: #selector(changeSegmentCalendar(sender:)), for: .valueChanged)
        
        return segment
    }()
    
    var pickerView: UIView!
    var timeFromPicker: UIPickerView!
    var timeToPicker: UIPickerView!
    
    func everydayTimePicker() {
        pickerView = UIView()
        pickerView.backgroundColor = UIColor.clear
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.alpha = 1
        
        let fromLabel = UILabel()
        fromLabel.text = "From"
        fromLabel.textColor = Theme.BLACK
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        fromLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        fromLabel.contentMode = .center
        pickerView.addSubview(fromLabel)
        
        fromLabel.leftAnchor.constraint(equalTo: pickerView.leftAnchor, constant: 16).isActive = true
        fromLabel.topAnchor.constraint(equalTo: pickerView.topAnchor).isActive = true
        fromLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        fromLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        timeFromPicker = UIPickerView()
        timeFromPicker.backgroundColor = UIColor.clear
        timeFromPicker.tintColor = Theme.BLACK
        timeFromPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        timeFromPicker.translatesAutoresizingMaskIntoConstraints = false
        timeFromPicker.setValue(Theme.BLACK, forKeyPath: "textColor")
        timeFromPicker.delegate = self
        timeFromPicker.dataSource = self
        pickerView.addSubview(timeFromPicker)
        
        timeFromPicker.leftAnchor.constraint(equalTo: fromLabel.rightAnchor).isActive = true
        timeFromPicker.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        timeFromPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        timeFromPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let toLabel = UILabel()
        toLabel.text = "To"
        toLabel.textColor = Theme.BLACK
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        toLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        toLabel.contentMode = .center
        pickerView.addSubview(toLabel)
        
        toLabel.leftAnchor.constraint(equalTo: timeFromPicker.rightAnchor, constant: 8).isActive = true
        toLabel.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        toLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        timeToPicker = UIPickerView()
        timeToPicker.backgroundColor = UIColor.clear
        timeToPicker.tintColor = Theme.BLACK
        timeToPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        timeToPicker.translatesAutoresizingMaskIntoConstraints = false
        timeToPicker.setValue(Theme.BLACK, forKeyPath: "textColor")
        timeToPicker.delegate = self
        timeToPicker.dataSource = self
        pickerView.addSubview(timeToPicker)
        
        timeToPicker.leftAnchor.constraint(equalTo: toLabel.rightAnchor).isActive = true
        timeToPicker.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        timeToPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        timeToPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    var segment: Int = 1
    
    @objc func changeSegmentCalendar(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            segment = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollViewParking.alpha = 1
                self.pickerView.alpha = 0
                if self.monday == 1 {
                    self.mondayHeightAnchor.constant = 120
                    UIView.animate(withDuration: 0.3) {
                        self.mondayTimeView.alpha = 1
                        self.mondayToPicker.alpha = 1
                        self.mondayFromPicker.alpha = 1
                        self.view.layoutIfNeeded()
                    }
                }
                if self.tuesday == 1 {
                    self.tuesdayHeightAnchor.constant = 120
                    UIView.animate(withDuration: 0.3) {
                        self.tuesdayTimeView.alpha = 1
                        self.tuesdayToPicker.alpha = 1
                        self.tuesdayFromPicker.alpha = 1
                        self.view.layoutIfNeeded()
                    }
                }
                if self.wednesday == 1 {
                    self.wednesdayHeightAnchor.constant = 120
                    UIView.animate(withDuration: 0.3) {
                        self.wednesdayTimeView.alpha = 1
                        self.wednesdayToPicker.alpha = 1
                        self.wednesdayFromPicker.alpha = 1
                        self.view.layoutIfNeeded()
                    }
                }
                if self.thursday == 1 {
                    self.thursdayHeightAnchor.constant = 120
                    UIView.animate(withDuration: 0.3) {
                        self.thursdayTimeView.alpha = 1
                        self.thursdayToPicker.alpha = 1
                        self.thursdayFromPicker.alpha = 1
                        self.view.layoutIfNeeded()
                    }
                }
                if self.friday == 1 {
                    self.fridayHeightAnchor.constant = 120
                    UIView.animate(withDuration: 0.3) {
                        self.fridayTimeView.alpha = 1
                        self.fridayToPicker.alpha = 1
                        self.fridayFromPicker.alpha = 1
                        self.view.layoutIfNeeded()
                    }
                }
                if self.saturday == 1 {
                    self.saturdayHeightAnchor.constant = 120
                    UIView.animate(withDuration: 0.3) {
                        self.saturdayTimeView.alpha = 1
                        self.saturdayToPicker.alpha = 1
                        self.saturdayFromPicker.alpha = 1
                        self.view.layoutIfNeeded()
                    }
                }
                if self.sunday == 1 {
                    self.sundayHeightAnchor.constant = 120
                    UIView.animate(withDuration: 0.3) {
                        self.sundayTimeView.alpha = 1
                        self.sundayToPicker.alpha = 1
                        self.sundayFromPicker.alpha = 1
                        self.view.layoutIfNeeded()
                    }
                }
                self.view.layoutIfNeeded()
            }, completion: nil)
        default:
            segment = 1
            UIView.animate(withDuration: 0.3, animations: {
                self.pickerView.alpha = 1
                self.scrollViewParking.alpha = 0
                self.mondayTimeView.alpha = 0
                self.mondayToPicker.alpha = 0
                self.mondayFromPicker.alpha = 0
                self.mondayTimeView.alpha = 0
                self.mondayToPicker.alpha = 0
                self.mondayFromPicker.alpha = 0
                self.tuesdayTimeView.alpha = 0
                self.tuesdayToPicker.alpha = 0
                self.tuesdayFromPicker.alpha = 0
                self.wednesdayTimeView.alpha = 0
                self.wednesdayToPicker.alpha = 0
                self.wednesdayFromPicker.alpha = 0
                self.thursdayTimeView.alpha = 0
                self.thursdayToPicker.alpha = 0
                self.thursdayFromPicker.alpha = 0
                self.fridayTimeView.alpha = 0
                self.fridayToPicker.alpha = 0
                self.fridayFromPicker.alpha = 0
                self.saturdayTimeView.alpha = 0
                self.saturdayToPicker.alpha = 0
                self.saturdayFromPicker.alpha = 0
                self.sundayTimeView.alpha = 0
                self.sundayToPicker.alpha = 0
                self.sundayFromPicker.alpha = 0
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        pickerView.subviews.forEach({
            
            $0.isHidden = $0.frame.height < 1.0
        })
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 20
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == mondayToPicker || pickerView == tuesdayToPicker || pickerView == wednesdayToPicker || pickerView == thursdayToPicker || pickerView == fridayToPicker || pickerView == saturdayToPicker || pickerView == sundayToPicker || pickerView == timeToPicker {
            return pmTimeValues.count
        } else {
            return amTimeValues.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == mondayToPicker || pickerView == tuesdayToPicker || pickerView == wednesdayToPicker || pickerView == thursdayToPicker || pickerView == fridayToPicker || pickerView == saturdayToPicker || pickerView == sundayToPicker || pickerView == timeToPicker {
            return pmTimeValues[row] as? String
        } else {
            return amTimeValues[row] as? String
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if pickerView == mondayToPicker || pickerView == tuesdayToPicker || pickerView == wednesdayToPicker || pickerView == thursdayToPicker || pickerView == fridayToPicker || pickerView == saturdayToPicker || pickerView == sundayToPicker || pickerView == timeToPicker {
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: 90, height: 80)
            
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: 90, height: 80)
            label.textAlignment = .center
            label.textColor = Theme.BLACK
            label.font = UIFont.systemFont(ofSize: 20)
            label.text = pmTimeValues[row] as? String
            view.addSubview(label)
            
            return view
        } else {
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: 90, height: 80)
            
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: 90, height: 80)
            label.textAlignment = .center
            label.textColor = Theme.BLACK
            label.font = UIFont.systemFont(ofSize: 20)
            label.text = amTimeValues[row] as? String
            view.addSubview(label)
            
            return view
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == timeFromPicker {
            mondayFrom = amTimeValues[row] as! String
            tuesdayFrom = amTimeValues[row] as! String
            wednesdayFrom = amTimeValues[row] as! String
            thursdayFrom = amTimeValues[row] as! String
            fridayFrom = amTimeValues[row] as! String
            saturdayFrom = amTimeValues[row] as! String
            sundayFrom = amTimeValues[row] as! String
        } else if pickerView == timeToPicker {
            mondayTo = pmTimeValues[row] as! String
            tuesdayTo = pmTimeValues[row] as! String
            wednesdayTo = pmTimeValues[row] as! String
            thursdayTo = pmTimeValues[row] as! String
            fridayTo = pmTimeValues[row] as! String
            saturdayTo = pmTimeValues[row] as! String
            sundayTo = pmTimeValues[row] as! String
        } else if pickerView == mondayFromPicker {
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
    
    func hideDays() {
        self.mondayTimeView.alpha = 0
        self.tuesdayTimeView.alpha = 0
        self.wednesdayTimeView.alpha = 0
        self.thursdayTimeView.alpha = 0
        self.fridayTimeView.alpha = 0
        self.saturdayTimeView.alpha = 0
        self.sundayTimeView.alpha = 0
        self.pickerView.alpha = 1
    }
    
    func addParkingWithProperties(parkingID: String) {
        let ref = Database.database().reference().child("parking").child(parkingID)
        if monday == 1 {
            ref.child("Availability").child("Monday").updateChildValues(["From": mondayFrom, "To": mondayTo]) { (error, ref) in
                if error != nil {
                    print(error ?? "")
                    return
                }
            }
        } else {
            ref.child("Availability").updateChildValues(["Monday": monday]) { (error, ref) in
                if error != nil {
                    print(error ?? "")
                    return
                }
            }
        }
        if tuesday == 1 {
            ref.child("Availability").child("Tuesday").updateChildValues(["From": tuesdayFrom, "To": tuesdayTo]) { (error, ref) in
                if error != nil {
                    print(error ?? "")
                    return
                }
            }
        } else {
            ref.child("Availability").updateChildValues(["Tuesday": tuesday]) { (error, ref) in
                if error != nil {
                    print(error ?? "")
                    return
                }
            }
        }
        if wednesday == 1 {
            ref.child("Availability").child("Wednesday").updateChildValues(["From": wednesdayFrom, "To": wednesdayTo]) { (error, ref) in
                if error != nil {
                    print(error ?? "")
                    return
                }
            }
        } else {
            ref.child("Availability").updateChildValues(["Wednesday": wednesday]) { (error, ref) in
                if error != nil {
                    print(error ?? "")
                    return
                }
            }
        }
        if thursday == 1 {
            ref.child("Availability").child("Thursday").updateChildValues(["From": thursdayFrom, "To": thursdayTo]) { (error, ref) in
                if error != nil {
                    print(error ?? "")
                    return
                }
            }
        } else {
            ref.child("Availability").updateChildValues(["Thursday": thursday]) { (error, ref) in
                if error != nil {
                    print(error ?? "")
                    return
                }
            }
        }
        if friday == 1 {
            ref.child("Availability").child("Friday").updateChildValues(["From": fridayFrom, "To": fridayTo]) { (error, ref) in
                if error != nil {
                    print(error ?? "")
                    return
                }
            }
        } else {
            ref.child("Availability").updateChildValues(["Friday": friday]) { (error, ref) in
                if error != nil {
                    print(error ?? "")
                    return
                }
            }
        }
        if saturday == 1 {
            ref.child("Availability").child("Saturday").updateChildValues(["From": saturdayFrom, "To": saturdayTo]) { (error, ref) in
                if error != nil {
                    print(error ?? "")
                    return
                }
            }
        } else {
            ref.child("Availability").updateChildValues(["Saturday": saturday]) { (error, ref) in
                if error != nil {
                    print(error ?? "")
                    return
                }
            }
        }
        if sunday == 1 {
            ref.child("Availability").child("Sunday").updateChildValues(["From": sundayFrom, "To": sundayTo]) { (error, ref) in
                if error != nil {
                    print(error ?? "")
                    return
                }
            }
        } else {
            ref.child("Availability").updateChildValues(["Sunday": sunday]) { (error, ref) in
                if error != nil {
                    print(error ?? "")
                    return
                }
            }
        }
    }
    
    var mondayTimeView: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.clear
        container.translatesAutoresizingMaskIntoConstraints = false
        container.alpha = 0
        
        let image = UIImage(named: "Expand")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(imageView)
        
        imageView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 8).isActive = true
        imageView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        let label = UILabel()
        label.text = "Monday:"
        label.textColor = Theme.BLACK
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)
        
        label.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 4).isActive = true
        label.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        label.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        return container
    }()
    
    var mondayFromPicker: UIPickerView = {
        let mondayFromPicker = UIPickerView()
        mondayFromPicker.backgroundColor = UIColor.clear
        mondayFromPicker.tintColor = Theme.BLACK
        mondayFromPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        mondayFromPicker.translatesAutoresizingMaskIntoConstraints = false
        mondayFromPicker.setValue(Theme.BLACK, forKeyPath: "textColor")
        mondayFromPicker.alpha = 0
        
        return mondayFromPicker
    }()
    
    var mondayToPicker: UIPickerView = {
        let mondayToPicker = UIPickerView()
        mondayToPicker.backgroundColor = UIColor.clear
        mondayToPicker.tintColor = Theme.BLACK
        mondayToPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        mondayToPicker.translatesAutoresizingMaskIntoConstraints = false
        mondayToPicker.setValue(Theme.BLACK, forKeyPath: "textColor")
        mondayToPicker.alpha = 0
        
        return mondayToPicker
    }()
    
    func mondayTimePicker() {
        
        let fromLabel = UILabel()
        fromLabel.text = "From"
        fromLabel.textColor = Theme.BLACK
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        fromLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        fromLabel.contentMode = .center
        mondayTimeView.addSubview(fromLabel)
        
        fromLabel.leftAnchor.constraint(equalTo: mondayTimeView.leftAnchor, constant: 32).isActive = true
        fromLabel.topAnchor.constraint(equalTo: mondayTimeView.topAnchor, constant: 4).isActive = true
        fromLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        fromLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        mondayTimeView.addSubview(mondayFromPicker)
        mondayFromPicker.leftAnchor.constraint(equalTo: fromLabel.rightAnchor, constant: 4).isActive = true
        mondayFromPicker.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        mondayFromPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        mondayFromPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let toLabel = UILabel()
        toLabel.text = "To"
        toLabel.textColor = Theme.BLACK
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        toLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        toLabel.contentMode = .center
        mondayTimeView.addSubview(toLabel)
        
        toLabel.leftAnchor.constraint(equalTo: mondayFromPicker.rightAnchor, constant: 8).isActive = true
        toLabel.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        toLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        mondayTimeView.addSubview(mondayToPicker)
        mondayToPicker.leftAnchor.constraint(equalTo: toLabel.rightAnchor, constant: 4).isActive = true
        mondayToPicker.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        mondayToPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        mondayToPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    var tuesdayTimeView: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.clear
        container.translatesAutoresizingMaskIntoConstraints = false
        container.alpha = 0
        
        let image = UIImage(named: "Expand")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(imageView)
        
        imageView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 8).isActive = true
        imageView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        let label = UILabel()
        label.text = "Tuesday:"
        label.textColor = Theme.BLACK
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)
        
        label.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 4).isActive = true
        label.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        label.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        return container
    }()
    
    var tuesdayFromPicker: UIPickerView = {
        let tuesdayFromPicker = UIPickerView()
        tuesdayFromPicker.backgroundColor = UIColor.clear
        tuesdayFromPicker.tintColor = Theme.BLACK
        tuesdayFromPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        tuesdayFromPicker.translatesAutoresizingMaskIntoConstraints = false
        tuesdayFromPicker.setValue(Theme.BLACK, forKeyPath: "textColor")
        tuesdayFromPicker.alpha = 0
        
        return tuesdayFromPicker
    }()
    
    var tuesdayToPicker: UIPickerView = {
        let tuesdayToPicker = UIPickerView()
        tuesdayToPicker.backgroundColor = UIColor.clear
        tuesdayToPicker.tintColor = Theme.BLACK
        tuesdayToPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        tuesdayToPicker.translatesAutoresizingMaskIntoConstraints = false
        tuesdayToPicker.setValue(Theme.BLACK, forKeyPath: "textColor")
        tuesdayToPicker.alpha = 0
        
        return tuesdayToPicker
    }()
    
    func tuesdayTimePicker() {
        
        let fromLabel = UILabel()
        fromLabel.text = "From"
        fromLabel.textColor = Theme.BLACK
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        fromLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        fromLabel.contentMode = .center
        tuesdayTimeView.addSubview(fromLabel)
        
        fromLabel.leftAnchor.constraint(equalTo: tuesdayTimeView.leftAnchor, constant: 32).isActive = true
        fromLabel.topAnchor.constraint(equalTo: tuesdayTimeView.topAnchor, constant: 4).isActive = true
        fromLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        fromLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        tuesdayTimeView.addSubview(tuesdayFromPicker)
        tuesdayFromPicker.leftAnchor.constraint(equalTo: fromLabel.rightAnchor, constant: 4).isActive = true
        tuesdayFromPicker.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        tuesdayFromPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        tuesdayFromPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let toLabel = UILabel()
        toLabel.text = "To"
        toLabel.textColor = Theme.BLACK
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        toLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        toLabel.contentMode = .center
        tuesdayTimeView.addSubview(toLabel)
        
        toLabel.leftAnchor.constraint(equalTo: tuesdayFromPicker.rightAnchor, constant: 8).isActive = true
        toLabel.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        toLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        tuesdayTimeView.addSubview(tuesdayToPicker)
        tuesdayToPicker.leftAnchor.constraint(equalTo: toLabel.rightAnchor, constant: 4).isActive = true
        tuesdayToPicker.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        tuesdayToPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        tuesdayToPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    var wednesdayTimeView: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.clear
        container.translatesAutoresizingMaskIntoConstraints = false
        container.alpha = 0
        
        let image = UIImage(named: "Expand")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(imageView)
        
        imageView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 8).isActive = true
        imageView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        let label = UILabel()
        label.text = "Wednesday:"
        label.textColor = Theme.BLACK
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)
        
        label.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 4).isActive = true
        label.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        label.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        return container
    }()
    
    var wednesdayFromPicker: UIPickerView = {
        let wednesdayFromPicker = UIPickerView()
        wednesdayFromPicker.backgroundColor = UIColor.clear
        wednesdayFromPicker.tintColor = Theme.BLACK
        wednesdayFromPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        wednesdayFromPicker.translatesAutoresizingMaskIntoConstraints = false
        wednesdayFromPicker.setValue(Theme.BLACK, forKeyPath: "textColor")
        wednesdayFromPicker.alpha = 0
        
        return wednesdayFromPicker
    }()
    
    var wednesdayToPicker: UIPickerView = {
        let wednesdayToPicker = UIPickerView()
        wednesdayToPicker.backgroundColor = UIColor.clear
        wednesdayToPicker.tintColor = Theme.BLACK
        wednesdayToPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        wednesdayToPicker.translatesAutoresizingMaskIntoConstraints = false
        wednesdayToPicker.setValue(Theme.BLACK, forKeyPath: "textColor")
        wednesdayToPicker.alpha = 0
        
        return wednesdayToPicker
    }()
    
    func wednesdayTimePicker() {
        
        let fromLabel = UILabel()
        fromLabel.text = "From"
        fromLabel.textColor = Theme.BLACK
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        fromLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        fromLabel.contentMode = .center
        wednesdayTimeView.addSubview(fromLabel)
        
        fromLabel.leftAnchor.constraint(equalTo: wednesdayTimeView.leftAnchor, constant: 32).isActive = true
        fromLabel.topAnchor.constraint(equalTo: wednesdayTimeView.topAnchor, constant: 4).isActive = true
        fromLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        fromLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        wednesdayTimeView.addSubview(wednesdayFromPicker)
        wednesdayFromPicker.leftAnchor.constraint(equalTo: fromLabel.rightAnchor, constant: 4).isActive = true
        wednesdayFromPicker.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        wednesdayFromPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        wednesdayFromPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let toLabel = UILabel()
        toLabel.text = "To"
        toLabel.textColor = Theme.BLACK
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        toLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        toLabel.contentMode = .center
        wednesdayTimeView.addSubview(toLabel)
        
        toLabel.leftAnchor.constraint(equalTo: wednesdayFromPicker.rightAnchor, constant: 8).isActive = true
        toLabel.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        toLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        wednesdayTimeView.addSubview(wednesdayToPicker)
        wednesdayToPicker.leftAnchor.constraint(equalTo: toLabel.rightAnchor, constant: 4).isActive = true
        wednesdayToPicker.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        wednesdayToPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        wednesdayToPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    var thursdayTimeView: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.clear
        container.translatesAutoresizingMaskIntoConstraints = false
        container.alpha = 0
        
        let image = UIImage(named: "Expand")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(imageView)
        
        imageView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 8).isActive = true
        imageView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        let label = UILabel()
        label.text = "Thursday:"
        label.textColor = Theme.BLACK
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)
        
        label.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 4).isActive = true
        label.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        label.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        return container
    }()
    
    var thursdayFromPicker: UIPickerView = {
        let thursdayFromPicker = UIPickerView()
        thursdayFromPicker.backgroundColor = UIColor.clear
        thursdayFromPicker.tintColor = Theme.BLACK
        thursdayFromPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        thursdayFromPicker.translatesAutoresizingMaskIntoConstraints = false
        thursdayFromPicker.setValue(Theme.BLACK, forKeyPath: "textColor")
        thursdayFromPicker.alpha = 0
        
        return thursdayFromPicker
    }()
    
    var thursdayToPicker: UIPickerView = {
        let thursdayToPicker = UIPickerView()
        thursdayToPicker.backgroundColor = UIColor.clear
        thursdayToPicker.tintColor = Theme.BLACK
        thursdayToPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        thursdayToPicker.translatesAutoresizingMaskIntoConstraints = false
        thursdayToPicker.setValue(Theme.BLACK, forKeyPath: "textColor")
        thursdayToPicker.alpha = 0
        
        return thursdayToPicker
    }()
    
    func thursdayTimePicker() {
        
        let fromLabel = UILabel()
        fromLabel.text = "From"
        fromLabel.textColor = Theme.BLACK
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        fromLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        fromLabel.contentMode = .center
        thursdayTimeView.addSubview(fromLabel)
        
        fromLabel.leftAnchor.constraint(equalTo: thursdayTimeView.leftAnchor, constant: 32).isActive = true
        fromLabel.topAnchor.constraint(equalTo: thursdayTimeView.topAnchor, constant: 4).isActive = true
        fromLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        fromLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        thursdayTimeView.addSubview(thursdayFromPicker)
        thursdayFromPicker.leftAnchor.constraint(equalTo: fromLabel.rightAnchor, constant: 4).isActive = true
        thursdayFromPicker.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        thursdayFromPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        thursdayFromPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let toLabel = UILabel()
        toLabel.text = "To"
        toLabel.textColor = Theme.BLACK
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        toLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        toLabel.contentMode = .center
        thursdayTimeView.addSubview(toLabel)
        
        toLabel.leftAnchor.constraint(equalTo: thursdayFromPicker.rightAnchor, constant: 8).isActive = true
        toLabel.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        toLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        thursdayTimeView.addSubview(thursdayToPicker)
        thursdayToPicker.leftAnchor.constraint(equalTo: toLabel.rightAnchor, constant: 4).isActive = true
        thursdayToPicker.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        thursdayToPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        thursdayToPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    var fridayTimeView: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.clear
        container.translatesAutoresizingMaskIntoConstraints = false
        container.alpha = 0
        
        let image = UIImage(named: "Expand")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(imageView)
        
        imageView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 8).isActive = true
        imageView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        let label = UILabel()
        label.text = "Friday:"
        label.textColor = Theme.BLACK
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)
        
        label.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 4).isActive = true
        label.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        label.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        return container
    }()
    
    var fridayFromPicker: UIPickerView = {
        let fridayFromPicker = UIPickerView()
        fridayFromPicker.backgroundColor = UIColor.clear
        fridayFromPicker.tintColor = Theme.BLACK
        fridayFromPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        fridayFromPicker.translatesAutoresizingMaskIntoConstraints = false
        fridayFromPicker.setValue(Theme.BLACK, forKeyPath: "textColor")
        fridayFromPicker.alpha = 0
        
        return fridayFromPicker
    }()
    
    var fridayToPicker: UIPickerView = {
        let fridayToPicker = UIPickerView()
        fridayToPicker.backgroundColor = UIColor.clear
        fridayToPicker.tintColor = Theme.BLACK
        fridayToPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        fridayToPicker.translatesAutoresizingMaskIntoConstraints = false
        fridayToPicker.setValue(Theme.BLACK, forKeyPath: "textColor")
        fridayToPicker.alpha = 0
        
        return fridayToPicker
    }()
    
    func fridayTimePicker() {
        
        let fromLabel = UILabel()
        fromLabel.text = "From"
        fromLabel.textColor = Theme.BLACK
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        fromLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        fromLabel.contentMode = .center
        fridayTimeView.addSubview(fromLabel)
        
        fromLabel.leftAnchor.constraint(equalTo: fridayTimeView.leftAnchor, constant: 32).isActive = true
        fromLabel.topAnchor.constraint(equalTo: fridayTimeView.topAnchor, constant: 4).isActive = true
        fromLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        fromLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        fridayTimeView.addSubview(fridayFromPicker)
        fridayFromPicker.leftAnchor.constraint(equalTo: fromLabel.rightAnchor, constant: 4).isActive = true
        fridayFromPicker.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        fridayFromPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        fridayFromPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let toLabel = UILabel()
        toLabel.text = "To"
        toLabel.textColor = Theme.BLACK
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        toLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        toLabel.contentMode = .center
        fridayTimeView.addSubview(toLabel)
        
        toLabel.leftAnchor.constraint(equalTo: fridayFromPicker.rightAnchor, constant: 8).isActive = true
        toLabel.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        toLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        fridayTimeView.addSubview(fridayToPicker)
        fridayToPicker.leftAnchor.constraint(equalTo: toLabel.rightAnchor, constant: 4).isActive = true
        fridayToPicker.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        fridayToPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        fridayToPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    var saturdayTimeView: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.clear
        container.translatesAutoresizingMaskIntoConstraints = false
        container.alpha = 0
        
        let image = UIImage(named: "Expand")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(imageView)
        
        imageView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 8).isActive = true
        imageView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        let label = UILabel()
        label.text = "Saturday:"
        label.textColor = Theme.BLACK
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)
        
        label.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 4).isActive = true
        label.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        label.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        return container
    }()
    
    var saturdayFromPicker: UIPickerView = {
        let saturdayFromPicker = UIPickerView()
        saturdayFromPicker.backgroundColor = UIColor.clear
        saturdayFromPicker.tintColor = Theme.BLACK
        saturdayFromPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        saturdayFromPicker.translatesAutoresizingMaskIntoConstraints = false
        saturdayFromPicker.setValue(Theme.BLACK, forKeyPath: "textColor")
        saturdayFromPicker.alpha = 0
        
        return saturdayFromPicker
    }()
    
    var saturdayToPicker: UIPickerView = {
        let saturdayToPicker = UIPickerView()
        saturdayToPicker.backgroundColor = UIColor.clear
        saturdayToPicker.tintColor = Theme.BLACK
        saturdayToPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        saturdayToPicker.translatesAutoresizingMaskIntoConstraints = false
        saturdayToPicker.setValue(Theme.BLACK, forKeyPath: "textColor")
        saturdayToPicker.alpha = 0
        
        return saturdayToPicker
    }()
    
    func saturdayTimePicker() {
        
        let fromLabel = UILabel()
        fromLabel.text = "From"
        fromLabel.textColor = Theme.BLACK
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        fromLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        fromLabel.contentMode = .center
        saturdayTimeView.addSubview(fromLabel)
        
        fromLabel.leftAnchor.constraint(equalTo: saturdayTimeView.leftAnchor, constant: 32).isActive = true
        fromLabel.topAnchor.constraint(equalTo: saturdayTimeView.topAnchor, constant: 4).isActive = true
        fromLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        fromLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        saturdayTimeView.addSubview(saturdayFromPicker)
        saturdayFromPicker.leftAnchor.constraint(equalTo: fromLabel.rightAnchor, constant: 4).isActive = true
        saturdayFromPicker.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        saturdayFromPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        saturdayFromPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let toLabel = UILabel()
        toLabel.text = "To"
        toLabel.textColor = Theme.BLACK
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        toLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        toLabel.contentMode = .center
        saturdayTimeView.addSubview(toLabel)
        
        toLabel.leftAnchor.constraint(equalTo: saturdayFromPicker.rightAnchor, constant: 8).isActive = true
        toLabel.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        toLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        saturdayTimeView.addSubview(saturdayToPicker)
        saturdayToPicker.leftAnchor.constraint(equalTo: toLabel.rightAnchor, constant: 4).isActive = true
        saturdayToPicker.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        saturdayToPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        saturdayToPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    var sundayTimeView: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.clear
        container.translatesAutoresizingMaskIntoConstraints = false
        container.alpha = 0
        
        let image = UIImage(named: "Expand")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(imageView)
        
        imageView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 8).isActive = true
        imageView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        let label = UILabel()
        label.text = "Sunday:"
        label.textColor = Theme.BLACK
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)
        
        label.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 4).isActive = true
        label.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        label.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        return container
    }()
    
    var sundayFromPicker: UIPickerView = {
        let sundayFromPicker = UIPickerView()
        sundayFromPicker.backgroundColor = UIColor.clear
        sundayFromPicker.tintColor = Theme.BLACK
        sundayFromPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        sundayFromPicker.translatesAutoresizingMaskIntoConstraints = false
        sundayFromPicker.setValue(Theme.BLACK, forKeyPath: "textColor")
        sundayFromPicker.alpha = 0
        
        return sundayFromPicker
    }()
    
    var sundayToPicker: UIPickerView = {
        let sundayToPicker = UIPickerView()
        sundayToPicker.backgroundColor = UIColor.clear
        sundayToPicker.tintColor = Theme.BLACK
        sundayToPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        sundayToPicker.translatesAutoresizingMaskIntoConstraints = false
        sundayToPicker.setValue(Theme.BLACK, forKeyPath: "textColor")
        sundayToPicker.alpha = 0
        
        return sundayToPicker
    }()
    
    func sundayTimePicker() {
        
        let fromLabel = UILabel()
        fromLabel.text = "From"
        fromLabel.textColor = Theme.BLACK
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        fromLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        fromLabel.contentMode = .center
        sundayTimeView.addSubview(fromLabel)
        
        fromLabel.leftAnchor.constraint(equalTo: sundayTimeView.leftAnchor, constant: 32).isActive = true
        fromLabel.topAnchor.constraint(equalTo: sundayTimeView.topAnchor, constant: 4).isActive = true
        fromLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        fromLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        sundayTimeView.addSubview(sundayFromPicker)
        sundayFromPicker.leftAnchor.constraint(equalTo: fromLabel.rightAnchor, constant: 4).isActive = true
        sundayFromPicker.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        sundayFromPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        sundayFromPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let toLabel = UILabel()
        toLabel.text = "To"
        toLabel.textColor = Theme.BLACK
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        toLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        toLabel.contentMode = .center
        sundayTimeView.addSubview(toLabel)
        
        toLabel.leftAnchor.constraint(equalTo: sundayFromPicker.rightAnchor, constant: 8).isActive = true
        toLabel.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        toLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        sundayTimeView.addSubview(sundayToPicker)
        sundayToPicker.leftAnchor.constraint(equalTo: toLabel.rightAnchor, constant: 4).isActive = true
        sundayToPicker.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        sundayToPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        sundayToPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        timeFromPicker.delegate = self
        timeFromPicker.dataSource = self
        timeToPicker.delegate = self
        timeToPicker.dataSource = self
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
    
    private let amTimeValues: NSArray = ["All day","1:00 am","1:30 am","2:00 am","2:30 am","3:00 am","3:30 am","4:00 am","4:30 am","5:00 am","5:30 am","6:00 am","6:30 am","7:00 am","7:30 am","8:00 am","8:30 am","9:00 am","9:30 am","10:00 am","10:30 am","11:00 am","11:30 am","12:00 pm","12:30 pm","1:00 pm","1:30 pm","2:00 pm","2:30 pm","3:00 pm","3:30 pm","4:00 pm","4:30 pm","5:00 pm","5:30 pm","6:00 pm","6:30 pm","7:00 pm","7:30 pm","8:00 pm"]
    private let pmTimeValues: NSArray = ["All day","12:00 pm","12:30 pm","1:00 pm","1:30 pm","2:00 pm","2:30 pm","3:00 pm","3:30 pm","4:00 pm","4:30 pm","5:00 pm","5:30 pm","6:00 pm","6:30 pm","7:00 pm","7:30 pm","8:00 pm","8:30 pm","9:00 pm","9:30 pm","10:00 pm","10:30 pm","11:00 pm","11:30 pm","12:00 am","12:30 am"]
    

}
