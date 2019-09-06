//
//  OtherSettingsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/11/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class OtherSettingsViewController: UIViewController {

    var delegate: changeSettingsHandler?
    let cellId = "cellId"
    var options: [String] = ["Payment", "Vehicle", "Notifications", "Accessibility", "About Us", "Logout"]
    var optionsSub: [String] = ["No payment methods", "No vehicles", "Update your preferences", "Wheelchair Access", "Policies & Agreements", ""]
    var optionsColorsTop: [UIColor] = [Theme.LightRed, Theme.LightPurple, Theme.LightTeal, Theme.LightYellow, Theme.LightBlue, Theme.HARMONY_RED.lighter()!]
    var optionsColorsBottom: [UIColor] = [Theme.DarkRed, Theme.DarkPurple, Theme.DarkTeal, Theme.DarkYellow, Theme.DarkBlue, Theme.HARMONY_RED]
    var optionsIcons: [UIImage] = [UIImage(named: "settingsCard")!.withRenderingMode(.alwaysTemplate),
                                   UIImage(named: "settingsVehicle")!.withRenderingMode(.alwaysTemplate),
                                   UIImage(named: "settingsNotifications")!.withRenderingMode(.alwaysTemplate),
                                   UIImage(named: "settingsAccessibility")!.withRenderingMode(.alwaysTemplate),
                                   UIImage(named: "settingsAbout")!.withRenderingMode(.alwaysTemplate),
                                   UIImage(named: "settingsLogout")!.withRenderingMode(.alwaysTemplate)]
    
    var optionsTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(SettingsCell.self, forCellReuseIdentifier: "cellId")
        view.isScrollEnabled = false
        
        return view
    }()
    
    func observePaymentMethod() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(userId).child("selectedPayment")
        ref.observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                let paymentMethod = PaymentMethod(dictionary: dictionary)
                if let brand = paymentMethod.brand, let cardNumber = paymentMethod.last4 {
                    self.optionsSub[0] = brand.uppercased() + " •••• \(cardNumber)"
                    self.optionsTableView.reloadData()
                }
            }
        }
        ref.observe(.childRemoved) { (snapshot) in
            self.optionsSub[0] = "No payment methods"
            self.optionsTableView.reloadData()
            ref.observe(.childAdded, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    let paymentMethod = PaymentMethod(dictionary: dictionary)
                    if let brand = paymentMethod.brand, let cardNumber = paymentMethod.last4 {
                        self.optionsSub[0] = brand.uppercased() + " •••• \(cardNumber)"
                        self.optionsTableView.reloadData()
                    }
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        
        view.backgroundColor = Theme.WHITE
        
        setupViews()
        observePaymentMethod()
    }
    
    func setupViews() {
        
        self.view.addSubview(optionsTableView)
        optionsTableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        optionsTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        optionsTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        optionsTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
}


extension OtherSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = optionsTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SettingsCell
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.separatorStyle = .singleLine
        if options.count > indexPath.row && optionsSub.count > indexPath.row {
            cell.titleLabel.text = options[indexPath.row]
            cell.subtitleLabel.text = optionsSub[indexPath.row]
            cell.iconView.setImage(optionsIcons[indexPath.row], for: .normal)
            
            if optionsSub[indexPath.row] == "" {
                cell.titleLabelTopAnchor.isActive = false
                cell.titleLabelCenterAnchor.isActive = true
            } else {
                cell.titleLabelTopAnchor.isActive = true
                cell.titleLabelCenterAnchor.isActive = false
            }
            
            let index = indexPath.row
            if index == 2 {
                cell.titleLabel.alpha = 0.4
                cell.subtitleLabel.alpha = 0.4
                cell.iconView.alpha = 0.4
            } else if index == 3 {
                cell.titleLabel.alpha = 0.4
                cell.subtitleLabel.alpha = 0.4
                cell.iconView.alpha = 0.4
            } else {
                cell.titleLabel.alpha = 1
                cell.subtitleLabel.alpha = 1
                cell.iconView.alpha = 1
            }
        }
        if cell.titleLabel.text == "Vehicle" || cell.titleLabel.text == "Notifications" || cell.titleLabel.text == "Accessibility" || cell.titleLabel.text == "Logout" || cell.titleLabel.text == "" {
            cell.nextButton.alpha = 0
        } else {
            cell.nextButton.alpha = 1
        }
        if options[indexPath.row] == "" {
            cell.nextButton.alpha = 0
            cell.backgroundColor = Theme.OFF_WHITE
        }
        if cell.titleLabel.text == "Logout" {
            cell.titleLabel.textColor = Theme.HARMONY_RED
            cell.nextButton.alpha = 0
            cell.defaultButton.alpha = 0
        } else if cell.titleLabel.text == "Payment" && cell.subtitleLabel.text != "No payment methods" {
            cell.defaultButton.alpha = 1
        } else {
            cell.defaultButton.alpha = 0
            cell.titleLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = optionsTableView.cellForRow(at: indexPath) as! SettingsCell
        if let title = cell.titleLabel.text {
            if title == "About Us" {
                self.delegate?.moveToAbout()
            } else if title == "Logout" {
                self.delegate?.handleLogout()
            } else if title == "Payment" {
                self.delegate?.handlePaymentPressed()
            }
        }
    }

    
}
