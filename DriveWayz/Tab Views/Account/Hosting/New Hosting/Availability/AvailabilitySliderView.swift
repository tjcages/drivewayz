//
//  AvailabilitySliderView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/30/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import MultiSlider

class AvailabilitySliderView: UIViewController {
    
    var delegate: NewHostAvailabilityDelegate?
    let tickMaxHeight: CGFloat = 72
    var tickCount: Int = 48
    var currentTicks: [UIView] = []
    var dateFormatter = DateFormatter()
    var watchDrags: Bool = false
    
    var timeRange: [Date] = [] {
        didSet {
            if sliderTrack.value.count == 0 {
                let array: [Date] = []
                delegate?.changeTimeRange(times: array)
            } else if sliderTrack.value.count == 2 {
                if timeRange.count >= 2 {
                    let array: [Date] = [timeRange[0], timeRange[1]]
                    delegate?.changeTimeRange(times: array)
                }
            } else if sliderTrack.value.count == 4 {
                delegate?.changeTimeRange(times: timeRange)
            }
        }
    }
    
    var startValue: CGFloat = 16.0 {
        didSet {
            checkHighlightedTicks()
        }
    }
    
    var endValue: CGFloat = 38.0 {
        didSet {
            checkHighlightedTicks()
        }
    }
    
    var startValue2: CGFloat = 14.0 {
        didSet {
            checkHighlightedTicks()
        }
    }
    
    var endValue2: CGFloat = 38.0 {
        didSet {
            checkHighlightedTicks()
        }
    }
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Peak rental hours"
        label.textColor = Theme.PRUSSIAN_BLUE
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    lazy var sliderTrack: MultiSlider = {
        let view = MultiSlider(frame: CGRect(x: 0, y: 0, width: phoneWidth - 40, height: 6))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.minimumValue = 0.0
        view.maximumValue = CGFloat(tickCount)
        view.orientation = .horizontal
        view.hasRoundTrackEnds = true
        view.value = [startValue, endValue]
        view.showsThumbImageShadow = false
        view.outerTrackColor = .clear
        view.trackWidth = 6
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
    
    var hourView2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        view.layer.cornerRadius = 13
        
        return view
    }()

    var hourViewTriangle2: TriangleView = {
        let view = TriangleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.color = Theme.BLUE
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 6
        
        return view
    }()
    
    var hourLabel2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "5:00pm"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH5
        label.textAlignment = .center
        
        return label
    }()
    
    var hourView3: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        view.layer.cornerRadius = 13
        view.alpha = 0
        
        let triangle = TriangleView()
        triangle.translatesAutoresizingMaskIntoConstraints = false
        triangle.color = Theme.BLUE
        triangle.backgroundColor = UIColor.clear
        triangle.layer.cornerRadius = 6
        
        view.addSubview(triangle)
        triangle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        triangle.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 1).isActive = true
        triangle.widthAnchor.constraint(equalToConstant: 10).isActive = true
        triangle.heightAnchor.constraint(equalToConstant: 5).isActive = true
        
        return view
    }()
    
    var hourLabel3: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "7:00am"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH5
        label.textAlignment = .center
        label.alpha = 0
        
        return label
    }()
    
    var hourView4: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        view.layer.cornerRadius = 13
        view.alpha = 0
        
        return view
    }()
    
    var hourViewTriangle4: TriangleView = {
        let view = TriangleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.color = Theme.BLUE
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 6
        view.alpha = 0
        
        return view
    }()
    
    var hourLabel4: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "5:00pm"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH5
        label.textAlignment = .center
        label.alpha = 0
        
        return label
    }()
    
    var addRangeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add range", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(addRangePressed), for: .touchUpInside)
        
        return button
    }()
    
    var removeRangeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Remove range", for: .normal)
        button.setTitleColor(Theme.HARMONY_RED, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(removeRangePressed), for: .touchUpInside)
        
        return button
    }()
    
    var trackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        view.layer.cornerRadius = 3
        
        return view
    }()
    
    var firstTrackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        
        return view
    }()
    
    var secondTrackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        view.alpha = 0
        
        return view
    }()
    
    var unavailableView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE
        view.layer.cornerRadius = 13
        view.alpha = 0
        
        let triangle = TriangleView()
        triangle.translatesAutoresizingMaskIntoConstraints = false
        triangle.color = Theme.PRUSSIAN_BLUE
        triangle.backgroundColor = UIColor.clear
        triangle.layer.cornerRadius = 6
        
        view.addSubview(triangle)
        triangle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        triangle.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 1).isActive = true
        triangle.widthAnchor.constraint(equalToConstant: 10).isActive = true
        triangle.heightAnchor.constraint(equalToConstant: 5).isActive = true
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Unavailable"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH5
        label.textAlignment = .center
        
        view.addSubview(label)
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.sizeToFit()
        
        return view
    }()
    
    var unavailableButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.PRUSSIAN_BLUE
        button.layer.cornerRadius = 4
        button.setTitle("Make Unavailable", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.addTarget(self, action: #selector(unavailableButtonPressed), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.WHITE
        
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"
        dateFormatter.dateFormat = "h:mma"
        
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        valueChanged(sender: sliderTrack)
        checkHighlightedTicks()
        watchDrags = true
    }
    
    func setupViews() {
        
        view.addSubview(informationLabel)
        informationLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        informationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        informationLabel.sizeToFit()
        
        setupSlider()
        
        view.addSubview(addRangeButton)
        view.addSubview(removeRangeButton)
        
        addRangeButton.topAnchor.constraint(equalTo: hourView.bottomAnchor, constant: 16).isActive = true
        addRangeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        addRangeButton.sizeToFit()
        
        removeRangeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        removeRangeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        removeRangeButton.sizeToFit()
        
        view.addSubview(unavailableView)
        unavailableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        unavailableView.topAnchor.constraint(equalTo: sliderTrack.bottomAnchor, constant: 20).isActive = true
        unavailableView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        unavailableView.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        view.addSubview(unavailableButton)
        unavailableButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 140, height: 28)
        
    }
    
    var sliderCenterAnchor: NSLayoutConstraint!
    var triangleCenterAnchor: NSLayoutConstraint!
    var hourViewWidthAnchor: NSLayoutConstraint!
    
    var sliderCenterAnchor2: NSLayoutConstraint!
    var triangleCenterAnchor2: NSLayoutConstraint!
    var hourViewWidthAnchor2: NSLayoutConstraint!
    
    var sliderCenterAnchor3: NSLayoutConstraint!
    var hourViewWidthAnchor3: NSLayoutConstraint!
    var sliderCenterAnchor4: NSLayoutConstraint!
    var triangleCenterAnchor4: NSLayoutConstraint!
    var hourViewWidthAnchor4: NSLayoutConstraint!
    
    func setupSlider() {
        
        view.addSubview(tickView)
        view.addSubview(trackView)
        view.addSubview(firstTrackView)
        view.addSubview(secondTrackView)
        view.addSubview(sliderTrack)
        
        sliderTrack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        sliderTrack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        sliderTrack.topAnchor.constraint(equalTo: informationLabel.bottomAnchor, constant: tickMaxHeight + 24).isActive = true
        sliderTrack.heightAnchor.constraint(equalToConstant: 8).isActive = true
        
        tickView.anchor(top: nil, left: sliderTrack.leftAnchor, bottom: sliderTrack.topAnchor, right: sliderTrack.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: tickMaxHeight)

        drawTicks(count: tickCount)
        
        view.addSubview(hourViewTriangle)
        view.addSubview(hourView)
        triangleCenterAnchor = hourView.centerXAnchor.constraint(equalTo: hourViewTriangle.centerXAnchor)
            triangleCenterAnchor.priority = UILayoutPriority.defaultLow
            triangleCenterAnchor.isActive = true
        hourView.topAnchor.constraint(equalTo: sliderTrack.bottomAnchor, constant: 20).isActive = true
        hourViewWidthAnchor = hourView.widthAnchor.constraint(equalToConstant: 70)
            hourViewWidthAnchor.isActive = true
        hourView.heightAnchor.constraint(equalToConstant: 26).isActive = true
        hourView.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor).isActive = true
        
        sliderCenterAnchor = hourViewTriangle.centerXAnchor.constraint(equalTo: sliderTrack.leftAnchor)
            sliderCenterAnchor.isActive = true
        hourViewTriangle.bottomAnchor.constraint(equalTo: hourView.topAnchor, constant: 1).isActive = true
        hourViewTriangle.widthAnchor.constraint(equalToConstant: 10).isActive = true
        hourViewTriangle.heightAnchor.constraint(equalToConstant: 5).isActive = true
        
        view.addSubview(hourLabel)
        hourLabel.centerXAnchor.constraint(equalTo: hourView.centerXAnchor).isActive = true
        hourLabel.centerYAnchor.constraint(equalTo: hourView.centerYAnchor).isActive = true
        hourLabel.sizeToFit()
        
        view.addSubview(hourViewTriangle2)
        view.addSubview(hourView2)
        triangleCenterAnchor2 = hourView2.centerXAnchor.constraint(equalTo: hourViewTriangle2.centerXAnchor)
            triangleCenterAnchor2.priority = UILayoutPriority.defaultLow
            triangleCenterAnchor2.isActive = true
        hourView2.topAnchor.constraint(equalTo: sliderTrack.bottomAnchor, constant: 20).isActive = true
        hourViewWidthAnchor2 = hourView2.widthAnchor.constraint(equalToConstant: 70)
            hourViewWidthAnchor2.isActive = true
        hourView2.heightAnchor.constraint(equalToConstant: 26).isActive = true
        hourView2.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor).isActive = true
        
        sliderCenterAnchor2 = hourViewTriangle2.centerXAnchor.constraint(equalTo: sliderTrack.leftAnchor)
            sliderCenterAnchor2.isActive = true
        hourViewTriangle2.bottomAnchor.constraint(equalTo: hourView.topAnchor, constant: 1).isActive = true
        hourViewTriangle2.widthAnchor.constraint(equalToConstant: 10).isActive = true
        hourViewTriangle2.heightAnchor.constraint(equalToConstant: 5).isActive = true
        
        view.addSubview(hourLabel2)
        hourLabel2.centerXAnchor.constraint(equalTo: hourView2.centerXAnchor).isActive = true
        hourLabel2.centerYAnchor.constraint(equalTo: hourView2.centerYAnchor).isActive = true
        hourLabel2.sizeToFit()
        
        view.addSubview(hourView3)
        sliderCenterAnchor3 = hourView3.centerXAnchor.constraint(equalTo: sliderTrack.leftAnchor)
            sliderCenterAnchor3.isActive = true
        hourView3.topAnchor.constraint(equalTo: sliderTrack.bottomAnchor, constant: 20).isActive = true
        hourViewWidthAnchor3 = hourView3.widthAnchor.constraint(equalToConstant: 70)
            hourViewWidthAnchor3.isActive = true
        hourView3.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        view.addSubview(hourLabel3)
        hourLabel3.centerXAnchor.constraint(equalTo: hourView3.centerXAnchor).isActive = true
        hourLabel3.centerYAnchor.constraint(equalTo: hourView3.centerYAnchor).isActive = true
        hourLabel3.sizeToFit()
        
        view.addSubview(hourViewTriangle4)
        view.addSubview(hourView4)
        triangleCenterAnchor4 = hourView4.centerXAnchor.constraint(equalTo: hourViewTriangle4.centerXAnchor)
            triangleCenterAnchor4.priority = UILayoutPriority.defaultLow
            triangleCenterAnchor4.isActive = true
        hourView4.topAnchor.constraint(equalTo: sliderTrack.bottomAnchor, constant: 20).isActive = true
        hourViewWidthAnchor4 = hourView4.widthAnchor.constraint(equalToConstant: 70)
            hourViewWidthAnchor4.isActive = true
        hourView4.heightAnchor.constraint(equalToConstant: 26).isActive = true
        hourView4.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor).isActive = true
        
        sliderCenterAnchor4 = hourViewTriangle4.centerXAnchor.constraint(equalTo: sliderTrack.leftAnchor)
            sliderCenterAnchor4.isActive = true
        hourViewTriangle4.bottomAnchor.constraint(equalTo: hourView.topAnchor, constant: 1).isActive = true
        hourViewTriangle4.widthAnchor.constraint(equalToConstant: 10).isActive = true
        hourViewTriangle4.heightAnchor.constraint(equalToConstant: 5).isActive = true
        
        view.addSubview(hourLabel4)
        hourLabel4.centerXAnchor.constraint(equalTo: hourView4.centerXAnchor).isActive = true
        hourLabel4.centerYAnchor.constraint(equalTo: hourView4.centerYAnchor).isActive = true
        hourLabel4.sizeToFit()
    
        trackView.anchor(top: nil, left: sliderTrack.leftAnchor, bottom: nil, right: sliderTrack.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 6)
        trackView.centerYAnchor.constraint(equalTo: sliderTrack.centerYAnchor).isActive = true
        
        firstTrackView.anchor(top: nil, left: hourViewTriangle.centerXAnchor, bottom: nil, right: hourViewTriangle2.centerXAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 6)
        firstTrackView.centerYAnchor.constraint(equalTo: sliderTrack.centerYAnchor).isActive = true
        
        secondTrackView.anchor(top: nil, left: hourView3.centerXAnchor, bottom: nil, right: hourViewTriangle4.centerXAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 6)
        secondTrackView.centerYAnchor.constraint(equalTo: sliderTrack.centerYAnchor).isActive = true
        
    }
    
    @objc func addRangePressed() {
        if sliderTrack.value.count != 2 {
            watchDrags = false
            startValue = 16.0
            endValue = 38.0
            sliderTrack.value = [startValue, endValue]
            valueChanged(sender: self.sliderTrack)
            UIView.animate(withDuration: animationIn, animations: {
                self.unavailableView.alpha = 0
                self.hourView3.alpha = 0
                self.hourView4.alpha = 0
                self.hourLabel3.alpha = 0
                self.hourLabel4.alpha = 0
                self.hourViewTriangle4.alpha = 0
                self.secondTrackView.alpha = 0
                self.firstTrackView.alpha = 0
            }) { (success) in
                self.valueChanged(sender: self.sliderTrack)
                self.checkHighlightedTicks()
                self.delegate?.removeRangePressed()
                UIView.animate(withDuration: animationIn, animations: {
                    self.unavailableButton.alpha = 1
                    self.hourView.alpha = 1
                    self.hourView2.alpha = 1
                    self.hourLabel.alpha = 1
                    self.hourLabel2.alpha = 1
                    self.firstTrackView.alpha = 1
                    self.hourViewTriangle.alpha = 1
                    self.hourViewTriangle2.alpha = 1
                    self.removeRangeButton.alpha = 1
                    self.addRangeButton.alpha = 1
                    self.view.layoutIfNeeded()
                }) { (success) in
                    self.watchDrags = true
                }
            }
        } else {
            watchDrags = false
            startValue = 0.0
            endValue = 15.0
            startValue2 = 35.0
            endValue2 = CGFloat(tickCount)
            sliderTrack.value = [startValue, endValue, startValue2, endValue2]
            valueChanged(sender: self.sliderTrack)
            UIView.animate(withDuration: animationIn, animations: {
                self.addRangeButton.alpha = 0
                self.hourView3.alpha = 1
                self.hourView4.alpha = 1
                self.hourViewTriangle4.alpha = 1
                self.hourLabel3.alpha = 1
                self.hourLabel4.alpha = 1
                self.firstTrackView.alpha = 0
            }) { (success) in
                self.valueChanged(sender: self.sliderTrack)
                self.checkHighlightedTicks()
                self.delegate?.addRangePressed()
                UIView.animate(withDuration: animationIn, animations: {
                    self.firstTrackView.alpha = 1
                    self.secondTrackView.alpha = 1
                    self.view.layoutIfNeeded()
                }) { (success) in
                    self.watchDrags = true
                    self.checkHighlightedTicks()
                }
            }
        }
    }
    
    @objc func removeRangePressed() {
        if sliderTrack.value.count != 4 {
            watchDrags = false
            startValue = 0.0
            endValue = 0.0
            sliderTrack.value = []
            timeRange = []
            UIView.animate(withDuration: animationIn, animations: {
                self.unavailableButton.alpha = 0
                self.hourView.alpha = 0
                self.hourView2.alpha = 0
                self.hourView3.alpha = 0
                self.hourView4.alpha = 0
                self.hourLabel.alpha = 0
                self.hourLabel2.alpha = 0
                self.hourLabel3.alpha = 0
                self.hourLabel4.alpha = 0
                self.hourViewTriangle.alpha = 0
                self.hourViewTriangle2.alpha = 0
                self.hourViewTriangle4.alpha = 0
                self.firstTrackView.alpha = 0
                self.secondTrackView.alpha = 0
                self.removeRangeButton.alpha = 0
            }) { (success) in
                self.checkHighlightedTicks()
                self.delegate?.addRangePressed()
                self.watchDrags = true
                UIView.animate(withDuration: animationIn) {
                    self.addRangeButton.alpha = 1
                    self.unavailableView.alpha = 1
                    self.view.layoutIfNeeded()
                }
            }
        } else {
            watchDrags = false
            startValue = 16.0
            endValue = 38.0
            sliderTrack.value = [startValue, endValue]
            valueChanged(sender: self.sliderTrack)
            UIView.animate(withDuration: animationIn, animations: {
                self.hourView3.alpha = 0
                self.hourView4.alpha = 0
                self.hourLabel3.alpha = 0
                self.hourLabel4.alpha = 0
                self.hourViewTriangle4.alpha = 0
                self.secondTrackView.alpha = 0
                self.firstTrackView.alpha = 0
            }) { (success) in
                self.valueChanged(sender: self.sliderTrack)
                self.checkHighlightedTicks()
                self.delegate?.removeRangePressed()
                UIView.animate(withDuration: animationIn, animations: {
                    self.firstTrackView.alpha = 1
                    self.addRangeButton.alpha = 1
                    self.view.layoutIfNeeded()
                }) { (success) in
                    self.watchDrags = true
                }
            }
        }
    }
    
    @objc func unavailableButtonPressed() {
        sliderTrack.value = []
        removeRangePressed()
    }

    func drawTicks(count: Int) {
        let displacement = (phoneWidth - 40)/CGFloat(count)
        for i in 1 ..< count {
            let percent = parkingValues[i - 1]
            let frame = CGRect(x: displacement * CGFloat(i), y: 0, width: 2, height: tickMaxHeight * percent)
            let tick = createTick(frame: frame)
            tick.tag = i - 1
            
            currentTicks.append(tick)
            tickView.addSubview(tick)
        }
    }
    
    func createTick(frame: CGRect) -> UIView {
        let tick = UIView(frame: frame)
        tick.backgroundColor = lineColor
        
        return tick
    }
    
    func removeTicks() {
        if currentTicks.count != 0 {
            for tick in currentTicks {
                tick.removeFromSuperview()
            }
        }
    }
    
    @objc func valueChanged(sender: MultiSlider) {
        let date = Date().dateAt(hours: 0, minutes: 0)
        let thumbIndex = sender.draggedThumbIndex
        if sender.thumbViews.count > thumbIndex && thumbIndex >= 0 && watchDrags {
            let deltaValue = sender.thumbViews[thumbIndex].frame.midX
            let value = sender.value[thumbIndex].rounded()
            
            let additionalSeconds: TimeInterval = TimeInterval(value * 1800) // Adding half hour each time
            let newTime = dateFormatter.string(from: date.addingTimeInterval(additionalSeconds))
            
            timeRange[thumbIndex] = date.addingTimeInterval(additionalSeconds)
            
            if thumbIndex == 0 {
                startValue = value
                sliderCenterAnchor.constant = deltaValue
                hourLabel.text = newTime
                let width = newTime.width(withConstrainedHeight: 26, font: Fonts.SSPSemiBoldH5) + 16
                hourViewWidthAnchor.constant = width
            } else if thumbIndex == 1 {
                endValue = value
                sliderCenterAnchor2.constant = deltaValue
                hourLabel2.text = newTime
                let width = newTime.width(withConstrainedHeight: 26, font: Fonts.SSPSemiBoldH5) + 16
                hourViewWidthAnchor2.constant = width
            } else if thumbIndex == 2 {
               startValue2 = value
               sliderCenterAnchor3.constant = deltaValue
               hourLabel3.text = newTime
               let width = newTime.width(withConstrainedHeight: 26, font: Fonts.SSPSemiBoldH5) + 16
               hourViewWidthAnchor3.constant = width
            } else if thumbIndex == 3 {
                endValue2 = value
                sliderCenterAnchor4.constant = deltaValue
                hourLabel4.text = newTime
                let width = newTime.width(withConstrainedHeight: 26, font: Fonts.SSPSemiBoldH5) + 16
                hourViewWidthAnchor4.constant = width
            }
            
            self.view.layoutIfNeeded()
        } else {
            let additionalSeconds: TimeInterval = TimeInterval(startValue * 1800) // Adding half hour each time
            let additionalSeconds2: TimeInterval = TimeInterval(endValue * 1800) // Adding half hour each time
            let additionalSeconds3: TimeInterval = TimeInterval(startValue2 * 1800) // Adding half hour each time
            let additionalSeconds4: TimeInterval = TimeInterval(endValue2 * 1800) // Adding half hour each time
            let newTime = dateFormatter.string(from: date.addingTimeInterval(additionalSeconds))
            let secondTime = dateFormatter.string(from: date.addingTimeInterval(additionalSeconds2))
            let newTime2 = dateFormatter.string(from: date.addingTimeInterval(additionalSeconds3))
            let secondTime2 = dateFormatter.string(from: date.addingTimeInterval(additionalSeconds4))
            
            timeRange = []
            timeRange.append(date.addingTimeInterval(additionalSeconds))
            timeRange.append(date.addingTimeInterval(additionalSeconds2))
            timeRange.append(date.addingTimeInterval(additionalSeconds3))
            timeRange.append(date.addingTimeInterval(additionalSeconds4))
            
            if sender.thumbViews.count > 0 {
                let deltaValue = sender.thumbViews[0].frame.midX
                sliderCenterAnchor.constant = deltaValue
            }
            hourLabel.text = newTime
            let width = newTime.width(withConstrainedHeight: 26, font: Fonts.SSPSemiBoldH5) + 16
            hourViewWidthAnchor.constant = width
            
            if sender.thumbViews.count > 1 {
                let deltaValue2 = sender.thumbViews[1].frame.midX
                sliderCenterAnchor2.constant = deltaValue2
            }
            hourLabel2.text = secondTime
            let width2 = secondTime.width(withConstrainedHeight: 26, font: Fonts.SSPSemiBoldH5) + 16
            hourViewWidthAnchor2.constant = width2
            
            if sender.value.count == 4 {
                if sender.thumbViews.count > 2 {
                    let deltaValue3 = sender.thumbViews[2].frame.midX
                    sliderCenterAnchor3.constant = deltaValue3
                }
                hourLabel3.text = newTime2
                let width3 = newTime2.width(withConstrainedHeight: 26, font: Fonts.SSPSemiBoldH5) + 16
                hourViewWidthAnchor3.constant = width3
                
                if sender.thumbViews.count > 3 {
                    let deltaValue4 = sender.thumbViews[3].frame.midX
                    sliderCenterAnchor4.constant = deltaValue4
                }
                hourLabel4.text = secondTime2
                let width4 = secondTime2.width(withConstrainedHeight: 26, font: Fonts.SSPSemiBoldH5) + 16
                hourViewWidthAnchor4.constant = width4
            }
            
            self.view.layoutIfNeeded()
        }
    }
    
    func checkHighlightedTicks() {
        for view in currentTicks {
            if secondTrackView.alpha == 1 {
                if (view.tag >= Int(startValue - 1) && view.tag < Int(endValue)) || (view.tag >= Int(startValue2 - 1) && view.tag < Int(endValue2)) {
                    view.backgroundColor = Theme.BLUE.withAlphaComponent(0.8)
                } else {
                    view.backgroundColor = lineColor
                }
            } else {
                if view.tag >= Int(startValue - 1) && view.tag < Int(endValue) {
                    view.backgroundColor = Theme.BLUE.withAlphaComponent(0.8)
                } else {
                    view.backgroundColor = lineColor
                }
            }
        }
    }
    
}
