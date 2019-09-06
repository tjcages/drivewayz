//
//  DirectionsCell.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 8/25/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import Foundation
import UIKit
import MapboxDirections

class DirectionsCell: UITableViewCell {
    
    let textDistanceFormatter = DistanceFormatter(approximate: true)
    var isMainCell: Bool = false
    var distanceString: String = "" {
        didSet {
            self.subtitleLabel.text = self.distanceString
        }
    }
    var nextDrivingInstruction: RouteStep?
    var drivingInstruction: RouteStep? {
        didSet {
            textDistanceFormatter.numberFormatter.maximumFractionDigits = 0
            
            if let instruction = self.drivingInstruction {
                let text = instruction.instructions
                let drivingSide = (instruction.instructionsDisplayedAlongStep?.first?.drivingSide)!
                let direction = instruction.maneuverDirection
                
                if #available(iOS 12.0, *) {
                    let images = instruction.instructionsDisplayedAlongStep?.first?.primaryInstruction.maneuverImageSet(side: drivingSide)
                    self.arrowView.image = images?.darkContentImage
                    self.largeArrowView.image = images?.darkContentImage
                } else {
                    switch direction {
                    case .slightRight:
                        let image = UIImage(named: "directionsSlightRight")
                        self.arrowView.image = image
                        self.largeArrowView.image = image
                    case .sharpRight:
                        let image = UIImage(named: "directionsSharpRight")
                        self.arrowView.image = image
                        self.largeArrowView.image = image
                    case .right:
                        let image = UIImage(named: "directionsRight")
                        self.arrowView.image = image
                        self.largeArrowView.image = image
                    case .slightLeft:
                        let image = UIImage(named: "directionsSlightLeft")
                        self.arrowView.image = image
                        self.largeArrowView.image = image
                    case .sharpLeft:
                        let image = UIImage(named: "directionsSharpLeft")
                        self.arrowView.image = image
                        self.largeArrowView.image = image
                    case .left:
                        let image = UIImage(named: "directionsLeft")
                        self.arrowView.image = image
                        self.largeArrowView.image = image
                    case .uTurn:
                        let image = UIImage(named: "directionsUTurn")
                        self.arrowView.image = image
                        self.largeArrowView.image = image
                    default:
                        let image = UIImage(named: "directionsStraight")
                        self.arrowView.image = image
                        self.largeArrowView.image = image
                    }
                }
                
                if let nextInstruction = self.nextDrivingInstruction {
                    let distance = nextInstruction.distance
                    self.subtitleLabel.text = textDistanceFormatter.string(fromMeters: distance)
                }
                
                if isMainCell {
                    self.titleLabel.text = text
                } else {
                    self.titleLabel.text = text
                }
            }
        }
    }
    
    var arrowView: UIImageView = {
        let button = UIImageView()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
//        button.backgroundColor = lineColor
        button.contentMode = .scaleAspectFit
        
        return button
    }()
    
    var largeArrowView: UIImageView = {
        let button = UIImageView()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        
        return button
    }()
    
    var currentView: UIView = {
        let button = UIView()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 6
        button.backgroundColor = lineColor
        button.alpha = 0
        
        let view = UIView()
        view.backgroundColor = Theme.BLUE
        view.layer.cornerRadius = 5
        view.center = button.center
        view.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(view)
        view.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        view.heightAnchor.constraint(equalToConstant: 10).isActive = true
        view.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        return button
    }()
    
    var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "Head North"
        view.font = Fonts.SSPSemiBoldH3
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.DARK_GRAY
        view.numberOfLines = 2
        
        return view
    }()
    
    var subtitleLabel: UILabel = {
        let view = UILabel()
        view.text = "0.2 miles"
        view.font = Fonts.SSPRegularH5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.DARK_GRAY
        
        return view
    }()
    
    var topLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        view.layer.cornerRadius = 2
        
        return view
    }()
    
    var bottomLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        view.layer.cornerRadius = 2
        
        return view
    }()
    
    var titleTopAnchor: NSLayoutConstraint!
    var subtitleTopAnchor: NSLayoutConstraint!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        
        addSubview(topLine)
        addSubview(bottomLine)
        addSubview(currentView)
        addSubview(arrowView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(largeArrowView)
        
        currentView.centerXAnchor.constraint(equalTo: arrowView.centerXAnchor).isActive = true
        currentView.centerYAnchor.constraint(equalTo: arrowView.centerYAnchor).isActive = true
        currentView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        currentView.heightAnchor.constraint(equalTo: currentView.widthAnchor).isActive = true
        
        arrowView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        arrowView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        arrowView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        arrowView.widthAnchor.constraint(equalTo: arrowView.heightAnchor).isActive = true
        
        titleTopAnchor = titleLabel.centerYAnchor.constraint(equalTo: arrowView.centerYAnchor)
            titleTopAnchor.isActive = true
        titleLabel.leftAnchor.constraint(equalTo: arrowView.rightAnchor, constant: 32).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        titleLabel.sizeToFit()
        
        subtitleTopAnchor = subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12)
            subtitleTopAnchor.isActive = true
        subtitleLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        subtitleLabel.sizeToFit()
        
        topLine.topAnchor.constraint(equalTo: self.topAnchor, constant: -4).isActive = true
        topLine.centerXAnchor.constraint(equalTo: arrowView.centerXAnchor).isActive = true
        topLine.bottomAnchor.constraint(equalTo: arrowView.topAnchor, constant: -4).isActive = true
        topLine.widthAnchor.constraint(equalToConstant: 4).isActive = true
        
        bottomLine.topAnchor.constraint(equalTo: arrowView.bottomAnchor, constant: 4).isActive = true
        bottomLine.centerXAnchor.constraint(equalTo: arrowView.centerXAnchor).isActive = true
        bottomLine.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 4).isActive = true
        bottomLine.widthAnchor.constraint(equalToConstant: 4).isActive = true
        
        largeArrowView.centerXAnchor.constraint(equalTo: bottomLine.centerXAnchor, constant: 8).isActive = true
        largeArrowView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        largeArrowView.heightAnchor.constraint(equalToConstant: 55).isActive = true
        largeArrowView.widthAnchor.constraint(equalTo: largeArrowView.heightAnchor).isActive = true
        
    }
    
    func isMainInstruction() {
        isMainCell = true
        titleLabel.font = Fonts.SSPBoldH1
        subtitleLabel.font = Fonts.SSPSemiBoldH3
        currentView.alpha = 0
        arrowView.alpha = 0
        topLine.alpha = 0
        titleLabel.alpha = 1
        subtitleTopAnchor.constant = 2
        largeArrowView.alpha = 1
        bottomLine.alpha = 0
        subtitleLabel.alpha = 1
        subtitleLabel.textColor = Theme.BLUE
        titleTopAnchor.constant = 12
    }
    
    func isNormalInstruction() {
        isMainCell = false
        titleLabel.font = Fonts.SSPSemiBoldH3
        subtitleLabel.font = Fonts.SSPSemiBoldH4
        currentView.alpha = 0
        arrowView.alpha = 0.4
        topLine.alpha = 1
        titleLabel.alpha = 0.7
        subtitleTopAnchor.constant = 6
        largeArrowView.alpha = 0
        bottomLine.alpha = 1
        subtitleLabel.alpha = 0.7
        subtitleLabel.textColor = Theme.DARK_GRAY
        titleTopAnchor.constant = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


