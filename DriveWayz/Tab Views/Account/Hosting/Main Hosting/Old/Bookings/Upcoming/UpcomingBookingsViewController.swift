//
//  UpcomingBookingsViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/31/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class UpcomingBookingsViewController: UIViewController {
    
    var delegate: changeBookingInformation?
    
    // Data variable to track our sorted data
    var data = [TableSection: [Bookings]]()
    
    var bookings: [Bookings] = [] {
        didSet {
            self.paymentsTable.reloadData()
        }
    }
    
    // Total height to be used by containing controller to determine height of tableView
    var height: CGFloat = 0.0 {
        didSet {
            self.delegate?.expandNotificationsHeight(height: self.height)
        }
    }

    // This is the size of our header sections that we will use later on.
    let SectionHeaderHeight: CGFloat = 40
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    var paymentsTable: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(PaymentsCell.self, forCellReuseIdentifier: "cellId")
        view.isScrollEnabled = false
        view.clipsToBounds = true
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paymentsTable.delegate = self
        paymentsTable.dataSource = self
        
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
        
        container.addSubview(paymentsTable)
        paymentsTable.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        paymentsTable.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        paymentsTable.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        paymentsTable.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        
    }
    
}


extension UpcomingBookingsViewController: UITableViewDelegate, UITableViewDataSource, UserHeaderTableViewCellDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.height = CGFloat(70 * self.bookings.count)
        
        // As long as `total` is the last case in our TableSection enum,
        // this method will always be dynamically correct no mater how many table sections we add or remove.
        return TableSection.total.rawValue
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = PaymentsHeader()
        view.delegate = self
        
        if section == 0 {
            view.titleLabel.text = "TODAY"
        } else if section == 1 {
            view.titleLabel.text = "YESTERDAY"
        } else if section == 2 {
            view.titleLabel.text = "THIS WEEK"
        } else if section == 3 {
            view.titleLabel.text = "THIS MONTH"
        } else {
            view.titleLabel.text = "EARLIER"
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
        let cell = paymentsTable.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! PaymentsCell
        cell.separatorInset = UIEdgeInsets(top: 0, left: phoneWidth, bottom: 0, right: 0)
        cell.selectionStyle = .none
        
        // First check if there is a valid section of table
        // Then we check that for the section there is a row
        if let tableSection = TableSection(rawValue: indexPath.section), let notification = data[tableSection]?[indexPath.row] {
            cell.booking = notification
        }
        
        return cell
    }
    
    func didSelectUserHeaderTableViewCell(Selected: Bool, UserHeader: PaymentsHeader) {
        self.delegate?.bookingInformation()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = paymentsTable.cellForRow(at: indexPath) as! PaymentsCell
        // First check if there is a valid section of table
        // Then we check that for the section there is a row
        if let tableSection = TableSection(rawValue: indexPath.section), let notification = data[tableSection]?[indexPath.row] {
//            self.delegate?.expandBooking(booking: notification, image: cell.profileImageView.image!)
        }
    }
    
}
