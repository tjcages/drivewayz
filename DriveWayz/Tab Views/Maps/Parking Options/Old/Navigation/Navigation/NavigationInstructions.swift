//
//  NavigationInstructions.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 8/26/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Mapbox
import MapboxNavigation
import MapboxDirections
import MapboxCoreNavigation

class NavigationInstructions: UIViewController {
    
    var delegate: handleCurrentNavView?
    var finalAddress: String?
    
    var testLabel = UILabel()
    
    let textDistanceFormatter = DistanceFormatter(approximate: true)
    var routeProgress: RouteProgress? {
        didSet {
            if let progress = self.routeProgress {
                let step = progress.currentLegProgress.currentStep
                let distance = progress.currentLegProgress.currentStepProgress.distanceRemaining
                self.subtitleLabel.text = textDistanceFormatter.string(fromMeters: distance)
                self.updateProgress(step: step, current: true, distance: distance)
                
                guard let nextStep = progress.currentLegProgress.upcomingStep else { return }
                if let nextDistance = progress.currentLegProgress.upcomingStep?.distance {
                    self.updateProgress(step: nextStep, current: false, distance: nextDistance)
                } else {
                    self.updateProgress(step: nextStep, current: false, distance: distance)
                }
            }
        }
    }
    
    var isLastStep: Bool = false
    
    func updateProgress(step: RouteStep, current: Bool, distance: CLLocationDistance) {
        var direction = step.maneuverDirection
        if distance >= 1609.34 && current {
            self.minimizeContainer()
        } else if current {
            if let progress = self.routeProgress, let nextDistance = progress.currentLegProgress.upcomingStep?.distance, nextDistance <= 1609.34 && !isLastStep {
                self.expandContainer()
            } else {
                self.minimizeContainer()
            }
        }
        if distance >= 3218.69 {
            direction = .straightAhead
            let image = UIImage(named: "directionsStraight")!.withRenderingMode(.alwaysTemplate)
            self.setImage(image: image, current: current)
        } else {
            if #available(iOS 12.0, *) {
                if let drivingSide = step.instructionsDisplayedAlongStep?.first?.drivingSide {
                    let images = step.instructionsDisplayedAlongStep?.first?.primaryInstruction.maneuverImageSet(side: drivingSide)
                    if current {
                        self.largeArrowView.image = images?.lightContentImage
                    } else {
                        self.smallArrowView.image = images?.lightContentImage
                    }
                }
            } else {
                switch direction {
                case .slightRight:
                    let image = UIImage(named: "directionsSlightRight")!.withRenderingMode(.alwaysTemplate)
                    self.setImage(image: image, current: current)
                case .sharpRight:
                    let image = UIImage(named: "directionsSharpRight")!.withRenderingMode(.alwaysTemplate)
                    self.setImage(image: image, current: current)
                case .right:
                    let image = UIImage(named: "directionsRight")!.withRenderingMode(.alwaysTemplate)
                    self.setImage(image: image, current: current)
                case .slightLeft:
                    let image = UIImage(named: "directionsSlightLeft")!.withRenderingMode(.alwaysTemplate)
                    self.setImage(image: image, current: current)
                case .sharpLeft:
                    let image = UIImage(named: "directionsSharpLeft")!.withRenderingMode(.alwaysTemplate)
                    self.setImage(image: image, current: current)
                case .left:
                    let image = UIImage(named: "directionsLeft")!.withRenderingMode(.alwaysTemplate)
                    self.setImage(image: image, current: current)
                case .uTurn:
                    let image = UIImage(named: "directionsUTurn")!.withRenderingMode(.alwaysTemplate)
                    self.setImage(image: image, current: current)
                default:
                    let image = UIImage(named: "directionsStraight")!.withRenderingMode(.alwaysTemplate)
                    self.setImage(image: image, current: current)
                }
            }
        }
        if current {
            self.titleLabel.text = step.instructionsDisplayedAlongStep?.first?.primaryInstruction.text
            if self.titleLabel.text == "Finish" {
                self.titleLabel.text = finalAddress
                self.isLastStep = true
            }
            testLabel.text = self.titleLabel.text
            testLabel.font = Fonts.SSPSemiBoldH00
            let line = self.testLabel.calculateMaxLines()
            if line > 1 {
                self.titleLabel.font = Fonts.SSPSemiBoldH1
            } else {
                self.titleLabel.font = Fonts.SSPSemiBoldH00
            }
        } else {
            self.nextTitleLabel.text = step.instructionsDisplayedAlongStep?.first?.primaryInstruction.text
            if self.nextTitleLabel.text == "Finish" {
                self.nextTitleLabel.text = "Arrive at spot"
            }
        }
    }
    
    func setImage(image: UIImage, current: Bool) {
        if current {
            self.largeArrowView.image = image
        } else {
            self.smallArrowView.image = image
        }
    }
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    var titleLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.SSPSemiBoldH00
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.WHITE
        view.numberOfLines = 2
        
        return view
    }()
    
    var subtitleLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.SSPSemiBoldH3
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.WHITE
        view.textAlignment = .center
        
        return view
    }()

    var largeArrowView: UIImageView = {
        let button = UIImageView()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        button.tintColor = Theme.WHITE
        
        return button
    }()
    
    var topLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE.withAlphaComponent(0.4)
        view.layer.cornerRadius = 2
        
        return view
    }()
    
    var smallArrowView: UIImageView = {
        let button = UIImageView()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        button.tintColor = Theme.WHITE
        
        return button
    }()
    
    var nextTitleLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.SSPSemiBoldH3
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.WHITE
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.4
        
        setupViews()
    }
    
    var containerHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        containerHeightAnchor = container.heightAnchor.constraint(equalToConstant: 140)
            containerHeightAnchor.isActive = true
        
        container.addSubview(titleLabel)
        container.addSubview(subtitleLabel)
        container.addSubview(largeArrowView)
        container.addSubview(topLine)
        
        largeArrowView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 20).isActive = true
        largeArrowView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 12).isActive = true
        largeArrowView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        largeArrowView.widthAnchor.constraint(equalTo: largeArrowView.heightAnchor).isActive = true
        
        titleLabel.centerYAnchor.constraint(equalTo: largeArrowView.centerYAnchor, constant: 8).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: largeArrowView.rightAnchor, constant: 12).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -4).isActive = true
        titleLabel.sizeToFit()
        
        subtitleLabel.topAnchor.constraint(equalTo: largeArrowView.bottomAnchor, constant: 4).isActive = true
        subtitleLabel.centerXAnchor.constraint(equalTo: largeArrowView.centerXAnchor).isActive = true
        subtitleLabel.sizeToFit()
        
        topLine.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: -8).isActive = true
        topLine.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        topLine.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16).isActive = true
        topLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        container.addSubview(smallArrowView)
        container.addSubview(nextTitleLabel)
        
        smallArrowView.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        smallArrowView.topAnchor.constraint(equalTo: topLine.bottomAnchor, constant: 12).isActive = true
        smallArrowView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        smallArrowView.widthAnchor.constraint(equalTo: smallArrowView.heightAnchor).isActive = true
        
        nextTitleLabel.centerYAnchor.constraint(equalTo: smallArrowView.centerYAnchor).isActive = true
        nextTitleLabel.leftAnchor.constraint(equalTo: smallArrowView.rightAnchor, constant: 12).isActive = true
        nextTitleLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        nextTitleLabel.sizeToFit()
        
    }
    
    func minimizeContainer() {
        self.containerHeightAnchor.constant = 100
        self.delegate?.changeInstructionsHeight(height: 100)
        UIView.animate(withDuration: animationIn, animations: {
            self.smallArrowView.alpha = 0
            self.nextTitleLabel.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.smallArrowView.isHidden = true
            self.nextTitleLabel.isHidden = true
        }
    }
    
    func expandContainer() {
        self.containerHeightAnchor.constant = 140
        self.delegate?.changeInstructionsHeight(height: 140)
        self.smallArrowView.isHidden = false
        self.nextTitleLabel.isHidden = false
        UIView.animate(withDuration: animationIn, animations: {
            self.smallArrowView.alpha = 1
            self.nextTitleLabel.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
        }
    }
    
}
