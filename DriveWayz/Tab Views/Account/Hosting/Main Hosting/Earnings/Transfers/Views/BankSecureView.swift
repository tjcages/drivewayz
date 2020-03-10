//
//  BankSecureViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 6/17/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class BankSecureView: UIViewController {
    
    var firstCheck: CheckBox = {
        let check = CheckBox()
        check.translatesAutoresizingMaskIntoConstraints = false
        check.style = .tick
        check.isChecked = true
        check.borderStyle = .roundedSquare(radius: 16)
        check.checkedBorderColor = .clear
        check.checkboxBackgroundColor = .clear
        check.checkmarkColor = Theme.BLUE
        check.backgroundColor = Theme.HOST_BLUE
        check.layer.cornerRadius = 16
        check.clipsToBounds = true
        check.isUserInteractionEnabled = false
        
        return check
    }()
    
    var firstLabel: UILabel = {
        let label = UILabel()
        label.text = "Secure payouts"
        label.textColor = Theme.BLACK
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var firstSubLabel: UILabel = {
        let label = UILabel()
        label.text = "The transfer of your information \nis encrypted end-to-end."
        label.textColor = Theme.GRAY_WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH5
        label.numberOfLines = 2
        
        return label
    }()

    var secondCheck: CheckBox = {
        let check = CheckBox()
        check.translatesAutoresizingMaskIntoConstraints = false
        check.style = .tick
        check.isChecked = true
        check.borderStyle = .roundedSquare(radius: 16)
        check.checkedBorderColor = .clear
        check.checkboxBackgroundColor = .clear
        check.checkmarkColor = Theme.BLUE
        check.backgroundColor = Theme.HOST_BLUE
        check.layer.cornerRadius = 16
        check.clipsToBounds = true
        check.isUserInteractionEnabled = false
        
        return check
    }()
    
    var secondLabel: UILabel = {
        let label = UILabel()
        label.text = "Privacy ensured"
        label.textColor = Theme.BLACK
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var secondSubLabel: UILabel = {
        let label = UILabel()
        label.text = "Your credentials will never be \nmade accessible to Drivewayz."
        label.textColor = Theme.GRAY_WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH5
        label.numberOfLines = 2
        
        return label
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        
        return view
    }()
    
    var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Link Bank Account", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.BLACK
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 4
        
        return button
    }()
    
    lazy var hostPoliciesLabel: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isSelectable = false
        label.backgroundColor = .clear
        
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        
        let string = "By linking your account, you agree to our \nServices Agreement and the Stripe \nConnected Account Agreement."
        let attributedString = NSMutableAttributedString(string: string)
        let range = (string as NSString).range(of: string)
        let privacyRange = (string as NSString).range(of: "Services Agreement")
        let regulationRange = (string as NSString).range(of: "Stripe \nConnected Account Agreement")
        attributedString.addAttribute(NSAttributedString.Key.font, value: Fonts.SSPRegularH5, range: range)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.GRAY_WHITE, range: range)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.BLUE, range: privacyRange)
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: Theme.BLUE, range: privacyRange)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.BLUE, range: regulationRange)
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: Theme.BLUE, range: regulationRange)
        attributedString.addAttributes([NSAttributedString.Key.paragraphStyle : style], range: range)
        
        let privacyAttribute = [NSAttributedString.Key.myAttributeName: "Services Agreement"]
        attributedString.addAttributes(privacyAttribute, range: privacyRange)
        let regulationAttribute = [NSAttributedString.Key.myAttributeName: "Stripe"]
        attributedString.addAttributes(regulationAttribute, range: regulationRange)
        
        label.attributedText = attributedString
        label.isScrollEnabled = false
        label.isEditable = false
        
        return label
    }()
    
    var mainIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "hostLock")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.GRAY_WHITE
        button.isUserInteractionEnabled = false
        button.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let hostTap = UITapGestureRecognizer(target: self, action: #selector(textViewMethodToHandleTap(_:)))
        hostTap.delegate = self
        hostPoliciesLabel.addGestureRecognizer(hostTap)

        setupViews()
        setupBottom()
    }
    
    func setupViews() {
        
        view.addSubview(firstCheck)
        view.addSubview(firstLabel)
        view.addSubview(firstSubLabel)
        
        firstLabel.leftAnchor.constraint(equalTo: firstCheck.rightAnchor, constant: 20).isActive = true
        firstLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        firstLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        firstLabel.sizeToFit()
        
        firstSubLabel.leftAnchor.constraint(equalTo: firstLabel.leftAnchor).isActive = true
        firstSubLabel.rightAnchor.constraint(equalTo: firstLabel.rightAnchor).isActive = true
        firstSubLabel.topAnchor.constraint(equalTo: firstLabel.bottomAnchor, constant: 4).isActive = true
        firstSubLabel.sizeToFit()
        
        firstCheck.centerYAnchor.constraint(equalTo: firstSubLabel.topAnchor).isActive = true
        firstCheck.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        firstCheck.widthAnchor.constraint(equalToConstant: 32).isActive = true
        firstCheck.heightAnchor.constraint(equalTo: firstCheck.widthAnchor).isActive = true
        
        view.addSubview(secondCheck)
        view.addSubview(secondLabel)
        view.addSubview(secondSubLabel)
        
        secondLabel.leftAnchor.constraint(equalTo: secondCheck.rightAnchor, constant: 20).isActive = true
        secondLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        secondLabel.topAnchor.constraint(equalTo: firstSubLabel.bottomAnchor, constant: 20).isActive = true
        secondLabel.sizeToFit()
        
        secondSubLabel.leftAnchor.constraint(equalTo: secondLabel.leftAnchor).isActive = true
        secondSubLabel.rightAnchor.constraint(equalTo: secondLabel.rightAnchor).isActive = true
        secondSubLabel.topAnchor.constraint(equalTo: secondLabel.bottomAnchor, constant: 4).isActive = true
        secondSubLabel.sizeToFit()
        
        secondCheck.centerYAnchor.constraint(equalTo: secondSubLabel.topAnchor).isActive = true
        secondCheck.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        secondCheck.widthAnchor.constraint(equalToConstant: 32).isActive = true
        secondCheck.heightAnchor.constraint(equalTo: secondCheck.widthAnchor).isActive = true
        
    }
    
    func setupBottom() {
        
        view.addSubview(line)
        view.addSubview(mainButton)
        view.addSubview(hostPoliciesLabel)
        view.addSubview(mainIcon)
        
        mainButton.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 56)
        mainButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        
        hostPoliciesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hostPoliciesLabel.anchor(top: nil, left: view.leftAnchor, bottom: mainButton.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 16, paddingRight: 20, width: 0, height: 0)
        hostPoliciesLabel.sizeToFit()
        
        mainIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainIcon.anchor(top: nil, left: nil, bottom: hostPoliciesLabel.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        
        line.anchor(top: nil, left: view.leftAnchor, bottom: mainIcon.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 0, height: 1)
        
    }
 
}

extension BankSecureView: UIGestureRecognizerDelegate {
    
    func moveToHostPolicies() {
        let controller = ReadPoliciesViewController()
        controller.Url = URL(string: "http://www.drivewayz.io/host-policies.html")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func moveToHostRegulations() {
        let controller = ReadPoliciesViewController()
        controller.Url = URL(string: "http://www.drivewayz.io/rules--regulations.html")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
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
                if value == "Host Policy" {
                    moveToHostPolicies()
                } else if value == "Host Regulations" {
                    moveToHostRegulations()
                }
            }
        }
    }
    
}
