//
//  DurationTimeView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/11/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

enum DurationState {
    case hours
    case time
}

class DurationTimeView: UIViewController {
    
    var delegate: handleHoursSelected?
    var nowDelegate: handleSliderChanges?
    var tickCount: Int = 40
    var tickCountMax: Int = 40
    var selectedHours: Int = 2
    var selectedMinutes: Int = 15
    var totalSelectedTime: Double = 2.25
    
    var timesArray: [String] = ["Now"]
    var datesArray: [Date] = [Date()]
    var selectedTime: Int = 0
    var selectedString: String = "Now"
    var beginningDate: Date = Date()
    
    var currentTicks: [UIView] = []
    
    var durationState: DurationState = .hours {
        didSet {
            self.removeTicks()
            if self.durationState == .hours {
                lowestHourButton.setTitle("0", for: .normal)
                highestHourButton.setTitle("9", for: .normal)
                self.sliderTrackRightAnchor.constant = -2
                self.drawTicks(count: self.tickCount)
            } else if self.durationState == .time {
                lowestHourButton.setTitle("", for: .normal)
                highestHourButton.setTitle("", for: .normal)
                self.sliderTrackRightAnchor.constant = 24
                self.drawTicks(count: self.tickCount)
            }
            UIView.animate(withDuration: animationIn) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    var selectTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Additional time"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    lazy var nowButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.OFF_WHITE
        button.layer.cornerRadius = 4
        button.setTitle("Now", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var sliderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE
//        view.layer.cornerRadius = 4
        
        return view
    }()
    
    var lowestHourButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("0", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var highestHourButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("10", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        
        return button
    }()
    
    lazy var sliderTrack: UISlider = {
        let space = lowestHourButton.bounds.size.width
        let distance = phoneWidth - 56 - space * 2 - 80
        let view = UISlider(frame: CGRect(x: 0, y: 0, width: distance, height: 6))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.minimumTrackTintColor = .clear
        view.maximumTrackTintColor = .clear
        view.maximumValue = Float(tickCount)
        view.minimumValue = 0
        view.thumbTintColor = Theme.BLUE
        view.addTarget(self, action: #selector(valueChanged(sender:)), for: .valueChanged)
        
        return view
    }()
    
    var sliderTrackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 3

        return view
    }()
    
    var sliderPin: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.2
        view.layer.cornerRadius = 28
        view.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        
        let center = UIView(frame: CGRect(x: 8, y: 8, width: 40, height: 40))
        center.backgroundColor = Theme.BLUE
        center.layer.cornerRadius = 20
        view.addSubview(center)
        
        return view
    }()
    
    var leftTrack: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.6)
        view.layer.cornerRadius = 3
        
        return view
    }()
    
    var hourView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        view.layer.cornerRadius = 13
        
        let triangle = TriangleView()
        triangle.translatesAutoresizingMaskIntoConstraints = false
        triangle.color = Theme.BLUE
        triangle.backgroundColor = UIColor.clear
        triangle.transform = CGAffineTransform(scaleX: 1.0, y: -1.0)
        triangle.layer.cornerRadius = 6
        
        view.addSubview(triangle)
        triangle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        triangle.topAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        triangle.widthAnchor.constraint(equalToConstant: 10).isActive = true
        triangle.heightAnchor.constraint(equalToConstant: 5).isActive = true
        
        return view
    }()
    
    var hourLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "9"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH5
        label.textAlignment = .center
        
        return label
    }()
    
    var selectHoursLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Select hours"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        label.font = Fonts.SSPRegularH4
        label.alpha = 0
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        
        let minutes = totalSelectedTime * 60
        initializeTime(minutes: Int(minutes))
    }
    
    var sliderCenterAnchor: NSLayoutConstraint!
    var hourViewWidthAnchor: NSLayoutConstraint!
    
    var nowButtonBottomAnchor: NSLayoutConstraint!
    var sliderViewButtonAnchor: NSLayoutConstraint!
    var sliderViewFullAnchor: NSLayoutConstraint!
    var sliderTrackRightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(selectTimeLabel)
        view.addSubview(nowButton)
        
        view.addSubview(sliderView)
        view.addSubview(selectHoursLabel)
        view.addSubview(lowestHourButton)
        view.addSubview(highestHourButton)
        view.addSubview(sliderTrackView)
        view.addSubview(leftTrack)
        view.addSubview(sliderTrack)
        
        selectTimeLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        selectTimeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        selectTimeLabel.sizeToFit()
        
        nowButton.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 72, height: 42)
        nowButtonBottomAnchor = nowButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            nowButtonBottomAnchor.isActive = true
        
        sliderView.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 0, height: 42)
        sliderViewButtonAnchor = sliderView.leftAnchor.constraint(equalTo: nowButton.rightAnchor, constant: 8)
            sliderViewButtonAnchor.isActive = true
        sliderViewFullAnchor = sliderView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20)
            sliderViewFullAnchor.isActive = false
        
        selectHoursLabel.bottomAnchor.constraint(equalTo: sliderView.topAnchor, constant: -12).isActive = true
        selectHoursLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        selectHoursLabel.sizeToFit()
        
        lowestHourButton.leftAnchor.constraint(equalTo: sliderView.leftAnchor, constant: 4).isActive = true
        lowestHourButton.centerYAnchor.constraint(equalTo: sliderView.centerYAnchor).isActive = true
        lowestHourButton.sizeToFit()
        
        highestHourButton.rightAnchor.constraint(equalTo: sliderView.rightAnchor, constant: -4).isActive = true
        highestHourButton.centerYAnchor.constraint(equalTo: sliderView.centerYAnchor).isActive = true
        highestHourButton.sizeToFit()
        
        sliderTrack.centerXAnchor.constraint(equalTo: sliderView.centerXAnchor).isActive = true
        sliderTrackRightAnchor = sliderTrack.rightAnchor.constraint(equalTo: highestHourButton.leftAnchor, constant: -2)
            sliderTrackRightAnchor.isActive = true
        sliderTrack.centerYAnchor.constraint(equalTo: sliderView.centerYAnchor, constant: 2).isActive = true
        sliderTrack.heightAnchor.constraint(equalToConstant: 8).isActive = true
        
        sliderTrackView.leftAnchor.constraint(equalTo: sliderTrack.leftAnchor).isActive = true
        sliderTrackView.rightAnchor.constraint(equalTo: sliderTrack.rightAnchor).isActive = true
        sliderTrackView.centerYAnchor.constraint(equalTo: sliderTrack.centerYAnchor).isActive = true
        sliderTrackView.heightAnchor.constraint(equalToConstant: 6).isActive = true

        view.layoutIfNeeded()
        drawTicks(count: tickCount)
        
        view.addSubview(hourView)
        sliderCenterAnchor = hourView.centerXAnchor.constraint(equalTo: sliderTrackView.leftAnchor)
            sliderCenterAnchor.isActive = true
        hourView.bottomAnchor.constraint(equalTo: sliderView.topAnchor, constant: -2).isActive = true
        hourViewWidthAnchor = hourView.widthAnchor.constraint(equalToConstant: 38)
            hourViewWidthAnchor.isActive = true
        hourView.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        leftTrack.anchor(top: sliderTrackView.topAnchor, left: sliderTrackView.leftAnchor, bottom: sliderTrackView.bottomAnchor, right: hourView.centerXAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(hourLabel)
        hourLabel.centerXAnchor.constraint(equalTo: hourView.centerXAnchor).isActive = true
        hourLabel.centerYAnchor.constraint(equalTo: hourView.centerYAnchor).isActive = true
        hourLabel.sizeToFit()
        
    }
    
    func initializeTime(minutes: Int) {
        setHourLabel(minutes: minutes)
        let sender = sliderTrack
        sender.setValue(Float(minutes/15), animated: false)
        let deltaValue = sender.thumbRect(forBounds: sender.bounds, trackRect: sender.trackRect(forBounds: sender.bounds), value: sender.value).midX
        sliderCenterAnchor.constant = deltaValue - 12
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
        }
    }
    
    func setHourLabel(minutes: Int) {
        var tuple = minutesToHoursMinutes(minutes: minutes)
        tuple.leftMinutes = Int(round(Double(tuple.leftMinutes), toNearest: 15))
        if tuple.leftMinutes == 60 {
            tuple.leftMinutes = 0
            tuple.hours += 1
        }
        if tuple.hours == 1 {
            if tuple.leftMinutes == 0 {
                hourLabel.text = "\(tuple.hours)h"
            } else {
                hourLabel.text = "\(tuple.hours)h \(tuple.leftMinutes)m"
            }
        } else if tuple.hours == 0 {
            if tuple.leftMinutes == 0 {
                hourLabel.text = "00m"
            } else {
                hourLabel.text = "\(tuple.leftMinutes)m"
            }
        } else {
            if tuple.leftMinutes == 0 {
                hourLabel.text = "\(tuple.hours)h"
            } else {
                hourLabel.text = "\(tuple.hours)h \(tuple.leftMinutes)m"
            }
        }
        selectedHours = tuple.hours
        selectedMinutes = tuple.leftMinutes
        totalSelectedTime = Double(tuple.hours) + Double(tuple.leftMinutes)/60
        delegate?.setHourLabel(minutes: Int(totalSelectedTime * 60))
        nowDelegate?.setHourLabel(minutes: Int(totalSelectedTime * 60))
        
        hourViewWidthAnchor.constant = (hourLabel.text?.width(withConstrainedHeight: 26, font: Fonts.SSPSemiBoldH5))! + 20
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
        }
    }
    
    func setData(toDate: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        let nowString = formatter.string(from: toDate)
        nowButton.setTitle(nowString, for: .normal)
    }
    
    func nextHourDate(nextDays: Int) -> Date? {
        let calendar = Calendar.current
        var date = Date()
        var i = 0
        while i < nextDays {
            date = date.tomorrow
            i += 1
        }
        let minuteComponent = calendar.component(.minute, from: date)
        var components = DateComponents()
        components.minute = 60 - minuteComponent
        return calendar.date(byAdding: components, to: date)
    }
    
    func drawTicks(count: Int) {
        for i in 0 ..< (count - 1) {
            let tick = createTick()
            var space = lowestHourButton.bounds.size.width
            var distance = phoneWidth - 48 - space * 2 - 80
            if nowButtonBottomAnchor.constant != 0 {
                distance += 80
            }
            if durationState == .time {
                distance += 48
                space = 8
            }
            let displacement = distance/CGFloat(count)
            currentTicks.append(tick)
            
            if i % 2 == 0 {
                tick.frame = CGRect(x: space + displacement * CGFloat(i) + 10, y: 12, width: 1, height: 4)
            } else {
                tick.frame = CGRect(x: space + displacement * CGFloat(i) + 10, y: 10, width: 1, height: 6)
            }
            
            sliderView.addSubview(tick)
            UIView.animate(withDuration: animationIn) {
                tick.alpha = 1
            }
        }
    }
    
    func createTick() -> UIView {
        let tick = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 4))
        tick.backgroundColor = Theme.LIGHT_GRAY
        tick.alpha = 0
        
        return tick
    }
    
    func removeTicks() {
        if currentTicks.count != 0 {
            for tick in currentTicks {
                tick.removeFromSuperview()
            }
        }
    }
    
    @objc func valueChanged(sender: UISlider) {
        let minutes = Int(15 * sliderTrack.value)
        setHourLabel(minutes: minutes)

        let deltaValue = sender.thumbRect(forBounds: sender.bounds, trackRect: sender.trackRect(forBounds: sender.bounds), value: sender.value).midX
        sliderCenterAnchor.constant = deltaValue - 2
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
        }
    }
    
}

func round(_ value: Double, toNearest: Double) -> Double {
    return round(value / toNearest) * toNearest
}
