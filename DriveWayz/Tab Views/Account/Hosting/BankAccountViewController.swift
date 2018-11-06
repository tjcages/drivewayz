//
//  BankAccountViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 7/10/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import TextFieldEffects

class BankAccountViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, UITextViewDelegate {
    
    var delegate: controlsAccountOptions?
    
    var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = UIColor.clear
        scroll.alpha = 0
        
        return scroll
    }()
    
    var bankLabel: UILabel = {
        let label = UILabel()
        label.text = "Bank Account"
        label.textColor = Theme.DARK_GRAY
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = Fonts.SSPSemiBoldH1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var bankLabelDuplicate: UILabel = {
        let label = UILabel()
        label.text = "Bank Account"
        label.textColor = Theme.DARK_GRAY
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = Fonts.SSPSemiBoldH1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var label: UILabel = {
        let label = UILabel()
        label.text = "Please confirm the information below"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    let exitButton: UIButton = {
        let exitButton = UIButton()
        let image = UIImage(named: "Expand")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        exitButton.setImage(tintedImage, for: .normal)
        exitButton.tintColor = Theme.SEA_BLUE
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.addTarget(self, action: #selector(dismissDetails(sender:)), for: .touchUpInside)
        exitButton.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        
        return exitButton
    }()
    
    var name: UITextField = {
        let label = UITextField()
        label.textColor = Theme.PACIFIC_BLUE
        label.placeholder = "First"
        label.textAlignment = .center
        label.tintColor = Theme.PACIFIC_BLUE
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPLightH3
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var last: UITextField = {
        let label = UITextField()
        label.textColor = Theme.PACIFIC_BLUE
        label.placeholder = "Last"
        label.textAlignment = .center
        label.tintColor = Theme.PACIFIC_BLUE
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPLightH3
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var addressLine1: UITextField = {
        let label = UITextField()
        label.textColor = Theme.PACIFIC_BLUE
        label.placeholder = "Address"
        label.textAlignment = .center
        label.tintColor = Theme.PACIFIC_BLUE
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPLightH3
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var addressLine2: UITextField = {
        let label = UITextField()
        label.textColor = Theme.PACIFIC_BLUE
        label.placeholder = "Address line 2"
        label.textAlignment = .center
        label.tintColor = Theme.PACIFIC_BLUE
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPLightH3
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var city: UITextField = {
        let label = UITextField()
        label.textColor = Theme.PACIFIC_BLUE
        label.placeholder = "City"
        label.textAlignment = .center
        label.tintColor = Theme.PACIFIC_BLUE
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPLightH3
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var state: UITextField = {
        let label = UITextField()
        label.textColor = Theme.PACIFIC_BLUE
        label.placeholder = "State"
        label.textAlignment = .center
        label.tintColor = Theme.PACIFIC_BLUE
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPLightH3
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var zip: UITextField = {
        let label = UITextField()
        label.textColor = Theme.PACIFIC_BLUE
        label.placeholder = "Zipcode"
        label.textAlignment = .center
        label.tintColor = Theme.PACIFIC_BLUE
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPLightH3
        label.keyboardType = .numberPad
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var day: UITextField = {
        let label = UITextField()
        label.textColor = Theme.PACIFIC_BLUE
        label.placeholder = "Birth Day"
        label.textAlignment = .center
        label.tintColor = Theme.PACIFIC_BLUE
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPLightH3
        label.keyboardType = .numberPad
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var month: UITextField = {
        let label = UITextField()
        label.textColor = Theme.PACIFIC_BLUE
        label.placeholder = "Month"
        label.textAlignment = .center
        label.tintColor = Theme.PACIFIC_BLUE
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPLightH3
        label.keyboardType = .numberPad
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var year: UITextField = {
        let label = UITextField()
        label.textColor = Theme.PACIFIC_BLUE
        label.placeholder = "Year"
        label.textAlignment = .center
        label.tintColor = Theme.PACIFIC_BLUE
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPLightH3
        label.keyboardType = .numberPad
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var phone: UITextField = {
        let label = UITextField()
        label.textColor = Theme.PACIFIC_BLUE
        label.placeholder = "Phone number"
        label.textAlignment = .center
        label.tintColor = Theme.PACIFIC_BLUE
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPLightH3
        label.keyboardType = .numberPad
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var ssnField: UITextField = {
        let label = UITextField()
        label.textColor = Theme.PACIFIC_BLUE
        label.placeholder = "_ _ _ _"
        label.textAlignment = .left
        label.tintColor = Theme.PACIFIC_BLUE
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPLightH3
        label.keyboardType = .numberPad
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var xxx: UILabel = {
        let label = UILabel()
        label.text = "XXX-XX-"
        label.textColor = Theme.DARK_GRAY
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPLightH3
        
        return label
    }()
    
    var ssnLabel: UILabel = {
        let label = UILabel()
        label.text = "Social Security last four"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.textAlignment = .center
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPLightH3
        
        return label
    }()
    
    var routing: UITextField = {
        let label = UITextField()
        label.textColor = Theme.PACIFIC_BLUE
        label.placeholder = "Routing number"
        label.textAlignment = .center
        label.tintColor = Theme.PACIFIC_BLUE
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPLightH3
        label.keyboardType = .numberPad
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var account: UITextField = {
        let label = UITextField()
        label.textColor = Theme.PACIFIC_BLUE
        label.placeholder = "Account number"
        label.textAlignment = .center
        label.tintColor = Theme.PACIFIC_BLUE
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPLightH3
        label.keyboardType = .numberPad
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var confirm: UIButton = {
        let next = UIButton()
        next.setTitleColor(Theme.DARK_GRAY, for: .normal)
        next.setTitle("Next", for: .normal)
        next.backgroundColor = UIColor.clear
        next.layer.borderColor = Theme.DARK_GRAY.cgColor
        next.layer.borderWidth = 1
        next.addTarget(self, action: #selector(nextPressed(sender:)), for: .touchUpInside)
        next.translatesAutoresizingMaskIntoConstraints = false
        
        return next
    }()
    
    var back: UIButton = {
        let next = UIButton()
        next.setTitleColor(Theme.DARK_GRAY, for: .normal)
        next.setTitle("Back", for: .normal)
        next.alpha = 0
        next.backgroundColor = UIColor.clear
        next.layer.borderColor = Theme.DARK_GRAY.cgColor
        next.layer.borderWidth = 1
        next.addTarget(self, action: #selector(lastPressed(sender:)), for: .touchUpInside)
        next.translatesAutoresizingMaskIntoConstraints = false
        
        return next
    }()
    
    var split: UIView = {
        let line = UIView()
        line.backgroundColor = Theme.DARK_GRAY
        line.translatesAutoresizingMaskIntoConstraints = false

        return line
    }()
    
    var agreement: UITextView = {
        let agreement = UITextView()
        
        let serviceAttributes: [NSAttributedString.Key: Any] = [
            .link: NSURL(string: "https://stripe.com/us/connect-account/legal")!,
            .foregroundColor: UIColor.blue
        ]
        
        let attributedString = NSMutableAttributedString(string: "By registering your account, you agree to our Services Agreement and the Stripe Connected Account Agreement.")
        attributedString.setAttributes(serviceAttributes, range: NSMakeRange(90, 17))
    
        agreement.attributedText = attributedString
        agreement.isUserInteractionEnabled = true
        agreement.isEditable = false
        agreement.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        agreement.textAlignment = .center
        agreement.translatesAutoresizingMaskIntoConstraints = false
        agreement.font = Fonts.SSPRegularH6
        agreement.alpha = 0
        agreement.backgroundColor = UIColor.clear
        agreement.translatesAutoresizingMaskIntoConstraints = false
        
        return agreement
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = Theme.OFF_WHITE
        self.scrollView.delegate = self
        
        self.name.delegate = self
        self.last.delegate = self
        self.addressLine1.delegate = self
        self.addressLine2.delegate = self
        self.city.delegate = self
        self.state.delegate = self
        self.zip.delegate = self
        self.day.delegate = self
        self.month.delegate = self
        self.year.delegate = self
        self.phone.delegate = self
        self.ssnField.delegate = self
        self.routing.delegate = self
        self.account.delegate = self
        self.agreement.delegate = self
        
        setupViews()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var nameLeftAnchor: NSLayoutConstraint!
    var addressLeftAnchor: NSLayoutConstraint!
    var dayLeftAnchor: NSLayoutConstraint!
    var phoneLeftAnchor: NSLayoutConstraint!
    var ssnLeftAnchor: NSLayoutConstraint!
    var routingLeftAnchor: NSLayoutConstraint!
    var confirmLeftAnchor: NSLayoutConstraint!
    
    var nameNormalAnchor: NSLayoutConstraint!
    var addressNormalAnchor: NSLayoutConstraint!
    var dayNormalAnchor: NSLayoutConstraint!
    var phoneNormalAnchor: NSLayoutConstraint!
    var ssnNormalAnchor: NSLayoutConstraint!
    var routingNormalAnchor: NSLayoutConstraint!
    var confirmNormalAnchor: NSLayoutConstraint!
    var bankLabelNormalAnchor: NSLayoutConstraint!
    
    var nameTopAnchor: NSLayoutConstraint!
    var addressTopAnchor: NSLayoutConstraint!
    var dayTopAnchor: NSLayoutConstraint!
    var phoneTopAnchor: NSLayoutConstraint!
    var ssnTopAnchor: NSLayoutConstraint!
    var routingTopAnchor: NSLayoutConstraint!
    var confirmTopAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        
        scrollView.addSubview(bankLabel)
        bankLabel.alpha = 0
        bankLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        bankLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40).isActive = true
        bankLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        bankLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        
        self.view.addSubview(bankLabelDuplicate)
        bankLabelDuplicate.alpha = 1
        bankLabelDuplicate.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        bankLabelNormalAnchor = bankLabelDuplicate.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40)
        bankLabelNormalAnchor.isActive = true
        bankLabelDuplicate.heightAnchor.constraint(equalToConstant: 40).isActive = true
        bankLabelDuplicate.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        
        self.view.addSubview(exitButton)
        exitButton.rightAnchor.constraint(equalTo: bankLabel.leftAnchor, constant: 40).isActive = true
        exitButton.centerYAnchor.constraint(equalTo: bankLabel.centerYAnchor).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(split)
        split.topAnchor.constraint(equalTo: bankLabel.bottomAnchor, constant: 2).isActive = true
        split.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        split.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -60).isActive = true
        split.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.view.addSubview(label)
        label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: split.bottomAnchor, constant: 8).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.widthAnchor.constraint(equalToConstant: self.view.frame.width * 5/6).isActive = true
        
        self.view.addSubview(name)
        nameNormalAnchor = name.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100)
        nameNormalAnchor.isActive = true
        nameTopAnchor = name.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 40)
        nameTopAnchor.isActive = false
        nameLeftAnchor = name.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        nameLeftAnchor.isActive = true
        name.widthAnchor.constraint(equalToConstant: self.view.frame.width * 5/6).isActive = true
        name.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(last)
        last.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 20).isActive = true
        last.centerXAnchor.constraint(equalTo: name.centerXAnchor).isActive = true
        last.widthAnchor.constraint(equalToConstant: self.view.frame.width * 5/6).isActive = true
        last.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
        self.view.addSubview(confirm)
        confirmNormalAnchor = confirm.topAnchor.constraint(equalTo: last.bottomAnchor, constant: 60)
        confirmNormalAnchor.isActive = true
        confirmTopAnchor = confirm.topAnchor.constraint(equalTo: account.bottomAnchor, constant: 60)
        confirmTopAnchor.isActive = false
        confirmLeftAnchor = confirm.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        confirmLeftAnchor.isActive = true
        confirm.widthAnchor.constraint(equalToConstant: 200).isActive = true
        confirm.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(back)
        back.centerYAnchor.constraint(equalTo: confirm.centerYAnchor).isActive = true
        back.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -(self.view.frame.width/3.5)).isActive = true
        back.widthAnchor.constraint(equalToConstant: 100).isActive = true
        back.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(addressLine1)
        addressNormalAnchor = addressLine1.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -160)
        addressNormalAnchor.isActive = true
        addressTopAnchor = addressLine1.topAnchor.constraint(equalTo: last.bottomAnchor, constant: 40)
        addressTopAnchor.isActive = false
        addressLeftAnchor = addressLine1.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width)
        addressLeftAnchor.isActive = true
        addressLine1.widthAnchor.constraint(equalToConstant: self.view.frame.width * 5/6).isActive = true
        addressLine1.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(addressLine2)
        addressLine2.topAnchor.constraint(equalTo: addressLine1.bottomAnchor, constant: 10).isActive = true
        addressLine2.centerXAnchor.constraint(equalTo: addressLine1.centerXAnchor).isActive = true
        addressLine2.widthAnchor.constraint(equalToConstant: self.view.frame.width * 5/6).isActive = true
        addressLine2.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(city)
        city.topAnchor.constraint(equalTo: addressLine2.bottomAnchor, constant: 10).isActive = true
        city.centerXAnchor.constraint(equalTo: addressLine1.centerXAnchor).isActive = true
        city.widthAnchor.constraint(equalToConstant: self.view.frame.width * 5/6).isActive = true
        city.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(state)
        state.topAnchor.constraint(equalTo: city.bottomAnchor, constant: 10).isActive = true
        state.centerXAnchor.constraint(equalTo: addressLine1.centerXAnchor, constant: -(self.view.frame.width/6)).isActive = true
        state.widthAnchor.constraint(equalToConstant: self.view.frame.width * 1/3).isActive = true
        state.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(zip)
        zip.topAnchor.constraint(equalTo: city.bottomAnchor, constant: 10).isActive = true
        zip.centerXAnchor.constraint(equalTo: addressLine1.centerXAnchor, constant: self.view.frame.width/6).isActive = true
        zip.widthAnchor.constraint(equalToConstant: self.view.frame.width * 1/2).isActive = true
        zip.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(day)
        dayNormalAnchor = day.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100)
        dayNormalAnchor.isActive = true
        dayTopAnchor = day.topAnchor.constraint(equalTo: zip.bottomAnchor, constant: 40)
        dayTopAnchor.isActive = false
        dayLeftAnchor = day.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width - (self.view.frame.width/3))
        dayLeftAnchor.isActive = true
        day.widthAnchor.constraint(equalToConstant: self.view.frame.width/4).isActive = true
        day.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(month)
        month.centerYAnchor.constraint(equalTo: day.centerYAnchor).isActive = true
        month.leftAnchor.constraint(equalTo: day.rightAnchor, constant: 10).isActive = true
        month.widthAnchor.constraint(equalToConstant: self.view.frame.width * 1/6).isActive = true
        month.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(year)
        year.centerYAnchor.constraint(equalTo: day.centerYAnchor).isActive = true
        year.leftAnchor.constraint(equalTo: month.rightAnchor, constant: 10).isActive = true
        year.widthAnchor.constraint(equalToConstant: self.view.frame.width/6).isActive = true
        year.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(phone)
        phoneNormalAnchor = phone.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100)
        phoneNormalAnchor.isActive = true
        phoneTopAnchor = phone.topAnchor.constraint(equalTo: year.bottomAnchor, constant: 40)
        phoneTopAnchor.isActive = false
        phoneLeftAnchor = phone.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width)
        phoneLeftAnchor.isActive = true
        phone.widthAnchor.constraint(equalToConstant: self.view.frame.width * 5/6).isActive = true
        phone.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(ssnField)
        ssnNormalAnchor = ssnField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100)
        ssnNormalAnchor.isActive = true
        ssnTopAnchor = ssnField.topAnchor.constraint(equalTo: phone.bottomAnchor, constant: 40)
        ssnTopAnchor.isActive = false
        ssnLeftAnchor = ssnField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width + 60)
        ssnLeftAnchor.isActive = true
        ssnField.widthAnchor.constraint(equalToConstant: 60).isActive = true
        ssnField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(xxx)
        xxx.centerYAnchor.constraint(equalTo: ssnField.centerYAnchor).isActive = true
        xxx.rightAnchor.constraint(equalTo: ssnField.leftAnchor).isActive = true
        xxx.heightAnchor.constraint(equalToConstant: 40).isActive = true
        xxx.sizeToFit()
        
        self.view.addSubview(ssnLabel)
        ssnLabel.bottomAnchor.constraint(equalTo: xxx.topAnchor, constant: 4).isActive = true
        ssnLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        ssnLabel.sizeToFit()
        
        self.view.addSubview(routing)
        routingNormalAnchor = routing.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100)
        routingNormalAnchor.isActive = true
        routingTopAnchor = routing.topAnchor.constraint(equalTo: ssnField.bottomAnchor, constant: 40)
        routingTopAnchor.isActive = false
        routingLeftAnchor = routing.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width)
        routingLeftAnchor.isActive = true
        routing.widthAnchor.constraint(equalToConstant: self.view.frame.width * 5/6).isActive = true
        routing.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(account)
        account.topAnchor.constraint(equalTo: routing.bottomAnchor, constant: 20).isActive = true
        account.centerXAnchor.constraint(equalTo: routing.centerXAnchor).isActive = true
        account.widthAnchor.constraint(equalToConstant: self.view.frame.width * 5/6).isActive = true
        account.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(agreement)
        agreement.topAnchor.constraint(equalTo: confirm.bottomAnchor, constant: 10).isActive = true
        agreement.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        agreement.widthAnchor.constraint(equalToConstant: self.view.frame.width * 5/6).isActive = true
        agreement.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    
    @objc func nextPressed(sender: UIButton) {
        if routingLeftAnchor.constant == 0 {
            self.confirm.removeTarget(nil, action: nil, for: .allEvents)
            self.confirm.addTarget(self, action: #selector(self.registerAccount(sender:)), for: .touchUpInside)
            self.bankLabel.alpha = 1
            UIView.animate(withDuration: 0.3, animations: {
                self.routing.alpha = 0
                self.account.alpha = 0
                self.label.text = "Please confirm your information"
                self.scrollView.alpha = 1
                self.bankLabelDuplicate.alpha = 0
                
                self.name.isUserInteractionEnabled = false
                self.last.isUserInteractionEnabled = false
                self.addressLine1.isUserInteractionEnabled = false
                self.addressLine2.isUserInteractionEnabled = false
                self.city.isUserInteractionEnabled = false
                self.state.isUserInteractionEnabled = false
                self.zip.isUserInteractionEnabled = false
                self.day.isUserInteractionEnabled = false
                self.month.isUserInteractionEnabled = false
                self.year.isUserInteractionEnabled = false
                self.phone.isUserInteractionEnabled = false
                self.ssnField.isUserInteractionEnabled = false
                self.routing.isUserInteractionEnabled = false
                self.account.isUserInteractionEnabled = false
                
                self.nameNormalAnchor.isActive = false
                self.addressNormalAnchor.isActive = false
                self.dayNormalAnchor.isActive = false
                self.phoneNormalAnchor.isActive = false
                self.ssnNormalAnchor.isActive = false
                self.routingNormalAnchor.isActive = false
                self.confirmNormalAnchor.isActive = false
                
                self.nameTopAnchor.isActive = true
                self.addressTopAnchor.isActive = true
                self.dayTopAnchor.isActive = true
                self.phoneTopAnchor.isActive = true
                self.ssnTopAnchor.isActive = true
                self.routingTopAnchor.isActive = true
                self.confirmTopAnchor.isActive = true
                
                self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.6)
                self.view.layoutIfNeeded()
                self.confirm.setTitle("Register Your Account", for: .normal)
            }) { (success) in
                self.name.alpha = 1
                self.last.alpha = 1
                self.addressLine1.alpha = 1
                self.addressLine2.alpha = 1
                self.city.alpha = 1
                self.state.alpha = 1
                self.zip.alpha = 1
                self.day.alpha = 1
                self.month.alpha = 1
                self.year.alpha = 1
                self.phone.alpha = 1
                self.ssnField.alpha = 1
                self.xxx.alpha = 1
                self.routing.alpha = 1
                self.account.alpha = 1
                self.agreement.alpha = 1
            }
        } else if nameLeftAnchor.constant == 0 && name.alpha == 1 {
            UIView.animate(withDuration: 0.3, animations: {
                self.name.alpha = 0
                self.last.alpha = 0
                self.confirmLeftAnchor.constant = self.view.frame.width/6
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.addressLeftAnchor.constant = 0
                    self.back.alpha = 1
                    self.view.layoutIfNeeded()
                })
            }
        } else if addressLeftAnchor.constant == 0 && addressLine1.alpha == 1 {
            UIView.animate(withDuration: 0.3, animations: {
                self.addressLine1.alpha = 0
                self.addressLine2.alpha = 0
                self.city.alpha = 0
                self.state.alpha = 0
                self.zip.alpha = 0
                self.label.text = "Please enter the information below"
            }) { (success) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.dayLeftAnchor.constant = -(self.view.frame.width/4)
                    self.view.layoutIfNeeded()
                })
            }
        } else if dayLeftAnchor.constant == -(self.view.frame.width/4) && day.alpha == 1 {
            UIView.animate(withDuration: 0.3, animations: {
                self.day.alpha = 0
                self.month.alpha = 0
                self.year.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.phoneLeftAnchor.constant = 0
                    self.view.layoutIfNeeded()
                })
            }
        } else if phoneLeftAnchor.constant == 0 && ssnField.text == "" {
            UIView.animate(withDuration: 0.3, animations: {
                self.phone.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.ssnLeftAnchor.constant = 40
                    self.ssnLabel.alpha = 1
                    self.view.layoutIfNeeded()
                })
            }
        } else if ssnLeftAnchor.constant == 40 && xxx.alpha == 1 {
            UIView.animate(withDuration: 0.3, animations: {
                self.ssnLabel.alpha = 0
                self.xxx.alpha = 0
                self.ssnField.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.routingLeftAnchor.constant = 0
                    self.view.layoutIfNeeded()
                    self.confirm.setTitle("Confirm", for: .normal)
                })
            }
        }
    }
    
    @objc func lastPressed(sender: UIButton) {
        self.view.endEditing(true)
        if routingTopAnchor.isActive == true  {
            self.confirm.isUserInteractionEnabled = true
            self.confirm.alpha = 1
            self.confirm.removeTarget(nil, action: nil, for: .allEvents)
            self.confirm.addTarget(self, action: #selector(self.nextPressed(sender:)), for: .touchUpInside)
            self.scrollView.scrollsToTop = true
            UIView.animate(withDuration: 0.3, animations: {
                self.name.alpha = 0
                self.last.alpha = 0
                self.addressLine1.alpha = 0
                self.addressLine2.alpha = 0
                self.city.alpha = 0
                self.state.alpha = 0
                self.zip.alpha = 0
                self.day.alpha = 0
                self.month.alpha = 0
                self.year.alpha = 0
                self.phone.alpha = 0
                self.ssnField.alpha = 0
                self.xxx.alpha = 0
                self.routing.alpha = 1
                self.account.alpha = 1
                self.split.alpha = 1
                self.agreement.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.routing.alpha = 1
                    self.account.alpha = 1
                    self.label.text = "Please enter the information below"
                    self.scrollView.alpha = 0
                    self.bankLabelDuplicate.alpha = 1
                    
                    self.name.isUserInteractionEnabled = true
                    self.last.isUserInteractionEnabled = true
                    self.addressLine1.isUserInteractionEnabled = true
                    self.addressLine2.isUserInteractionEnabled = true
                    self.city.isUserInteractionEnabled = true
                    self.state.isUserInteractionEnabled = true
                    self.zip.isUserInteractionEnabled = true
                    self.day.isUserInteractionEnabled = true
                    self.month.isUserInteractionEnabled = true
                    self.year.isUserInteractionEnabled = true
                    self.phone.isUserInteractionEnabled = true
                    self.ssnField.isUserInteractionEnabled = true
                    self.routing.isUserInteractionEnabled = true
                    self.account.isUserInteractionEnabled = true
                    
                    self.nameNormalAnchor.isActive = true
                    self.addressNormalAnchor.isActive = true
                    self.dayNormalAnchor.isActive = true
                    self.phoneNormalAnchor.isActive = true
                    self.ssnNormalAnchor.isActive = true
                    self.routingNormalAnchor.isActive = true
                    self.confirmNormalAnchor.isActive = true
                    self.bankLabelNormalAnchor.constant = 40
                    
                    self.nameTopAnchor.isActive = false
                    self.addressTopAnchor.isActive = false
                    self.dayTopAnchor.isActive = false
                    self.phoneTopAnchor.isActive = false
                    self.ssnTopAnchor.isActive = false
                    self.routingTopAnchor.isActive = false
                    self.confirmTopAnchor.isActive = false
                    
                    self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1)
                    self.view.layoutIfNeeded()
                    self.confirm.setTitle("Confirm", for: .normal)
                })
            }
        } else if dayLeftAnchor.constant == self.view.frame.width - (self.view.frame.width/4) {
            UIView.animate(withDuration: 0.3, animations: {
                self.back.alpha = 0
                self.addressLeftAnchor.constant = self.view.frame.width
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.name.alpha = 1
                    self.last.alpha = 1
                    self.confirmLeftAnchor.constant = 0
                    self.view.layoutIfNeeded()
                })
            }
        } else if phoneLeftAnchor.constant == self.view.frame.width {
            UIView.animate(withDuration: 0.3, animations: {
                self.dayLeftAnchor.constant = self.view.frame.width - (self.view.frame.width/4)
                self.label.text = "Please confirm the information below"
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.addressLine1.alpha = 1
                    self.addressLine2.alpha = 1
                    self.city.alpha = 1
                    self.state.alpha = 1
                    self.zip.alpha = 1
                })
            }
        } else if ssnLeftAnchor.constant == self.view.frame.width  {
            UIView.animate(withDuration: 0.3, animations: {
                self.phoneLeftAnchor.constant = self.view.frame.width
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.day.alpha = 1
                    self.month.alpha = 1
                    self.year.alpha = 1
                })
            }
        } else if routingLeftAnchor.constant == self.view.frame.width  {
            UIView.animate(withDuration: 0.3, animations: {
                self.ssnLeftAnchor.constant = self.view.frame.width
                self.ssnLabel.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.phone.alpha = 1
                    self.ssnField.text = ""
                })
            }
        } else if routingLeftAnchor.constant == 0  {
            UIView.animate(withDuration: 0.3, animations: {
                self.routingLeftAnchor.constant = self.view.frame.width
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.ssnLabel.alpha = 1
                    self.ssnField.alpha = 1
                    self.xxx.alpha = 1
                    self.confirm.setTitle("Next", for: .normal)
                })
            }
        }
    }
    
    @objc func registerAccount(sender: UIButton) {
        self.confirm.isUserInteractionEnabled = false
        self.confirm.alpha = 0.5
        MyAPIClient.sharedClient.createAccountKey(routingNumber: routing.text!, accountNumber: account.text!, birthDay: day.text!, birthMonth: month.text!, birthYear: year.text!, addressLine1: addressLine1.text!, addressLine2: addressLine2.text!, addressCity: city.text!, addressState: state.text!, addressPostalCode: zip.text!, firstName: name.text!, lastName: last.text!, ssnLast4: ssnField.text!, phoneNumber: phone.text!)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == name {
            self.name.placeholder = ""
        } else if textField == last {
            self.last.placeholder = ""
        } else if textField == addressLine1 {
            self.addressLine1.placeholder = ""
        } else if textField == addressLine2 {
            self.addressLine2.placeholder = ""
        } else if textField == city {
            self.city.placeholder = ""
        } else if textField == state {
            self.state.placeholder = ""
        } else if textField == zip {
            self.zip.placeholder = ""
        } else if textField == day {
            self.day.placeholder = ""
        } else if textField == month {
            self.month.placeholder = ""
        } else if textField == year {
            self.year.placeholder = ""
        } else if textField == phone {
            self.phone.placeholder = ""
        } else if textField == ssnField {
            self.ssnField.placeholder = ""
        } else if textField == routing {
            self.routing.placeholder = ""
        } else {
            self.account.placeholder = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == name {
            self.name.placeholder = "First Name"
        } else if textField == last {
            self.last.placeholder = "Last"
        } else if textField == addressLine1 {
            self.addressLine1.placeholder = "Address"
        } else if textField == addressLine2 {
            self.addressLine2.placeholder = "Address line 2"
        } else if textField == city {
            self.city.placeholder = "City"
        } else if textField == state {
            self.state.placeholder = "State"
        } else if textField == zip {
            self.zip.placeholder = "Zipcode"
        } else if textField == day {
            self.day.placeholder = "Birth Day"
        } else if textField == month {
            self.month.placeholder = "Month"
        } else if textField == year {
            self.year.placeholder = "Year"
        } else if textField == phone {
            self.phone.placeholder = "Phone number"
        } else if textField == ssnField {
            self.ssnField.placeholder = "_ _ _ _"
        } else if textField == routing {
            self.routing.placeholder = "Routing number"
        } else {
            self.account.placeholder = "Account number"
        }
    }
    
    @objc func dismissDetails(sender: UIButton) {
        self.delegate?.hideBankAccountController()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}
