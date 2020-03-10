//
//  DurationSliderView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 2/17/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit
import MultiSlider

class DurationSliderView: UIView {
    
    let tickMaxHeight: CGFloat = 64
    var tickCount: Int = 48
    var currentTicks: [UIView] = []
    var dateFormatter = DateFormatter()
    var parkingTimes = parkingValues
    
    var startValue: CGFloat = 11.0 {
        didSet {
            checkHighlightedTicks()
        }
    }
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Peak business times"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    lazy var sliderTrack: MultiSlider = {
        let view = MultiSlider(frame: CGRect(x: 0, y: 0, width: phoneWidth - 0, height: 6))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.minimumValue = 0.0
        view.maximumValue = CGFloat(tickCount)
        view.orientation = .horizontal
        view.hasRoundTrackEnds = true
        view.value = [startValue]
        view.showsThumbImageShadow = false
        view.outerTrackColor = .clear
        view.trackWidth = 4
        view.thumbImage = UIImage(named: "thumbImage")
        view.tintColor = .clear
        view.addTarget(self, action: #selector(valueChanged(sender:)), for: .valueChanged)
        
        return view
    }()
    
    var tickView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        view.transform = CGAffineTransform(scaleX: 1.0, y: -1.0)
//        view.clipsToBounds = true
        
        return view
    }()
    
    var hourView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        view.layer.cornerRadius = 13
        
        return view
    }()
    
    var hourViewTriangle: TriangleView = {
        let view = TriangleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.color = Theme.BLUE
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 6
        view.transform = CGAffineTransform(scaleX: 1.0, y: -1.0)
        
        return view
    }()
    
    var hourLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "7:00am"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH5
        label.textAlignment = .center
        
        return label
    }()
    
    var trackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        view.layer.cornerRadius = 2
        
        return view
    }()
    
    var firstTrackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        view.layer.cornerRadius = 2
    
        return view
    }()
    
    var fromLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Now"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH5
        
        return label
    }()

    var toLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "12 hrs"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        translatesAutoresizingMaskIntoConstraints = false
        
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"
        dateFormatter.dateFormat = "h:mma"
        
        setTimes()
        setupViews()
        setupSlider()
        
        delayWithSeconds(0.1) {
            self.layoutIfNeeded()
            self.valueChanged(sender: self.sliderTrack)
            self.checkHighlightedTicks()
        }
    }
    
    func setTimes() {
        let date = Date().round(precision: TimeInterval(1800), rule: .toNearestOrAwayFromZero)
        let hour = Calendar.current.component(.hour, from: date)
        var halfHour = Calendar.current.component(.minute, from: date)
        if halfHour == 30 {
            halfHour = 1
        } else {
            halfHour = 0
        }
        let index = hour * 2 + halfHour
        let first = parkingTimes[0..<index]
        let second = parkingTimes[index..<parkingTimes.count]
        let newTimes = second + first
        let array = newTimes.map({ (x) -> CGFloat in
            return x
        })
        parkingTimes = array
        
        var doubleTime: [CGFloat] = []
        for i in 0..<parkingTimes.count {
            let time = parkingTimes[i]
            var nextTime = parkingTimes[i]
            if (i + 1) > (parkingTimes.count - 1) {
                nextTime = parkingTimes[0]
            } else {
                nextTime = parkingTimes[i + 1]
            }
            let double = (time + nextTime)/2
            doubleTime.append(time)
            doubleTime.append(double)
        }
        parkingTimes = doubleTime
    }
    
    func setupViews() {
        
        addSubview(informationLabel)
        informationLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        informationLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        informationLabel.sizeToFit()
        
    }
    
    var sliderCenterAnchor: NSLayoutConstraint!
    var triangleCenterAnchor: NSLayoutConstraint!
    var hourViewWidthAnchor: NSLayoutConstraint!
    var hourViewBottomAnchor: NSLayoutConstraint!
    
    func setupSlider() {
        
        addSubview(tickView)
        addSubview(trackView)
        addSubview(firstTrackView)
        addSubview(sliderTrack)
        
        sliderTrack.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        sliderTrack.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        sliderTrack.topAnchor.constraint(equalTo: informationLabel.bottomAnchor, constant: tickMaxHeight + 32).isActive = true
        sliderTrack.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
        tickView.anchor(top: nil, left: leftAnchor, bottom: sliderTrack.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: tickMaxHeight)

        drawTicks(count: tickCount)
        
        addSubview(hourViewTriangle)
        addSubview(hourView)
        triangleCenterAnchor = hourView.centerXAnchor.constraint(equalTo: hourViewTriangle.centerXAnchor)
            triangleCenterAnchor.priority = UILayoutPriority.defaultLow
            triangleCenterAnchor.isActive = true
        hourViewBottomAnchor = hourView.bottomAnchor.constraint(equalTo: sliderTrack.topAnchor, constant: -64)
            hourViewBottomAnchor.priority = UILayoutPriority.defaultLow
            hourViewBottomAnchor.isActive = true
        hourViewWidthAnchor = hourView.widthAnchor.constraint(equalToConstant: 70)
            hourViewWidthAnchor.isActive = true
        hourView.heightAnchor.constraint(equalToConstant: 26).isActive = true
        hourView.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor).isActive = true
        hourView.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor).isActive = true
        hourView.bottomAnchor.constraint(lessThanOrEqualTo: sliderTrack.topAnchor, constant: -48).isActive = true
        
        sliderCenterAnchor = hourViewTriangle.centerXAnchor.constraint(equalTo: leftAnchor)
            sliderCenterAnchor.isActive = true
        hourViewTriangle.topAnchor.constraint(equalTo: hourView.bottomAnchor, constant: -1).isActive = true
        hourViewTriangle.widthAnchor.constraint(equalToConstant: 10).isActive = true
        hourViewTriangle.heightAnchor.constraint(equalToConstant: 5).isActive = true
        
        addSubview(hourLabel)
        hourLabel.centerXAnchor.constraint(equalTo: hourView.centerXAnchor).isActive = true
        hourLabel.centerYAnchor.constraint(equalTo: hourView.centerYAnchor).isActive = true
        hourLabel.sizeToFit()
    
        trackView.anchor(top: nil, left: sliderTrack.leftAnchor, bottom: nil, right: sliderTrack.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 4)
        trackView.centerYAnchor.constraint(equalTo: sliderTrack.centerYAnchor).isActive = true
        
        firstTrackView.anchor(top: nil, left: trackView.leftAnchor, bottom: nil, right: hourViewTriangle.centerXAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 4)
        firstTrackView.centerYAnchor.constraint(equalTo: sliderTrack.centerYAnchor).isActive = true
        
        addSubview(fromLabel)
        addSubview(toLabel)
        
        fromLabel.topAnchor.constraint(equalTo: trackView.bottomAnchor, constant: 8).isActive = true
        fromLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        fromLabel.sizeToFit()
        
        toLabel.topAnchor.constraint(equalTo: trackView.bottomAnchor, constant: 8).isActive = true
        toLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        toLabel.sizeToFit()
        
    }
    
    func drawTicks(count: Int) {
        let displacement = (phoneWidth - 40)/CGFloat(count)
        for i in 1 ..< count {
            let percent = parkingTimes[i - 1]
            let frame = CGRect(x: -1 + displacement * CGFloat(i), y: 0, width: 2, height: (tickMaxHeight - 8) * percent + 8)
            let tick = createTick(frame: frame)
            tick.tag = i - 1
            
            currentTicks.append(tick)
            tickView.addSubview(tick)
        }
    }
    
    func createTick(frame: CGRect) -> UIView {
        let tick = UIView(frame: frame)
        tick.backgroundColor = Theme.LINE_GRAY
        
        return tick
    }
    
    func removeTicks() {
        if currentTicks.count != 0 {
            for tick in currentTicks {
                tick.removeFromSuperview()
            }
        }
    }
    
    func checkHighlightedTicks() {
        for view in currentTicks {
            if view.tag <= Int(startValue - 1) {
                view.backgroundColor = Theme.BLUE_MED
            } else {
                view.backgroundColor = Theme.LINE_GRAY
            }
        }
    }
    
    @objc func valueChanged(sender: MultiSlider) {
//        let date = Date().dateAt(hours: 0, minutes: 0)
        
        guard let deltaValue = sender.thumbViews.first?.frame.midX,
            let value = sender.value.first?.rounded() else { return }
        let hours = (value/4)
        var newTime = "\(hours) hours"
        if hours == 1.0 {
            newTime.removeLast()
        }
        
        if value >= 1 {
            let percent = parkingTimes[Int(value) - 1]
            let height = tickMaxHeight * percent + 8
            hourViewBottomAnchor.constant = -height
        }
        
        startValue = value
        sliderCenterAnchor.constant = deltaValue + 20
        hourLabel.text = newTime
        let width = newTime.width(withConstrainedHeight: 26, font: Fonts.SSPSemiBoldH5) + 16
        hourViewWidthAnchor.constant = width
        
        UIView.animate(withDuration: animationIn) {
            self.layoutIfNeeded()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
