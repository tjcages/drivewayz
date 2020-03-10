//
//  ParkNowView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/16/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol handleSliderChanges {
    func setHourLabel(minutes: Int)
}

class ParkNowView: UIViewController {
    
    var delegate: handleDuration?
    var currentTime: Date?
    var duration: Int = 135
    var dateFormatter = DateFormatter()
    var timer: Timer?
    var currentBookingHeight: CGFloat = 160
    
    lazy var dimView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight))
        
        return view
    }()
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var fromTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH2
        
        return label
    }()
    
    var toTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLUE
        label.font = Fonts.SSPSemiBoldH2
        label.textAlignment = .right
        
        return label
    }()
    
    var startLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Start time"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var endLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "End time"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .right
        
        return label
    }()
    
//    lazy var sliderView: UIView = {
//        let controller = UIView()
//        controller.view.translatesAutoresizingMaskIntoConstraints = false
//        controller.selectTimeLabel.alpha = 0
//        controller.nowDelegate = self
//        
//        return controller
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        dimView.addGestureRecognizer(tap)
        
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"

        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        observeCurrentTime()
        timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(observeCurrentTime), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    
    @objc func observeCurrentTime() {
        let time = Date()
        currentTime = time
        let format = dateFormatter.string(from: time)
        fromTimeLabel.text = format
        setHourLabel(minutes: duration)
    }
    
    func setupViews() {
        
        view.addSubview(dimView)
        view.addSubview(container)
        container.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: currentBookingHeight)
        
        view.addSubview(fromTimeLabel)
        view.addSubview(startLabel)
        
        fromTimeLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 20).isActive = true
        fromTimeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        fromTimeLabel.sizeToFit()
    
        startLabel.topAnchor.constraint(equalTo: fromTimeLabel.bottomAnchor, constant: 0).isActive = true
        startLabel.leftAnchor.constraint(equalTo: fromTimeLabel.leftAnchor).isActive = true
        startLabel.sizeToFit()
        
        view.addSubview(toTimeLabel)
        view.addSubview(endLabel)
        
        toTimeLabel.topAnchor.constraint(equalTo: fromTimeLabel.topAnchor).isActive = true
        toTimeLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        toTimeLabel.sizeToFit()
        
        endLabel.topAnchor.constraint(equalTo: fromTimeLabel.bottomAnchor, constant: 0).isActive = true
        endLabel.rightAnchor.constraint(equalTo: toTimeLabel.rightAnchor).isActive = true
        endLabel.sizeToFit()
        
//        view.addSubview(sliderView.view)
//        sliderView.view.topAnchor.constraint(equalTo: startLabel.bottomAnchor, constant: -12).isActive = true
//        sliderView.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        sliderView.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
//        sliderView.view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }

    @objc func dismissView() {
        delegate?.dismissView()
    }

}

extension ParkNowView: handleSliderChanges {
    
    func setHourLabel(minutes: Int) {
        duration = minutes
        if minutes == 0 {
            delegate?.unavailableMainButton()
        } else {
            delegate?.availableMainButton()
        }
        let seconds: TimeInterval = TimeInterval(minutes * 60)
        if let startTime = currentTime {
            let endTime = startTime.addingTimeInterval(seconds).round(precision: (5 * 60), rule: FloatingPointRoundingRule.up)
            let format = dateFormatter.string(from: endTime)
            toTimeLabel.text = format
        }
    }
    
}
