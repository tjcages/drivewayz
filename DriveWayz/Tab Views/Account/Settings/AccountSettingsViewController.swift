//
//  AccountSettingsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/11/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import FacebookLogin

class AccountSettingsViewController: UIViewController {
    
    var delegate: changeSettingsHandler?
    let cellId = "cellId"
    var options: [String] = ["Name", "Email", "Phone"]
    var optionsSub: [String] = ["No name", "No email", "No phone number"]
    var optionsColorsTop: [UIColor] = [Theme.LightPink, Theme.LightBlue, Theme.LightGreen]
    var optionsColorsBottom: [UIColor] = [Theme.DarkPink, Theme.BLUE, Theme.DarkGreen]
    var optionsIcons: [UIImage] = [UIImage(named: "settingsProfile")!, UIImage(named: "settingsEmail")!, UIImage(named: "settingsPhone")!]
    
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
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        view.layer.cornerRadius = 8

        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(optionsTableView)
        optionsTableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        optionsTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        optionsTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        optionsTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }

}


extension AccountSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = optionsTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SettingsCell
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 58, bottom: 0, right: 0)
        tableView.separatorStyle = .singleLine
        if indexPath.row == 2 {
            tableView.separatorStyle = .none
        }
        if options.count > indexPath.row {
            cell.titleLabel.text = options[indexPath.row]
            cell.subtitleLabel.text = optionsSub[indexPath.row]
            cell.iconView.setImage(optionsIcons[indexPath.row], for: .normal)
            
            let background = CAGradientLayer().customVerticalColor(topColor: optionsColorsTop[indexPath.row], bottomColor: optionsColorsBottom[indexPath.row])
            background.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            background.zPosition = -10
            cell.iconView.layer.addSublayer(background)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = optionsTableView.cellForRow(at: indexPath) as! SettingsCell
        if let title = cell.titleLabel.text, let subtitle = cell.subtitleLabel.text {
            self.editSettings(title: title, subtitle: subtitle)
        }
    }
    
    func editSettings(title: String, subtitle: String) {
        if subtitle == "No phone number" || subtitle == "No email" {
            self.delegate?.editSettings(title: title, subtitle: "")
        } else {
            self.delegate?.editSettings(title: title, subtitle: subtitle)
        }
    }
    
}
