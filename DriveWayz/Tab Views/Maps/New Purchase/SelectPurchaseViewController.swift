//
//  SelectPurchaseViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 8/7/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class SelectPurchaseViewController: UIViewController {
    
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
        let background = CAGradientLayer().blurColor()
        background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 160)
        view.layer.insertSublayer(background, at: 0)
        view.alpha = 0.9
        
        return view
    }()
    
    var segmentControlView: UIView = {
        let segmentControlView = UIView()
        segmentControlView.translatesAutoresizingMaskIntoConstraints = false
        segmentControlView.backgroundColor = Theme.WHITE
        
        return segmentControlView
    }()
    
    var currentSegment: UIButton = {
        let info = UIButton()
        info.translatesAutoresizingMaskIntoConstraints = false
        info.backgroundColor = UIColor.clear
        info.setTitle("Current", for: .normal)
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
        button.contentEdgeInsets.top = 10
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
        button.setTitle("$3.00/hour", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        return button
    }()

    var hoursButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.setTitle("2 hours", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .light)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        setupViews()
    }
    
    var currentSegmentAnchor: NSLayoutConstraint!
    var reserveSegmentAnchor: NSLayoutConstraint!
    
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
        viewContainer.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
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
        
        self.view.addSubview(costButton)
        costButton.bottomAnchor.constraint(equalTo: reserveButton.topAnchor).isActive = true
        costButton.widthAnchor.constraint(equalToConstant: (self.view.frame.width - 20) / 3).isActive = true
        costButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        costButton.leftAnchor.constraint(equalTo: paymentButton.rightAnchor).isActive = true
        
        self.view.addSubview(hoursButton)
        hoursButton.bottomAnchor.constraint(equalTo: reserveButton.topAnchor).isActive = true
        hoursButton.widthAnchor.constraint(equalToConstant: (self.view.frame.width - 20) / 3).isActive = true
        hoursButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        hoursButton.leftAnchor.constraint(equalTo: costButton.rightAnchor).isActive = true
        
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = Theme.OFF_WHITE
        self.view.addSubview(line)
        line.bottomAnchor.constraint(equalTo: reserveButton.topAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 40).isActive = true
        line.widthAnchor.constraint(equalToConstant: 1).isActive = true
        line.centerXAnchor.constraint(equalTo: paymentButton.rightAnchor).isActive = true
        
        let line2 = UIView()
        line2.translatesAutoresizingMaskIntoConstraints = false
        line2.backgroundColor = Theme.OFF_WHITE
        self.view.addSubview(line2)
        line2.bottomAnchor.constraint(equalTo: reserveButton.topAnchor).isActive = true
        line2.heightAnchor.constraint(equalToConstant: 40).isActive = true
        line2.widthAnchor.constraint(equalToConstant: 1).isActive = true
        line2.centerXAnchor.constraint(equalTo: hoursButton.leftAnchor).isActive = true
        
    }
    
    @objc func currentPressed(sender: UIButton) {
        reserveSegmentAnchor.isActive = false
        currentSegmentAnchor.isActive = true
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            //
        }
    }
    
    @objc func reservePressed(sender: UIButton) {
        currentSegmentAnchor.isActive = false
        reserveSegmentAnchor.isActive = true
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            //
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
