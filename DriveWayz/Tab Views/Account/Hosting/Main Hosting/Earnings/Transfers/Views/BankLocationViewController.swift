//
//  BankLocationViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 6/17/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class BankLocationViewController: UIViewController {
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = true
        view.showsHorizontalScrollIndicator = false
        view.decelerationRate = .fast
        
        return view
    }()

    var address1Label: UILabel = {
        let label = UILabel()
        label.text = "Address line 1"
        label.textColor = Theme.BLACK.withAlphaComponent(0.4)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH5
        label.layer.sublayerTransform = CATransform3DMakeTranslation(16, 0, 0)
        
        return label
    }()
    
    var address1TextField: UITextField = {
        let label = UITextField()
        label.textColor = Theme.BLUE
        label.placeholder = "Address"
        label.tintColor = Theme.BLUE
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = Theme.GRAY_WHITE.withAlphaComponent(0.1)
        label.layer.cornerRadius = 4
        label.layer.sublayerTransform = CATransform3DMakeTranslation(16, 0, 0)
        label.keyboardAppearance = .dark
        
        return label
    }()
    
    var cityLabel: UILabel = {
        let label = UILabel()
        label.text = "City"
        label.textColor = Theme.BLACK.withAlphaComponent(0.4)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH5
        label.layer.sublayerTransform = CATransform3DMakeTranslation(16, 0, 0)
        
        return label
    }()
    
    var cityTextField: UITextField = {
        let label = UITextField()
        label.textColor = Theme.BLUE
        label.placeholder = "City"
        label.tintColor = Theme.BLUE
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = Theme.GRAY_WHITE.withAlphaComponent(0.1)
        label.layer.cornerRadius = 4
        label.layer.sublayerTransform = CATransform3DMakeTranslation(16, 0, 0)
        label.keyboardAppearance = .dark
        
        return label
    }()
    
    var stateLabel: UILabel = {
        let label = UILabel()
        label.text = "State"
        label.textColor = Theme.BLACK.withAlphaComponent(0.4)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH5
        label.layer.sublayerTransform = CATransform3DMakeTranslation(16, 0, 0)
        
        return label
    }()
    
    var stateTextField: UITextField = {
        let label = UITextField()
        label.textColor = Theme.BLUE
        label.placeholder = "State"
        label.tintColor = Theme.BLUE
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = Theme.GRAY_WHITE.withAlphaComponent(0.1)
        label.layer.cornerRadius = 4
        label.layer.sublayerTransform = CATransform3DMakeTranslation(16, 0, 0)
        label.keyboardAppearance = .dark
        
        return label
    }()
    
    var zipLabel: UILabel = {
        let label = UILabel()
        label.text = "Zipcode"
        label.textColor = Theme.BLACK.withAlphaComponent(0.4)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH5
        label.layer.sublayerTransform = CATransform3DMakeTranslation(16, 0, 0)
        
        return label
    }()
    
    var zipTextField: UITextField = {
        let label = UITextField()
        label.textColor = Theme.BLUE
        label.placeholder = "Zipcode"
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        setupViews()
        createToolbar()
    }
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth, height: 550)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        scrollView.addGestureRecognizer(tap)
        
        scrollView.addSubview(address1Label)
        address1Label.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        address1Label.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        address1Label.sizeToFit()
        
        scrollView.addSubview(address1TextField)
        address1TextField.topAnchor.constraint(equalTo: address1Label.bottomAnchor, constant: 8).isActive = true
        address1TextField.leftAnchor.constraint(equalTo: address1Label.leftAnchor).isActive = true
        address1TextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32).isActive = true
        address1TextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        scrollView.addSubview(cityLabel)
        cityLabel.topAnchor.constraint(equalTo: address1TextField.bottomAnchor, constant: 20).isActive = true
        cityLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        cityLabel.sizeToFit()
        
        scrollView.addSubview(cityTextField)
        cityTextField.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 8).isActive = true
        cityTextField.leftAnchor.constraint(equalTo: cityLabel.leftAnchor).isActive = true
        cityTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32).isActive = true
        cityTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        scrollView.addSubview(stateLabel)
        stateLabel.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 20).isActive = true
        stateLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        stateLabel.sizeToFit()
        
        scrollView.addSubview(stateTextField)
        stateTextField.topAnchor.constraint(equalTo: stateLabel.bottomAnchor, constant: 8).isActive = true
        stateTextField.leftAnchor.constraint(equalTo: stateLabel.leftAnchor).isActive = true
        stateTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32).isActive = true
        stateTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        scrollView.addSubview(zipLabel)
        zipLabel.topAnchor.constraint(equalTo: stateTextField.bottomAnchor, constant: 20).isActive = true
        zipLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        zipLabel.sizeToFit()
        
        scrollView.addSubview(zipTextField)
        zipTextField.topAnchor.constraint(equalTo: zipLabel.bottomAnchor, constant: 8).isActive = true
        zipTextField.leftAnchor.constraint(equalTo: zipLabel.leftAnchor).isActive = true
        zipTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32).isActive = true
        zipTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
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
        
        address1TextField.inputAccessoryView = toolBar
        cityTextField.inputAccessoryView = toolBar
        stateTextField.inputAccessoryView = toolBar
        zipTextField.inputAccessoryView = toolBar
    }
    
    @objc func endEditing() {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
