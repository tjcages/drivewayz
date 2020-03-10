//
//  TransferAllViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/24/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class TransferAllViewController: UIViewController {
    
    // Delegate protocol to handle height of tableView
    var delegate: handleHostTransfers?
    var transferDelegate: handlePaymentTransfers?
    
    // Payouts already transferred to bank
    var totalPayouts: Double = 0.0 {
        didSet {
            self.delegate?.changePaymentAmount(total: self.totalPayouts, transit: self.transitPayouts)
        }
    }
    
    // Payouts in transit to the bank
    var transitPayouts: Double = 0.0 {
        didSet {
            self.delegate?.changePaymentAmount(total: self.totalPayouts, transit: self.transitPayouts)
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
    
    // Data variable to track our sorted data
    var data = [TableSection: [Payouts]]()
    
    // Helper method to sort our data
    func sortData() {
        data[.today] = payouts.filter({ $0.section == .today })
        data[.yesterday] = payouts.filter({ $0.section == .yesterday })
        data[.week] = payouts.filter({ $0.section == .week })
        data[.month] = payouts.filter({ $0.section == .month })
        data[.earlier] = payouts.filter({ $0.section == .earlier })
    }

    // Payout variable to hold all data and string to specify section
    var payouts: [Payouts] = [] {
        didSet {
            // Reload data each time our observer appends a new Payout value
            self.sortData()
            self.paymentsTable.reloadData()
            
            // Add payment to either transitPayouts or totalPayouts based on the initiated day
            for payout in self.payouts {
                guard let amount = payout.transferAmount, let section = payout.section else { return }
                if section == .today {
                    self.transitPayouts = self.transitPayouts + amount
                } else if section == .yesterday {
                    self.transitPayouts = self.transitPayouts + amount
                } else if section == .week {
                    self.totalPayouts = self.totalPayouts + amount
                } else if section == .month {
                    self.totalPayouts = self.totalPayouts + amount
                } else if section == .earlier {
                    self.totalPayouts = self.totalPayouts + amount
                } else {
                    self.totalPayouts = self.totalPayouts + amount
                }
            }
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
    
    var paymentsTable: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(TransferCell.self, forCellReuseIdentifier: "cellId")
        view.isScrollEnabled = false
        view.clipsToBounds = true
        
        return view
    }()
    
    // Observe Payouts data
    func observeData() {
        self.payouts = []
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(userID).child("Payouts")
        ref.observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                let payout = Payouts(dictionary: dictionary)
                self.payouts.append(payout)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paymentsTable.delegate = self
        paymentsTable.dataSource = self
        
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        setupViews()
        observeData()
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


extension TransferAllViewController: UITableViewDelegate, UITableViewDataSource, UserHeaderTableViewCellDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.height = CGFloat(70 * self.payouts.count)
        
        // As long as `total` is the last case in our TableSection enum,
        // this method will always be dynamically correct no mater how many table sections we add or remove.
        return TableSection.total.rawValue
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = PaymentsHeader()
        view.delegate = self
        
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
        if let tableSection = TableSection(rawValue: section), let payoutData = data[tableSection], payoutData.count > 0 {
            self.height = self.height + 40.0
            
            return SectionHeaderHeight
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Using Swift's optional lookup we first check if there is a valid section of table
        // Then we check that for the section there is data that goes with
        if let tableSection = TableSection(rawValue: section), let payoutData = data[tableSection] {
            
            return payoutData.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = paymentsTable.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! TransferCell
        cell.separatorInset = UIEdgeInsets(top: 0, left: phoneWidth, bottom: 0, right: 0)
        cell.selectionStyle = .none
        
        // First check if there is a valid section of table
        // Then we check that for the section there is a row
        if let tableSection = TableSection(rawValue: indexPath.section), let payout = data[tableSection]?[indexPath.row] {
            cell.payout = payout
        }
        
        return cell
    }
    
    func didSelectUserHeaderTableViewCell(Selected: Bool, UserHeader: PaymentsHeader) {
        self.transferDelegate?.transferOptions()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // First check if there is a valid section of table
        // Then we check that for the section there is a row
        if let tableSection = TableSection(rawValue: indexPath.section), let payout = data[tableSection]?[indexPath.row] {
            self.transferDelegate?.transferInformation(payout: payout)
        }
    }
    
}


class TransferCell: UITableViewCell {
    
    // Organize TransferCell
    var payout: Payouts? {
        didSet {
            if let timestamp = self.payout?.timestamp, let transferAmount = self.payout?.transferAmount {
                self.amountLabel.text = String(format: "+$%.2f", transferAmount)
                let date = Date(timeIntervalSince1970: timestamp)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy h:mma"
                let dateString = dateFormatter.string(from: date)
                self.durationLabel.text = dateString
                
                if let accountLabel = self.payout?.accountLabel {
                    self.titleLabel.text = "Bank •••• \(accountLabel)"
                }
                
                if let section = self.payout?.section {
                    if section == .today {
                        self.inTransitButton()
                    } else if section == .yesterday {
                        self.inTransitButton()
                    } else if section == .week {
                        self.madePaymentButton()
                    } else if section == .month {
                        self.madePaymentButton()
                    } else if section == .earlier {
                        self.madePaymentButton()
                    } else {
                        self.madePaymentButton()
                    }
                }
            }
        }
    }
    
    func inTransitButton() {
        self.transitButton.alpha = 1
        self.paidButton.alpha = 0
        self.amountLabel.textColor = Theme.GREEN
    }
    
    func madePaymentButton() {
        self.transitButton.alpha = 0
        self.paidButton.alpha = 1
        self.amountLabel.textColor = Theme.BLUE
    }
    
    var paidButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLUE.withAlphaComponent(0.2)
        button.setTitle("Paid", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH6
        button.layer.cornerRadius = 13
        
        return button
    }()
    
    var transitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.GREEN.withAlphaComponent(0.2)
        button.setTitle("Transit", for: .normal)
        button.setTitleColor(Theme.GREEN, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH6
        button.layer.cornerRadius = 13
        button.alpha = 0
        
        return button
    }()
    
    var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "••••"
        view.font = Fonts.SSPRegularH5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLACK
        
        return view
    }()
    
    var durationLabel: UILabel = {
        let view = UILabel()
        view.text = "11/11/2019 6:34PM"
        view.font = Fonts.SSPRegularH6
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLACK.withAlphaComponent(0.2)
        
        return view
    }()
    
    var amountLabel: UILabel = {
        let view = UILabel()
        view.text = "+$20"
        view.font = Fonts.SSPBoldH3
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLUE
        view.textAlignment = .right
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(transitButton)
        addSubview(paidButton)
        addSubview(titleLabel)
        addSubview(durationLabel)
        addSubview(amountLabel)
        
        paidButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        paidButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        paidButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        paidButton.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        transitButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        transitButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        transitButton.widthAnchor.constraint(equalToConstant: 58).isActive = true
        transitButton.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        amountLabel.centerYAnchor.constraint(equalTo: paidButton.centerYAnchor).isActive = true
        amountLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        amountLabel.sizeToFit()
        
        titleLabel.centerYAnchor.constraint(equalTo: paidButton.centerYAnchor, constant: -10).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: paidButton.rightAnchor, constant: 20).isActive = true
        titleLabel.sizeToFit()
        
        durationLabel.centerYAnchor.constraint(equalTo: paidButton.centerYAnchor, constant: 10).isActive = true
        durationLabel.leftAnchor.constraint(equalTo: paidButton.rightAnchor, constant: 20).isActive = true
        durationLabel.sizeToFit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
