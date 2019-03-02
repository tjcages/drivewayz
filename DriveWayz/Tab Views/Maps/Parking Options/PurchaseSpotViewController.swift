//
//  PurchaseSpotViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 2/19/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol handleDurationSet {
    func durationTimeSet(duration: String, time: Double)
}

class PurchaseSpotViewController: UIViewController, handleDurationSet {
    
    var delegate: handleCheckoutParking?
    var parkingCost: Double = 0.0
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.6
        
        return view
    }()
    
    var locatorArrow: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "locationArrow")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        button.alpha = 0.8
        
        return button
    }()
    
    var totalCostLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "$3.10 per hour"
        label.font = Fonts.SSPSemiBoldH1
        
        return label
    }()
    
    var fullDatesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "Set duration"
        label.font = Fonts.SSPRegularH2
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    var setTimeIcon: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "time")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(durationPressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel(frame: CGRect(x: 24, y: 10, width: 100, height: 30))
        label.text = "Visa 4422"
        label.font = Fonts.SSPRegularH4
        view.addSubview(label)
        
        let line = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.5))
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        view.addSubview(line)
        
        return view
    }()
    
    var carIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let img = UIImage(named: "singleCarIcon")
        var image = UIImage(cgImage: img!.cgImage!, scale: 1.0, orientation: UIImage.Orientation.upMirrored)
        button.setImage(image, for: .normal)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var carLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "1"
        label.font = Fonts.SSPLightH5
        label.textAlignment = .right
        
        return label
    }()
    
    lazy var confirmPurchaseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("CONFIRM PURCHASE", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.BLACK
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.addTarget(self, action: #selector(confirmPurchasePressed(sender:)), for: .touchUpInside)
//        button.layer.cornerRadius = 3
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
        
        return button
    }()
    
    var blankView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var durationController: PurchaseDurationViewController = {
        let controller = PurchaseDurationViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
        controller.delegate = self
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupPayment()
        setupControllers()
    }
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(confirmPurchaseButton)
        confirmPurchaseButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        confirmPurchaseButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: -1).isActive = true
        confirmPurchaseButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 1).isActive = true
        switch device {
        case .iphone8:
            confirmPurchaseButton.heightAnchor.constraint(equalToConstant: 62).isActive = true
        case .iphoneX:
            confirmPurchaseButton.heightAnchor.constraint(equalToConstant: 82).isActive = true
        }
    
        self.view.addSubview(locatorArrow)
        self.view.addSubview(totalCostLabel)
        locatorArrow.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        locatorArrow.centerYAnchor.constraint(equalTo: totalCostLabel.centerYAnchor).isActive = true
        locatorArrow.widthAnchor.constraint(equalToConstant: 26).isActive = true
        locatorArrow.heightAnchor.constraint(equalTo: locatorArrow.widthAnchor).isActive = true
        
        totalCostLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        totalCostLabel.leftAnchor.constraint(equalTo: locatorArrow.rightAnchor, constant: 12).isActive = true
        totalCostLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24).isActive = true
        totalCostLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(fullDatesLabel)
        fullDatesLabel.leftAnchor.constraint(equalTo: totalCostLabel.leftAnchor).isActive = true
        fullDatesLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        fullDatesLabel.topAnchor.constraint(equalTo: totalCostLabel.bottomAnchor, constant: 4).isActive = true
        fullDatesLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(durationPressed))
        fullDatesLabel.addGestureRecognizer(tapGesture)
        
        self.view.addSubview(setTimeIcon)
        setTimeIcon.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        setTimeIcon.centerYAnchor.constraint(equalTo: fullDatesLabel.centerYAnchor, constant: 2).isActive = true
        setTimeIcon.widthAnchor.constraint(equalToConstant: 26).isActive = true
        setTimeIcon.heightAnchor.constraint(equalTo: setTimeIcon.widthAnchor).isActive = true
        
    }
    
    func setupPayment() {
        
        self.view.addSubview(cardView)
        cardView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: -1).isActive = true
        cardView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 1).isActive = true
        cardView.bottomAnchor.constraint(equalTo: confirmPurchaseButton.topAnchor).isActive = true
        cardView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        cardView.addSubview(carIcon)
        carIcon.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        carIcon.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 15).isActive = true
        carIcon.widthAnchor.constraint(equalToConstant: 25).isActive = true
        carIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        cardView.addSubview(carLabel)
        carLabel.rightAnchor.constraint(equalTo: carIcon.leftAnchor, constant: -4).isActive = true
        carLabel.centerYAnchor.constraint(equalTo: carIcon.centerYAnchor).isActive = true
        carLabel.widthAnchor.constraint(equalToConstant: 25).isActive = true
        carLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    func setupControllers() {
        
        self.view.addSubview(durationController.view)
        durationController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        durationController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        durationController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        durationController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(blankView)
        self.view.bringSubviewToFront(confirmPurchaseButton)
        blankView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        blankView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        blankView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        blankView.topAnchor.constraint(equalTo: self.confirmPurchaseButton.topAnchor).isActive = true
        
    }
    
    func durationTimeSet(duration: String, time: Double) {
        self.fullDatesLabel.text = duration
        let amount = round((time * self.parkingCost) * 100)/100
        self.totalCostLabel.text = "$\(amount)"
        self.totalCostLabel.textColor = Theme.PACIFIC_BLUE
    }
    
    func bookingPressed() {
        if self.fullDatesLabel.text == "Set duration" {
            let price = String(format: "%.2f", self.parkingCost)
            self.totalCostLabel.text = "$\(price) per hour"
            self.confirmPurchaseButton.setTitle("SET DURATION", for: .normal)
            self.confirmPurchaseButton.backgroundColor = Theme.BLACK
            self.confirmPurchaseButton.setTitleColor(Theme.WHITE, for: .normal)
            self.confirmPurchaseButton.layer.borderWidth = 0
            self.totalCostLabel.textColor = Theme.BLACK
        } else {
            self.confirmPurchaseButton.setTitle("CONFIRM PURCHASE", for: .normal)
            self.confirmPurchaseButton.backgroundColor = Theme.PACIFIC_BLUE
            self.confirmPurchaseButton.setTitleColor(Theme.WHITE, for: .normal)
            self.confirmPurchaseButton.layer.borderWidth = 0
        }
    }
    
    @objc func confirmPurchasePressed(sender: UIButton) {
        if sender.titleLabel?.text == "SET DURATION" && self.durationController.view.alpha == 1 {
            self.delegate?.durationSet()
            self.durationController.timeDurationSet()
            self.confirmPurchaseButton.setTitle("CONFIRM PURCHASE", for: .normal)
            UIView.animate(withDuration: animationIn, animations: {
                self.durationController.view.alpha = 0
                self.locatorArrow.alpha = 0.8
                self.totalCostLabel.alpha = 1
                self.fullDatesLabel.alpha = 1
                self.setTimeIcon.alpha = 1
                self.cardView.alpha = 1
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.confirmPurchaseButton.backgroundColor = Theme.PACIFIC_BLUE
                    self.confirmPurchaseButton.setTitleColor(Theme.WHITE, for: .normal)
                    self.confirmPurchaseButton.layer.borderWidth = 0
                })
            }
        } else if sender.titleLabel?.text == "SET DURATION" && self.durationController.view.alpha == 0 {
            self.durationController.didSetTimes()
            self.durationPressed()
        } else {
            self.delegate?.confirmPurchasePressed()
        }
    }
    
    @objc func durationPressed() {
        self.delegate?.setDurationPressed()
        self.durationController.didSetTimes()
        UIView.animate(withDuration: animationIn, animations: {
            self.locatorArrow.alpha = 0
            self.totalCostLabel.alpha = 0
            self.fullDatesLabel.alpha = 0
            self.setTimeIcon.alpha = 0
            self.cardView.alpha = 0
            self.confirmPurchaseButton.backgroundColor = Theme.BLACK
        }) { (success) in
            self.confirmPurchaseButton.setTitle("SET DURATION", for: .normal)
            UIView.animate(withDuration: animationIn, animations: {
                self.durationController.view.alpha = 1
                self.confirmPurchaseButton.backgroundColor = Theme.WHITE
                self.confirmPurchaseButton.setTitleColor(Theme.BLACK, for: .normal)
                self.confirmPurchaseButton.layer.borderWidth = 1
            })
        }
    }
    
    @objc func durationSet() {
        UIView.animate(withDuration: animationIn, animations: {
            self.durationController.view.alpha = 0
        }) { (success) in
            UIView.animate(withDuration: animationOut, animations: {
                self.locatorArrow.alpha = 0.8
                self.totalCostLabel.alpha = 1
                self.fullDatesLabel.alpha = 1
                self.setTimeIcon.alpha = 1
                self.cardView.alpha = 1
            })
        }
    }
    
}
