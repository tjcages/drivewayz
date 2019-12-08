//
//  PriceSliderView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/4/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import MultiSlider

class PriceSliderView: UIViewController {
    
    var delegate: HostPriceDelegate?
    var minimumPrice: CGFloat = 1.32
    var maximumPrice: CGFloat = 7.0
    var standardPrice: CGFloat = 3.50 {
        didSet {
            maximumPrice = standardPrice * 2
            
            let standardValue = NSString(format: "$%.2f", standardPrice) as String
            let maxCostValue = NSString(format: "$%.2f", (standardPrice * 2)) as String
            let minCostValue = "$\(minimumPrice)"
            
            hourLabel.text = standardValue
            maxValueLabel.text = maxCostValue
            minValueLabel.text = minCostValue
            
            sliderTrack.minimumValue = minimumPrice
            sliderTrack.maximumValue = maximumPrice
            standardButtonPressed()
        }
    }
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hourly price range"
        label.textColor = Theme.PRUSSIAN_BLUE
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    lazy var sliderTrack: MultiSlider = {
        let view = MultiSlider(frame: CGRect(x: 0, y: 0, width: phoneWidth - 40, height: 6))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.minimumValue = minimumPrice
        view.maximumValue = maximumPrice
        view.orientation = .horizontal
        view.hasRoundTrackEnds = true
        view.showsThumbImageShadow = false
        view.outerTrackColor = .clear
        view.trackWidth = 6
        view.thumbImage = UIImage(named: "thumbImage")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .clear
        view.addTarget(self, action: #selector(valueChanged(sender:)), for: .valueChanged)
        
        return view
    }()
    
    var thumbView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY
        view.layer.cornerRadius = 12
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    var hourView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY
        view.layer.cornerRadius = 18
        
        return view
    }()
    
    var hourViewTriangle: TriangleView = {
        let view = TriangleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.color = Theme.DARK_GRAY
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 6
        view.transform = CGAffineTransform(scaleX: 1.0, y: -1.0)
        
        return view
    }()
    
    var hourLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH2
        label.textAlignment = .center
        
        return label
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
        view.backgroundColor = Theme.DARK_GRAY
        view.layer.cornerRadius = 3
        
        return view
    }()
    
    var minValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$1.32"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var minLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Min rate"
        label.textColor = Theme.PRUSSIAN_BLUE
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var maxValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$7.00"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .right
        
        return label
    }()
    
    var maxLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Max rate"
        label.textColor = Theme.PRUSSIAN_BLUE
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .right
        
        return label
    }()
    
    var standardButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Standard", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.addTarget(self, action: #selector(standardButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.BLUE.withAlphaComponent(0.2)
        
        setupViews()
        setupLabels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        standardButtonPressed()
    }
    
    var sliderCenterAnchor: NSLayoutConstraint!
    var triangleCenterAnchor: NSLayoutConstraint!
    var hourViewWidthAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(informationLabel)
        informationLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        informationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        informationLabel.sizeToFit()
        
        view.addSubview(trackView)
        view.addSubview(firstTrackView)
        view.addSubview(sliderTrack)
        view.addSubview(thumbView)
        
        sliderTrack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        sliderTrack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        sliderTrack.topAnchor.constraint(equalTo: informationLabel.bottomAnchor, constant: 72).isActive = true
        sliderTrack.heightAnchor.constraint(equalToConstant: 8).isActive = true
        
        thumbView.centerYAnchor.constraint(equalTo: trackView.centerYAnchor).isActive = true
        thumbView.heightAnchor.constraint(equalTo: thumbView.widthAnchor).isActive = true
        thumbView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        sliderCenterAnchor = thumbView.centerXAnchor.constraint(equalTo: sliderTrack.leftAnchor)
            sliderCenterAnchor.isActive = true
        
        view.addSubview(hourViewTriangle)
        view.addSubview(hourView)
        triangleCenterAnchor = hourView.centerXAnchor.constraint(equalTo: hourViewTriangle.centerXAnchor)
            triangleCenterAnchor.priority = UILayoutPriority.defaultLow
            triangleCenterAnchor.isActive = true
        hourView.bottomAnchor.constraint(equalTo: sliderTrack.topAnchor, constant: -20).isActive = true
        hourViewWidthAnchor = hourView.widthAnchor.constraint(equalToConstant: 92)
            hourViewWidthAnchor.isActive = true
        hourView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        hourView.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor).isActive = true
        hourView.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor).isActive = true
        
        hourViewTriangle.centerXAnchor.constraint(equalTo: thumbView.centerXAnchor).isActive = true
        hourViewTriangle.topAnchor.constraint(equalTo: hourView.bottomAnchor, constant: -1).isActive = true
        hourViewTriangle.widthAnchor.constraint(equalToConstant: 10).isActive = true
        hourViewTriangle.heightAnchor.constraint(equalToConstant: 5).isActive = true
        
        view.addSubview(hourLabel)
        hourLabel.centerXAnchor.constraint(equalTo: hourView.centerXAnchor).isActive = true
        hourLabel.centerYAnchor.constraint(equalTo: hourView.centerYAnchor).isActive = true
        hourLabel.sizeToFit()
        
        trackView.anchor(top: nil, left: sliderTrack.leftAnchor, bottom: nil, right: sliderTrack.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 6)
         trackView.centerYAnchor.constraint(equalTo: sliderTrack.centerYAnchor).isActive = true
        
        firstTrackView.anchor(top: nil, left: trackView.leftAnchor, bottom: nil, right: thumbView.centerXAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 6)
        firstTrackView.centerYAnchor.constraint(equalTo: sliderTrack.centerYAnchor).isActive = true
        
    }
    
    func setupLabels() {
        
        view.addSubview(minValueLabel)
        view.addSubview(minLabel)
        
        minValueLabel.topAnchor.constraint(equalTo: trackView.bottomAnchor, constant: 8).isActive = true
        minValueLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        minValueLabel.sizeToFit()
        
        minLabel.topAnchor.constraint(equalTo: minValueLabel.bottomAnchor).isActive = true
        minLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        minLabel.sizeToFit()
        
        view.addSubview(maxValueLabel)
        view.addSubview(maxLabel)
        
        maxValueLabel.topAnchor.constraint(equalTo: trackView.bottomAnchor, constant: 8).isActive = true
        maxValueLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        maxValueLabel.sizeToFit()
        
        maxLabel.topAnchor.constraint(equalTo: maxValueLabel.bottomAnchor).isActive = true
        maxLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        maxLabel.sizeToFit()
        
        view.addSubview(standardButton)
        standardButton.topAnchor.constraint(equalTo: trackView.bottomAnchor, constant: 8).isActive = true
        standardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        standardButton.sizeToFit()
        
    }
    
    func configureCustomPricing(state: String, city: String) {
        var stateAbrv = state
        stateAbrv = stateAbrv.replacingOccurrences(of: " ", with: "")
        if state.count > 2 {
            if let state = statesDictionary[stateAbrv] {
                stateAbrv = state
            }
        }
        let ref = Database.database().reference().child("Average Prices").child("\(stateAbrv)")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                if let cost = dictionary["\(city)"] as? CGFloat {
                    self.standardPrice = cost
                } else {
                    if let average = dictionary["Standard"] as? CGFloat {
                        self.standardPrice = average
                    }
                }
            }
        }
    }
    
    @objc func standardButtonPressed() {
        sliderTrack.value = [standardPrice]
        valueChanged(sender: sliderTrack)
        valueChanged(sender: sliderTrack)
    }
    
    @objc func valueChanged(sender: MultiSlider) {
        guard let value = sender.value.first else { return }
        let string = String(format: "$%.2f", value)
        hourLabel.text = string
        
        let deltaValue = sender.thumbViews[0].frame.midX
        let width = string.width(withConstrainedHeight: 36, font: Fonts.SSPSemiBoldH2) + 32
        sliderCenterAnchor.constant = deltaValue
        hourViewWidthAnchor.constant = width
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
        }
    }
    
}
