//
//  HostOnboardingBottomView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/22/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class HostOnboardingBottomView: UIViewController {
    
    lazy var bottomHeight: CGFloat = 168 - cancelBottomHeight
    
    var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("List Your Spot", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.DARK_GRAY
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
        
        let string = "Read our Host Policies or learn \nabout Host Regulations."
        let attributedString = NSMutableAttributedString(string: string)
        let range = (string as NSString).range(of: string)
        let privacyRange = (string as NSString).range(of: "Host Policies")
        let regulationRange = (string as NSString).range(of: "Host Regulations")
        attributedString.addAttribute(NSAttributedString.Key.font, value: Fonts.SSPRegularH5, range: range)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.PRUSSIAN_BLUE, range: range)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.BLUE, range: privacyRange)
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: Theme.BLUE, range: privacyRange)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.BLUE, range: regulationRange)
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: Theme.BLUE, range: regulationRange)
        attributedString.addAttributes([NSAttributedString.Key.paragraphStyle : style], range: range)
        
        let privacyAttribute = [NSAttributedString.Key.myAttributeName: "Host Policy"]
        attributedString.addAttributes(privacyAttribute, range: privacyRange)
        let regulationAttribute = [NSAttributedString.Key.myAttributeName: "Host Regulations"]
        attributedString.addAttributes(regulationAttribute, range: regulationRange)
        
        label.attributedText = attributedString
        label.isScrollEnabled = false
        label.isEditable = false
        
        return label
    }()
    
    var mainIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "mainQuickHost")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.PRUSSIAN_BLUE
        button.isUserInteractionEnabled = false
        button.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let hostTap = UITapGestureRecognizer(target: self, action: #selector(textViewMethodToHandleTap(_:)))
        hostTap.delegate = self
        hostPoliciesLabel.addGestureRecognizer(hostTap)
        
        setupViews()
    }
    
    var mainButtonBottomAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(mainButton)
        view.addSubview(hostPoliciesLabel)
        view.addSubview(mainIcon)
        
        mainButton.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 56)
        mainButtonBottomAnchor = mainButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
            mainButtonBottomAnchor.isActive = true
        
        hostPoliciesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hostPoliciesLabel.anchor(top: nil, left: view.leftAnchor, bottom: mainButton.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 16, paddingRight: 20, width: 0, height: 0)
        hostPoliciesLabel.sizeToFit()
        
        mainIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainIcon.anchor(top: nil, left: nil, bottom: hostPoliciesLabel.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        
    }
    
    func expandController() {
        mainButtonBottomAnchor.constant = 16
        UIView.animate(withDuration: animationIn) {
            self.mainButton.alpha = 0
            self.hostPoliciesLabel.alpha = 0
            self.mainIcon.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func minimizeController() {
        mainButtonBottomAnchor.constant = -16
        UIView.animate(withDuration: animationIn) {
            self.mainButton.alpha = 1
            self.hostPoliciesLabel.alpha = 1
            self.mainIcon.alpha = 1
            self.view.layoutIfNeeded()
        }
    }

}

extension HostOnboardingBottomView: UIGestureRecognizerDelegate {
    
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
