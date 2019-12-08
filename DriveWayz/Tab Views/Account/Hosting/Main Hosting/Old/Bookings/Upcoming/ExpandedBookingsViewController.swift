//
//  HostingPreviousViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/15/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Cosmos

class ExpandedBookingsViewController: UIViewController {
    
    var delegate: handleBookingInformation?
    var counterClockwise: Bool = true
    
    var booking: Bookings? {
        didSet {
            if let booking = self.booking {
                if let name = booking.userName {
                    let split = name.split(separator: " ")
                    if let first = split.first, let last = split.dropFirst().first?.first {
                        self.nameLabel.text = "\(first) \(last.uppercased())."
                    }
                }
                if let fromTime = booking.fromDate, let toTime = booking.toDate {
                    let fromDate = Date(timeIntervalSince1970: fromTime)
                    let toDate = Date(timeIntervalSince1970: toTime)
                    let formatter = DateFormatter()
                    formatter.dateFormat = "h:mma"
                    formatter.amSymbol = "am"
                    formatter.pmSymbol = "pm"
                    let fromString = formatter.string(from: fromDate)
                    let toString = formatter.string(from: toDate)
                    
                    self.fromTimeLabel.text = fromString
                    self.toTimeLabel.text = toString
                    
                    self.fromTimeAnchor = fromString.width(withConstrainedHeight: 30, font: Fonts.SSPSemiBoldH1) + 10
                    self.toTimeAnchor = toString.width(withConstrainedHeight: 30, font: Fonts.SSPSemiBoldH1) + 10
                    self.view.layoutIfNeeded()
                }
                
                
                if let userDuration = booking.userDuration, let userRating = booking.userRating, let fromDate = booking.fromDate {
                    if let payment = booking.totalCost, let hours = booking.hours, let price = booking.price {
                        self.userTotalCharge.text = String(format:"$%.02f", payment)
                        let hostProfit = hours * price * 0.75
                        let bookingFee = 0.30
                        let processingFee = 0.029 * payment
                        let drivewayzFee = hours * price * 0.25
                        self.userProfit.text = String(format:"$%.02f", hostProfit)
                        self.userBookingFee.text = String(format:"-$%.02f", bookingFee)
                        self.userProcessingFee.text = String(format:"-$%.02f", processingFee)
                        self.userDrivewayzFee.text = String(format:"-$%.02f", drivewayzFee)
                    }
                    self.stars.rating = userRating
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "E, d MMM yyyy"
                    let fromDay = Date(timeIntervalSince1970: fromDate)
                    let fromString = dateFormatter.string(from: fromDay)
                    self.dateLabel.setTitle(fromString, for: .normal)
                    self.dateWidthAnchor.constant = fromString.width(withConstrainedHeight: 30, font: Fonts.SSPSemiBoldH5) + 16
                    
                    let dates = userDuration.split(separator: "-")
                    self.fromTimeLabel.text = String(dates[0])
                    self.toTimeLabel.text = String(dates[1])
                    
                    if let vehicleID = booking.vehicleID {
                        let ref = Database.database().reference().child("UserVehicles").child(vehicleID)
                        ref.observeSingleEvent(of: .value) { (snapshot) in
                            if let dictionary = snapshot.value as? [String: Any] {
                                if let vehicleYear = dictionary["vehicleYear"] as? String, let vehicleMake = dictionary["vehicleMake"] as? String, let vehicleModel = dictionary["vehicleModel"] as? String, let licensePlate = dictionary["licensePlate"] as? String {
                                    let vehicle = "\(vehicleYear) \(vehicleMake) \(vehicleModel)"
                                    self.userVehicle.text = vehicle
                                    self.userLicense.text = licensePlate
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        
        return view
    }()
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    lazy var exitButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "exit")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        button.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.9)
        button.layer.cornerRadius = 15
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        return button
    }()
    
    var profileImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 30
        view.backgroundColor = Theme.WHITE
        view.image = UIImage(named: "background4")
        
        return view
    }()
    
    var gradientView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 38
        view.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/4)
        view.clipsToBounds = true
        view.backgroundColor = Theme.WHITE
        view.alpha = 0.8
        view.isUserInteractionEnabled = false
        let background = CAGradientLayer().customColor(topColor: Theme.LIGHT_GRAY, bottomColor: Theme.LIGHT_GRAY.withAlphaComponent(0.8))
        background.frame = CGRect(x: 0, y: 0, width: 110, height: 110)
        background.zPosition = -10
        view.layer.addSublayer(background)
        
        return view
    }()
    
    var fadedGradientView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 32
        view.clipsToBounds = true
        view.backgroundColor = Theme.WHITE
        view.alpha = 0.4
        view.isUserInteractionEnabled = false
        let background = CAGradientLayer().customColor(topColor: Theme.LIGHT_GRAY, bottomColor: Theme.LIGHT_GRAY.withAlphaComponent(0.8))
        background.frame = CGRect(x: 0, y: 0, width: 140, height: 140)
        background.zPosition = -10
        view.layer.addSublayer(background)
        
        return view
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tyler"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH2
        label.textAlignment = .center
        
        return label
    }()
    
    var stars: CosmosView = {
        let view = CosmosView()
        view.rating = 5.0
        view.settings.fillMode = .precise
        view.settings.updateOnTouch = false
        view.settings.starSize = 16
        view.settings.starMargin = 2
        view.settings.filledColor = Theme.GOLD
        view.settings.emptyBorderColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        view.settings.filledBorderColor = Theme.GOLD
        view.settings.emptyColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.settings.filledImage = UIImage(named: "Star Filled")?.withRenderingMode(.alwaysOriginal)
        view.settings.emptyImage = UIImage(named: "Star Empty")?.withRenderingMode(.alwaysOriginal)
        
        return view
    }()
    
    var vehicleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Vehicle"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var userVehicle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .right
        
        return label
    }()
    
    var vehicleLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
        return view
    }()
    
    var licenseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "License plate"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var userLicense: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .right
        
        return label
    }()
    
    var licenseLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
        return view
    }()
    
    var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
        return view
    }()
    
    var dimView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LIGHT_GRAY
        
        return view
    }()
    
    var dateLabel: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sat Jan 12, 2019", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH5
        button.backgroundColor = Theme.BLUE
        button.layer.cornerRadius = 4
        button.titleEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 16, right: 8)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var fromTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "8:00am"
        label.font = Fonts.SSPSemiBoldH1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        
        return label
    }()
    
    var toTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "10:15am"
        label.font = Fonts.SSPSemiBoldH1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.textAlignment = .right
        
        return label
    }()
    
    var toLabel: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("to", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.4), for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH3
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var durationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH5
        label.text = "PAYMENT INFORMATION"
        
        return label
    }()
    
    var priceView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    var totalChargeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Total charge"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var userTotalCharge: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$15.50"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .right
        
        return label
    }()
    
    var lineView3: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
        return view
    }()
    
    var bookingFeeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Booking fee"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var userBookingFee: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "-$0.32"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .right
        
        return label
    }()
    
    var processingFeeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Processing fee"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var userProcessingFee: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "-$1.23"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .right
        
        return label
    }()
    
    var drivewayzFeeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Drivewayz fee"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var userDrivewayzFee: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "-$2.80"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .right
        
        return label
    }()
    
    var lineView4: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
        return view
    }()
    
    var profitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Your profit"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var userProfit: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$12.38"
        label.textColor = Theme.GREEN_PIGMENT
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .right
        
        return label
    }()
    
    var lineView2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
        return view
    }()
    
    var optionsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH5
        label.text = "OPTIONS"
        
        return label
    }()
    
    var optionsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    var remindDriver: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Contact driver", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(driverOptionsPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var expandAvailabilityButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        
        return button
    }()
    
    var contactDriver: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("I need my spot back", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(driverOptionsPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var expandCalanderButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var overstayedDuration: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Driver overstayed duration", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(driverOptionsPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var expandUnavailableButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var informationIncorrect: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Driver information was incorrect", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(driverOptionsPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var expandSpotButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var reportUser: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Report driver", for: .normal)
        button.setTitleColor(Theme.HARMONY_RED, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(driverOptionsPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var expandReportButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var pullButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "pull-up")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        setupViews()
        setupUser()
        setupVehicle()
        setupDuration()
        setupPrice()
        setupOptions()
        animateCirclesClockwise(counterClockwise: self.counterClockwise)
    }
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth, height: 1180)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: statusHeight).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(exitButton)
        exitButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        exitButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16).isActive = true
        
        scrollView.addSubview(container)
        container.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 30).isActive = true
        
        self.view.addSubview(pullButton)
        pullButton.bottomAnchor.constraint(equalTo: container.topAnchor, constant: -16).isActive = true
        pullButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        pullButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        pullButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
    }
    
    func setupUser() {
        
        container.addSubview(gradientView)
        gradientView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        gradientView.topAnchor.constraint(equalTo: container.topAnchor, constant: 32).isActive = true
        gradientView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        gradientView.widthAnchor.constraint(equalTo: gradientView.heightAnchor).isActive = true
        
        container.addSubview(fadedGradientView)
        container.sendSubviewToBack(fadedGradientView)
        fadedGradientView.topAnchor.constraint(equalTo: gradientView.topAnchor, constant: 0).isActive = true
        fadedGradientView.leftAnchor.constraint(equalTo: gradientView.leftAnchor, constant: 0).isActive = true
        fadedGradientView.rightAnchor.constraint(equalTo: gradientView.rightAnchor, constant: 0).isActive = true
        fadedGradientView.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: 0).isActive = true
        
        scrollView.addSubview(profileImageView)
        profileImageView.centerYAnchor.constraint(equalTo: gradientView.centerYAnchor).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        scrollView.addSubview(nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        nameLabel.topAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: 8).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(stars)
        stars.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
        stars.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stars.sizeToFit()
        
    }
    
    func setupVehicle() {
        
        scrollView.addSubview(vehicleLabel)
        vehicleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        vehicleLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        vehicleLabel.topAnchor.constraint(equalTo: stars.bottomAnchor, constant: 32).isActive = true
        vehicleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(userVehicle)
        userVehicle.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        userVehicle.topAnchor.constraint(equalTo: stars.bottomAnchor, constant: 32).isActive = true
        userVehicle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        userVehicle.sizeToFit()
        
        scrollView.addSubview(vehicleLine)
        vehicleLine.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32 + (vehicleLabel.text?.width(withConstrainedHeight: 20, font: Fonts.SSPRegularH5))!).isActive = true
        vehicleLine.rightAnchor.constraint(equalTo: userVehicle.leftAnchor, constant: -12).isActive = true
        vehicleLine.bottomAnchor.constraint(equalTo: vehicleLabel.bottomAnchor, constant: -2).isActive = true
        vehicleLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        scrollView.addSubview(licenseLabel)
        licenseLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        licenseLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        licenseLabel.topAnchor.constraint(equalTo: vehicleLabel.bottomAnchor, constant: 12).isActive = true
        licenseLabel.sizeToFit()
        
        scrollView.addSubview(userLicense)
        userLicense.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        userLicense.topAnchor.constraint(equalTo: vehicleLabel.bottomAnchor, constant: 12).isActive = true
        userLicense.heightAnchor.constraint(equalToConstant: 20).isActive = true
        userLicense.sizeToFit()
        
        scrollView.addSubview(licenseLine)
        licenseLine.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32 + (licenseLabel.text?.width(withConstrainedHeight: 20, font: Fonts.SSPRegularH5))!).isActive = true
        licenseLine.rightAnchor.constraint(equalTo: userLicense.leftAnchor, constant: -12).isActive = true
        licenseLine.bottomAnchor.constraint(equalTo: licenseLabel.bottomAnchor, constant: -2).isActive = true
        licenseLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        scrollView.addSubview(lineView)
        lineView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        lineView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        lineView.topAnchor.constraint(equalTo: licenseLabel.bottomAnchor, constant: 32).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
        
    }
    
    var dateWidthAnchor: NSLayoutConstraint!
    var fromTimeAnchor: CGFloat = 0
    var toTimeAnchor: CGFloat = 0
    
    func setupDuration() {
        
        scrollView.addSubview(dimView)
        scrollView.addSubview(dateLabel)
        scrollView.addSubview(durationView)
        scrollView.addSubview(fromTimeLabel)
        scrollView.addSubview(toTimeLabel)
        scrollView.addSubview(toLabel)
        
        dimView.topAnchor.constraint(equalTo: lineView.topAnchor).isActive = true
        dimView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        dimView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        dimView.bottomAnchor.constraint(equalTo: durationView.bottomAnchor, constant: 24).isActive = true
        
        dateLabel.topAnchor.constraint(equalTo: dimView.topAnchor, constant: 24).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        dateWidthAnchor = dateLabel.widthAnchor.constraint(equalToConstant: 130)
        dateWidthAnchor.isActive = true
        dateLabel.sizeToFit()
        
        durationView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: -4).isActive = true
        durationView.leftAnchor.constraint(equalTo: dateLabel.leftAnchor).isActive = true
        durationView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        durationView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        fromTimeLabel.centerYAnchor.constraint(equalTo: durationView.centerYAnchor).isActive = true
        fromTimeLabel.leftAnchor.constraint(equalTo: durationView.leftAnchor, constant: 12).isActive = true
        fromTimeLabel.widthAnchor.constraint(equalToConstant: fromTimeAnchor).isActive = true
        fromTimeLabel.sizeToFit()
        
        toTimeLabel.centerYAnchor.constraint(equalTo: durationView.centerYAnchor).isActive = true
        toTimeLabel.rightAnchor.constraint(equalTo: durationView.rightAnchor, constant: -12).isActive = true
        toTimeLabel.widthAnchor.constraint(equalToConstant: toTimeAnchor).isActive = true
        toTimeLabel.sizeToFit()
        
        toLabel.bottomAnchor.constraint(equalTo: fromTimeLabel.bottomAnchor, constant: -6).isActive = true
        toLabel.leftAnchor.constraint(equalTo: fromTimeLabel.rightAnchor).isActive = true
        toLabel.rightAnchor.constraint(equalTo: toTimeLabel.leftAnchor).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
 
    func setupPrice() {
        
        scrollView.addSubview(priceView)
        scrollView.addSubview(priceLabel)
        priceLabel.topAnchor.constraint(equalTo: dimView.bottomAnchor, constant: 24).isActive = true
        priceLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        priceLabel.sizeToFit()
        
        priceView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: -4).isActive = true
        priceView.rightAnchor.constraint(equalTo: priceLabel.rightAnchor, constant: 8).isActive = true
        priceView.topAnchor.constraint(equalTo: priceLabel.topAnchor, constant: -4).isActive = true
        priceView.bottomAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4).isActive = true
        
        scrollView.addSubview(totalChargeLabel)
        totalChargeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        totalChargeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        totalChargeLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 12).isActive = true
        totalChargeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(userTotalCharge)
        userTotalCharge.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        userTotalCharge.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        userTotalCharge.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 12).isActive = true
        userTotalCharge.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(lineView3)
        lineView3.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        lineView3.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        lineView3.topAnchor.constraint(equalTo: totalChargeLabel.bottomAnchor, constant: 12).isActive = true
        lineView3.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
        
        scrollView.addSubview(bookingFeeLabel)
        bookingFeeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        bookingFeeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        bookingFeeLabel.topAnchor.constraint(equalTo: lineView3.bottomAnchor, constant: 12).isActive = true
        bookingFeeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(userBookingFee)
        userBookingFee.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        userBookingFee.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        userBookingFee.topAnchor.constraint(equalTo: lineView3.bottomAnchor, constant: 12).isActive = true
        userBookingFee.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(processingFeeLabel)
        processingFeeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        processingFeeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        processingFeeLabel.topAnchor.constraint(equalTo: bookingFeeLabel.bottomAnchor, constant: 12).isActive = true
        processingFeeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(userProcessingFee)
        userProcessingFee.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        userProcessingFee.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        userProcessingFee.topAnchor.constraint(equalTo: bookingFeeLabel.bottomAnchor, constant: 12).isActive = true
        userProcessingFee.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(drivewayzFeeLabel)
        drivewayzFeeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        drivewayzFeeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        drivewayzFeeLabel.topAnchor.constraint(equalTo: processingFeeLabel.bottomAnchor, constant: 12).isActive = true
        drivewayzFeeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(userDrivewayzFee)
        userDrivewayzFee.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        userDrivewayzFee.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        userDrivewayzFee.topAnchor.constraint(equalTo: processingFeeLabel.bottomAnchor, constant: 12).isActive = true
        userDrivewayzFee.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(lineView4)
        lineView4.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        lineView4.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        lineView4.topAnchor.constraint(equalTo: drivewayzFeeLabel.bottomAnchor, constant: 12).isActive = true
        lineView4.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
        
        scrollView.addSubview(profitLabel)
        profitLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        profitLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        profitLabel.topAnchor.constraint(equalTo: lineView4.bottomAnchor, constant: 12).isActive = true
        profitLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(userProfit)
        userProfit.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        userProfit.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        userProfit.topAnchor.constraint(equalTo: lineView4.bottomAnchor, constant: 12).isActive = true
        userProfit.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(lineView2)
        lineView2.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        lineView2.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        lineView2.topAnchor.constraint(equalTo: profitLabel.bottomAnchor, constant: 32).isActive = true
        lineView2.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
        
    }
    
    func setupOptions() {
        
        scrollView.addSubview(optionsView)
        scrollView.addSubview(optionsLabel)
        optionsLabel.topAnchor.constraint(equalTo: lineView2.topAnchor, constant: 24).isActive = true
        optionsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        optionsLabel.sizeToFit()
        
        optionsView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: -4).isActive = true
        optionsView.rightAnchor.constraint(equalTo: optionsLabel.rightAnchor, constant: 8).isActive = true
        optionsView.topAnchor.constraint(equalTo: optionsLabel.topAnchor, constant: -4).isActive = true
        optionsView.bottomAnchor.constraint(equalTo: optionsLabel.bottomAnchor, constant: 4).isActive = true
        
        container.addSubview(remindDriver)
        remindDriver.topAnchor.constraint(equalTo: optionsLabel.bottomAnchor, constant: 8).isActive = true
        remindDriver.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        remindDriver.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        remindDriver.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        container.addSubview(expandAvailabilityButton)
        expandAvailabilityButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        expandAvailabilityButton.centerYAnchor.constraint(equalTo: remindDriver.centerYAnchor).isActive = true
        expandAvailabilityButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        expandAvailabilityButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        container.addSubview(contactDriver)
        contactDriver.topAnchor.constraint(equalTo: remindDriver.bottomAnchor).isActive = true
        contactDriver.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        contactDriver.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        contactDriver.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        container.addSubview(expandCalanderButton)
        expandCalanderButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        expandCalanderButton.centerYAnchor.constraint(equalTo: contactDriver.centerYAnchor).isActive = true
        expandCalanderButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        expandCalanderButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        container.addSubview(overstayedDuration)
        overstayedDuration.topAnchor.constraint(equalTo: contactDriver.bottomAnchor).isActive = true
        overstayedDuration.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        overstayedDuration.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        overstayedDuration.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        container.addSubview(expandUnavailableButton)
        expandUnavailableButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        expandUnavailableButton.centerYAnchor.constraint(equalTo: overstayedDuration.centerYAnchor).isActive = true
        expandUnavailableButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        expandUnavailableButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        container.addSubview(informationIncorrect)
        informationIncorrect.topAnchor.constraint(equalTo: overstayedDuration.bottomAnchor).isActive = true
        informationIncorrect.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        informationIncorrect.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        informationIncorrect.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        container.addSubview(expandSpotButton)
        expandSpotButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        expandSpotButton.centerYAnchor.constraint(equalTo: informationIncorrect.centerYAnchor).isActive = true
        expandSpotButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        expandSpotButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        container.addSubview(reportUser)
        reportUser.topAnchor.constraint(equalTo: informationIncorrect.bottomAnchor).isActive = true
        reportUser.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        reportUser.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        reportUser.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        container.addSubview(expandReportButton)
        expandReportButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        expandReportButton.centerYAnchor.constraint(equalTo: reportUser.centerYAnchor).isActive = true
        expandReportButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        expandReportButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
    }
    
    func animateCirclesClockwise(counterClockwise: Bool) {
        var multiplier: CGFloat = 1
        if counterClockwise == true {
            self.counterClockwise = false
            multiplier = -1
        } else { self.counterClockwise = true }
        UIView.animate(withDuration: 6, animations: {
            self.gradientView.transform = CGAffineTransform(rotationAngle: multiplier * CGFloat.pi/2)
            self.fadedGradientView.transform = CGAffineTransform(rotationAngle: -multiplier * CGFloat.pi/4)
        }) { (success) in
            self.animateCirclesClockwise(counterClockwise: self.counterClockwise)
        }
    }
    
    @objc func driverOptionsPressed(sender: UIButton) {
        guard let text = sender.titleLabel?.text else { return }
        let controller = BookingIssueViewController()
        switch device {
        case .iphone8:
            controller.gradientHeightAnchor = 80
        case .iphoneX:
            controller.gradientHeightAnchor = 100
        }
        controller.mainIssue = text
        if text == "I need my spot back" {
            controller.setQuestions(question: "HostSpotQuestions")
        } else if text == "Driver overstayed duration" {
            controller.setQuestions(question: "DriverOverstayQuestions")
        } else if text == "Driver information was incorrect" {
            controller.setQuestions(question: "IncorrectInformationQuestions")
        } else if text == "Report driver" {
            controller.setQuestions(question: "ReportDriverQuestions")
        } else if text == "Contact driver" {
            let controller = SendBookingIssuesViewController()
            self.navigationController?.pushViewController(controller, animated: true)
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}


// Dismiss controller if it's swiped down and change the color of the exit button based on scroll translation
extension ExpandedBookingsViewController: UIScrollViewDelegate {
    
    @objc func backButtonPressed() {
        self.delegate?.closeBackground()
        self.dismiss(animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        if translation <= -120 {
            self.backButtonPressed()
        } else if translation <= -16 {
            UIView.animate(withDuration: animationIn) {
                self.exitButton.alpha = 0
            }
        } else {
            UIView.animate(withDuration: animationIn) {
                self.exitButton.alpha = 1
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
