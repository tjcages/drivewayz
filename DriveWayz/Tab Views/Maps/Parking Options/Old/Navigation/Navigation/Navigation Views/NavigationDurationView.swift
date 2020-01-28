//
//  NavigationDurationView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 8/27/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Mapbox
import MapboxNavigation
import MapboxDirections
import MapboxCoreNavigation

class NavigationDurationView: UIViewController {
    
    var destinationAddress: String?
    var expectedTravelTime: TimeInterval? {
        didSet {
            if let travelTime = self.expectedTravelTime, let durationRemaining = self.durationRemaining {
                let upcomingDate = Date().addingTimeInterval(travelTime + durationRemaining)
                let dateFormatter = DateFormatter()
                dateFormatter.amSymbol = "am"
                dateFormatter.pmSymbol = "pm"
                dateFormatter.dateFormat = "h:mma"
                let upcomingString = dateFormatter.string(from: upcomingDate)
                self.destinationTime.text = upcomingString
                
                let minutes = (Int(travelTime)/60) % 60
                self.walkingTime.text = "\(minutes) min"
            }
        }
    }
    
    var durationRemaining: TimeInterval?
    var routeProgress: RouteProgress? {
        didSet {
            if let progress = self.routeProgress {
                let duration = progress.durationRemaining
                durationRemaining = duration
                
                let upcomingDate = Date().addingTimeInterval(duration)
                let dateFormatter = DateFormatter()
                dateFormatter.amSymbol = "am"
                dateFormatter.pmSymbol = "pm"
                dateFormatter.dateFormat = "h:mma"
                let upcomingString = dateFormatter.string(from: upcomingDate)
                
                let minutes = (Int(duration)/60) % 60
                let minutesString = "\(minutes) min"
                self.parkingTime.text = minutesString
                
                if self.arrivalLabel.text == "time left" {
                    self.arrivalTime.text = minutesString
                } else {
                    self.arrivalTime.text = upcomingString
                }
            }
        }
    }
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2 Car Driveway"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH2
        
        return label
    }()
    
    var topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        view.clipsToBounds = true
        
        return view
    }()
    
    var bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        
        return view
    }()
    
    var arrivalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "arrival"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .right
        
        return label
    }()
    
    var arrivalTime: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH25
        label.textAlignment = .right
        
        return label
    }()
    
    var arrivalTimeIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "map-pin")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var arrivalTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "University Avenue"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH4
        
        return label
    }()

    var parkingIcon: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY
        let circle = UIView()
        circle.backgroundColor = Theme.OFF_WHITE
        circle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(circle)
        circle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        circle.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        circle.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6).isActive = true
        circle.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        return view
    }()
    
    var parkingOption: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Residential"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var parkingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "parking spot"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var parkingTime: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "in 5 min"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH2
        
        return label
    }()
    
    var dottedLine: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: "circleLine")
        view.image = image
        view.image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        view.tintColor = lineColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        return view
    }()
    
    var walkingIcon: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "walkingIcon")
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var walkingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Walk to final destination"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var walkingTime: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "10 min"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .right
        
        return label
    }()
    
    var walkingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY
        
        return view
    }()
    
    var destinationIcon: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY
        view.layer.cornerRadius = 8
        let circle = UIView()
        circle.backgroundColor = Theme.OFF_WHITE
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.layer.cornerRadius = 3
        view.addSubview(circle)
        circle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        circle.widthAnchor.constraint(equalToConstant: 6).isActive = true
        circle.heightAnchor.constraint(equalToConstant: 6).isActive = true
        circle.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        return view
    }()
    
    var destinationOption: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Folsom Field"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var destinationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "destination"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var destinationTime: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "4:45pm"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH2
        
        return label
    }()
    
    var dottedLine2: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: "circleLine")
        view.image = image
        view.image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        view.tintColor = lineColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        return view
    }()
    
    var checkInButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Check in", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.layer.borderColor = lineColor.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = Theme.WHITE
        
        return button
    }()
    
    var issueButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("End navigation", for: .normal)
        button.setTitleColor(Theme.HARMONY_RED, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.layer.borderColor = lineColor.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = Theme.WHITE
        
        return button
    }()
    
    var fromTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "8:00am"
        label.font = Fonts.SSPSemiBoldH1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.alpha = 0
        
        return label
    }()
    
    var toTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "10:15am"
        label.font = Fonts.SSPSemiBoldH1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.textAlignment = .right
        label.alpha = 0
        
        return label
    }()
    
    var toLabel: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("to", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.4), for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH3
        button.isUserInteractionEnabled = false
        button.alpha = 0
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

//        view.backgroundColor = Theme.OFF_WHITE.withAlphaComponent(0.8)
        
        setupViews()
        setupTopViews()
        setupParking()
        setupWalking()
        setupDestination()
        setupOptions()
        setupDuration()
    }
    
    var containerHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(container)
        container.addSubview(bottomView)
        container.addSubview(topView)
        
        container.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        containerHeightAnchor = container.heightAnchor.constraint(equalToConstant: 368)
            containerHeightAnchor.isActive = true
        
        topView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        topView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: -1).isActive = true
        topView.rightAnchor.constraint(equalTo: container.rightAnchor, constant: 1).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 108).isActive = true
        
        bottomView.heightAnchor.constraint(equalToConstant: 260).isActive = true
        bottomView.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        bottomView.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        
    }
    
    var mainViewNormalAnchor: NSLayoutConstraint!
    var mainViewLeftAnchor: NSLayoutConstraint!
    var mainViewRightAnchor: NSLayoutConstraint!
    
    func setupTopViews() {
        
        view.addSubview(mainView)
        view.addSubview(arrivalTime)
        view.addSubview(arrivalLabel)
        
        arrivalTime.topAnchor.constraint(equalTo: topView.topAnchor, constant: 20).isActive = true
        arrivalTime.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
//        arrivalTime.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16).isActive = true
        arrivalTime.sizeToFit()
        
        arrivalLabel.anchor(top: arrivalTime.bottomAnchor, left: nil, bottom: nil, right: arrivalTime.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 24)
        
        mainViewRightAnchor = mainView.rightAnchor.constraint(equalTo: view.rightAnchor)
            mainViewRightAnchor.isActive = true
        mainView.topAnchor.constraint(equalTo: arrivalTime.topAnchor, constant: -4).isActive = true
        mainView.bottomAnchor.constraint(equalTo: arrivalLabel.bottomAnchor, constant: 8).isActive = true
        mainViewNormalAnchor = mainView.leftAnchor.constraint(equalTo: arrivalTime.leftAnchor, constant: -20)
            mainViewNormalAnchor.isActive = true
        mainViewLeftAnchor = mainView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16)
            mainViewLeftAnchor.isActive = false
        
        view.addSubview(mainLabel)
        mainLabel.centerYAnchor.constraint(equalTo: arrivalTime.centerYAnchor).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16).isActive = true
        mainLabel.sizeToFit()
        
        topView.addSubview(arrivalTimeIcon)
        arrivalTimeIcon.anchor(top: mainLabel.bottomAnchor, left: container.leftAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 22, height: 22)
        
        topView.addSubview(arrivalTimeLabel)
        arrivalTimeLabel.centerYAnchor.constraint(equalTo: arrivalTimeIcon.centerYAnchor).isActive = true
        arrivalTimeLabel.leftAnchor.constraint(equalTo: arrivalTimeIcon.rightAnchor, constant: 4).isActive = true
        arrivalTimeLabel.sizeToFit()
        
    }
    
    func setupParking() {
        
        bottomView.addSubview(parkingIcon)
        parkingIcon.anchor(top: bottomView.topAnchor, left: container.leftAnchor, bottom: nil, right: nil, paddingTop: 32, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 16, height: 16)
        
        bottomView.addSubview(parkingOption)
        parkingOption.anchor(top: parkingIcon.topAnchor, left: parkingIcon.rightAnchor, bottom: nil, right: container.rightAnchor, paddingTop: -14, paddingLeft: 16, paddingBottom: 0, paddingRight: 48, width: 0, height: 26)
        
        bottomView.addSubview(parkingLabel)
        parkingLabel.anchor(top: parkingOption.bottomAnchor, left: parkingOption.leftAnchor, bottom: nil, right: container.rightAnchor, paddingTop: -4, paddingLeft: 0, paddingBottom: 0, paddingRight: 48, width: 0, height: 24)
        
        bottomView.addSubview(parkingTime)
        parkingTime.centerYAnchor.constraint(equalTo: parkingIcon.centerYAnchor).isActive = true
        parkingTime.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16).isActive = true
        parkingTime.sizeToFit()
        
    }
    
    func setupWalking() {
        
        bottomView.addSubview(dottedLine)
        bottomView.addSubview(dottedLine2)
        
        bottomView.addSubview(walkingView)
        bottomView.addSubview(walkingIcon)
        bottomView.addSubview(walkingLabel)
        bottomView.addSubview(walkingTime)
        
        walkingIcon.anchor(top: parkingIcon.bottomAnchor, left: walkingLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 42, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 18, height: 18)
        
        walkingLabel.leftAnchor.constraint(equalTo: dottedLine.leftAnchor).isActive = true
        walkingLabel.centerYAnchor.constraint(equalTo: walkingIcon.centerYAnchor).isActive = true
        walkingLabel.sizeToFit()
        
        walkingView.anchor(top: walkingLabel.topAnchor, left: view.leftAnchor, bottom: walkingLabel.bottomAnchor, right: walkingIcon.rightAnchor, paddingTop: -8, paddingLeft: 0, paddingBottom: -8, paddingRight: -12, width: 0, height: 0)
        
        walkingTime.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16).isActive = true
        walkingTime.centerYAnchor.constraint(equalTo: walkingIcon.centerYAnchor).isActive = true
        walkingTime.sizeToFit()
        
        dottedLine.topAnchor.constraint(equalTo: parkingIcon.bottomAnchor, constant: -2).isActive = true
        dottedLine.bottomAnchor.constraint(equalTo: walkingIcon.topAnchor, constant: -1).isActive = true
        dottedLine.centerXAnchor.constraint(equalTo: parkingIcon.centerXAnchor, constant: 1).isActive = true
        dottedLine.widthAnchor.constraint(equalToConstant: 12).isActive = true
        
    }
    
    func setupDestination() {
        
        bottomView.addSubview(destinationIcon)
        
        destinationIcon.anchor(top: walkingIcon.bottomAnchor, left: container.leftAnchor, bottom: nil, right: nil, paddingTop: 42, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 16, height: 16)
        
        bottomView.addSubview(destinationOption)
        destinationOption.anchor(top: destinationIcon.topAnchor, left: destinationIcon.rightAnchor, bottom: nil, right: container.rightAnchor, paddingTop: -14, paddingLeft: 16, paddingBottom: 0, paddingRight: 48, width: 0, height: 26)
        
        bottomView.addSubview(destinationLabel)
        destinationLabel.anchor(top: destinationOption.bottomAnchor, left: destinationOption.leftAnchor, bottom: nil, right: container.rightAnchor, paddingTop: -4, paddingLeft: 0, paddingBottom: 0, paddingRight: 48, width: 0, height: 24)
        
        bottomView.addSubview(destinationTime)
        destinationTime.centerYAnchor.constraint(equalTo: destinationIcon.centerYAnchor).isActive = true
        destinationTime.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16).isActive = true
        destinationTime.sizeToFit()
        
        dottedLine2.topAnchor.constraint(equalTo: walkingIcon.bottomAnchor, constant: -1).isActive = true
        dottedLine2.bottomAnchor.constraint(equalTo: destinationIcon.topAnchor, constant: 0).isActive = true
        dottedLine2.centerXAnchor.constraint(equalTo: parkingIcon.centerXAnchor, constant: 1).isActive = true
        dottedLine2.widthAnchor.constraint(equalToConstant: 12).isActive = true
        
    }
    
    var issueButtonCenterAnchor: NSLayoutConstraint!
    var issueButtonLeftAnchor: NSLayoutConstraint!
    
    func setupOptions() {
        
        bottomView.addSubview(checkInButton)
        checkInButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 1).isActive = true
        checkInButton.leftAnchor.constraint(equalTo: container.leftAnchor, constant: -1).isActive = true
        checkInButton.rightAnchor.constraint(equalTo: container.centerXAnchor, constant: 0.5).isActive = true
        checkInButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        bottomView.addSubview(issueButton)
        issueButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 1).isActive = true
        issueButtonCenterAnchor = issueButton.leftAnchor.constraint(equalTo: container.centerXAnchor, constant: -0.5)
            issueButtonCenterAnchor.isActive = true
        issueButtonLeftAnchor = issueButton.leftAnchor.constraint(equalTo: container.leftAnchor, constant: -1)
            issueButtonLeftAnchor.isActive = false
        issueButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: 1).isActive = true
        issueButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
    }
    
    var fromTimeAnchor: NSLayoutConstraint!
    var toTimeAnchor: NSLayoutConstraint!
    
    func setupDuration() {
        
        view.addSubview(fromTimeLabel)
        fromTimeLabel.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true
        fromTimeLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 32).isActive = true
        fromTimeAnchor = fromTimeLabel.widthAnchor.constraint(equalToConstant: (fromTimeLabel.text?.width(withConstrainedHeight: 30, font: Fonts.SSPSemiBoldH1))!)
            fromTimeAnchor.isActive = true
        fromTimeLabel.sizeToFit()
        
        view.addSubview(toTimeLabel)
        toTimeLabel.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true
        toTimeLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -32).isActive = true
        toTimeAnchor = toTimeLabel.widthAnchor.constraint(equalToConstant: (toTimeLabel.text?.width(withConstrainedHeight: 30, font: Fonts.SSPSemiBoldH1))!)
            toTimeAnchor.isActive = true
        toTimeLabel.sizeToFit()
        
        view.addSubview(toLabel)
        toLabel.bottomAnchor.constraint(equalTo: fromTimeLabel.bottomAnchor, constant: -6).isActive = true
        toLabel.leftAnchor.constraint(equalTo: fromTimeLabel.rightAnchor).isActive = true
        toLabel.rightAnchor.constraint(equalTo: toTimeLabel.leftAnchor).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    func navigationBegan() {
        
    }
    
    func navigationNearParking() {
        containerHeightAnchor.constant = 300
        UIView.animate(withDuration: animationIn) {
            self.parkingIcon.alpha = 0
            self.parkingTime.alpha = 0
            self.parkingLabel.alpha = 0
            self.parkingOption.alpha = 0
            self.dottedLine.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func navigationParked() {
        navigationNearParking()
        containerHeightAnchor.constant = 164
        arrivalLabel.text = "check in"
        UIView.animate(withDuration: animationIn) {
            self.walkingIcon.alpha = 0
            self.walkingTime.alpha = 0
            self.walkingLabel.alpha = 0
            self.dottedLine2.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func navigationWalking() {
        navigationParked()
        containerHeightAnchor.constant = 164
        arrivalLabel.text = "time left"
        mainLabel.text = destinationOption.text
        if let destination = destinationAddress {
            arrivalTimeLabel.text = destination
        } else {
            arrivalTimeLabel.text = ""
        }
        destinationOption.text = "Destination"
        issueButtonCenterAnchor.isActive = false
        issueButtonLeftAnchor.isActive = true
        UIView.animate(withDuration: animationIn) {
            self.topView.backgroundColor = Theme.BLUE
            self.checkInButton.alpha = 0
            self.destinationOption.alpha = 0
            self.destinationTime.alpha = 0
            self.destinationIcon.alpha = 0
            self.destinationLabel.alpha = 0
            self.dottedLine2.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func navigationArrived() {
        containerHeightAnchor.constant = 272
        mainViewNormalAnchor.isActive = false
        mainViewLeftAnchor.isActive = true
        mainViewRightAnchor.constant = -24
        UIView.animate(withDuration: animationIn) {
            self.mainLabel.alpha = 0
            self.arrivalLabel.alpha = 0
            self.arrivalTime.alpha = 0
            self.arrivalTimeLabel.alpha = 0
            self.arrivalTimeIcon.alpha = 0
            self.fromTimeLabel.alpha = 1
            self.toTimeLabel.alpha = 1
            self.toLabel.alpha = 1
            self.view.layoutIfNeeded()
        }
    }

}
