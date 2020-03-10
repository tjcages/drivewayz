//
//  ListingNumberView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/24/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ListingNumberView: UIViewController {
    
    var delegate: HandleListingDetails?
    var spotRange: [Int] = []
    
    var customNumbers: [Int] = [] {
        didSet {
            if customNumbers.count > 0 {
                customNumbersPicker.reloadData()
                showCustomNumbers()
            } else {
                hideCustomNumbers()
            }
        }
    }
    
    var numberSpots: Int = 0 {
        didSet {
            if self.numberSpots > 1 {
                createNextToolbar()
            } else {
                createToolbar()
            }
        }
    }

    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Spot number"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Select this if the driver is required to park in a numbered space."
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH5
        label.numberOfLines = 2
        
        return label
    }()
    
    var switchButton: UISwitch = {
        let view = UISwitch()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onTintColor = Theme.BLUE
        view.tintColor = Theme.LINE_GRAY
        view.addTarget(self, action: #selector(switchPressed(sender:)), for: .valueChanged)
        
        return view
    }()
    
    var informationIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "informationIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        
        return button
    }()
    
    var mainTextView: UITextView = {
        let view = UITextView()
        view.textColor = Theme.BLACK
        view.font = Fonts.SSPRegularH2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.keyboardType = .numberPad
        view.tintColor = .clear
        view.textAlignment = .center
        view.keyboardAppearance = .dark
        view.alpha = 0
        
        return view
    }()
    
    var textViewLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        view.alpha = 0
        
        return view
    }()
    
    var secondMainTextView: UITextView = {
        let view = UITextView()
        view.textColor = Theme.BLACK
        view.font = Fonts.SSPRegularH2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.keyboardType = .numberPad
        view.tintColor = .clear
        view.textAlignment = .center
        view.keyboardAppearance = .dark
        view.alpha = 0
        
        return view
    }()
    
    var secondTextViewLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        view.alpha = 0
        
        return view
    }()
    
    var toLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "to"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH5
        label.alpha = 0
        
        return label
    }()
    
    var addRangeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add another range", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.contentHorizontalAlignment = .left
        button.alpha = 0
        button.addTarget(self, action: #selector(addRangePressed), for: .touchUpInside)
        
        return button
    }()
    
    var customNumbersButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Custom numbers", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.contentHorizontalAlignment = .left
        button.alpha = 0
        
        return button
    }()
    
    lazy var bubbleArrow: BubbleArrow = {
        let view = BubbleArrow()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.message = "Please enter how many spots are being listed first."
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.2
        view.rightTriangle()
        view.horizontalTriangle()
        view.label.font = Fonts.SSPRegularH5
        view.alpha = 0
        
        return view
    }()
    
    var mainTextView2: UITextView = {
        let view = UITextView()
        view.textColor = Theme.BLACK
        view.font = Fonts.SSPRegularH2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.keyboardType = .numberPad
        view.tintColor = .clear
        view.textAlignment = .center
        view.keyboardAppearance = .dark
        view.alpha = 0
        
        return view
    }()
    
    var textViewLine2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        view.alpha = 0
        
        return view
    }()
    
    var secondMainTextView2: UITextView = {
        let view = UITextView()
        view.textColor = Theme.BLACK
        view.font = Fonts.SSPRegularH2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.keyboardType = .numberPad
        view.tintColor = .clear
        view.textAlignment = .center
        view.keyboardAppearance = .dark
        view.alpha = 0
        
        return view
    }()
    
    var secondTextViewLine2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        view.alpha = 0
        
        return view
    }()
    
    var toLabel2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "to"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH5
        label.alpha = 0
        
        return label
    }()
    
    var removeRangeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.LINE_GRAY
        let image = UIImage(named: "exit")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.layer.cornerRadius = 16
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.alpha = 0
        button.addTarget(self, action: #selector(removeRangePressed), for: .touchUpInside)
        
        return button
    }()
    
    var layout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        
        return layout
    }()
    
    lazy var customNumbersPicker: UICollectionView = {
        let picker = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        picker.backgroundColor = UIColor.clear
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.showsHorizontalScrollIndicator = false
        picker.showsVerticalScrollIndicator = false
        picker.register(CustomNumbersCell.self, forCellWithReuseIdentifier: "identifier")
        picker.decelerationRate = .fast
        picker.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        picker.alpha = 0
        
        return picker
    }()
    
    var editNumbersButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit numbers", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.contentHorizontalAlignment = .left
        button.alpha = 0
//        button.addTarget(self, action: #selector(addRangePressed), for: .touchUpInside)
        
        return button
    }()
    
    var numberRangeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Number range", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.contentHorizontalAlignment = .left
        button.alpha = 0
        button.addTarget(self, action: #selector(hideCustomNumbers), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = true
        
        mainTextView.delegate = self
        secondMainTextView.delegate = self
        mainTextView2.delegate = self
        secondMainTextView2.delegate = self
        customNumbersPicker.delegate = self
        customNumbersPicker.dataSource = self

        setupViews()
        setupTextViews()
        setupSecondRange()
        
        createToolbar()
    }
        
    func setupViews() {
        
        view.addSubview(switchButton)
        view.addSubview(mainLabel)
        view.addSubview(subLabel)
        view.addSubview(informationIcon)
        
        switchButton.topAnchor.constraint(equalTo: mainLabel.topAnchor).isActive = true
        switchButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        switchButton.widthAnchor.constraint(equalToConstant: 51).isActive = true
        switchButton.heightAnchor.constraint(equalToConstant: 31).isActive = true
        
        mainLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()

        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 4).isActive = true
        subLabel.leftAnchor.constraint(equalTo: mainLabel.leftAnchor).isActive = true
        subLabel.rightAnchor.constraint(equalTo: switchButton.leftAnchor, constant: -20).isActive = true
        subLabel.sizeToFit()
        
        informationIcon.centerYAnchor.constraint(equalTo: mainLabel.centerYAnchor).isActive = true
        informationIcon.leftAnchor.constraint(equalTo: mainLabel.rightAnchor, constant: 4).isActive = true
        informationIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        informationIcon.widthAnchor.constraint(equalTo: informationIcon.heightAnchor).isActive = true
        
    }
    
    var textViewWidthAnchor: NSLayoutConstraint!
    var secondTextViewWidthAnchor: NSLayoutConstraint!
    
    func setupTextViews() {
        
        view.addSubview(mainTextView)
        view.addSubview(textViewLine)
        
        mainTextView.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 8).isActive = true
        mainTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainTextView.heightAnchor.constraint(equalToConstant: 46).isActive = true
        textViewWidthAnchor = mainTextView.widthAnchor.constraint(equalToConstant: 32)
            textViewWidthAnchor.isActive = true
        
        textViewLine.anchor(top: nil, left: mainTextView.leftAnchor, bottom: mainTextView.bottomAnchor, right: mainTextView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 2)
        
        view.addSubview(toLabel)
        view.addSubview(secondMainTextView)
        view.addSubview(secondTextViewLine)
        
        toLabel.leftAnchor.constraint(equalTo: mainTextView.rightAnchor, constant: 16).isActive = true
        toLabel.bottomAnchor.constraint(equalTo: textViewLine.bottomAnchor).isActive = true
        toLabel.sizeToFit()
        
        secondMainTextView.topAnchor.constraint(equalTo: mainTextView.topAnchor).isActive = true
        secondMainTextView.leftAnchor.constraint(equalTo: toLabel.rightAnchor, constant: 16).isActive = true
        secondMainTextView.heightAnchor.constraint(equalToConstant: 46).isActive = true
        secondTextViewWidthAnchor = secondMainTextView.widthAnchor.constraint(equalToConstant: 32)
            secondTextViewWidthAnchor.isActive = true
        
        secondTextViewLine.anchor(top: nil, left: secondMainTextView.leftAnchor, bottom: secondMainTextView.bottomAnchor, right: secondMainTextView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 2)
        
        view.addSubview(customNumbersPicker)
        customNumbersPicker.anchor(top: mainTextView.topAnchor, left: view.leftAnchor, bottom: mainTextView.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(addRangeButton)
        view.addSubview(customNumbersButton)
        
        addRangeButton.topAnchor.constraint(equalTo: mainTextView.bottomAnchor, constant: 16).isActive = true
        addRangeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        addRangeButton.sizeToFit()
        
        customNumbersButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        customNumbersButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        customNumbersButton.sizeToFit()
        
        view.addSubview(editNumbersButton)
        view.addSubview(numberRangeButton)
        
        editNumbersButton.topAnchor.constraint(equalTo: mainTextView.bottomAnchor, constant: 16).isActive = true
        editNumbersButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        editNumbersButton.sizeToFit()
        
        numberRangeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        numberRangeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        numberRangeButton.sizeToFit()
        
        view.addSubview(bubbleArrow)
        bubbleArrow.leftAnchor.constraint(equalTo: mainTextView.rightAnchor, constant: 32).isActive = true
        bubbleArrow.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        bubbleArrow.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        bubbleArrow.heightAnchor.constraint(equalToConstant: 68).isActive = true
        
    }
    
    var textViewWidthAnchor2: NSLayoutConstraint!
    var secondTextViewWidthAnchor2: NSLayoutConstraint!
    
    func setupSecondRange() {
        
        view.addSubview(mainTextView2)
        view.addSubview(textViewLine2)
        
        mainTextView2.topAnchor.constraint(equalTo: mainTextView.bottomAnchor, constant: 16).isActive = true
        mainTextView2.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainTextView2.heightAnchor.constraint(equalToConstant: 46).isActive = true
        textViewWidthAnchor2 = mainTextView2.widthAnchor.constraint(equalToConstant: 32)
            textViewWidthAnchor2.isActive = true
        
        textViewLine2.anchor(top: nil, left: mainTextView2.leftAnchor, bottom: mainTextView2.bottomAnchor, right: mainTextView2.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 2)
        
        view.addSubview(toLabel2)
        view.addSubview(secondMainTextView2)
        view.addSubview(secondTextViewLine2)
        
        toLabel2.leftAnchor.constraint(equalTo: mainTextView2.rightAnchor, constant: 16).isActive = true
        toLabel2.bottomAnchor.constraint(equalTo: textViewLine2.bottomAnchor).isActive = true
        toLabel2.sizeToFit()
        
        secondMainTextView2.topAnchor.constraint(equalTo: mainTextView2.topAnchor).isActive = true
        secondMainTextView2.leftAnchor.constraint(equalTo: toLabel2.rightAnchor, constant: 16).isActive = true
        secondMainTextView2.heightAnchor.constraint(equalToConstant: 46).isActive = true
        secondTextViewWidthAnchor2 = secondMainTextView2.widthAnchor.constraint(equalToConstant: 32)
            secondTextViewWidthAnchor2.isActive = true
        
        secondTextViewLine2.anchor(top: nil, left: secondMainTextView2.leftAnchor, bottom: secondMainTextView2.bottomAnchor, right: secondMainTextView2.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 2)
        
        view.addSubview(removeRangeButton)
        removeRangeButton.centerYAnchor.constraint(equalTo: mainTextView2.centerYAnchor).isActive = true
        removeRangeButton.anchor(top: nil, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 32, height: 32)
        
    }
    
    func collectNumbers(numberz: Int) -> Bool {
        if !switchButton.isOn { return true }
        if mainTextView.alpha == 1 && secondMainTextView.alpha == 0 {
            // Only one spot
            guard let number = Int(mainTextView.text) else { return false }
            spotRange = [number]
        } else if mainTextView.alpha == 1 && secondMainTextView.alpha == 1 && mainTextView2.alpha == 0 {
            // Only one range
            guard let number = Int(mainTextView.text), let number2 = Int(secondMainTextView.text) else { return false }
            var range: [Int] = []
            for num in number...number2 {
                range.append(num)
            }
            if range.count != numberz {
                return false
            }
            spotRange = range
        } else if mainTextView.alpha == 1 && secondMainTextView.alpha == 1 && mainTextView2.alpha == 1 && secondMainTextView2.alpha == 1 {
            // Two ranges
            guard let number = Int(mainTextView.text), let number2 = Int(secondMainTextView.text), let number3 = Int(mainTextView.text), let number4 = Int(secondMainTextView.text) else { return false }
            var range: [Int] = []
            for num in number...number2 {
                range.append(num)
            }
            for num in number3...number4 {
                range.append(num)
            }
            if range.count != numberz {
                return false
            }
            spotRange = range
        } else if customNumbersPicker.alpha == 1 {
            // Custom numbers
            if customNumbers.count != numberz {
                return false
            } else {
                spotRange = customNumbers
            }
        } else {
            // No numbers
            return false
        }
        return true
    }
    
    @objc func switchPressed(sender: UISwitch) {
        delegate?.dismissKeyboard()
        if let check = delegate?.checkNumber() {
            if check {
                if sender.isOn {
                    spotViewExpanded()
                } else {
                    spotViewDismissed()
                }
            } else {
                sender.setOn(false, animated: true)
            }
        }
    }
    
    func spotViewExpanded() {
        delegate?.expandSpotView()
        UIView.animate(withDuration: animationIn) {
            self.mainTextView.alpha = 1
            self.textViewLine.alpha = 1
            if self.numberSpots > 1 {
                self.addRangeButton.alpha = 1
                self.customNumbersButton.alpha = 1
                self.secondMainTextView.alpha = 1
                self.secondTextViewLine.alpha = 1
                self.toLabel.alpha = 1
            }
        }
    }
    
    func spotViewDismissed() {
        delegate?.dismissKeyboard()
        delegate?.minimizeSpotView()
        UIView.animate(withDuration: animationIn) {
            self.bubbleArrow.alpha = 0
            self.mainTextView.alpha = 0
            self.textViewLine.alpha = 0
            self.addRangeButton.alpha = 0
            self.customNumbersButton.alpha = 0
            self.secondMainTextView.alpha = 0
            self.secondTextViewLine.alpha = 0
            self.toLabel.alpha = 0
            self.customNumbersPicker.alpha = 0
            self.editNumbersButton.alpha = 0
            self.numberRangeButton.alpha = 0
            
            self.addRangeButton.alpha = 1
            self.mainTextView2.alpha = 0
            self.textViewLine2.alpha = 0
            self.secondMainTextView2.alpha = 0
            self.secondTextViewLine2.alpha = 0
            self.toLabel2.alpha = 0
            self.removeRangeButton.alpha = 0
        }
    }
    
    @objc func addRangePressed() {
        delegate?.addSpotRange()
        UIView.animate(withDuration: animationIn) {
            self.addRangeButton.alpha = 0
            self.mainTextView2.alpha = 1
            self.textViewLine2.alpha = 1
            self.secondMainTextView2.alpha = 1
            self.secondTextViewLine2.alpha = 1
            self.toLabel2.alpha = 1
            self.removeRangeButton.alpha = 1
        }
    }
    
    @objc func removeRangePressed() {
        delegate?.removeSpotRange()
        UIView.animate(withDuration: animationIn) {
            self.addRangeButton.alpha = 1
            self.mainTextView2.alpha = 0
            self.textViewLine2.alpha = 0
            self.secondMainTextView2.alpha = 0
            self.secondTextViewLine2.alpha = 0
            self.toLabel2.alpha = 0
            self.removeRangeButton.alpha = 0
        }
    }
    
    func showCustomNumbers() {
        delegate?.expandSpotView()
        switchButton.setOn(true, animated: true)
        UIView.animate(withDuration: animationIn, animations: {
            self.mainTextView.alpha = 0
            self.mainTextView2.alpha = 0
            self.secondMainTextView.alpha = 0
            self.secondMainTextView2.alpha = 0
            self.toLabel.alpha = 0
            self.toLabel2.alpha = 0
            self.addRangeButton.alpha = 0
            self.customNumbersButton.alpha = 0
        }) { (sucess) in
            UIView.animate(withDuration: animationIn) {
                self.customNumbersPicker.alpha = 1
                self.editNumbersButton.alpha = 1
                self.numberRangeButton.alpha = 1
            }
        }
    }
    
    @objc func hideCustomNumbers() {
        UIView.animate(withDuration: animationIn, animations: {
            self.customNumbersPicker.alpha = 0
            self.editNumbersButton.alpha = 0
            self.numberRangeButton.alpha = 0
        }) { (sucess) in
            self.spotViewExpanded()
            self.switchButton.setOn(true, animated: true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if switchButton.isOn {
            mainTextView.becomeFirstResponder()
        } else {
            if let check = delegate?.checkNumber() {
                if check {
                    delegate?.unselectViews()
                    switchButton.setOn(true, animated: true)
                    spotViewExpanded()
                } else {
                    switchButton.setOn(false, animated: true)
                }
            }
        }
    }
}

extension ListingNumberView: UITextViewDelegate {
    
    // Build the 'Done' button to dismiss keyboard
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = Theme.BLACK
        toolBar.sizeToFit()
        toolBar.tintColor = Theme.WHITE
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        doneButton.setTitleTextAttributes([ NSAttributedString.Key.font: Fonts.SSPSemiBoldH4], for: UIControl.State.normal)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        mainTextView.inputAccessoryView = toolBar
        secondMainTextView.inputAccessoryView = toolBar
        mainTextView2.inputAccessoryView = toolBar
        secondMainTextView2.inputAccessoryView = toolBar
    }
    
    // Build the 'Next' button to dismiss keyboard
    func createNextToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = Theme.BLACK
        toolBar.sizeToFit()
        toolBar.tintColor = Theme.WHITE
        
        let doneButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(skipToNext))
        doneButton.setTitleTextAttributes([ NSAttributedString.Key.font: Fonts.SSPSemiBoldH4], for: UIControl.State.normal)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        mainTextView.inputAccessoryView = toolBar
        mainTextView2.inputAccessoryView = toolBar
    }
    
    @objc func skipToNext() {
        if mainTextView.isFirstResponder {
            secondMainTextView.becomeFirstResponder()
        } else {
            secondMainTextView2.becomeFirstResponder()
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if mainTextView2.alpha != 1 {
            if view.backgroundColor == .clear {
                delegate?.unselectViews()
                delegate?.selectView(view: view)
            }
            if textView == mainTextView {
                textViewLine.backgroundColor = Theme.BLUE
            } else {
                secondTextViewLine.backgroundColor = Theme.BLUE
            }
            if bubbleArrow.alpha == 1 {
                UIView.animate(withDuration: animationIn) {
                    self.bubbleArrow.alpha = 0
                }
            }
        } else {
            if view.backgroundColor == .clear {
                delegate?.unselectViews()
                delegate?.selectView(view: view)
            }
            textViewLine.backgroundColor = Theme.LINE_GRAY
            secondTextViewLine.backgroundColor = Theme.LINE_GRAY
            textViewLine2.backgroundColor = Theme.LINE_GRAY
            secondTextViewLine2.backgroundColor = Theme.LINE_GRAY
            if textView == mainTextView2 {
                textViewLine2.backgroundColor = Theme.BLUE
            } else {
               secondTextViewLine2.backgroundColor = Theme.BLUE
            }
       }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if mainTextView2.alpha != 1 {
            if numberSpots > 1 {
                if let text = mainTextView.text, let secondText = secondMainTextView.text {
                    if text != "" && secondText != "" {
                        delegate?.unselectViews()
                    }
                }
            } else {
                delegate?.unselectViews()
            }
            if textView == mainTextView {
                textViewLine.backgroundColor = Theme.LINE_GRAY
            } else {
                secondTextViewLine.backgroundColor = Theme.LINE_GRAY
            }
            if let text = mainTextView.text {
                if text == "" {
                    switchButton.setOn(false, animated: true)
                    spotViewDismissed()
                }
            }
        } else {
            if textView == mainTextView2 {
                textViewLine2.backgroundColor = Theme.LINE_GRAY
            } else {
               secondTextViewLine2.backgroundColor = Theme.LINE_GRAY
            }
            if let text = mainTextView2.text, let secondText = secondMainTextView2.text {
                if text != "" && secondText != "" {
                    delegate?.unselectViews()
                }
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            let width = text.width(withConstrainedHeight: 46, font: Fonts.SSPRegularH2)
            if textView == mainTextView {
                textViewWidthAnchor.constant = width + 24
                secondMainTextView.text = ""
            } else if textView == secondMainTextView {
                secondTextViewWidthAnchor.constant = width + 24
            } else if textView == mainTextView2 {
                textViewWidthAnchor2.constant = width + 24
                secondMainTextView2.text = ""
            } else if textView == secondMainTextView2 {
                secondTextViewWidthAnchor2.constant = width + 24
            }
            view.layoutIfNeeded()
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension ListingNumberView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return customNumbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let number = "\(customNumbers[indexPath.row])"
        let width = number.width(withConstrainedHeight: 46, font: Fonts.SSPRegularH2) + 24
        let size = CGSize(width: width, height: 46)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath) as! CustomNumbersCell
        cell.number = "\(customNumbers[indexPath.row])"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        editNumbersButton.sendActions(for: .touchUpInside)
    }
    
}

class CustomNumbersCell: UICollectionViewCell {
    
    var number: String = "" {
        didSet {
            mainTextView.text = number
        }
    }
    
    var mainTextView: UITextView = {
        let view = UITextView()
        view.textColor = Theme.BLACK
        view.font = Fonts.SSPRegularH2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.keyboardType = .numberPad
        view.tintColor = .clear
        view.textAlignment = .center
        view.keyboardAppearance = .dark
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    var textViewLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(mainTextView)
        addSubview(textViewLine)
        
        mainTextView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        textViewLine.anchor(top: nil, left: mainTextView.leftAnchor, bottom: mainTextView.bottomAnchor, right: mainTextView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 2)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

