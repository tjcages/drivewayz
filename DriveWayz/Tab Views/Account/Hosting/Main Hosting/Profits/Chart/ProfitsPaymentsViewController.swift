//
//  ProfitsPaymentsViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/24/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ProfitsPaymentsViewController: UIViewController {
    
    // Delegate protocol to handle height of tableView
    var delegate: handleHostTransfers?
    var transferDelegate: handlePaymentTransfers?
    
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
            self.delegate?.expandTransferHeight(height: self.height)
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


extension ProfitsPaymentsViewController: UITableViewDelegate, UITableViewDataSource, UserHeaderTableViewCellDelegate {
    
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
//        self.delegate?.bookingInformation()
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


class PaymentsCell: UITableViewCell {
    
    var booking: Bookings? {
        didSet {
            if let booking = self.booking {
                self.contextLabel.text = booking.context
                if let name = booking.userName {
                    let split = name.split(separator: " ")
                    if let first = split.first, let last = split.dropFirst().first?.first {
                        self.titleLabel.text = "\(first) \(last.uppercased())."
                    }
                }
                if let fromTime = booking.fromDate, let toTime = booking.toDate {
                    let fromDate = Date(timeIntervalSince1970: fromTime)
                    let toDate = Date(timeIntervalSince1970: toTime)
                    let formatter = DateFormatter()
                    formatter.dateFormat = "h:mm a"
                    let fromString = formatter.string(from: fromDate)
                    let toString = formatter.string(from: toDate)
                    self.durationLabel.text = "\(fromString) - \(toString)"
                }
                if let hours = booking.hours, let price = booking.price {
                    let cost = hours * price
                    self.amountLabel.text = NSString(format: "+$%.2f", cost) as String
                }
                if let profileURL = booking.userProfileURL, profileURL != "" {
                    self.profileImageView.loadImageUsingCacheWithUrlString(profileURL) { (success) in
                        if success != true {
                            let image = UIImage(named: "background4")
                            self.profileImageView.image = image
                        } else {
                            let image = resizeImage(image: self.profileImageView.image!, targetSize: CGSize(width: 200, height: 200))
                            self.profileImageView.image = image
                        }
                    }
                }
            }
        }
    }
    
    var profileImageView: UIImageView = {
        let button = UIImageView()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.contentMode = .scaleAspectFill
        button.backgroundColor = Theme.LIGHT_GRAY.withAlphaComponent(0.2)
        let image = UIImage(named: "background4")
        button.image = image
        
        return button
    }()
    
    var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "Ryan E."
        view.font = Fonts.SSPRegularH5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.DARK_GRAY
        
        return view
    }()
    
    var durationLabel: UILabel = {
        let view = UILabel()
        view.text = "6:34PM - 8:45PM"
        view.font = Fonts.SSPRegularH6
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var contextLabel: UILabel = {
        let view = UILabel()
        view.text = "Booking"
        view.font = Fonts.SSPRegularH6
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        view.textAlignment = .right
        
        return view
    }()
    
    var amountLabel: UILabel = {
        let view = UILabel()
        view.text = "+$20"
        view.font = Fonts.SSPBoldH3
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.GREEN_PIGMENT
        view.textAlignment = .right
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(titleLabel)
        addSubview(durationLabel)
        addSubview(contextLabel)
        addSubview(amountLabel)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        titleLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: -10).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 16).isActive = true
        titleLabel.sizeToFit()
        
        durationLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 10).isActive = true
        durationLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 16).isActive = true
        durationLabel.sizeToFit()
        
        amountLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        amountLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        amountLabel.sizeToFit()
        
        contextLabel.centerYAnchor.constraint(equalTo: durationLabel.centerYAnchor).isActive = true
        contextLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        contextLabel.sizeToFit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

protocol UserHeaderTableViewCellDelegate {
    func didSelectUserHeaderTableViewCell(Selected: Bool, UserHeader: PaymentsHeader)
}

class PaymentsHeader: UIView {
    
    var delegate: UserHeaderTableViewCellDelegate?
    
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
        button.addTarget(self, action: #selector(selectedHeader), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        
        return button
    }()
    
    var topLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
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
        moreButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -4).isActive = true
        moreButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        moreButton.widthAnchor.constraint(equalToConstant: 56).isActive = true
        
    }
    
    @objc func selectedHeader() {
        delegate?.didSelectUserHeaderTableViewCell(Selected: true, UserHeader: self)
    }
    
}

