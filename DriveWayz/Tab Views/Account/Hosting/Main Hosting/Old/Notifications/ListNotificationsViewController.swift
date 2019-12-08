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
        view.backgroundColor = Theme.WHITE
        
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
        let view = NotificationsDateHeader()
        
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
