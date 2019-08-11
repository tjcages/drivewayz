//
//  ListNotificationsViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/26/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ListNotificationsViewController: UIViewController {
    
    var delegate: handleHostNotifications?
    
    // Total height to be used by containing controller to determine height of tableView
    var height: CGFloat = 0.0 {
        didSet {
            self.delegate?.expandNotificationsHeight(height: self.height)
        }
    }
    
    // This is the size of our header sections that we will use later on.
    let SectionHeaderHeight: CGFloat = 40
    
    // Data variable to track our sorted data
    var data = [TableSection: [HostNotifications]]()
    
    // Helper method to sort our data
    func sortData() {
        data[.today] = notifications.filter({ $0.section == .today })
        data[.yesterday] = notifications.filter({ $0.section == .yesterday })
        data[.week] = notifications.filter({ $0.section == .week })
        data[.month] = notifications.filter({ $0.section == .month })
        data[.earlier] = notifications.filter({ $0.section == .earlier })
    }
    
    // Notification variable to hold all data and string to specify section
    var notifications: [HostNotifications] = [] {
        didSet {
            self.notifications = self.notifications.sorted { $0.timestamp! > $1.timestamp! }
            
            // Reload data each time our observer appends a new Notification value
            self.sortData()
            self.notificationsTable.reloadData()
        }
    }

    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    var notificationsTable: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(NotificationsCell.self, forCellReuseIdentifier: "cellId")
        view.isScrollEnabled = false
        view.clipsToBounds = true
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationsTable.delegate = self
        notificationsTable.dataSource = self
        
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        container.addSubview(notificationsTable)
        notificationsTable.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        notificationsTable.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        notificationsTable.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        notificationsTable.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        
    }
    
}


extension ListNotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.height = CGFloat(70 * self.notifications.count)
        
        // As long as `total` is the last case in our TableSection enum,
        // this method will always be dynamically correct no mater how many table sections we add or remove.
        return TableSection.total.rawValue
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = NotificationsHeader()
        
        // Determine the section title based on our original enum
        if let tableSection = TableSection(rawValue: section) {
            switch tableSection {
            case .today:
                view.titleLabel.text = "TODAY"
            case .yesterday:
                view.titleLabel.text = "YESTERDAY"
            case .week:
                view.titleLabel.text = "THIS WEEK"
            case .month:
                view.titleLabel.text = "THIS MONTH"
            case .earlier:
                view.titleLabel.text = "EARLIER"
            default:
                view.titleLabel.text = ""
            }
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // First check if there is a valid section of table
        // Then we check that for the section there is more than 1 row
        if let tableSection = TableSection(rawValue: section), let notificationData = data[tableSection], notificationData.count > 0 {
            self.height = self.height + 40.0
            
            return SectionHeaderHeight
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Using Swift's optional lookup we first check if there is a valid section of table
        // Then we check that for the section there is data that goes with
        if let tableSection = TableSection(rawValue: section), let notificationData = data[tableSection] {
            
            return notificationData.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = notificationsTable.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! NotificationsCell
        cell.separatorInset = UIEdgeInsets(top: 0, left: phoneWidth, bottom: 0, right: 0)
        cell.selectionStyle = .none
        
        // First check if there is a valid section of table
        // Then we check that for the section there is a row
        if let tableSection = TableSection(rawValue: indexPath.section), let notification = data[tableSection]?[indexPath.row] {
            cell.notification = notification
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // First check if there is a valid section of table
        // Then we check that for the section there is a row
        if let tableSection = TableSection(rawValue: indexPath.section), let notification = data[tableSection]?[indexPath.row] {
            self.delegate?.notificationInformation(notification: notification)
        }
    }
    
}


class NotificationsCell: UITableViewCell {
    
    var notification: HostNotifications? {
        didSet {
            if let notification = self.notification, let title = notification.title, let subTitle = notification.subtitle, let timeString = notification.date, let image = notification.notificationImage, let colors = notification.containerGradient {
                self.titleLabel.text = title
                self.subTitleLabel.text = subTitle
                self.dateLabel.setTitle("\(timeString)", for: .normal)
                let width = timeString.width(withConstrainedHeight: 20, font: Fonts.SSPRegularH6) + 16
                self.dateWidthAnchor.constant = width
                self.layoutIfNeeded()
                if let mainColors = colors.first {
                    let topColor = mainColors.key
                    let bottomColor = mainColors.value
                    self.gradientView.layer.removeFromSuperlayer()
                    let background = CAGradientLayer().customColor(topColor: topColor, bottomColor: bottomColor)
                    background.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
                    background.zPosition = -10
                    self.gradientView.layer.addSublayer(background)
                    let resize = resizeImage(image: image, targetSize: CGSize(width: 120, height: 120))
                    self.profileImageView.image = resize
                }
            }
        }
    }
    
    var gradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 45/2
        view.clipsToBounds = true
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var profileImageView: UIImageView = {
        let button = UIImageView()
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.layer.cornerRadius = 45/2
        button.clipsToBounds = true
        button.contentMode = .scaleAspectFit
        
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
        view.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var dateLabel: UIButton = {
        let view = UIButton()
        view.titleLabel?.font = Fonts.SSPRegularH6
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(Theme.WHITE, for: .normal)
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        
        return view
    }()
    
    var dateWidthAnchor: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = Theme.WHITE
        
        addSubview(gradientView)
        addSubview(profileImageView)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(dateLabel)
        
        gradientView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        gradientView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        gradientView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        gradientView.widthAnchor.constraint(equalTo: gradientView.heightAnchor).isActive = true
        
        profileImageView.topAnchor.constraint(equalTo: gradientView.topAnchor).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: gradientView.leftAnchor).isActive = true
        profileImageView.rightAnchor.constraint(equalTo: gradientView.rightAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor).isActive = true
        
        titleLabel.bottomAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 0).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 16).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -72).isActive = true
        titleLabel.sizeToFit()
        
        subTitleLabel.topAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 0).isActive = true
        subTitleLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 16).isActive = true
        subTitleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -72).isActive = true
        subTitleLabel.sizeToFit()
        
        dateLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        dateWidthAnchor = dateLabel.widthAnchor.constraint(equalToConstant: 40)
            dateWidthAnchor.isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}



class NotificationsHeader: UIView {
    
    var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "TODAY"
        view.font = Fonts.SSPRegularH5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var moreButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "openDots")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.contentMode = .scaleAspectFit
        button.tintColor = Theme.DARK_GRAY
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var topLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LIGHT_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    override func draw(_ rect: CGRect) {
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(topLine)
        topLine.bottomAnchor.constraint(equalTo: self.topAnchor).isActive = true
        topLine.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        topLine.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        topLine.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
        
        addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        titleLabel.sizeToFit()
        
        addSubview(moreButton)
        moreButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        moreButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        moreButton.heightAnchor.constraint(equalToConstant: 6).isActive = true
        moreButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
    }
    
}

