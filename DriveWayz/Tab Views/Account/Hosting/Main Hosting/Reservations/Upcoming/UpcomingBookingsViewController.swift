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
    var bookings: [Bookings] = []

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
        return 0
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
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = paymentsTable.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! PaymentsCell
        cell.separatorInset = UIEdgeInsets(top: 0, left: phoneWidth, bottom: 0, right: 0)
        cell.selectionStyle = .none
        
        if indexPath.row == 0 {
            cell.profileImageView.image = UIImage(named: "profile-image-5")
            cell.amountLabel.text = "+$16.79"
            cell.contextLabel.text = "Reservation"
            cell.titleLabel.text = "Taylor M."
        } else if indexPath.row == 1 {
            cell.profileImageView.image = UIImage(named: "profile-image")
            cell.amountLabel.text = "+$12.50"
            cell.durationLabel.text = "10:15AM - 2:30PM"
            cell.titleLabel.text = "Graham B."
        } else if indexPath.row == 2 {
            cell.profileImageView.image = UIImage(named: "profile-image-1")
            cell.amountLabel.text = "+$6.80"
        }
        
        return cell
    }
    
    func didSelectUserHeaderTableViewCell(Selected: Bool, UserHeader: PaymentsHeader) {
        self.delegate?.bookingInformation()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.expandBooking()
    }
    
}
