//
//  UserCell.swift
//  CollegeFeed
//
//  Created by Tyler Jordan Cagle on 7/24/17.
//  Copyright © 2017 COAppDesign. All rights reserved.
//

import UIKit
import Firebase

class UserCell: UITableViewCell {
    
    var message: Message? {
        didSet {
            setUpNameAndProfileImage()
            detailTextLabel?.text = message?.text
            if let seconds = message?.timestamp?.doubleValue {
                let timestampDate = NSDate(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                timeLabel.text = dateFormatter.string(from: timestampDate as Date)
            }
        }
    }
    
    var parking: ParkingSpots? {
        didSet {
            setUpParkingSpot()
            detailTextLabel?.text = parking?.parkingCost
            if let seconds = parking?.timestamp?.doubleValue {
                let timestampDate = NSDate(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                timeLabel.text = dateFormatter.string(from: timestampDate as Date)
            }
        }
    }
    
    private func setUpNameAndProfileImage() {
        if let ID = message?.chatPartnerID() {
            let ref = Database.database().reference().child("users").child(ID)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    if let profileImageURL = dictionary["picture"] as? String {
                        self.profileImageView.loadImageUsingCacheWithUrlString(profileImageURL)
                    }
                    if let name = dictionary["name"] as? String {
                        var fullNameArr = name.split(separator: " ")
                        let firstName: String = String(fullNameArr[0])
                        if let lastName: String = fullNameArr.count > 1 ? String(fullNameArr[1]) : nil {
                            var lastCharacter = lastName.chunk(n: 1)
                            self.textLabel?.text = "\(firstName) \(lastCharacter[0])."
                        } else {
                            self.textLabel?.text = name
                            if name == " Drivewayz " {
                                self.profileImageView.image = UIImage(named: "background4")
                            }
                        }
                    }
                }
            }, withCancel: nil)
        }
    }
    
    private func setUpParkingSpot() {
        textLabel?.text = parking?.parkingCost
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = Theme.WHITE
        
        if textLabel?.text == " Drivewayz " {
            textLabel?.textColor = Theme.PACIFIC_BLUE
            textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        } else {
            textLabel?.textColor = Theme.BLACK
            textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
        }
        textLabel?.frame = CGRect(x: 74, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width + 10, height: textLabel!.frame.height)
        
        detailTextLabel?.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        detailTextLabel?.font = UIFont.systemFont(ofSize: 16, weight: .light)
        detailTextLabel?.frame = CGRect(x: 74, y: detailTextLabel!.frame.origin.y + 2, width: self.frame.width - 124, height: detailTextLabel!.frame.height)
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(timeLabel)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: textLabel!.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
