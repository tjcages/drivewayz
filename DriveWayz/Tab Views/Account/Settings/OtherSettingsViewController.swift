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
    var optionsSub: [String] = ["VISA XXXX", "xxxx 2457", "Update your preferences", "Wheelchair Access", "Policies & Agreements", ""]
    var optionsColorsTop: [UIColor] = [Theme.LightRed, Theme.LightPurple, Theme.LightTeal, Theme.LightYellow, Theme.LightBlue, Theme.HARMONY_RED.lighter()!]
    var optionsColorsBottom: [UIColor] = [Theme.DarkRed, Theme.DarkPurple, Theme.DarkTeal, Theme.DarkYellow, Theme.DarkBlue, Theme.HARMONY_RED]
    var optionsIcons: [UIImage] = [UIImage(named: "settingsCard")!, UIImage(named: "settingsVehicle")!, UIImage(named: "settingsNotifications")!, UIImage(named: "settingsAccessibility")!, UIImage(named: "settingsAbout")!, UIImage(named: "settingsLogout")!]
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Other Settings"
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH2
        
        return label
    }()
    
    var optionsTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(SettingsCell.self, forCellReuseIdentifier: "cellId")
        view.isScrollEnabled = false
//        view.allowsSelection = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.2
        view.layer.cornerRadius = 4
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        mainLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 16).isActive = true
        mainLabel.sizeToFit()
        
        self.view.addSubview(optionsTableView)
        optionsTableView.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 12).isActive = true
        optionsTableView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor).isActive = true
        optionsTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        optionsTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -12).isActive = true
        
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
        cell.separatorInset = UIEdgeInsets(top: 0, left: 58, bottom: 0, right: 0)
        tableView.separatorStyle = .singleLine
        if options.count > indexPath.row && optionsSub.count > indexPath.row {
            cell.titleLabel.text = options[indexPath.row]
            cell.subtitleLabel.text = optionsSub[indexPath.row]
            cell.iconView.setImage(optionsIcons[indexPath.row], for: .normal)
            
            let background = CAGradientLayer().customVerticalColor(topColor: optionsColorsTop[indexPath.row], bottomColor: optionsColorsBottom[indexPath.row])
            background.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            background.zPosition = -10
            cell.iconView.layer.addSublayer(background)
            
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
        if cell.titleLabel.text == "Payment" || cell.titleLabel.text == "Vehicle" || cell.titleLabel.text == "Notifications" || cell.titleLabel.text == "Accessibility" || cell.titleLabel.text == "Logout" || cell.titleLabel.text == "" {
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
        } else if cell.titleLabel.text == "Vehicle" || cell.titleLabel.text == "Terms" || cell.titleLabel.text == "" {
            cell.separatorInset = UIEdgeInsets(top: 0, left: self.view.frame.width, bottom: 0, right: self.view.frame.width)
        } else {
            cell.titleLabel.textColor = Theme.BLACK
        }
        if cell.subtitleLabel.text == "Payment" {
            cell.paymentButton.alpha = 1
            cell.subtitleLabel.text = ""
            cell.paymentButton.setTitle(userInformationNumbers, for: .normal)
            cell.paymentButton.setImage(userInformationImage, for: .normal)
        } else {
            cell.paymentButton.alpha = 0
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
            }
        }
    }

    
}
