//
//  ListingDetailsView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/23/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol HandleListingDetails {
    func unselectViews()
    func dismissKeyboard()
    func checkNumber() -> Bool
    func selectView(view: UIView)
    func monitorNumberSpots(text: String)
    func saveCutomNumbers(numbers: [Int])
    
    func expandSpotView()
    func addSpotRange()
    func removeSpotRange()
    func minimizeSpotView()
    
    func expandGateView()
    func minimizeGateView()
    
    func removeDim()
}

class ListingDetailsView: UIViewController {
    
    var delegate: HandleListingDetailViews?
    var scrollHeight: CGFloat = 352 + abs(cancelBottomHeight * 2)
    
    lazy var numbersView: ListingNumbersView = {
        let controller = ListingNumbersView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        
        return controller
    }()
    
    lazy var spotView: ListingNumberView = {
        let controller = ListingNumberView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        controller.informationIcon.addTarget(self, action: #selector(spotInformationPressed), for: .touchUpInside)
        controller.customNumbersButton.addTarget(self, action: #selector(customNumbersPressed), for: .touchUpInside)
        controller.editNumbersButton.addTarget(self, action: #selector(customNumbersPressed), for: .touchUpInside)
        
        return controller
    }()
    
    lazy var gateView: ListingCodeView = {
        let controller = ListingCodeView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        controller.informationIcon.addTarget(self, action: #selector(gateInformationPressed), for: .touchUpInside)
        
        return controller
    }()

    lazy var bubbleArrow: BubbleArrow = {
        let view = BubbleArrow()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        view.message = "Please provide the correct amount of spot numbers."
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.2
        view.leftTriangle()
        view.verticalTriangle()
        view.label.font = Fonts.SSPRegularH5
        view.alpha = 0
        
        return view
    }()
    
    let customView = CustomNumbersView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        setupViews()
    }
    
    var spotViewHeightAnchor: NSLayoutConstraint!
    var gateViewHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(numbersView.view)
        view.addSubview(spotView.view)
        view.addSubview(gateView.view)
        
        numbersView.view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 120)
        
        spotView.view.anchor(top: numbersView.view.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        spotViewHeightAnchor = spotView.view.heightAnchor.constraint(equalToConstant: 116)
            spotViewHeightAnchor.isActive = true
        
        gateView.view.anchor(top: spotView.view.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        gateViewHeightAnchor = gateView.view.heightAnchor.constraint(equalToConstant: 116)
            gateViewHeightAnchor.isActive = true
        
        view.addSubview(bubbleArrow)
        bubbleArrow.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        bubbleArrow.bottomAnchor.constraint(equalTo: spotView.view.topAnchor, constant: 8).isActive = true
        bubbleArrow.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        bubbleArrow.heightAnchor.constraint(equalToConstant: (bubbleArrow.label.text?.height(withConstrainedWidth: phoneWidth - 64, font: Fonts.SSPRegularH4))! + 24).isActive = true
        
    }
    
    @objc func spotInformationPressed() {
        delegate?.dimBackground()
        delayWithSeconds(animationIn) {
            let controller = ListingInformationView()
            controller.delegate = self
            controller.modalPresentationStyle = .overFullScreen
            controller.informationIndex = 0
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @objc func gateInformationPressed() {
        delegate?.dimBackground()
        delayWithSeconds(animationIn) {
            let controller = ListingInformationView()
            controller.delegate = self
            controller.modalPresentationStyle = .overFullScreen
            controller.informationIndex = 1
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @objc func customNumbersPressed() {
        spotView.view.endEditing(true)
        delegate?.dimBackground()
        if let number = Int(numbersView.mainTextView.text) {
            customView.maxSpots = number
        }
        delayWithSeconds(animationIn) {
            self.customView.delegate = self
            self.customView.modalPresentationStyle = .overFullScreen
            self.present(self.customView, animated: true, completion: nil)
        }
    }
    
    func removeDim() {
        delegate?.removeDim()
    }
    
}

extension ListingDetailsView: HandleListingDetails {
    
    func saveCutomNumbers(numbers: [Int]) {
        spotView.customNumbers = numbers
    }
    
    func expandSpotView() {
        if spotView.numberSpots > 1 {
            scrollHeight += 128
            delegate?.changeScrollHeight(height: scrollHeight)
            spotViewHeightAnchor.constant = 244
            UIView.animate(withDuration: animationIn, animations: {
                self.view.layoutIfNeeded()
            }) { (success) in
                if self.spotView.mainTextView.alpha == 1 {
                    self.spotView.mainTextView.becomeFirstResponder()
                }
            }
        } else {
            scrollHeight += 62
            delegate?.changeScrollHeight(height: scrollHeight)
            spotViewHeightAnchor.constant = 178
            UIView.animate(withDuration: animationIn, animations: {
                self.spotView.addRangeButton.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                if self.spotView.mainTextView.alpha == 1 {
                    self.spotView.mainTextView.becomeFirstResponder()
                }
            }
        }
    }
    
    func addSpotRange() {
        scrollHeight += 28
        delegate?.changeScrollHeight(height: scrollHeight)
        spotViewHeightAnchor.constant = 272
        UIView.animate(withDuration: animationIn, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            self.spotView.mainTextView2.becomeFirstResponder()
        }
    }
    
    func removeSpotRange() {
        scrollHeight -= 62
        delegate?.changeScrollHeight(height: scrollHeight)
        spotViewHeightAnchor.constant = 244
        UIView.animate(withDuration: animationIn, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func minimizeSpotView() {
        dismissKeyboard()
        if spotView.numberSpots > 1 {
            scrollHeight -= 128
        } else {
            scrollHeight -= 62
        }
        delegate?.changeScrollHeight(height: scrollHeight)
        spotViewHeightAnchor.constant = 116
        UIView.animate(withDuration: animationIn, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            //
        }
    }
    
    func expandGateView() {
        scrollHeight += 62
        delegate?.changeScrollHeight(height: scrollHeight)
        gateViewHeightAnchor.constant = 178
        UIView.animate(withDuration: animationIn, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            self.gateView.mainTextView.becomeFirstResponder()
        }
    }
    
    func minimizeGateView() {
        dismissKeyboard()
        scrollHeight -= 62
        delegate?.changeScrollHeight(height: scrollHeight)
        gateViewHeightAnchor.constant = 116
        UIView.animate(withDuration: animationIn, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            //
        }
    }
    
    func checkNumber() -> Bool {
        if numbersView.mainTextView.text == "" {
            UIView.animate(withDuration: animationIn, animations: {
                self.numbersView.bubbleArrow.alpha = 1
            }) { (success) in

            }
            return false
        } else {
            dismissKeyboard()
            return true
        }
    }
    
    func monitorNumberSpots(text: String) {
        if let value = Int(text) {
            spotView.numberSpots = value
        }
    }
    
    func selectView(view: UIView) {
        view.backgroundColor = Theme.BLUE.withAlphaComponent(0.2)
        delegate?.scrollToView(view: view)
        
        if view == numbersView.view {
            spotView.switchButton.isUserInteractionEnabled = false
            gateView.switchButton.isUserInteractionEnabled = false
        } else if view == spotView.view {
            gateView.switchButton.isUserInteractionEnabled = false
        } else if view == gateView.view {
            spotView.switchButton.isUserInteractionEnabled = false
        }
    }
    
    func unselectViews() {
        numbersView.view.backgroundColor = .clear
        spotView.view.backgroundColor = .clear
        gateView.view.backgroundColor = .clear
        
        spotView.switchButton.isUserInteractionEnabled = true
        gateView.switchButton.isUserInteractionEnabled = true
        
        delegate?.scrollToTop()
    }
 
    func dismissKeyboard() {
        view.endEditing(true)
        unselectViews()
    }
    
}

