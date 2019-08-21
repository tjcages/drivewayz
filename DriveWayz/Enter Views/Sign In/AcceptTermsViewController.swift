//
//  AcceptTermsViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 8/20/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class AcceptTermsViewController: UIViewController {
    
    var uid: String?
    var name: String?
    var phoneNumber: String?
    
    var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH2
        label.text = "Create account"
        
        return label
    }()
    
    var informationAcceptLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH4
        label.numberOfLines = 6
        label.text = "By registering your host parking space you confirm that you own all rights and privileges to the property or have written consent from the landlord and you agree to the policies below."
        
        return label
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = lineColor
        button.setTitle("Confirm", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(createNewUser), for: .touchUpInside)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var loadingActivity: NVActivityIndicatorView = {
        let loading = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballPulse, color: Theme.WHITE, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.alpha = 0
        
        return loading
    }()
    
    var mainPoliciesCheck: CheckBox = {
        let check = CheckBox()
        check.translatesAutoresizingMaskIntoConstraints = false
        check.style = .tick
        check.borderStyle = .roundedSquare(radius: 2)
        check.checkedBorderColor = Theme.BLUE
        check.uncheckedBorderColor = lineColor
        check.checkmarkColor = Theme.BLUE
        check.addTarget(self, action: #selector(onCheckBoxValueChange(_:)), for: .valueChanged)
        
        return check
    }()
    
    var mainPoliciesLabel: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH5
        label.isSelectable = false
        let string = "I agree to the Privacy Policy"
        let attributedString = NSMutableAttributedString(string: string)
        let range = (string as NSString).range(of: string)
        let privacyRange = (string as NSString).range(of: "Privacy Policy")
        attributedString.addAttribute(NSAttributedString.Key.font, value: Fonts.SSPRegularH5, range: range)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.BLUE, range: privacyRange)
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: Theme.BLUE, range: privacyRange)
        
        let privacyAttribute = [NSAttributedString.Key.myAttributeName: "Privacy Policy"]
        attributedString.addAttributes(privacyAttribute, range: privacyRange)
        
        label.attributedText = attributedString
        label.isScrollEnabled = false
        label.isEditable = false
        
        return label
    }()
    
    var hostPoliciesCheck: CheckBox = {
        let check = CheckBox()
        check.translatesAutoresizingMaskIntoConstraints = false
        check.style = .tick
        check.borderStyle = .roundedSquare(radius: 2)
        check.checkedBorderColor = Theme.BLUE
        check.uncheckedBorderColor = lineColor
        check.checkmarkColor = Theme.BLUE
        check.addTarget(self, action: #selector(onCheckBoxValueChange(_:)), for: .valueChanged)
        
        return check
    }()
    
    lazy var hostPoliciesLabel: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH5
        label.isSelectable = false
        let string = "I have read and agree to the \nTerms & Conditions"
        let attributedString = NSMutableAttributedString(string: string)
        let range = (string as NSString).range(of: string)
        let regulationRange = (string as NSString).range(of: "Terms & Conditions")
        attributedString.addAttribute(NSAttributedString.Key.font, value: Fonts.SSPRegularH5, range: range)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.BLUE, range: regulationRange)
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: Theme.BLUE, range: regulationRange)

        let regulationAttribute = [NSAttributedString.Key.myAttributeName: "Terms & Conditions"]
        attributedString.addAttributes(regulationAttribute, range: regulationRange)
        
        label.attributedText = attributedString
        label.isScrollEnabled = false
        label.isEditable = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(textViewMethodToHandleTap(_:)))
        tap.delegate = self
        label.addGestureRecognizer(tap)
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainTap = UITapGestureRecognizer(target: self, action: #selector(textViewMethodToHandleTap(_:)))
        mainTap.delegate = self
        mainPoliciesLabel.addGestureRecognizer(mainTap)
        let hostTap = UITapGestureRecognizer(target: self, action: #selector(textViewMethodToHandleTap(_:)))
        hostTap.delegate = self
        hostPoliciesLabel.addGestureRecognizer(hostTap)
        
        view.backgroundColor = Theme.WHITE

        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        switch device {
        case .iphone8:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true
        case .iphoneX:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 52).isActive = true
        }
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        switch device {
        case .iphone8:
            mainLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120).isActive = true
        case .iphoneX:
            mainLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 132).isActive = true
        }
        
        self.view.addSubview(informationAcceptLabel)
        informationAcceptLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 16).isActive = true
        informationAcceptLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        informationAcceptLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        informationAcceptLabel.sizeToFit()
        
        self.view.addSubview(mainPoliciesCheck)
        mainPoliciesCheck.leftAnchor.constraint(equalTo: informationAcceptLabel.leftAnchor).isActive = true
        mainPoliciesCheck.topAnchor.constraint(equalTo: informationAcceptLabel.bottomAnchor, constant: 48).isActive = true
        mainPoliciesCheck.heightAnchor.constraint(equalToConstant: 25).isActive = true
        mainPoliciesCheck.widthAnchor.constraint(equalTo: mainPoliciesCheck.heightAnchor).isActive = true
        
        self.view.addSubview(mainPoliciesLabel)
        mainPoliciesLabel.leftAnchor.constraint(equalTo: mainPoliciesCheck.rightAnchor, constant: 16).isActive = true
        mainPoliciesLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainPoliciesLabel.centerYAnchor.constraint(equalTo: mainPoliciesCheck.centerYAnchor).isActive = true
        mainPoliciesLabel.sizeToFit()
        
        self.view.addSubview(hostPoliciesCheck)
        hostPoliciesCheck.leftAnchor.constraint(equalTo: informationAcceptLabel.leftAnchor).isActive = true
        hostPoliciesCheck.topAnchor.constraint(equalTo: mainPoliciesCheck.bottomAnchor, constant: 32).isActive = true
        hostPoliciesCheck.heightAnchor.constraint(equalToConstant: 25).isActive = true
        hostPoliciesCheck.widthAnchor.constraint(equalTo: mainPoliciesCheck.heightAnchor).isActive = true
        
        self.view.addSubview(hostPoliciesLabel)
        hostPoliciesLabel.leftAnchor.constraint(equalTo: hostPoliciesCheck.rightAnchor, constant: 16).isActive = true
        hostPoliciesLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        hostPoliciesLabel.centerYAnchor.constraint(equalTo: hostPoliciesCheck.centerYAnchor).isActive = true
        hostPoliciesLabel.sizeToFit()
        
        self.view.addSubview(confirmButton)
        confirmButton.topAnchor.constraint(equalTo: hostPoliciesLabel.bottomAnchor, constant: 64).isActive = true
        confirmButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 60).isActive = true
        confirmButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -60).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        self.view.addSubview(loadingActivity)
        loadingActivity.centerXAnchor.constraint(equalTo: confirmButton.centerXAnchor).isActive = true
        loadingActivity.centerYAnchor.constraint(equalTo: confirmButton.centerYAnchor).isActive = true
        loadingActivity.widthAnchor.constraint(equalToConstant: 40).isActive = true
        loadingActivity.heightAnchor.constraint(equalTo: loadingActivity.widthAnchor).isActive = true
        
    }
    
    @objc func createNewUser() {
        if let userID = self.uid, let name = self.name, let number = self.phoneNumber {
            
            let loadingView = SuccessfulPurchaseViewController()
            loadingView.loadingActivity.startAnimating()
            loadingView.modalPresentationStyle = .overCurrentContext
            loadingView.modalTransitionStyle = .crossDissolve
            self.present(loadingView, animated: true, completion: nil)
            
            let ref = Database.database().reference(fromURL: "https://drivewayz-e20b9.firebaseio.com")
            let usersReference = ref.child("users").child(userID)
            let values = ["name": name,
                          "phone": "+1 " + number,
                          "DeviceID": AppDelegate.DEVICEID]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if let error = err {
                    print(error.localizedDescription as Any)
                    self.showSimpleAlert(title: "Error", message: error.localizedDescription)
                    return
                }
                self.dismiss(animated: true, completion: {
                    self.moveToLocationServices()
                })

                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                UserDefaults.standard.set(name, forKey: "userName")
                UserDefaults.standard.synchronize()
            })
        }
    }
    
    @objc func onCheckBoxValueChange(_ sender: CheckBox) {
        if self.mainPoliciesCheck.isChecked == true && self.hostPoliciesCheck.isChecked == true {
            self.confirmButton.backgroundColor = Theme.BLUE
            self.confirmButton.setTitleColor(Theme.WHITE, for: .normal)
            self.confirmButton.isUserInteractionEnabled = true
        } else {
            self.confirmButton.backgroundColor = lineColor
            self.confirmButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
            self.confirmButton.isUserInteractionEnabled = false
        }
    }
    
    func moveToLocationServices() {
        let controller = LocationServicesViewController()
        self.addChild(controller)
        self.navigationController?.pushViewController(controller, animated: true)
    }

}

extension AcceptTermsViewController: UIGestureRecognizerDelegate {
    
    @objc func textViewMethodToHandleTap(_ sender: UITapGestureRecognizer) {
        
        let myTextView = sender.view as! UITextView
        let layoutManager = myTextView.layoutManager
        
        // location of tap in myTextView coordinates and taking the inset into account
        var location = sender.location(in: myTextView)
        location.x -= myTextView.textContainerInset.left;
        location.y -= myTextView.textContainerInset.top;
        
        // character index at tap location
        let characterIndex = layoutManager.characterIndex(for: location, in: myTextView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        // if index is valid then do something.
        if characterIndex < myTextView.textStorage.length {
            // check if the tap location has a certain attribute
            let attributeName = NSAttributedString.Key.myAttributeName
            let attributeValue = myTextView.attributedText?.attribute(attributeName, at: characterIndex, effectiveRange: nil)
            if let value = attributeValue as? String {
                if value == "Privacy Policy" {
                    self.moveToPrivacy()
                } else if value == "Terms & Conditions" {
                    self.moveToTerms()
                }
            }
        }
    }
    
    func moveToPrivacy() {
        let controller = ReadPoliciesViewController()
        controller.Url = URL(string: "http://www.drivewayz.io/privacy.html")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func moveToTerms() {
        let controller = ReadPoliciesViewController()
        controller.Url = URL(string: "http://www.drivewayz.io/terms.html")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func backButtonPressed() {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    func showSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
}
