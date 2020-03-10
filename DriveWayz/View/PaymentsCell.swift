//
//  PaymentsCell.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/14/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class PaymentsCell: UITableViewCell {
    
    var booking: Bookings? {
        didSet {
//            if let booking = self.booking {
//                self.contextLabel.text = booking.context
//                if let name = booking.userName {
//                    let split = name.split(separator: " ")
//                    if let first = split.first, let last = split.dropFirst().first?.first {
//                        self.titleLabel.text = "\(first) \(last.uppercased())."
//                    }
//                }
//                if let fromTime = booking.fromDate, let toTime = booking.toDate {
//                    let fromDate = Date(timeIntervalSince1970: fromTime)
//                    let toDate = Date(timeIntervalSince1970: toTime)
//                    let formatter = DateFormatter()
//                    formatter.dateFormat = "h:mm a"
//                    let fromString = formatter.string(from: fromDate)
//                    let toString = formatter.string(from: toDate)
//                    self.durationLabel.text = "\(fromString) - \(toString)"
//                }
//                if let hours = booking.hours, let price = booking.price {
//                    let cost = hours * price
//                    self.amountLabel.text = NSString(format: "+$%.2f", cost) as String
//                }
//                if let profileURL = booking.userProfileURL, profileURL != "" {
//                    self.profileImageView.loadImageUsingCacheWithUrlString(profileURL) { (success) in
//                        if success != true {
//                            let image = UIImage(named: "background4")
//                            self.profileImageView.image = image
//                        } else {
//                            let image = resizeImage(image: self.profileImageView.image!, targetSize: CGSize(width: 200, height: 200))
//                            self.profileImageView.image = image
//                        }
//                    }
//                }
//            }
        }
    }
    
    var iconButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLUE
        button.layer.cornerRadius = 45/2
        button.clipsToBounds = true
        button.tintColor = Theme.WHITE
        let image = UIImage(named: "notificationPin")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "Carter parked"
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH5
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_WHITE
        label.text = "2 hours ago"
        
        return label
    }()
    
    var amountLabel: UILabel = {
        let label = UILabel()
        label.text = "+$6.73"
        label.font = Fonts.SSPSemiBoldH3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.textAlignment = .right
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Theme.WHITE
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(iconButton)
        addSubview(mainLabel)
        addSubview(subLabel)
        addSubview(amountLabel)
        
        iconButton.anchor(top: nil, left: leftAnchor, bottom: nil, right:  nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 45, height: 45)
        iconButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        mainLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: iconButton.rightAnchor, constant: 20).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: amountLabel.leftAnchor, constant: -16).isActive = true
        mainLabel.sizeToFit()
        
        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor).isActive = true
        subLabel.leftAnchor.constraint(equalTo: iconButton.rightAnchor, constant: 20).isActive = true
        subLabel.rightAnchor.constraint(equalTo: amountLabel.leftAnchor, constant: -16).isActive = true
        subLabel.sizeToFit()
        
        amountLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        amountLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        amountLabel.sizeToFit()
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: 1))
        view.backgroundColor = Theme.LINE_GRAY
        addSubview(view)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
