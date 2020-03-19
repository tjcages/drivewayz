//
//  BookingSpotView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 12/8/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import SVGKit

enum SpotType {
    case Private
    case Free
    case Public
}

enum Business: CGFloat {
    case empty = 1.0
    case mostly_empty = 0.9
    case almost_half = 0.7
    case half = 0.6
    case past_half = 0.5
    case almost_full = 0.3
    case full = 0.2
}

class BookingSpotView: UITableViewCell {
    
    var carHeight: CGFloat = 30
    var carWidth: CGFloat = 64
    var spotType: SpotType = .Public {
        didSet {
            switch spotType {
            case .Private:
                setKiosk()
            case .Public:
                setKiosk()
            case .Free:
                setFree()
            }
        }
    }
    
    var business: [Business] = [.almost_half, .mostly_empty, .almost_full] {
        didSet {
            bookingView.availability.business = business
            if let first = business.first {
                bookingView.business = first
            }
        }
    }
    
    func determineUpcomingAvailability(times: [CGFloat]) {
        var businessArray: [Business] = []
        var count = times.count
        if count > 3 {
            count = 3
        }
        for i in 0..<count {
            let time = times[i]
            if time < Business.full.rawValue {
                businessArray.append(.full)
            } else if time >= Business.full.rawValue && time < Business.almost_full.rawValue {
                businessArray.append(.almost_full)
            } else if time >= Business.almost_full.rawValue && time < Business.past_half.rawValue {
                businessArray.append(.past_half)
            } else if time >= Business.past_half.rawValue && time < Business.half.rawValue {
                businessArray.append(.half)
            } else if time >= Business.half.rawValue && time < Business.almost_half.rawValue {
                businessArray.append(.almost_half)
            } else if time >= Business.almost_half.rawValue && time < Business.mostly_empty.rawValue {
                businessArray.append(.mostly_empty)
            } else if time >= Business.mostly_empty.rawValue && time < Business.empty.rawValue {
                businessArray.append(.empty)
            }
        }
        business = businessArray
    }
    
    var parkingLot: ParkingLot? {
        didSet {
            if let lot = parkingLot {
                if let duration = lot.walkingDuration {
                    self.bookingView.subLabel.text = String(Int(duration)) + " min"
                }
                determineUpcomingAvailability(times: lot.parkingTimes)
                if let minPrice = lot.minprice {
                    if minPrice == "nan" {
                        // Free spot
                        spotType = .Free
                        bookingView.aceButton.isHidden = true
                        var lotType = " lot"
                        if let lotOrGarage = lot.lotOrGarage {
                            lotType = " \(lotOrGarage.lowercased())"
                        }
                        if let subLocality = lot.subLocality {
                            let split = subLocality.split(separator: " ")
                            if let first = split.first {
                                if first.count <= 3, let second = split.dropFirst().first {
                                    bookingView.mainLabel.text = "\(String(first)) \(String(second))" + lotType
                                } else {
                                    bookingView.mainLabel.text = String(first) + lotType
                                }
                            } else {
                                bookingView.mainLabel.text = subLocality + lotType
                            }
                        } else {
                            if let address = lot.address {
                                var stringAdress = address.components(separatedBy: CharacterSet.decimalDigits).joined()
                                if stringAdress.first == " " { stringAdress = String(stringAdress.dropFirst()) }
                                
                                let range: Range<String.Index> = stringAdress.range(of: " ")!
                                let index: Int = stringAdress.distance(from: stringAdress.startIndex, to: range.lowerBound)
                                let split = stringAdress.split(separator: " ")
                                if index <= 3 {
                                    // Add the second word
                                    if let first = split.first, let second = split.dropFirst().first {
                                        bookingView.mainLabel.text = "\(String(first)) \(String(second))" + lotType
                                    } else {
                                        print("can't split address")
                                    }
                                } else {
                                    // Just the first word
                                    if let first = split.first {
                                        bookingView.mainLabel.text = String(first) + lotType
                                    } else {
                                        print("can't split address")
                                    }
                                }
                            } else {
                                bookingView.mainLabel.text = "Free lot"
                            }
                        }
                        bookingView.costLabel.text = "Free"
                    } else {
                        // Fall back on min price
                        spotType = .Public
//                        bookingView.mainLabel.text = "Public" // JUST FOR TESTING
                        
                        if let price = Double(minPrice) {
                            bookingView.costLabel.text = String(format: "$%.2f/hour", price)
                            
                            if price < 10 {
                                bookingView.mainLabel.text = "Economy"
                            } else {
                                bookingView.mainLabel.text = "Prime"
                            }
                        } else {
                            print("can't find price")
                        }
                        if let parkingOperator = lot.shortOperator {
                            bookingView.aceButton.isHidden = false
                            bookingView.parkingOperator = parkingOperator
                        } else {
                            bookingView.aceButton.isHidden = true
                        }
                    }
                } else {
                    print("can't find minprice")
                }
            }
        }
    }
    
    var didSelect: Bool = false {
        didSet {
            if didSelect {
                selectedView()
            } else {
                unselectedView()
            }
        }
    }
    
    var carView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.clipsToBounds = true
        
        return view
    }()
    
    var carIllustration: SVGKImageView = {
        let image = SVGKImage(named: "Half_Car_Illustration")
        let view = SVGKFastImageView(svgkImage: image)!
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var iconButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.STANDARD_GRAY
        let image = UIImage(named: "kiosk_filled")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.GRAY_WHITE_3
        button.layer.cornerRadius = 20
        
        return button
    }()
    
    var bookingView = BookingView()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Theme.WHITE
        
        setupViews()

    }
    
    var iconCenterAnchor: NSLayoutConstraint!
    var iconLeftAnchor: NSLayoutConstraint!
    var iconRightAnchor: NSLayoutConstraint!
    
    var carLeftAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        addSubview(iconButton)
        addSubview(carView)
        carView.addSubview(carIllustration)
        
        carView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        carHeight = carIllustration.image.size.height/carIllustration.image.size.width * carWidth
        carIllustration.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: carWidth, height: carHeight)
        carIllustration.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 8).isActive = true
        carLeftAnchor = carIllustration.leftAnchor.constraint(equalTo: carView.leftAnchor, constant: -carWidth)
            carLeftAnchor.isActive = true
        
        iconCenterAnchor = iconButton.centerYAnchor.constraint(equalTo: centerYAnchor)
            iconCenterAnchor.isActive = true
        iconLeftAnchor = iconButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 20)
            iconLeftAnchor.isActive = true
        iconRightAnchor = iconButton.rightAnchor.constraint(equalTo: carIllustration.rightAnchor)
            iconRightAnchor.isActive = false
        iconButton.widthAnchor.constraint(equalTo: iconButton.heightAnchor).isActive = true
        iconButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(bookingView)
        bookingView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        bookingView.leftAnchor.constraint(equalTo: iconButton.rightAnchor, constant: 20).isActive = true
        bookingView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        bookingView.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        addSubview(line)
        line.anchor(top: nil, left: bookingView.leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
    }
    
    func selectedView() {
        carLeftAnchor.constant = 0
        iconCenterAnchor.constant = -6
        iconLeftAnchor.isActive = false
        iconRightAnchor.isActive = true
        bookingView.subLabelLeftAnchor.constant = 4
        bookingView.availabilityRightAnchor.constant = -8
        UIView.animateOut(withDuration: animationIn, animations: {
            if let lot = self.parkingLot, let duration = lot.walkingDuration {
                self.bookingView.subLabel.text = String(Int(duration)) + " min"
            }
            self.bookingView.availabilityLabel.textColor = Theme.GRAY_WHITE
            self.bookingView.walkIcon.alpha = 1
            self.bookingView.availability.alpha = 1
            self.bookingView.aceButton.alpha = 1
            self.bookingView.costLabel.font = Fonts.SSPSemiBoldH3
            
            switch self.spotType {
            case .Private:
                self.iconButton.tintColor = Theme.BLUE_DARK
                self.iconButton.backgroundColor = Theme.BLUE_MED.withAlphaComponent(0.4)
            case .Public:
                self.iconButton.tintColor = Theme.BLUE_DARK
                self.iconButton.backgroundColor = Theme.BLUE_MED.withAlphaComponent(0.4)
            case .Free:
                self.iconButton.tintColor = Theme.COOL_1_MED
                self.iconButton.backgroundColor = Theme.COOL_1_MED.withAlphaComponent(0.4)
            }
            self.backgroundColor = Theme.BLUE_LIGHT.withAlphaComponent(0.5)
            self.layoutIfNeeded()
        }) { (success) in
            //
        }
    }
    
    func unselectedView() {
        carLeftAnchor.constant = -carWidth
        iconCenterAnchor.constant = 0
        iconLeftAnchor.isActive = true
        iconRightAnchor.isActive = false
        bookingView.subLabelLeftAnchor.constant = -16
        bookingView.availabilityRightAnchor.constant = 38
        UIView.animateOut(withDuration: animationIn, animations: {
            if let lot = self.parkingLot, let duration = lot.walkingDuration {
                self.bookingView.subLabel.text = String(Int(duration)) + " min walk"
            }
            self.bookingView.availabilityLabel.textColor = self.bookingView.businessColor
            self.bookingView.walkIcon.alpha = 0
            self.bookingView.availability.alpha = 0
            self.bookingView.aceButton.alpha = 0
            self.bookingView.costLabel.font = Fonts.SSPRegularH3
            self.iconButton.tintColor = Theme.GRAY_WHITE_3
            self.iconButton.backgroundColor = Theme.STANDARD_GRAY
            self.backgroundColor = Theme.WHITE
            self.layoutIfNeeded()
        }) { (success) in
            //
        }
    }
    
    func setFree() {
        let image = UIImage(named: "coupon_filled")?.withRenderingMode(.alwaysTemplate)
        iconButton.setImage(image, for: .normal)
    }
    
    func setKiosk() {
        let image = UIImage(named: "kiosk_filled")?.withRenderingMode(.alwaysTemplate)
        iconButton.setImage(image, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

