//
//  MyNotificationsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 4/2/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class MyNotificationsViewController: UIViewController {
    
    var delegate: handleHostNotifications?
    var showMoreBool: Bool = true
    var notifications: [HostNotifications] = []
    
    var container: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    var notificationsTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        view.separatorColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        view.register(NotificationsView.self, forCellReuseIdentifier: "cellId")
        view.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        view.contentOffset = CGPoint.zero
        view.decelerationRate = .fast
        view.showsVerticalScrollIndicator = false
        view.clipsToBounds = false
        view.isScrollEnabled = false
        
        return view
    }()
    
    func setData(parking: ParkingSpots) {
        self.notifications = []
        if let parkingID = parking.parkingID {
            let ref = Database.database().reference().child("ParkingSpots").child(parkingID).child("Notifications")
            ref.observe(.childAdded) { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    let notification = HostNotifications(dictionary: dictionary)
                    self.notifications.append(notification)
                    self.notificationsTableView.reloadData()
                    self.delegate?.resetNotificationHeight()
                }
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationsTableView.delegate = self
        notificationsTableView.dataSource = self

        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0
        view.layer.cornerRadius = 4
        
        setupViews()
    }
    
    var notificationHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        container.addSubview(notificationsTableView)
        notificationsTableView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 12).isActive = true
        notificationsTableView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        notificationsTableView.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        notificationHeightAnchor = notificationsTableView.heightAnchor.constraint(equalToConstant: 70)
            notificationHeightAnchor.isActive = true
        
    }

}


extension MyNotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showMoreBool && self.notifications.count > 3 {
            self.notificationHeightAnchor.constant = CGFloat(self.notifications.count * 70 + 74)
            self.view.layoutIfNeeded()
            return self.notifications.count + 1
        } else {
            self.notificationHeightAnchor.constant = CGFloat(self.notifications.count * 70 + 24)
            self.view.layoutIfNeeded()
            return self.notifications.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row != 3 {
            return 70
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = notificationsTableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! NotificationsView
        cell.selectionStyle = .none
        tableView.separatorStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if indexPath.row < self.notifications.count {
            if indexPath.row == 3 && showMoreBool {
                cell.titleLabel.alpha = 0
                cell.subTitleLabel.alpha = 0
                cell.dateLabel.alpha = 0
                cell.profileImageView.alpha = 0
                cell.showMoreLabel.alpha = 1
            } else {
                cell.titleLabel.alpha = 1
                cell.subTitleLabel.alpha = 1
                cell.dateLabel.alpha = 1
                cell.profileImageView.alpha = 1
                cell.showMoreLabel.alpha = 0
                cell.titleLabel.text = self.notifications[indexPath.row].title
                cell.subTitleLabel.text = self.notifications[indexPath.row].subtitle
                cell.dateLabel.text = self.notifications[indexPath.row].date
                cell.profileImageView.image = self.notifications[indexPath.row].notificationImage
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 && showMoreBool {
            self.delegate?.bringNofiticationsController()
        }
    }
    
}


class NotificationsView: UITableViewCell {
    
    var profileImageView: UIImageView = {
        let button = UIImageView()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.contentMode = .scaleAspectFill
        button.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        
        return button
    }()
    
    var titleLabel: UILabel = {
        let view = UILabel()
        view.text = ""
        view.font = Fonts.SSPSemiBoldH5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLACK
        
        return view
    }()
    
    var subTitleLabel: UILabel = {
        let view = UILabel()
        view.text = ""
        view.font = Fonts.SSPRegularH6
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        
        return view
    }()
    
    var dateLabel: UILabel = {
        let view = UILabel()
        view.text = ""
        view.font = Fonts.SSPRegularH6
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        view.textAlignment = .right
        
        return view
    }()
    
    var showMoreLabel: UILabel = {
        let view = UILabel()
        view.text = "Show more"
        view.font = Fonts.SSPRegularH5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        view.textAlignment = .center
        view.alpha = 0
        
        return view
    }()
    
    var selectionLeftAnchor: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = Theme.WHITE
        
        addSubview(profileImageView)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(dateLabel)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 2).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -48).isActive = true
        
        subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -8).isActive = true
        subTitleLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        subTitleLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        subTitleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -48).isActive = true
        
        dateLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 6).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        addSubview(showMoreLabel)
        showMoreLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        showMoreLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        showMoreLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        showMoreLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

