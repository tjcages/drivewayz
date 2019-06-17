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
    var optionsSub: [String] = ["Samantha Wilson", "samantha@gmail.con", "+62 856 099 849"]
    var optionsColorsTop: [UIColor] = [Theme.LightOrange, Theme.LightPink, Theme.LightGreen]
    var optionsColorsBottom: [UIColor] = [Theme.DarkOrange, Theme.DarkPink, Theme.DarkGreen]
    var optionsIcons: [UIImage] = [UIImage(named: "settingsProfile")!, UIImage(named: "settingsEmail")!, UIImage(named: "settingsPhone")!]
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Account"
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
