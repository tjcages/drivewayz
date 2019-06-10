//
//  PurchaseSliderViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 3/9/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class PurchaseSliderViewController: UIViewController {
    
    var delegate: handleHoursSelected?
    var minimumValue: CGFloat = 0.0
    var maximumValue: CGFloat = 11.0
    var tickCount: Int = 36
    
    var sliderTrack: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.1)
        view.alpha = 0.8
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    var sliderPin: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        view.layer.cornerRadius = 14
        
        let center = UIView(frame: CGRect(x: 8, y: 8, width: 12, height: 12))
        center.backgroundColor = Theme.WHITE
        center.layer.borderColor = Theme.STRAWBERRY_PINK.cgColor
        center.layer.borderWidth = 3
        center.layer.cornerRadius = 6
        view.addSubview(center)
        
        return view
    }()
    
    var coveredDistance: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        view.alpha = 0.8
        view.layer.cornerRadius = 4
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    var sliderCenterAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(sliderTrack)
        self.drawTicks(count: self.tickCount)
        sliderTrack.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 6).isActive = true
        sliderTrack.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        sliderTrack.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -6).isActive = true
        sliderTrack.heightAnchor.constraint(equalToConstant: 8).isActive = true
        
        self.view.addSubview(coveredDistance)
        self.view.addSubview(sliderPin)
        sliderPin.centerYAnchor.constraint(equalTo: sliderTrack.centerYAnchor).isActive = true
        sliderCenterAnchor = sliderPin.centerXAnchor.constraint(equalTo: sliderTrack.leftAnchor)
            sliderCenterAnchor.isActive = true
        sliderPin.heightAnchor.constraint(equalToConstant: 28).isActive = true
        sliderPin.widthAnchor.constraint(equalTo: sliderPin.heightAnchor).isActive = true
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(sliderMoved(sender:)))
        sliderPin.addGestureRecognizer(panGesture)
        
        coveredDistance.topAnchor.constraint(equalTo: sliderTrack.topAnchor).isActive = true
        coveredDistance.leftAnchor.constraint(equalTo: sliderTrack.leftAnchor).isActive = true
        coveredDistance.rightAnchor.constraint(equalTo: sliderPin.centerXAnchor).isActive = true
        coveredDistance.bottomAnchor.constraint(equalTo: sliderTrack.bottomAnchor).isActive = true
    
    }
    
    func initializeTime(minutes: Int) {
        let distance = phoneWidth - 56
        let deltaValue = 9/CGFloat(self.tickCount) * distance
        self.sliderCenterAnchor.constant = deltaValue
        self.delegate?.setHourLabel(minutes: minutes)
        self.view.layoutIfNeeded()
    }
    
    @objc func sliderMoved(sender: UIPanGestureRecognizer) {
        let location = sender.location(in: self.view)
        let distance = phoneWidth - 56
        let deltaLocation = CGFloat(location.x)
        let displacement = distance/CGFloat(self.tickCount)
        let difference = ceil(deltaLocation/displacement)
        if Int(difference) <= self.tickCount && Int(difference) >= 0 {
            let deltaValue = difference/CGFloat(self.tickCount) * distance
            self.sliderCenterAnchor.constant = deltaValue
            let minutes = 15 * Int(difference)
            self.delegate?.setHourLabel(minutes: minutes)
            self.view.layoutIfNeeded()
        }
    }
    
    func drawTicks(count: Int) {
        for i in 1 ..< count {
            let tick = createTick()
            let distance = phoneWidth - 56
            let displacement = distance/CGFloat(count)
        
            if i % 2 == 0 {
                tick.frame = CGRect(x: displacement * CGFloat(i) + 10, y: 20, width: 1, height: 8)
            } else {
                tick.frame = CGRect(x: displacement * CGFloat(i) + 10, y: 20, width: 1, height: 12)
            }

            self.view.addSubview(tick)
        }
    }
    
    func createTick() -> UIView {
        let tick = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 8))
        tick.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        tick.alpha = 0.8
        
        return tick
    }

}
