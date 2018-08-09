//
//  SelectPurchaseViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 8/7/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

protocol handleReservations {
    func reserveCheckPressed(from: String, to: String, hour: Double)
    func hideParkNow()
    func bringParkNow()
}

class SelectPurchaseViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, handleReservations {
    
    var parkingCost: String?
    var delegate: controlHoursButton?
    
    var viewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 5
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 1
        view.layer.shadowOpacity = 0.8
        
        return view
    }()
    
    lazy var swipeBlur: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().lightBlurColor()
        background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 160)
        view.layer.insertSublayer(background, at: 0)
        view.alpha = 0
        
        return view
    }()
    
    var segmentControlView: UIView = {
        let segmentControlView = UIView()
        segmentControlView.translatesAutoresizingMaskIntoConstraints = false
        segmentControlView.backgroundColor = UIColor.clear
        
        return segmentControlView
    }()
    
    var currentSegment: UIButton = {
        let info = UIButton()
        info.translatesAutoresizingMaskIntoConstraints = false
        info.backgroundColor = UIColor.clear
        info.setTitle("Park now", for: .normal)
        info.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        info.setTitleColor(Theme.BLACK, for: .normal)
        info.titleLabel?.textAlignment = .center
        info.addTarget(self, action: #selector(currentPressed(sender:)), for: .touchUpInside)
        
        return info
    }()
    
    var reserveSegment: UIButton = {
        let availability = UIButton()
        availability.translatesAutoresizingMaskIntoConstraints = false
        availability.backgroundColor = UIColor.clear
        availability.setTitle("Reserve", for: .normal)
        availability.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        availability.setTitleColor(Theme.BLACK, for: .normal)
        availability.titleLabel?.textAlignment = .center
        availability.addTarget(self, action: #selector(reservePressed(sender:)), for: .touchUpInside)
        
        return availability
    }()
    
    var selectionLine: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = Theme.PRIMARY_COLOR
        
        return line
    }()
    
    lazy var reserveButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 20, height: 50))
        button.setTitle("Book Spot", for: .normal)
        button.setTitle("", for: .selected)
        button.backgroundColor = Theme.PRIMARY_DARK_COLOR
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(Theme.WHITE, for: .normal)
        let path = UIBezierPath(roundedRect:button.bounds,
                                byRoundingCorners:[.bottomRight, .bottomLeft],
                                cornerRadii: CGSize(width: 5, height: 5))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        button.layer.mask = maskLayer
        
        return button
    }()
    
    var paymentButton: UIButton = {
        let button = UIButton()
        button.setTitle("Payment", for: .normal)
        button.backgroundColor = UIColor.clear
        button.contentMode = .center
        button.titleLabel?.textAlignment = .center
//        button.contentEdgeInsets.top = 10
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(handlePaymentButtonTapped), for: .touchUpInside)
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .light)
        
        return button
    }()
    
    var costButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.setTitleColor(Theme.BLACK.withAlphaComponent(0.7), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        return button
    }()

    var hoursButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.setTitle("1 hour", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .light)
        button.addTarget(self, action: #selector(hourButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var currentTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.BLACK
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "8:00 am"
        label.alpha = 0
        
        return label
    }()
    
    var toLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.BLACK.withAlphaComponent(0.7)
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "to"
        label.alpha = 0
        
        return label
    }()
    
    var timeToPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = UIColor.clear
        picker.tintColor = Theme.DARK_GRAY
        picker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.setValue(Theme.BLACK, forKeyPath: "textColor")
        picker.alpha = 0
        
        return picker
    }()
    
    var checkButton: UIButton = {
        let image = UIImage(named: "Checkmark")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(tintedImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.tintColor = Theme.PRIMARY_DARK_COLOR
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        button.addTarget(self, action: #selector(checkButtonPressed(sender:)), for: .touchUpInside)

        return button
    }()
    
    var line: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = Theme.OFF_WHITE
        
        return line
    }()
    
    var line2: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = Theme.OFF_WHITE
        
        return line
    }()
    
    var line3: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = Theme.OFF_WHITE
        line.alpha = 0
        
        return line
    }()
    
    lazy var reserveController: ReserveViewController = {
        let controller = ReserveViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Reserve"
        controller.view.layer.cornerRadius = 5
        controller.view.alpha = 0
        controller.delegate = self
        
        return controller
    }()
    
    var reserveFromLabel: UIButton = {
        let button = UIButton()
        button.setTitle("8:00 am Wednesday 08", for: .normal)
        button.backgroundColor = UIColor.clear
        button.contentMode = .center
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .light)
        button.titleLabel?.numberOfLines = 2
        button.alpha = 0
        button.addTarget(self, action: #selector(reservePressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var reserveToLabel: UIButton = {
        let button = UIButton()
        button.setTitle("9:00 am Thursday 09", for: .normal)
        button.backgroundColor = UIColor.clear
        button.contentMode = .center
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .light)
        button.titleLabel?.numberOfLines = 2
        button.alpha = 0
        button.addTarget(self, action: #selector(reservePressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var reserveCostLabel: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.setTitleColor(Theme.BLACK.withAlphaComponent(0.7), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitle("$8.00", for: .normal)
        button.alpha = 0
        
        return button
    }()
    
    var toReserveLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.BLACK.withAlphaComponent(0.7)
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "to"
        label.alpha = 0
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.timeToPicker.delegate = self
        self.timeToPicker.dataSource = self
        
        setupViews()
        setTimes()
    }
    
    func setAvailability(available: Bool) {
        
    }
    
    func setData(parkingCost: String, parkingID: String, id: String) {
        self.parkingCost = parkingCost
        self.costButton.setTitle(parkingCost, for: .normal)
        self.costButton.setTitle(parkingCost, for: .highlighted)
        self.reserveCostLabel.setTitle(parkingCost, for: .normal)
        self.reserveCostLabel.setTitle(parkingCost, for: .highlighted)
        self.reserveController.setData(parkingID: parkingID)
    }
    
    var currentSegmentAnchor: NSLayoutConstraint!
    var reserveSegmentAnchor: NSLayoutConstraint!
    var viewContainerHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(swipeBlur)
        swipeBlur.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        swipeBlur.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        swipeBlur.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        swipeBlur.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        self.view.addSubview(viewContainer)
        viewContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -15).isActive = true
        viewContainer.widthAnchor.constraint(equalToConstant: self.view.frame.width - 20).isActive = true
        viewContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        viewContainerHeightAnchor = viewContainer.heightAnchor.constraint(equalToConstant: 140)
            viewContainerHeightAnchor.isActive = true
        
        self.view.addSubview(segmentControlView)
        segmentControlView.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 5).isActive = true
        segmentControlView.rightAnchor.constraint(equalTo: viewContainer.rightAnchor).isActive = true
        segmentControlView.leftAnchor.constraint(equalTo: viewContainer.leftAnchor).isActive = true
        segmentControlView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        segmentControlView.addSubview(currentSegment)
        currentSegment.leftAnchor.constraint(equalTo: segmentControlView.leftAnchor).isActive = true
        currentSegment.rightAnchor.constraint(equalTo: segmentControlView.centerXAnchor, constant: 20).isActive = true
        currentSegment.heightAnchor.constraint(equalToConstant: 30).isActive = true
        currentSegment.topAnchor.constraint(equalTo: segmentControlView.topAnchor).isActive = true
        
        segmentControlView.addSubview(reserveSegment)
        reserveSegment.rightAnchor.constraint(equalTo: segmentControlView.rightAnchor).isActive = true
        reserveSegment.leftAnchor.constraint(equalTo: segmentControlView.centerXAnchor, constant: -20).isActive = true
        reserveSegment.heightAnchor.constraint(equalToConstant: 30).isActive = true
        reserveSegment.topAnchor.constraint(equalTo: segmentControlView.topAnchor).isActive = true
        
        self.view.addSubview(selectionLine)
        selectionLine.topAnchor.constraint(equalTo: segmentControlView.bottomAnchor).isActive = true
        selectionLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        selectionLine.widthAnchor.constraint(equalToConstant: self.view.frame.width / 4 - 10).isActive = true
        currentSegmentAnchor = selectionLine.centerXAnchor.constraint(equalTo: currentSegment.centerXAnchor)
            currentSegmentAnchor.isActive = true
        reserveSegmentAnchor = selectionLine.centerXAnchor.constraint(equalTo: reserveSegment.centerXAnchor)
            reserveSegmentAnchor.isActive = false
        
        self.view.addSubview(reserveButton)
        reserveButton.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor).isActive = true
        reserveButton.widthAnchor.constraint(equalTo: viewContainer.widthAnchor).isActive = true
        reserveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        reserveButton.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor).isActive = true
        
        self.view.addSubview(paymentButton)
        paymentButton.bottomAnchor.constraint(equalTo: reserveButton.topAnchor).isActive = true
        paymentButton.widthAnchor.constraint(equalToConstant: (self.view.frame.width - 20) / 3).isActive = true
        paymentButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        paymentButton.leftAnchor.constraint(equalTo: viewContainer.leftAnchor).isActive = true
        
        self.view.addSubview(reserveFromLabel)
        reserveFromLabel.bottomAnchor.constraint(equalTo: reserveButton.topAnchor).isActive = true
        reserveFromLabel.widthAnchor.constraint(equalToConstant: (self.view.frame.width - 20) / 3 - 20).isActive = true
        reserveFromLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        reserveFromLabel.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 5).isActive = true
        
        self.view.addSubview(costButton)
        costButton.bottomAnchor.constraint(equalTo: reserveButton.topAnchor).isActive = true
        costButton.widthAnchor.constraint(equalToConstant: (self.view.frame.width - 20) / 3).isActive = true
        costButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        costButton.leftAnchor.constraint(equalTo: paymentButton.rightAnchor).isActive = true
        
        self.view.addSubview(reserveToLabel)
        reserveToLabel.bottomAnchor.constraint(equalTo: reserveButton.topAnchor).isActive = true
        reserveToLabel.widthAnchor.constraint(equalToConstant: (self.view.frame.width - 20) / 3 - 20).isActive = true
        reserveToLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        reserveToLabel.leftAnchor.constraint(equalTo: paymentButton.rightAnchor, constant: 35).isActive = true
        
        self.view.addSubview(hoursButton)
        hoursButton.bottomAnchor.constraint(equalTo: reserveButton.topAnchor).isActive = true
        hoursButton.widthAnchor.constraint(equalToConstant: (self.view.frame.width - 20) / 3).isActive = true
        hoursButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        hoursButton.leftAnchor.constraint(equalTo: costButton.rightAnchor).isActive = true
        
        self.view.addSubview(reserveCostLabel)
        reserveCostLabel.bottomAnchor.constraint(equalTo: reserveButton.topAnchor).isActive = true
        reserveCostLabel.widthAnchor.constraint(equalToConstant: (self.view.frame.width - 20) / 3).isActive = true
        reserveCostLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        reserveCostLabel.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: 10).isActive = true
        
        self.view.addSubview(line3)
        line3.bottomAnchor.constraint(equalTo: reserveButton.topAnchor).isActive = true
        line3.heightAnchor.constraint(equalToConstant: 40).isActive = true
        line3.widthAnchor.constraint(equalToConstant: 1).isActive = true
        line3.centerXAnchor.constraint(equalTo: reserveCostLabel.leftAnchor, constant: 15).isActive = true
        
        self.view.addSubview(line)
        line.bottomAnchor.constraint(equalTo: reserveButton.topAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 40).isActive = true
        line.widthAnchor.constraint(equalToConstant: 1).isActive = true
        line.centerXAnchor.constraint(equalTo: paymentButton.rightAnchor).isActive = true
        
        self.view.addSubview(toReserveLabel)
        toReserveLabel.bottomAnchor.constraint(equalTo: reserveButton.topAnchor).isActive = true
        toReserveLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        toReserveLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        toReserveLabel.centerXAnchor.constraint(equalTo: reserveFromLabel.rightAnchor, constant: 15).isActive = true
        
        self.view.addSubview(line2)
        line2.bottomAnchor.constraint(equalTo: reserveButton.topAnchor).isActive = true
        line2.heightAnchor.constraint(equalToConstant: 40).isActive = true
        line2.widthAnchor.constraint(equalToConstant: 1).isActive = true
        line2.centerXAnchor.constraint(equalTo: hoursButton.leftAnchor).isActive = true
        
        self.view.addSubview(toLabel)
        toLabel.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor).isActive = true
        toLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        toLabel.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor, constant: -30).isActive = true
        
        self.view.addSubview(currentTimeLabel)
        currentTimeLabel.rightAnchor.constraint(equalTo: toLabel.leftAnchor).isActive = true
        currentTimeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        currentTimeLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        currentTimeLabel.centerYAnchor.constraint(equalTo: toLabel.centerYAnchor).isActive = true
        
        self.view.addSubview(timeToPicker)
        timeToPicker.leftAnchor.constraint(equalTo: toLabel.rightAnchor).isActive = true
        timeToPicker.centerYAnchor.constraint(equalTo: toLabel.centerYAnchor).isActive = true
        timeToPicker.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeToPicker.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.view.addSubview(checkButton)
        checkButton.leftAnchor.constraint(equalTo: timeToPicker.rightAnchor, constant: 10).isActive = true
        checkButton.centerYAnchor.constraint(equalTo: toLabel.centerYAnchor).isActive = true
        checkButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        checkButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        viewContainer.addSubview(reserveController.view)
        self.addChildViewController(reserveController)
        reserveController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        reserveController.view.widthAnchor.constraint(equalTo: viewContainer.widthAnchor).isActive = true
        reserveController.view.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 45).isActive = true
        reserveController.view.bottomAnchor.constraint(equalTo: reserveButton.topAnchor, constant: -10).isActive = true
        
    }
    
    @objc func currentPressed(sender: UIButton) {
        currentSender()
    }
    
    func currentSender() {
        self.minimizeHours()
        self.reserveSegmentAnchor.isActive = false
        self.currentSegmentAnchor.isActive = true
        UIView.animate(withDuration: 0.2, animations: {
            self.reserveController.view.alpha = 0
            self.toReserveLabel.alpha = 0
            self.reserveToLabel.alpha = 0
            self.reserveFromLabel.alpha = 0
            self.reserveCostLabel.alpha = 0
            self.line3.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: 0.2, animations: {
                self.viewContainerHeightAnchor.constant = 140
                self.paymentButton.alpha = 1
                self.costButton.alpha = 1
                self.hoursButton.alpha = 1
                self.line.alpha = 1
                self.line2.alpha = 1
                self.view.layoutIfNeeded()
            })
        }
    }

    @objc func reservePressed(sender: UIButton) {
        self.expandHours()
        self.currentSegmentAnchor.isActive = false
        self.reserveSegmentAnchor.isActive = true
        self.currentSegment.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.2, animations: {
            self.paymentButton.alpha = 0
            self.costButton.alpha = 0
            self.hoursButton.alpha = 0
            self.line.alpha = 0
            self.line2.alpha = 0
            self.toReserveLabel.alpha = 0
            self.reserveToLabel.alpha = 0
            self.reserveFromLabel.alpha = 0
            self.reserveCostLabel.alpha = 0
            self.line3.alpha = 0
//            self.currentSegment.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: 0.2, animations: {
                self.viewContainerHeightAnchor.constant = 315
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: 0.2, animations: {
                    self.reserveController.view.alpha = 1
                })
            }
        }
    }
    
    func reserveCheckPressed(from: String, to: String, hour: Double) {
        self.minimizeHours()
        self.reserveFromLabel.setTitle(from, for: .normal)
        self.reserveToLabel.setTitle(to, for: .normal)
        
        let costString = self.parkingCost?.replacingOccurrences(of: "$", with: "")
        let cost = Double(costString!.replacingOccurrences(of: "/hour", with: ""))
        
        let payment = cost! * hour
        let paymentString = String(format: "$%.2f", payment)
        self.reserveCostLabel.setTitle(paymentString, for: .normal)
        
        self.currentSegmentAnchor.isActive = false
        self.reserveSegmentAnchor.isActive = true
        self.currentSegment.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.2, animations: {
            self.paymentButton.alpha = 0
            self.costButton.alpha = 0
            self.hoursButton.alpha = 0
            self.line.alpha = 0
            self.line2.alpha = 0
            self.reserveController.view.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.viewContainerHeightAnchor.constant = 140
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: 0.2, animations: {
                    self.toReserveLabel.alpha = 1
                    self.reserveToLabel.alpha = 1
                    self.reserveFromLabel.alpha = 1
                    self.reserveCostLabel.alpha = 1
                    self.line3.alpha = 1
                })
            }
        }
    }
    
    @objc func hourButtonPressed(sender: UIButton) {
        viewContainerHeightAnchor.constant = 200
        self.currentSegment.isUserInteractionEnabled = false
        self.setTimes()
        UIView.animate(withDuration: 0.2, animations: {
            self.hoursButton.alpha = 0
            self.reserveButton.alpha = 0.6
            self.reserveSegment.alpha = 0
            self.reserveButton.isUserInteractionEnabled = false
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: 0.2, animations: {
                self.toLabel.alpha = 1
                self.timeToPicker.alpha = 1
                self.currentTimeLabel.alpha = 1
                self.checkButton.alpha = 1
            })
        }
    }
    
    @objc func checkButtonPressed(sender: UIButton) {
        viewContainerHeightAnchor.constant = 140
        UIView.animate(withDuration: 0.2, animations: {
            self.toLabel.alpha = 0
            self.timeToPicker.alpha = 0
            self.currentTimeLabel.alpha = 0
            self.checkButton.alpha = 0
            self.reserveSegment.alpha = 1
            self.reserveButton.alpha = 1
            self.reserveButton.isUserInteractionEnabled = true
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: 0.2, animations: {
                self.hoursButton.alpha = 1
            })
            let costString = self.parkingCost?.replacingOccurrences(of: "$", with: "")
            let cost = Double(costString!.replacingOccurrences(of: "/hour", with: ""))
            let hoursString = self.hoursButton.titleLabel?.text?.replacingOccurrences(of: " hours", with: "")
            let hours = Double(hoursString!.replacingOccurrences(of: " hour", with: ""))
            
            let payment = cost! * hours!
            let paymentString = String(format: "$%.2f", payment)
            self.costButton.setTitle(paymentString, for: .normal)
        }
    }
    
    func hideParkNow() {
        UIView.animate(withDuration: 0.2) {
            self.currentSegment.alpha = 0
            self.reserveButton.alpha = 0.6
            self.reserveButton.isUserInteractionEnabled = false
        }
    }
    
    func bringParkNow() {
        UIView.animate(withDuration: 0.2) {
            self.currentSegment.alpha = 1
            self.reserveButton.alpha = 1
            self.reserveButton.isUserInteractionEnabled = true
        }
    }
    
    func expandHours() {
        self.delegate?.openHoursButton()
    }
    
    func minimizeHours() {
        self.delegate?.closeHoursButton()
    }
    
    var futureHours: [String] = []
    var lastDate: Date = Calendar.current.date(byAdding: .minute, value: 10, to: Date())!
    
    func setTimes() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "h:mm a"
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        let dateString = formatter.string(from: Date())
        
        self.currentTimeLabel.text = dateString
        
        for _ in 0..<12 {
            let lateDate = Calendar.current.date(byAdding: .hour, value: 1, to: lastDate)
            let futureDateString = formatter.string(from: lateDate!)
            self.futureHours.append(futureDateString)
            self.lastDate = lateDate!
        }
        self.timeToPicker.reloadAllComponents()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        pickerView.subviews.forEach({
            $0.isHidden = $0.frame.height < 1.0
        })
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 20
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.futureHours.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.futureHours[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 90, height: 80)
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 90, height: 80)
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = self.futureHours[row]
        view.addSubview(label)
        
        return view
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row != 0 {
            self.hoursButton.setTitle("\(row+1) hours", for: .normal)
        } else {
            self.hoursButton.setTitle("\(row+1) hour", for: .normal)
        }
    }
    
    private let timeValues: NSArray = ["All day","1:00 am","1:30 am","2:00 am","2:30 am","3:00 am","3:30 am","4:00 am","4:30 am","5:00 am","5:30 am","6:00 am","6:30 am","7:00 am","7:30 am","8:00 am","8:30 am","9:00 am","9:30 am","10:00 am","10:30 am","11:00 am","11:30 am","12:00 pm","12:30 pm","1:00 pm","1:30 pm","2:00 pm","2:30 pm","3:00 pm","3:30 pm","4:00 pm","4:30 pm","5:00 pm","5:30 pm","6:00 pm","6:30 pm","7:00 pm","7:30 pm","8:00 pm","8:30 pm","9:00 pm","9:30 pm","10:00 pm","10:30 pm","11:00 pm","11:30 pm","12:00 am","12:30 am"]
    //    private let pmTimeValues: NSArray = ["All day","12:00 pm","12:30 pm","1:00 pm","1:30 pm","2:00 pm","2:30 pm","3:00 pm","3:30 pm","4:00 pm","4:30 pm","5:00 pm","5:30 pm","6:00 pm","6:30 pm","7:00 pm","7:30 pm","8:00 pm","8:30 pm","9:00 pm","9:30 pm","10:00 pm","10:30 pm","11:00 pm","11:30 pm","12:00 am","12:30 am"]
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
