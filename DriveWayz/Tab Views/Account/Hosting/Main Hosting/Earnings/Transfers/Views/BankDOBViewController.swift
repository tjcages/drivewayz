//
//  BankDOBViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 6/17/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class BankDOBViewController: UIViewController {

    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = true
        view.showsHorizontalScrollIndicator = false
        view.decelerationRate = .fast
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    var monthLabel: UILabel = {
        let label = UILabel()
        label.text = "Month"
        label.textColor = Theme.BLACK.withAlphaComponent(0.4)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH5
        label.layer.sublayerTransform = CATransform3DMakeTranslation(16, 0, 0)
        
        return label
    }()
    
    var monthTextField: UITextField = {
        let label = UITextField()
        label.textColor = Theme.BLUE
        label.placeholder = "MM"
        label.tintColor = Theme.BLUE
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = Theme.GRAY_WHITE.withAlphaComponent(0.1)
        label.layer.cornerRadius = 4
        label.layer.sublayerTransform = CATransform3DMakeTranslation(16, 0, 0)
        label.keyboardAppearance = .dark
        label.keyboardType = .numberPad
        
        return label
    }()
    
    var dayLabel: UILabel = {
        let label = UILabel()
        label.text = "Day"
        label.textColor = Theme.BLACK.withAlphaComponent(0.4)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH5
        label.layer.sublayerTransform = CATransform3DMakeTranslation(16, 0, 0)
        
        return label
    }()
    
    var dayTextField: UITextField = {
        let label = UITextField()
        label.textColor = Theme.BLUE
        label.placeholder = "DD"
        label.tintColor = Theme.BLUE
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = Theme.GRAY_WHITE.withAlphaComponent(0.1)
        label.layer.cornerRadius = 4
        label.layer.sublayerTransform = CATransform3DMakeTranslation(16, 0, 0)
        label.keyboardAppearance = .dark
        label.keyboardType = .numberPad
        
        return label
    }()
    
    var yearLabel: UILabel = {
        let label = UILabel()
        label.text = "Year"
        label.textColor = Theme.BLACK.withAlphaComponent(0.4)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH5
        label.layer.sublayerTransform = CATransform3DMakeTranslation(16, 0, 0)
        
        return label
    }()
    
    var yearTextField: UITextField = {
        let label = UITextField()
        label.textColor = Theme.BLUE
        label.placeholder = "YYYY"
        label.tintColor = Theme.BLUE
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = Theme.GRAY_WHITE.withAlphaComponent(0.1)
        label.layer.cornerRadius = 4
        label.layer.sublayerTransform = CATransform3DMakeTranslation(16, 0, 0)
        label.keyboardAppearance = .dark
        label.keyboardType = .numberPad
        
        return label
    }()
    
    var firstSlash: UILabel = {
        let label = UILabel()
        label.text = "/"
        label.textColor = Theme.BLACK
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var secondSlash: UILabel = {
        let label = UILabel()
        label.text = "/"
        label.textColor = Theme.BLACK
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        monthTextField.delegate = self
        dayTextField.delegate = self
        yearTextField.delegate = self
        
        setupViews()
        createToolbar()
    }
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth, height: 100)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        scrollView.addGestureRecognizer(tap)
        
        scrollView.addSubview(monthLabel)
        scrollView.addSubview(firstSlash)
        scrollView.addSubview(monthTextField)
        
        monthLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 32).isActive = true
        monthLabel.leftAnchor.constraint(equalTo: monthTextField.leftAnchor).isActive = true
        monthLabel.sizeToFit()
        
        monthTextField.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 8).isActive = true
        monthTextField.leftAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -114).isActive = true
        monthTextField.widthAnchor.constraint(equalToConstant: 56).isActive = true
        monthTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        firstSlash.centerYAnchor.constraint(equalTo: monthTextField.centerYAnchor).isActive = true
        firstSlash.leftAnchor.constraint(equalTo: monthTextField.rightAnchor, constant: 8).isActive = true
        firstSlash.widthAnchor.constraint(equalToConstant: (firstSlash.text?.width(withConstrainedHeight: 30, font: Fonts.SSPRegularH3))!).isActive = true
        firstSlash.sizeToFit()
        
        scrollView.addSubview(dayLabel)
        scrollView.addSubview(secondSlash)
        scrollView.addSubview(dayTextField)
        
        dayLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 32).isActive = true
        dayLabel.leftAnchor.constraint(equalTo: dayTextField.leftAnchor).isActive = true
        dayLabel.sizeToFit()
        
        dayTextField.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 8).isActive = true
        dayTextField.leftAnchor.constraint(equalTo: firstSlash.rightAnchor, constant: 8).isActive = true
        dayTextField.widthAnchor.constraint(equalToConstant: 56).isActive = true
        dayTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        secondSlash.centerYAnchor.constraint(equalTo: dayTextField.centerYAnchor).isActive = true
        secondSlash.leftAnchor.constraint(equalTo: dayTextField.rightAnchor, constant: 8).isActive = true
        secondSlash.widthAnchor.constraint(equalToConstant: (secondSlash.text?.width(withConstrainedHeight: 30, font: Fonts.SSPRegularH3))!).isActive = true
        secondSlash.sizeToFit()
        
        scrollView.addSubview(yearLabel)
        scrollView.addSubview(yearTextField)
        
        yearLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 32).isActive = true
        yearLabel.leftAnchor.constraint(equalTo: yearTextField.leftAnchor).isActive = true
        yearLabel.sizeToFit()
        
        yearTextField.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 8).isActive = true
        yearTextField.leftAnchor.constraint(equalTo: secondSlash.rightAnchor, constant: 8).isActive = true
        yearTextField.widthAnchor.constraint(equalToConstant: 70).isActive = true
        yearTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
    }
    
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = Theme.BLACK
        toolBar.tintColor = Theme.BLUE
        toolBar.layer.borderColor = Theme.BLACK.withAlphaComponent(0.4).cgColor
        toolBar.layer.borderWidth = 0.5
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(endEditing))
        doneButton.setTitleTextAttributes([ NSAttributedString.Key.font: Fonts.SSPSemiBoldH4], for: UIControl.State.normal)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        monthTextField.inputAccessoryView = toolBar
        dayTextField.inputAccessoryView = toolBar
        yearTextField.inputAccessoryView = toolBar
    }
    
    @objc func endEditing() {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}


extension BankDOBViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        if string == "" {
            if text.count == 0 {
                if textField == self.yearTextField {
                    self.dayTextField.becomeFirstResponder()
                } else if textField == self.dayTextField {
                    self.monthTextField.becomeFirstResponder()
                }
                return true
            } else {
                return true
            }
        } else {
            if text.count == 0 {
                return true
            } else if text.count == 1 && textField != self.yearTextField {
                delayWithSeconds(0.1) {
                    if textField == self.monthTextField {
                        self.dayTextField.becomeFirstResponder()
                    } else if textField == self.dayTextField {
                        self.yearTextField.becomeFirstResponder()
                    }
                }
                return true
            } else {
                return true
            }
        }
    }
    
}
