//
//  DayAvailabilityViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/7/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class DayAvailabilityViewController: UIViewController {
    
    let numberPicker = UIPickerView()
    var selectedFromTime: String = "8:00 AM"
    var selectedToTime: String = "5:00 PM"
    var additionalToTime: String?
    var additionalFromTime: String?
    var dayAvailable: Int = 0
    
    var durationFromTimes: [String] = ["1:00 AM","2:00 AM","3:00 AM","4:00 AM","5:00 AM","6:00 AM","7:00 AM","8:00 AM","9:00 AM","10:00 AM","11:00 AM","12:00 PM","1:00 PM","2:00 PM","3:00 PM","4:00 PM","5:00 PM","6:00 PM","7:00 PM","8:00 PM","9:00 PM","10:00 PM","11:00 PM"]
    var durationToTimes: [String] = ["9:00 AM","10:00 AM","11:00 AM","12:00 PM","1:00 PM","2:00 PM","3:00 PM","4:00 PM","5:00 PM","6:00 PM","7:00 PM","8:00 PM","9:00 PM","10:00 PM","11:00 PM","11:59 PM"]
    
    var dayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Monday"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var customButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Custom", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.addTarget(self, action: #selector(customPressed), for: .touchUpInside)
        button.contentHorizontalAlignment = .right
        
        return button
    }()
    
    var shadowContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.GRAY_WHITE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var secondSelection: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().customVerticalColor(topColor: Theme.BLUE, bottomColor: Theme.BLUE.lighter(by: 20)!)
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: 80)
        background.zPosition = -10
        button.layer.addSublayer(background)
        let origImage = UIImage(named: "Checkmark")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(selectionPressed(sender:)), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    var durationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true
        
        return view
    }()
    
    var durationFromButton: UITextField = {
        let button = UITextField()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.text = "8:00 AM"
        button.textColor = Theme.BLACK
        button.font = Fonts.SSPSemiBoldH3
        button.textAlignment = .right
        button.tintColor = .clear
        
        return button
    }()
    
    var durationToButton: UITextField = {
        let button = UITextField()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.text = "5:00 PM"
        button.textColor = Theme.BLACK
        button.font = Fonts.SSPSemiBoldH3
        button.textAlignment = .left
        button.tintColor = .clear
        
        return button
    }()
    
    var allDayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "All day"
        label.font = Fonts.SSPSemiBoldH3
        label.textAlignment = .center
        
        return label
    }()
    
    var arrow: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.tintColor = Theme.GRAY_WHITE.withAlphaComponent(0.4)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var fromLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.GREEN
        view.layer.cornerRadius = 5
        view.alpha = 0
        
        return view
    }()
    
    var toLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.GREEN
        view.layer.cornerRadius = 5
        view.alpha = 0
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        durationFromButton.delegate = self
        durationToButton.delegate = self
        
        setupViews()
        setupDuration()
        setupButtons()
        setupHidden()
        createDatePicker()
    }
    
    func setupViews() {
        
        self.view.addSubview(dayLabel)
        dayLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        dayLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        dayLabel.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        dayLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.view.addSubview(customButton)
        customButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        customButton.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        customButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        customButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.view.addSubview(shadowContainer)
        shadowContainer.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
        shadowContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        shadowContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        shadowContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        shadowContainer.addSubview(container)
        container.topAnchor.constraint(equalTo: shadowContainer.topAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: shadowContainer.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: shadowContainer.rightAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: shadowContainer.bottomAnchor).isActive = true
        
        container.addSubview(line)
        line.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        line.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        line.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    var durationViewWidthAnchor: NSLayoutConstraint!
    
    func setupDuration() {
        
        container.addSubview(allDayLabel)
        allDayLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16).isActive = true
        allDayLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        allDayLabel.sizeToFit()
        
        container.addSubview(durationView)
        durationView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        durationView.bottomAnchor.constraint(equalTo: line.topAnchor).isActive = true
        durationView.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        durationViewWidthAnchor = durationView.widthAnchor.constraint(equalToConstant: 0)
            durationViewWidthAnchor.isActive = true
        
        durationView.addSubview(durationFromButton)
        durationFromButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 12).isActive = true
        durationFromButton.rightAnchor.constraint(equalTo: container.centerXAnchor, constant: -48).isActive = true
        durationFromButton.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 24).isActive = true
        durationFromButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        durationView.addSubview(durationToButton)
        durationToButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 12).isActive = true
        durationToButton.leftAnchor.constraint(equalTo: container.centerXAnchor, constant: 48).isActive = true
        durationToButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -24).isActive = true
        durationToButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        durationView.addSubview(arrow)
        arrow.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        arrow.centerYAnchor.constraint(equalTo: durationFromButton.centerYAnchor).isActive = true
        arrow.widthAnchor.constraint(equalToConstant: 20).isActive = true
        arrow.heightAnchor.constraint(equalTo: arrow.widthAnchor).isActive = true
        
        durationView.addSubview(fromLine)
        fromLine.widthAnchor.constraint(equalToConstant: 10).isActive = true
        fromLine.centerYAnchor.constraint(equalTo: durationFromButton.centerYAnchor).isActive = true
        fromLine.heightAnchor.constraint(equalTo: fromLine.widthAnchor).isActive = true
        fromLine.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 32).isActive = true
        
        durationView.addSubview(toLine)
        toLine.widthAnchor.constraint(equalToConstant: 10).isActive = true
        toLine.centerYAnchor.constraint(equalTo: durationToButton.centerYAnchor).isActive = true
        toLine.heightAnchor.constraint(equalTo: toLine.widthAnchor).isActive = true
        toLine.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -32).isActive = true
        
    }

    func setupButtons() {
        
        container.addSubview(secondSelection)
        secondSelection.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        secondSelection.topAnchor.constraint(equalTo: line.topAnchor).isActive = true
        secondSelection.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        secondSelection.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        
        self.customPressed()
//        self.secondSelection.alpha = 0
    }
    
    func createDatePicker() {
        numberPicker.delegate = self
        numberPicker.backgroundColor = Theme.BLACK.withAlphaComponent(0.6)
        durationFromButton.inputView = numberPicker
        durationToButton.inputView = numberPicker
        createToolbar()
    }
    
    
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = Theme.BLACK
        toolBar.tintColor = Theme.WHITE
        toolBar.layer.borderColor = Theme.GRAY_WHITE.withAlphaComponent(0.4).cgColor
        toolBar.layer.borderWidth = 0.5
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        durationFromButton.inputAccessoryView = toolBar
        durationToButton.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func customPressed() {
        self.view.endEditing(true)
        if self.durationViewWidthAnchor.constant == 0 {
            self.durationViewWidthAnchor.constant = phoneWidth - 24
            UIView.animate(withDuration: animationIn, animations: {
                self.customButton.setTitle("ALL DAY", for: .normal)
                self.view.layoutIfNeeded()
            }) { (success) in
                if let from = self.durationFromButton.text, let to = self.durationToButton.text {
                    self.selectedFromTime = from
                    self.selectedToTime = to
                    self.additionalFromTime = nil
                    self.additionalToTime = nil
                }
            }
        } else {
            self.durationViewWidthAnchor.constant = 0
            UIView.animate(withDuration: animationIn, animations: {
                self.customButton.setTitle("Specific Times", for: .normal)
                self.secondSelection.alpha = 1
                self.view.layoutIfNeeded()
            }) { (success) in
                self.checkSelectedTimes()
                self.selectedFromTime = "All day"
                self.selectedToTime = "All day"
            }
        }
    }
    
    @objc func selectionPressed(sender: UIButton) {
        self.view.endEditing(true)
        if sender == self.secondSelection {
            self.secondSelection.alpha = 0
        }
        self.checkSelectedTimes()
    }
    
    @objc func hiddenPressed(sender: UIButton) {
        self.view.endEditing(true)
        if sender == self.secondHidden {
            self.secondSelection.alpha = 1
        }
        self.checkSelectedTimes()
    }
    
    func checkSelectedTimes() {
        if self.secondSelection.alpha == 1 {
            self.dayAvailable = 1
        } else {
            self.dayAvailable = 0
        }
    }
    
    func setupHidden() {
        
        container.addSubview(secondHidden)
        container.sendSubviewToBack(secondHidden)
        secondHidden.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        secondHidden.topAnchor.constraint(equalTo: line.topAnchor).isActive = true
        secondHidden.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        secondHidden.widthAnchor.constraint(equalTo: secondSelection.widthAnchor).isActive = true
        
    }
    
    var secondHidden: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let origImage = UIImage(named: "exit")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.GRAY_WHITE
        button.addTarget(self, action: #selector(hiddenPressed(sender:)), for: .touchUpInside)
        
        return button
    }()

}


extension DayAvailabilityViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.fromLine.alpha == 1 {
            return durationFromTimes.count
        } else if self.toLine.alpha == 1 {
            return durationToTimes.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if self.fromLine.alpha == 1 {
            return "\(durationFromTimes[row])"
        } else if self.toLine.alpha == 1 {
            return "\(durationToTimes[row])"
        } else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.fromLine.alpha == 1 {
            self.selectedFromTime = "\(self.durationFromTimes[row])"
            self.durationFromButton.text = self.selectedFromTime
            self.changeToDates()
        } else if self.toLine.alpha == 1 {
            self.selectedToTime = "\(self.durationToTimes[row])"
            self.durationToButton.text = self.selectedToTime
        }
        self.secondSelection.alpha = 1
        self.checkSelectedTimes()
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        label.textColor = Theme.WHITE
        label.textAlignment = .center
        label.font = Fonts.SSPSemiBoldH2
        if self.fromLine.alpha == 1 {
            if self.durationFromTimes.count > row {
                label.text = "\(durationFromTimes[row])"
            }
        } else if self.toLine.alpha == 1 {
            if self.durationToTimes.count > row {
                label.text = "\(durationToTimes[row])"
            }
        }
        
        return label
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.durationFromButton {
            self.fromLine.alpha = 1
        } else if textField == self.durationToButton {
            self.toLine.alpha = 1
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.numberPicker.reloadAllComponents()
        if textField == self.durationFromButton {
            self.fromLine.alpha = 0
        } else if textField == self.durationToButton {
            self.toLine.alpha = 0
        }
    }
    
    @objc func changeToDates() {
        let fromDate = self.selectedFromTime
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        if let date = dateFormatter.date(from: fromDate), var toDate = dateFormatter.date(from: fromDate) {
            self.durationToTimes = []
            let firstDate = toDate.addingTimeInterval(3600)
            let firstString = dateFormatter.string(from: firstDate)
            self.durationToButton.text = firstString
            while Calendar.current.isDate(date, inSameDayAs: toDate) {
                toDate = toDate.addingTimeInterval(3600)
                let stringDate = dateFormatter.string(from: toDate)
                self.durationToTimes.append(stringDate)
            }
            self.numberPicker.reloadAllComponents()
        }
    }
    
}
