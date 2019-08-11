//
//  BankRoutingViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 6/17/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class BankRoutingViewController: UIViewController {

    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = true
        view.showsHorizontalScrollIndicator = false
        view.decelerationRate = .fast
        
        return view
    }()
    
    var routingLabel: UILabel = {
        let label = UILabel()
        label.text = "Routing number"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH5
        label.layer.sublayerTransform = CATransform3DMakeTranslation(16, 0, 0)
        
        return label
    }()
    
    var routingTextField: UITextField = {
        let label = UITextField()
        label.textColor = Theme.PACIFIC_BLUE
        label.placeholder = "Routing"
        label.tintColor = Theme.PACIFIC_BLUE
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.1)
        label.layer.cornerRadius = 4
        label.layer.sublayerTransform = CATransform3DMakeTranslation(16, 0, 0)
        label.keyboardAppearance = .dark
        label.keyboardType = .numberPad
        
        return label
    }()
    
    var accountLabel: UILabel = {
        let label = UILabel()
        label.text = "Account number"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH5
        label.layer.sublayerTransform = CATransform3DMakeTranslation(16, 0, 0)
        
        return label
    }()
    
    var accountTextField: UITextField = {
        let label = UITextField()
        label.textColor = Theme.PACIFIC_BLUE
        label.placeholder = "Account"
        label.tintColor = Theme.PACIFIC_BLUE
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.1)
        label.layer.cornerRadius = 4
        label.layer.sublayerTransform = CATransform3DMakeTranslation(16, 0, 0)
        label.keyboardAppearance = .dark
        label.keyboardType = .numberPad
        
        return label
    }()
    
    var loadingActivity: NVActivityIndicatorView = {
        let loading = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballPulse, color: Theme.BLACK, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.alpha = 0
        
        return loading
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        createToolbar()
    }
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth, height: 390)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        scrollView.addGestureRecognizer(tap)
        
        scrollView.addSubview(routingLabel)
        routingLabel.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        routingLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        routingLabel.sizeToFit()
        
        scrollView.addSubview(routingTextField)
        routingTextField.topAnchor.constraint(equalTo: routingLabel.bottomAnchor, constant: 8).isActive = true
        routingTextField.leftAnchor.constraint(equalTo: routingLabel.leftAnchor).isActive = true
        routingTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32).isActive = true
        routingTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        scrollView.addSubview(accountLabel)
        accountLabel.topAnchor.constraint(equalTo: routingTextField.bottomAnchor, constant: 20).isActive = true
        accountLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        accountLabel.sizeToFit()
        
        scrollView.addSubview(accountTextField)
        accountTextField.topAnchor.constraint(equalTo: accountLabel.bottomAnchor, constant: 8).isActive = true
        accountTextField.leftAnchor.constraint(equalTo: accountLabel.leftAnchor).isActive = true
        accountTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32).isActive = true
        accountTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.view.addSubview(loadingActivity)
        loadingActivity.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loadingActivity.centerYAnchor.constraint(equalTo: accountTextField.bottomAnchor, constant: 32).isActive = true
        loadingActivity.widthAnchor.constraint(equalToConstant: 40).isActive = true
        loadingActivity.heightAnchor.constraint(equalTo: loadingActivity.widthAnchor).isActive = true
        
    }
    
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = Theme.DARK_GRAY
        toolBar.tintColor = Theme.BLUE
        toolBar.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.4).cgColor
        toolBar.layer.borderWidth = 0.5
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(endEditing))
        doneButton.setTitleTextAttributes([ NSAttributedString.Key.font: Fonts.SSPSemiBoldH4], for: UIControl.State.normal)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        routingTextField.inputAccessoryView = toolBar
        accountTextField.inputAccessoryView = toolBar
    }
    
    @objc func endEditing() {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
