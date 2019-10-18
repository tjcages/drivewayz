//
//  NewTimeView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/13/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

enum ReservationDateState {
    case today
    case single
    case multiple
}

class NewTimeView: UIViewController {
    
    var delegate: handleDurationChanges?
    var reservationDateState: ReservationDateState = .today {
        didSet {
            fromPicker.reloadAllComponents()
            toPicker.reloadAllComponents()
            
            fromPicker.selectRow(0, inComponent: 0, animated: true)
            fromPicker.selectRow(0, inComponent: 2, animated: true)
            toPicker.selectRow(0, inComponent: 0, animated: true)
            toPicker.selectRow(0, inComponent: 2, animated: true)
            
            var selectedFromArray: [String] = []
            switch reservationDateState {
            case .today:
                selectedFromArray = durationTodayHours
                fromView.textViewText = "Now"
                setData()
            case .single:
                selectedFromArray = durationTodayHours
                fromView.textViewText = "Now"
            case .multiple:
                selectedFromArray = durationHours
                fromView.textViewText = "\(selectedFromArray[0]):\(durationMinutes[1])"
            }

            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm"
            
            let seconds = 2.25 * 3600 // 2 hours and 15 minutes
            let now = Date().addingTimeInterval(seconds).round(precision: (15 * 60), rule: FloatingPointRoundingRule.up)
            let endString = formatter.string(from: now)
            toView.textViewText = endString
            
            setHourLabel()
        }
    }
    
    let fromPicker = UIPickerView()
    let toPicker = UIPickerView()
    
    var selectedFromTime: String = "8:00 AM"
    var selectedToTime: String = "5:00 PM"
    
    var durationHours: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"]
    var durationTodayHours: [String] = []
    var durationMinutes: [String] = ["00", "15", "30", "45"]
    
    var fromHourIndex: Int = 0
    var fromMinuteIndex: Int = 0
    var toHourIndex: Int = 0
    var toMinuteIndex: Int = 0
    
    var fromLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "from"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var toLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "to"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH4
        
        return label
    }()

    var fromView: LineInputAccessoryView = {
        let view = LineInputAccessoryView()
        view.textViewFont = Fonts.SSPSemiBoldH2
        view.textViewText = "Now"
        view.textViewKeyboardType = .numberPad
        view.textViewAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        view.lineUnselectedColor = .clear
        view.lineTextView?.tintColor = .clear
        view.lineTextView?.placeholderLabel.alpha = 0
        
        return view
    }()
    
    lazy var nowButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Now", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.addTarget(self, action: #selector(nowButtonPressed), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    var fromAmButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.setTitle("am", for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH4
        button.layer.cornerRadius = 14
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)
        button.addTarget(self, action: #selector(meridiemPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var fromPmButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLUE
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.setTitle("pm", for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH4
        button.layer.cornerRadius = 14
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)
        button.addTarget(self, action: #selector(meridiemPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var toView: LineInputAccessoryView = {
        let view = LineInputAccessoryView()
        view.textViewFont = Fonts.SSPSemiBoldH2
        view.textViewKeyboardType = .numberPad
        view.textViewAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        view.lineUnselectedColor = .clear
        view.lineTextView?.tintColor = .clear
        view.lineTextView?.placeholderLabel.alpha = 0
        
        return view
    }()
    
    var toAmButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.setTitle("am", for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH4
        button.layer.cornerRadius = 14
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)
        button.addTarget(self, action: #selector(meridiemPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var toPmButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLUE
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.setTitle("pm", for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH4
        button.layer.cornerRadius = 14
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)
        button.addTarget(self, action: #selector(meridiemPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    func setData() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a"
        let meridiem = dateFormatter.string(from: date)
        openFromMeridiem()
        if meridiem == "AM" {
            setMeridiem(sender: fromAmButton)
        } else {
            setMeridiem(sender: fromPmButton)
        }
        changeFromMeridiem()
        
        let seconds = 2.25 * 3600 // 2 hours and 15 minutes
        let toDate = Date().addingTimeInterval(seconds)
        let nextMeridiem = dateFormatter.string(from: toDate)
        openToMeridiem()
        if nextMeridiem == "AM" {
            setMeridiem(sender: toAmButton)
        } else {
            setMeridiem(sender: toPmButton)
        }
        changeToMeridiem()
        
        durationTodayHours = []
        dateFormatter.dateFormat = "h"
        let calendar = Calendar.current
        let currentDate = Date()
        var nextDate = currentDate
        while calendar.isDate(nextDate, inSameDayAs: currentDate) {
            let dateString = dateFormatter.string(from: nextDate)
            self.durationTodayHours.append(dateString)
            nextDate = nextDate.addingTimeInterval(3600)
        }
        fromPicker.reloadAllComponents()
        toPicker.reloadAllComponents()
        setHourLabel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        fromView.lineTextView?.delegate = self
        toView.lineTextView?.delegate = self

        setupViews()
        setupFromTimes()
        setupToTimes()
        createDatePicker()
        setData()
    }
    
    func setupViews() {
        
        view.addSubview(fromLabel)
        view.addSubview(toLabel)
        
        fromLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        fromLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        fromLabel.sizeToFit()
        
        toLabel.topAnchor.constraint(equalTo: fromLabel.bottomAnchor, constant: 32).isActive = true
        toLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        toLabel.sizeToFit()
        
    }
    
    var fromAmRightAnchor: NSLayoutConstraint!
    var nowButtonRightAnchor: NSLayoutConstraint!
    
    func setupFromTimes() {

        view.addSubview(nowButton)
        view.addSubview(fromView)
        view.addSubview(fromPmButton)
        view.addSubview(fromAmButton)
        
        fromView.topAnchor.constraint(equalTo: fromLabel.topAnchor).isActive = true
        fromView.rightAnchor.constraint(equalTo: fromAmButton.leftAnchor, constant: -8).isActive = true
        fromView.heightAnchor.constraint(equalToConstant: 46).isActive = true
        fromView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        
        fromPmButton.centerYAnchor.constraint(equalTo: fromView.centerYAnchor, constant: 4).isActive = true
        fromPmButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        fromPmButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        fromPmButton.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        fromAmButton.centerYAnchor.constraint(equalTo: fromPmButton.centerYAnchor).isActive = true
        fromAmRightAnchor = fromAmButton.rightAnchor.constraint(equalTo: fromPmButton.rightAnchor, constant: -40)
            fromAmRightAnchor.isActive = true
        fromAmButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        fromAmButton.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        nowButton.anchor(top: fromView.topAnchor, left: nil, bottom: fromView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 72, height: 0)
        nowButtonRightAnchor = nowButton.rightAnchor.constraint(equalTo: fromView.leftAnchor, constant: 72)
            nowButtonRightAnchor.isActive = true
        
    }
    
    var toAmRightAnchor: NSLayoutConstraint!
    
    func setupToTimes() {
        
        view.addSubview(toView)
        view.addSubview(toPmButton)
        view.addSubview(toAmButton)
        
        toView.topAnchor.constraint(equalTo: toLabel.topAnchor).isActive = true
        toView.rightAnchor.constraint(equalTo: toAmButton.leftAnchor, constant: -8).isActive = true
        toView.heightAnchor.constraint(equalToConstant: 46).isActive = true
        toView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        
        toPmButton.centerYAnchor.constraint(equalTo: toView.centerYAnchor, constant: 4).isActive = true
        toPmButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        toPmButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        toPmButton.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        toAmButton.centerYAnchor.constraint(equalTo: toPmButton.centerYAnchor).isActive = true
        toAmRightAnchor = toAmButton.rightAnchor.constraint(equalTo: toPmButton.rightAnchor, constant: -40)
            toAmRightAnchor.isActive = true
        toAmButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        toAmButton.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
    }
    
    @objc func nowButtonPressed() {
        view.endEditing(true)
        fromView.textViewText = "Now"
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a"
        let meridiem = dateFormatter.string(from: date)
        openFromMeridiem()
        if meridiem == "AM" {
            setMeridiem(sender: fromAmButton)
        } else {
            setMeridiem(sender: fromPmButton)
        }
        changeFromMeridiem()
        
        setHourLabel()
    }
    
    func setMeridiem(sender: UIButton) {
        if sender == fromPmButton {
            if sender.backgroundColor == Theme.BLUE {
                sender.backgroundColor = .clear
                sender.setTitleColor(Theme.DARK_GRAY, for: .normal)
                fromPmButton.backgroundColor = Theme.BLUE
                fromPmButton.setTitleColor(Theme.WHITE, for: .normal)
                
                fromAmButton.isSelected = false
                fromPmButton.isSelected = true
            } else {
                sender.backgroundColor = Theme.BLUE
                sender.setTitleColor(Theme.WHITE, for: .normal)
                fromAmButton.backgroundColor = .clear
                fromAmButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
                
                fromAmButton.isSelected = false
                fromPmButton.isSelected = true
            }
        } else if sender == fromAmButton {
            if sender.backgroundColor == Theme.BLUE {
                sender.backgroundColor = .clear
                sender.setTitleColor(Theme.DARK_GRAY, for: .normal)
                fromAmButton.backgroundColor = Theme.BLUE
                fromAmButton.setTitleColor(Theme.WHITE, for: .normal)
                
                fromAmButton.isSelected = true
                fromPmButton.isSelected = false
            } else {
                sender.backgroundColor = Theme.BLUE
                sender.setTitleColor(Theme.WHITE, for: .normal)
                fromPmButton.backgroundColor = .clear
                fromPmButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
                
                fromAmButton.isSelected = true
                fromPmButton.isSelected = false
            }
        } else if sender == toPmButton {
            if sender.backgroundColor == Theme.BLUE {
                sender.backgroundColor = .clear
                sender.setTitleColor(Theme.DARK_GRAY, for: .normal)
                toPmButton.backgroundColor = Theme.BLUE
                toPmButton.setTitleColor(Theme.WHITE, for: .normal)
                
                toAmButton.isSelected = false
                toPmButton.isSelected = true
            } else {
                sender.backgroundColor = Theme.BLUE
                sender.setTitleColor(Theme.WHITE, for: .normal)
                toAmButton.backgroundColor = .clear
                toAmButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
                
                toAmButton.isSelected = false
                toPmButton.isSelected = true
            }
        } else if sender == toAmButton {
            if sender.backgroundColor == Theme.BLUE {
                sender.backgroundColor = .clear
                sender.setTitleColor(Theme.DARK_GRAY, for: .normal)
                toAmButton.backgroundColor = Theme.BLUE
                toAmButton.setTitleColor(Theme.WHITE, for: .normal)
                
                toAmButton.isSelected = true
                toPmButton.isSelected = false
            } else {
                sender.backgroundColor = Theme.BLUE
                sender.setTitleColor(Theme.WHITE, for: .normal)
                toPmButton.backgroundColor = .clear
                toPmButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
                
                toAmButton.isSelected = true
                toPmButton.isSelected = false
            }
        }
    }
    
    @objc func meridiemPressed(sender: UIButton) {
        if fromAmButton.alpha == 1 && fromPmButton.alpha == 1 {
            setMeridiem(sender: sender)
        }
        if toAmButton.alpha == 1 && toPmButton.alpha == 1 {
            setMeridiem(sender: sender)
        }
    }

}


extension NewTimeView: UITextViewDelegate {
    
    // Handle when the keyboard is activated so that the textview is always visible
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            delegate?.changeTimeHeight(amount: 0)
            if !fromView.isFirstResponder {
                changeFromMeridiem()
            }
            if !toView.isFirstResponder {
                changeToMeridiem()
            }
        } else {
            delegate?.changeTimeHeight(amount: -(keyboardViewEndFrame.height - view.safeAreaInsets.bottom - 108))
            if fromView.lineTextView != nil {
                if fromView.lineTextView!.isFirstResponder {
                    openFromMeridiem()
                    if fromView.lineTextView?.text == "Now" {
                        var selectedArray: [String] = []
                        switch reservationDateState {
                        case .today:
                            selectedArray = durationTodayHours
                        case .single:
                            selectedArray = durationTodayHours
                        case .multiple:
                            selectedArray = durationHours
                        }
                        fromView.lineTextView?.text = "\(selectedArray[0]):\(durationMinutes[0])"
                        fromPicker.selectRow(0, inComponent: 0, animated: true)
                        fromPicker.selectRow(0, inComponent: 2, animated: true)
                    }
                }
            }
            if toView.lineTextView != nil {
                if toView.lineTextView!.isFirstResponder {
                    openToMeridiem()
                }
            }
        }
        setHourLabel()
    }
    
    func openFromMeridiem() {
        fromAmRightAnchor.constant = -40
        nowButtonRightAnchor.constant = 0
        if fromAmButton.alpha == 1 && fromPmButton.alpha == 0 {
            UIView.animate(withDuration: animationIn) {
                if self.reservationDateState != .multiple {
                    self.nowButton.alpha = 1
                }
                self.fromPmButton.alpha = 1
                self.fromPmButton.backgroundColor = .clear
                self.fromPmButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
                self.fromAmButton.backgroundColor = Theme.BLUE
                self.fromAmButton.setTitleColor(Theme.WHITE, for: .normal)
                self.view.layoutIfNeeded()
            }
        } else if fromPmButton.alpha == 1 && fromAmButton.alpha == 0 {
            UIView.animate(withDuration: animationIn) {
                if self.reservationDateState != .multiple {
                    self.nowButton.alpha = 1
                }
                self.fromAmButton.alpha = 1
                self.fromAmButton.backgroundColor = .clear
                self.fromAmButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
                self.fromPmButton.backgroundColor = Theme.BLUE
                self.fromPmButton.setTitleColor(Theme.WHITE, for: .normal)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func changeFromMeridiem() {
        fromAmRightAnchor.constant = 0
        nowButtonRightAnchor.constant = 72
        if fromAmButton.backgroundColor == Theme.BLUE {
            UIView.animate(withDuration: animationIn) {
                self.nowButton.alpha = 0
                self.fromPmButton.alpha = 0
                self.fromPmButton.backgroundColor = .clear
                self.fromPmButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
                self.fromAmButton.backgroundColor = .clear
                self.fromAmButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
                self.view.layoutIfNeeded()
            }
        } else if fromPmButton.backgroundColor == Theme.BLUE {
            UIView.animate(withDuration: animationIn) {
                self.nowButton.alpha = 0
                self.fromAmButton.alpha = 0
                self.fromAmButton.backgroundColor = .clear
                self.fromAmButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
                self.fromPmButton.backgroundColor = .clear
                self.fromPmButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func openToMeridiem() {
        toAmRightAnchor.constant = -40
        if toAmButton.alpha == 1 && toPmButton.alpha == 0 {
            UIView.animate(withDuration: animationIn) {
                self.toPmButton.alpha = 1
                self.toPmButton.backgroundColor = .clear
                self.toPmButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
                self.toAmButton.backgroundColor = Theme.BLUE
                self.toAmButton.setTitleColor(Theme.WHITE, for: .normal)
                self.view.layoutIfNeeded()
            }
        } else if toPmButton.alpha == 1 && toAmButton.alpha == 0 {
            UIView.animate(withDuration: animationIn) {
                self.toAmButton.alpha = 1
                self.toAmButton.backgroundColor = .clear
                self.toAmButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
                self.toPmButton.backgroundColor = Theme.BLUE
                self.toPmButton.setTitleColor(Theme.WHITE, for: .normal)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func changeToMeridiem() {
        toAmRightAnchor.constant = 0
        if toAmButton.backgroundColor == Theme.BLUE {
            UIView.animate(withDuration: animationIn) {
                self.toPmButton.alpha = 0
                self.toPmButton.backgroundColor = .clear
                self.toPmButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
                self.toAmButton.backgroundColor = .clear
                self.toAmButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
                self.view.layoutIfNeeded()
            }
        } else if toPmButton.backgroundColor == Theme.BLUE {
            UIView.animate(withDuration: animationIn) {
                self.toAmButton.alpha = 0
                self.toAmButton.backgroundColor = .clear
                self.toAmButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
                self.toPmButton.backgroundColor = .clear
                self.toPmButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
}

extension NewTimeView: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    func createDatePicker() {
        fromPicker.delegate = self
        toPicker.delegate = self
        
        fromPicker.inputView?.backgroundColor = .white
        
        fromPicker.selectRow(1, inComponent: 0, animated: false)
        fromPicker.selectRow(1, inComponent: 1, animated: false)
        fromPicker.selectRow(1, inComponent: 2, animated: false)
        
        fromView.lineTextView?.inputView = fromPicker
        toView.lineTextView?.inputView = toPicker
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var selectedArray: [String] = []
        switch reservationDateState {
        case .today:
            selectedArray = durationTodayHours
        case .single:
            if pickerView == fromPicker {
                selectedArray = durationTodayHours
            } else {
                selectedArray = durationHours
            }
        case .multiple:
            selectedArray = durationHours
        }
        if component == 0 {
            return selectedArray.count
        } else if component == 1 {
            return 1
        } else {
            return durationMinutes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var selectedArray: [String] = []
        switch reservationDateState {
        case .today:
            selectedArray = durationTodayHours
        case .single:
            if pickerView == fromPicker {
                selectedArray = durationTodayHours
            } else {
                selectedArray = durationHours
            }
        case .multiple:
            selectedArray = durationHours
        }
        if component == 0 {
            return selectedArray[row]
        } else if component == 1 {
            return ":"
        } else {
            return durationMinutes[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 56
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var selectedArray: [String] = []
        switch reservationDateState {
        case .today:
            selectedArray = durationTodayHours
        case .single:
            if pickerView == fromPicker {
                selectedArray = durationTodayHours
            } else {
                selectedArray = durationHours
            }
        case .multiple:
            selectedArray = durationHours
        }
        if pickerView == fromPicker {
            if component == 0 {
                fromHourIndex = row
                if selectedArray.count > row {
                    fromView.lineTextView?.text = "\(selectedArray[row]):\(durationMinutes[fromMinuteIndex])"
                    if selectedArray.count > (row + 2) {
                        if durationMinutes.count > (fromMinuteIndex + 1) {
                            toView.lineTextView?.text = "\(selectedArray[row + 2]):\(durationMinutes[fromMinuteIndex + 1])"
                        } else {
                            if selectedArray.count > (fromHourIndex + 3) {
                                toView.lineTextView?.text = "\(selectedArray[row + 3]):\(durationMinutes[0])"
                            } else {
                                toView.lineTextView?.text = "\(selectedArray[row + 2]):\(durationMinutes[0])"
                            }
                        }
                    } else if selectedArray.count > (row + 1) {
                        if durationMinutes.count > (fromMinuteIndex + 1) {
                            toView.lineTextView?.text = "\(selectedArray[row + 1]):\(durationMinutes[fromMinuteIndex + 1])"
                        } else {
                            if selectedArray.count > (fromHourIndex + 2) {
                                toView.lineTextView?.text = "\(selectedArray[row + 2]):\(durationMinutes[0])"
                            } else {
                                toView.lineTextView?.text = "\(selectedArray[row + 1]):\(durationMinutes[0])"
                            }
                        }
                    } else if durationMinutes.count > (fromMinuteIndex + 1) {
                        toView.lineTextView?.text = "\(selectedArray[row]):\(durationMinutes[fromMinuteIndex + 1])"
                    }
                }
                if let noonIndex = selectedArray.firstIndex(of: "12") {
                    if row >= noonIndex {
                        openFromMeridiem()
                        setMeridiem(sender: fromPmButton)
                    } else {
                        openFromMeridiem()
                        setMeridiem(sender: fromAmButton)
                    }
                } else {
                    openFromMeridiem()
                    setMeridiem(sender: fromPmButton)
                }
                if reservationDateState != .today {
                    selectedArray = durationHours
                } else {
                    selectedArray = durationTodayHours
                }
                if let noonIndex = selectedArray.firstIndex(of: "12") {
                    if row >= noonIndex {
                        openToMeridiem()
                        setMeridiem(sender: toPmButton)
                    } else {
                        openToMeridiem()
                        setMeridiem(sender: toAmButton)
                    }
                } else {
                    openFromMeridiem()
                    setMeridiem(sender: fromPmButton)
                }
            } else if component == 2 {
                fromMinuteIndex = row
                if durationMinutes.count > row {
                    fromView.lineTextView?.text = "\(selectedArray[fromHourIndex]):\(durationMinutes[row])"
                    if selectedArray.count > (fromHourIndex + 2) {
                        if durationMinutes.count > (row + 1) {
                            toView.lineTextView?.text = "\(selectedArray[fromHourIndex + 2]):\(durationMinutes[row + 1])"
                        } else {
                            if selectedArray.count > (fromHourIndex + 3) {
                                toView.lineTextView?.text = "\(selectedArray[fromHourIndex + 3]):\(durationMinutes[0])"
                            } else {
                                toView.lineTextView?.text = "\(selectedArray[fromHourIndex + 2]):\(durationMinutes[0])"
                            }
                        }
                    } else if selectedArray.count > (fromHourIndex + 1) {
                        if durationMinutes.count > (row + 1) {
                            toView.lineTextView?.text = "\(selectedArray[fromHourIndex + 1]):\(durationMinutes[row + 1])"
                        } else {
                            toView.lineTextView?.text = "\(selectedArray[fromHourIndex + 1]):\(durationMinutes[0])"
                        }
                    } else if durationMinutes.count > (row + 1) {
                        toView.lineTextView?.text = "\(selectedArray[fromHourIndex]):\(durationMinutes[row + 1])"
                    } else {
                        toView.lineTextView?.text = "\(selectedArray[fromHourIndex]):\(durationMinutes[row])"
                    }
                }
            }
        } else {
            if component == 0 {
                toHourIndex = row
                if selectedArray.count > row {
                    toView.lineTextView?.text = "\(selectedArray[row]):\(durationMinutes[toMinuteIndex])"
                }
                if let noonIndex = selectedArray.firstIndex(of: "12") {
                    if row >= noonIndex {
                        openToMeridiem()
                        setMeridiem(sender: toPmButton)
                    } else {
                        openToMeridiem()
                        setMeridiem(sender: toAmButton)
                    }
                } else {
                    openFromMeridiem()
                    setMeridiem(sender: fromPmButton)
                }
            } else if component == 2 {
                toMinuteIndex = row
                if durationMinutes.count > row {
                    if selectedArray.count > toHourIndex {
                        toView.lineTextView?.text = "\(selectedArray[toHourIndex]):\(durationMinutes[row])"
                    } else {
                        toView.lineTextView?.text = "\(selectedArray[(selectedArray.count - 1)]):\(durationMinutes[row])"
                    }
                }
            }
        }
        setHourLabel()
    }
    
    func setHourLabel() {
        var start: String = ""
        var end: String = ""
        
        if let from = fromView.lineTextView?.text {
            start = from
            if fromAmButton.isSelected {
                start += (" AM")
            } else {
                start += (" PM")
            }
        }
        if let to = toView.lineTextView?.text {
            end = to
            if toAmButton.isSelected {
                end += (" AM")
            } else {
                end += (" PM")
            }
        }
        delegate?.changeStartAndEnd(start: start, end: end)
    }
    
}
