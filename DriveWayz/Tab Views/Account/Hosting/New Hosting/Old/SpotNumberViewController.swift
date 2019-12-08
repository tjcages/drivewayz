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
    
    var spotNumbers: [Int] = [12, 123, 1234, 12345] {
        didSet {
            self.multipleSpotsPicker.reloadData()
        }
    }
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        
        return view
    }()
    
    var numberInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.text = "Number of spots"
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var numberField: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "1"
        view.textColor = Theme.DARK_GRAY
        view.font = Fonts.SSPRegularH3
        view.tintColor = .clear
        view.keyboardAppearance = .dark
        view.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        return view
    }()
    
    var numberLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
        return view
    }()
    
    var spotNumberInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
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
        button.layer.cornerRadius = 25/2
        button.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.4).cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = Theme.OFF_WHITE
        button.addTarget(self, action: #selector(checkmarkPressed(sender:)), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        
        return button
    }()
    
    var spotNumberField: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "• • • •"
        view.font = Fonts.SSPRegularH3
        view.textColor = Theme.DARK_GRAY
        view.tintColor = Theme.PACIFIC_BLUE
        view.keyboardType = .numberPad
        view.keyboardAppearance = .dark
        view.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        return view
    }()
    
    var spotNumberLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
        return view
    }()
    
    var multipleSpotNumberInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.text = "Additional spot numbers"
        label.font = Fonts.SSPRegularH5
        label.alpha = 0
        
        return label
    }()
    
    var multipleSpotNumberField: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "• • • •"
        view.font = Fonts.SSPRegularH3
        view.textColor = Theme.DARK_GRAY
        view.tintColor = Theme.PACIFIC_BLUE
        view.keyboardType = .numberPad
        view.keyboardAppearance = .dark
        view.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        view.alpha = 0
        
        return view
    }()
    
    var layout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        
        return layout
    }()
    
    lazy var multipleSpotsPicker: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.clipsToBounds = false
        view.register(SpotNumbers.self, forCellWithReuseIdentifier: "Cell")
        view.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        view.alpha = 0
        
        return view
    }()
    
    var multipleSpotNumberLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        view.alpha = 0
        
        return view
    }()
    
    var gateCodeInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
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
        button.layer.cornerRadius = 25/2
        button.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.4).cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = Theme.OFF_WHITE
        button.addTarget(self, action: #selector(checkmarkPressed(sender:)), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        
        return button
    }()
    
    var gateCodeField: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "• • • •"
        view.font = Fonts.SSPRegularH3
        view.textColor = Theme.DARK_GRAY
        view.tintColor = Theme.PACIFIC_BLUE
        view.keyboardType = .numberPad
        view.keyboardAppearance = .dark
        view.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        return view
    }()
    
    var gateCodeLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
        return view
    }()
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPLightH5
        label.numberOfLines = 3
        label.text = "Any spot number or gate code provided will be hidden until a motorist books the parking space."
        label.textAlignment = .center
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        view.backgroundColor = UIColor.clear
        
        numberField.delegate = self
        spotNumberField.delegate = self
        multipleSpotNumberField.delegate = self
        gateCodeField.delegate = self
        multipleSpotsPicker.delegate = self
        multipleSpotsPicker.dataSource = self
        
        setupViews()
        setupNumber()
        setupCode()
    }
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth, height: phoneHeight - 100)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        scrollView.addGestureRecognizer(tap)
        
        scrollView.addSubview(numberInformation)
        numberInformation.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16).isActive = true
        numberInformation.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        numberInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        numberInformation.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(numberField)
        numberField.topAnchor.constraint(equalTo: numberInformation.bottomAnchor, constant: 8).isActive = true
        numberField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        numberField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        numberField.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        scrollView.addSubview(numberLine)
        numberLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        numberLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -48).isActive = true
        numberLine.bottomAnchor.constraint(equalTo: numberField.bottomAnchor).isActive = true
        numberLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
    
    }
    
    func setupNumber() {
        
        scrollView.addSubview(spotNumberInformation)
        spotNumberInformation.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        spotNumberInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        spotNumberInformation.heightAnchor.constraint(equalToConstant: 20).isActive = true
        spotNumberInformation.topAnchor.constraint(equalTo: numberLine.bottomAnchor, constant: 30).isActive = true
        
        scrollView.addSubview(spotNumberField)
        spotNumberField.topAnchor.constraint(equalTo: spotNumberInformation.bottomAnchor, constant: 8).isActive = true
        spotNumberField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        spotNumberField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        spotNumberField.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        scrollView.addSubview(spotNumberCheckmark)
        spotNumberCheckmark.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        spotNumberCheckmark.centerYAnchor.constraint(equalTo: spotNumberField.centerYAnchor).isActive = true
        spotNumberCheckmark.widthAnchor.constraint(equalToConstant: 25).isActive = true
        spotNumberCheckmark.heightAnchor.constraint(equalTo: spotNumberCheckmark.widthAnchor).isActive = true
        
        scrollView.addSubview(spotNumberLine)
        spotNumberLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        spotNumberLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -48).isActive = true
        spotNumberLine.bottomAnchor.constraint(equalTo: spotNumberField.bottomAnchor).isActive = true
        spotNumberLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        scrollView.addSubview(multipleSpotNumberInformation)
        multipleSpotNumberInformation.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        multipleSpotNumberInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        multipleSpotNumberInformation.heightAnchor.constraint(equalToConstant: 20).isActive = true
        multipleSpotNumberInformation.topAnchor.constraint(equalTo: spotNumberLine.bottomAnchor, constant: 30).isActive = true
        
        scrollView.addSubview(multipleSpotNumberField)
        multipleSpotNumberField.topAnchor.constraint(equalTo: multipleSpotNumberInformation.bottomAnchor, constant: 8).isActive = true
        multipleSpotNumberField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        multipleSpotNumberField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        multipleSpotNumberField.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        scrollView.addSubview(multipleSpotsPicker)
        multipleSpotsPicker.topAnchor.constraint(equalTo: multipleSpotNumberInformation.bottomAnchor, constant: 8).isActive = true
        multipleSpotsPicker.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        multipleSpotsPicker.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        multipleSpotsPicker.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        scrollView.addSubview(multipleSpotNumberLine)
        multipleSpotNumberLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        multipleSpotNumberLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -48).isActive = true
        multipleSpotNumberLine.bottomAnchor.constraint(equalTo: multipleSpotNumberField.bottomAnchor).isActive = true
        multipleSpotNumberLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
    }
    
    var otherNumbersAnchor: NSLayoutConstraint!
    var singleNumbersAnchor: NSLayoutConstraint!
    
    func setupCode() {
        
        scrollView.addSubview(gateCodeInformation)
        gateCodeInformation.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        gateCodeInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        gateCodeInformation.heightAnchor.constraint(equalToConstant: 20).isActive = true
        singleNumbersAnchor = gateCodeInformation.topAnchor.constraint(equalTo: spotNumberLine.bottomAnchor, constant: 30)
            singleNumbersAnchor.isActive = true
        otherNumbersAnchor = gateCodeInformation.topAnchor.constraint(equalTo: multipleSpotNumberLine.bottomAnchor, constant: 30)
            otherNumbersAnchor.isActive = false
        
        scrollView.addSubview(gateCodeField)
        gateCodeField.topAnchor.constraint(equalTo: gateCodeInformation.bottomAnchor, constant: 8).isActive = true
        gateCodeField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        gateCodeField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        gateCodeField.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        scrollView.addSubview(gateCodeCheckmark)
        gateCodeCheckmark.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        gateCodeCheckmark.centerYAnchor.constraint(equalTo: gateCodeField.centerYAnchor).isActive = true
        gateCodeCheckmark.widthAnchor.constraint(equalToConstant: 25).isActive = true
        gateCodeCheckmark.heightAnchor.constraint(equalTo: gateCodeCheckmark.widthAnchor).isActive = true
        
        scrollView.addSubview(gateCodeLine)
        gateCodeLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        gateCodeLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -48).isActive = true
        gateCodeLine.bottomAnchor.constraint(equalTo: gateCodeField.bottomAnchor).isActive = true
        gateCodeLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        scrollView.addSubview(informationLabel)
        informationLabel.topAnchor.constraint(equalTo: gateCodeLine.bottomAnchor, constant: 32).isActive = true
        informationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        informationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        informationLabel.sizeToFit()
        
        createNumberPicker()
        
    }
    
    func guessSpotNumbers() {
        if let firstNumberString = self.spotNumberField.text, var firstNumber = Int(firstNumberString), let numberSpotsString = self.numberField.text, let numberSpots = Int(numberSpotsString) {
            for _ in 0..<(numberSpots - 1) {
                
            }
        }
    }
    
    func otherSpots() {
        self.spotNumberInformation.text = "Enter the first spot number"
        self.otherNumbersAnchor.isActive = true
        self.singleNumbersAnchor.isActive = false
        UIView.animate(withDuration: animationIn) {
            self.multipleSpotNumberInformation.alpha = 1
            self.multipleSpotsPicker.alpha = 1
            self.multipleSpotNumberLine.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func singleSpots() {
        self.spotNumberInformation.text = "Does the spot have a number?"
        self.otherNumbersAnchor.isActive = false
        self.singleNumbersAnchor.isActive = true
        UIView.animate(withDuration: animationIn) {
            self.multipleSpotNumberInformation.alpha = 0
            self.multipleSpotNumberField.alpha = 0
            self.multipleSpotsPicker.alpha = 0
            self.multipleSpotNumberLine.alpha = 0
            self.view.layoutIfNeeded()
        }
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
                if sender == self.spotNumberCheckmark, self.numberField.text != "1" {
                    self.otherSpots()
                }
            }
        } else {
            UIView.animate(withDuration: 0.1, animations: {
                sender.tintColor = .clear
                sender.backgroundColor = Theme.OFF_WHITE
                sender.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.4).cgColor
            }) { (success) in
                if sender == self.spotNumberCheckmark, self.numberField.text != "1" {
                    self.singleSpots()
                }
            }
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
        toolBar.barTintColor = Theme.DARK_GRAY
        toolBar.tintColor = Theme.WHITE
        toolBar.layer.borderColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.4).cgColor
        toolBar.layer.borderWidth = 0.5
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        numberField.inputAccessoryView = toolBar
        spotNumberField.inputAccessoryView = toolBar
        multipleSpotNumberField.inputAccessoryView = toolBar
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
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


extension SpotNumberViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return spotNumbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let amenitiesText = spotNumbers[indexPath.row]
        let stringText = String(amenitiesText)
        let width = stringText.width(withConstrainedHeight: 36, font: Fonts.SSPRegularH3) + 8
        
        return CGSize(width: width, height: 36)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! SpotNumbers
        if spotNumbers.count == (indexPath.row + 1) {
            cell.iconLabel.text = "\(spotNumbers[indexPath.row])"
        } else if spotNumbers.count > 1 {
            cell.iconLabel.text = "\(spotNumbers[indexPath.row]),"
        } else {
            cell.iconLabel.text = "\(spotNumbers[indexPath.row])"
        }
        
        return cell
    }
    
}


extension SpotNumberViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {
    
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
        label.font = Fonts.SSPRegularH3
        label.text = "\(numbers[row])"
        
        return label
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "• • • •" {
            textView.text = ""
        }
        if textView == self.spotNumberField {
            self.spotNumberField.backgroundColor = Theme.BLUE.withAlphaComponent(0.1)
            self.spotNumberLine.backgroundColor = Theme.BLUE
            self.scrollView.scrollToView(view: numberInformation, animated: true, offset: 16)
        } else if textView == self.numberField {
            self.numberField.backgroundColor = Theme.BLUE.withAlphaComponent(0.1)
            self.numberLine.backgroundColor = Theme.BLUE
        } else if textView == self.gateCodeField {
            self.gateCodeField.backgroundColor = Theme.BLUE.withAlphaComponent(0.1)
            self.gateCodeLine.backgroundColor = Theme.BLUE
            self.scrollView.scrollToView(view: gateCodeInformation, animated: true, offset: 16)
        } else if textView == self.multipleSpotNumberField {
            self.scrollView.scrollToView(view: spotNumberInformation, animated: true, offset: 16)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "• • • •"
            if textView == spotNumberField {
                self.checkmarkPressed(bool: false, sender: self.spotNumberCheckmark)
            } else if textView == gateCodeField {
                self.checkmarkPressed(bool: false, sender: self.gateCodeCheckmark)
            }
        }
        if textView == self.spotNumberField {
            self.spotNumberField.backgroundColor = UIColor.clear
            self.spotNumberLine.backgroundColor = lineColor
        } else if textView == self.numberField {
            self.numberField.backgroundColor = UIColor.clear
            self.numberLine.backgroundColor = lineColor
        } else if textView == self.gateCodeField {
            self.gateCodeField.backgroundColor = UIColor.clear
            self.gateCodeLine.backgroundColor = lineColor
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == numberField {
            return false
        }
        if textView == spotNumberField {
            self.checkmarkPressed(bool: true, sender: self.spotNumberCheckmark)
        } else if textView == gateCodeField {
            self.checkmarkPressed(bool: true, sender: self.gateCodeCheckmark)
        }
        return true
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            self.scrollView.contentInset = .zero
        } else {
            self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset
    }
    
}


class SpotNumbers: UICollectionViewCell {
    
    var iconLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .center
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    func setupViews() {
        
        self.addSubview(iconLabel)
        iconLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        iconLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        iconLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        iconLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
