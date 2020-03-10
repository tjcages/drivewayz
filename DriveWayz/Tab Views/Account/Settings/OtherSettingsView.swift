//
//  OtherSettingsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/11/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class OtherSettingsView: UIViewController {

    var delegate: changeSettingsHandler?
    let cellId = "cellId"
    var options: [String] = ["Notifications", "Accessibility", "About us", "Logout"]
    var optionsIcons: [UIImage?] = [UIImage(named: "aboutNotifications"), UIImage(named: "aboutAccessibility"), UIImage(named: "aboutUs")]
    
    var optionsTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(SettingsCell.self, forCellReuseIdentifier: "cellId")
        view.isScrollEnabled = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(optionsTableView)
        optionsTableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        optionsTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        optionsTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        optionsTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
}


extension OtherSettingsView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        if section == 0 {
            let label = UILabel()
            label.font = Fonts.SSPRegularH4
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = Theme.GRAY_WHITE
            label.text = "Preferences"
            
            view.addSubview(label)
            label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
            label.sizeToFit()
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SettingsCell
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        if options.count > indexPath.row {
            cell.titleLabel.text = options[indexPath.row]
        }
        if optionsIcons.count > indexPath.row && indexPath.section == 0 {
            cell.setIcon(image: optionsIcons[indexPath.row])
        } else {
            cell.removeIcon()
        }
        
        if indexPath.section == 1 {
            cell.titleLabel.text = options.last
            cell.titleLabel.textColor = Theme.SALMON
        } else {
            if indexPath.row == 2 {
                cell.titleLabel.textColor = Theme.BLACK
            } else {
                cell.titleLabel.textColor = Theme.GRAY_WHITE
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = optionsTableView.cellForRow(at: indexPath) as! SettingsCell
        if let title = cell.titleLabel.text {
            if title == "About us" {
                delegate?.moveToAbout()
            } else if title == "Logout" {
                delegate?.handleLogout()
            }
        }
    }

    
}
