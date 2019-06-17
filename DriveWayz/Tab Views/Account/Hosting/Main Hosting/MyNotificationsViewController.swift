//
//  MyNotificationsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 4/2/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

struct HostNotifications {
    var profileImageURL: UIImage?
    var title: String?
    var subtitle: String?
    var date: String?
}

class MyNotificationsViewController: UIViewController {

    var notifications: [HostNotifications] = [HostNotifications(profileImageURL: UIImage(named: "background4"), title: "Graham messaged you", subtitle: "Moving my car now", date: "23 min"), HostNotifications(profileImageURL: UIImage(named: "home-1"), title: "Congratulations!", subtitle: "You got 5 stars from Tyler", date: "1 hr"), HostNotifications(profileImageURL: UIImage(named: "dadAndKid"), title: "Tyler messaged you", subtitle: "Great! I am coming that way.", date: "1 hr")]
    
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
        view.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 110, right: 0)
        view.contentOffset = CGPoint.zero
        view.decelerationRate = .fast
        view.showsVerticalScrollIndicator = false
        view.clipsToBounds = false
        view.isScrollEnabled = false
        view.allowsSelection = false
        
        return view
    }()
    

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
        notificationsTableView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        
    }

}


extension MyNotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifications.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < self.notifications.count {
            return 70
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = notificationsTableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! NotificationsView
        cell.selectionStyle = .default
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if indexPath.row < self.notifications.count {
            cell.titleLabel.alpha = 1
            cell.subTitleLabel.alpha = 1
            cell.dateLabel.alpha = 1
            cell.profileImageView.alpha = 1
            cell.showMoreLabel.alpha = 0
            cell.titleLabel.text = self.notifications[indexPath.row].title
            cell.subTitleLabel.text = self.notifications[indexPath.row].subtitle
            cell.dateLabel.text = self.notifications[indexPath.row].date
            cell.profileImageView.image = self.notifications[indexPath.row].profileImageURL
        } else {
            cell.titleLabel.alpha = 0
            cell.subTitleLabel.alpha = 0
            cell.dateLabel.alpha = 0
            cell.profileImageView.alpha = 0
            cell.showMoreLabel.alpha = 1
        }
        
        return cell
    }
    
}


class NotificationsView: UITableViewCell {
    
    var profileImageView: UIImageView = {
        let button = UIImageView()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.contentMode = .scaleAspectFill
//        button.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        
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
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: -2).isActive = true
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

