//
//  HelpOptionsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/11/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class HelpOptionsViewController: UIViewController {

    let cellId = "cellId"
    var options: [String] = ["Contact Drivewayz", "Review last booking", "Someone is in my spot"]
    var optionsSub: [String] = ["", "", ""]
    var optionsColorsTop: [UIColor] = [Theme.LightPurple, Theme.LightGreen, Theme.LightRed]
    var optionsColorsBottom: [UIColor] = [Theme.DarkPurple, Theme.DarkGreen, Theme.DarkRed]
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        
        view.backgroundColor = Theme.OFF_WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        view.layer.cornerRadius = 4
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(optionsTableView)
        optionsTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12).isActive = true
        optionsTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        optionsTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        optionsTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -12).isActive = true
        
    }
    
}


extension HelpOptionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = optionsTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SettingsCell
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 58, bottom: 0, right: 0)
        tableView.separatorStyle = .singleLine
        if indexPath.row >= 2 {
            tableView.separatorStyle = .none
        }
        if options.count > indexPath.row {
            cell.titleLabel.text = options[indexPath.row]
            cell.subtitleLabel.text = optionsSub[indexPath.row]
            if cell.titleLabel.text == "Contact Drivewayz" {
                let image = UIImage(named: "DrivewayzTopIcon")
                cell.iconView.setImage(image, for: .normal)
                cell.iconView.imageEdgeInsets = UIEdgeInsets(top: 10, left: 8, bottom: 6, right: 8)
            } else if cell.titleLabel.text == "Review last booking" {
                let image = UIImage(named: "settingsHome")
                cell.iconView.setImage(image, for: .normal)
                cell.iconView.imageEdgeInsets = UIEdgeInsets(top: -2, left: -2, bottom: -2, right: -2)
            } else if cell.titleLabel.text == "Someone is in my spot" {
                let image = UIImage(named: "settingsVehicle")
                cell.iconView.setImage(image, for: .normal)
                cell.iconView.imageEdgeInsets = UIEdgeInsets.zero
            }
            
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
            if cell.titleLabel.text == "Contact Drivewayz" {
                cell.titleLabel.alpha = 1
                cell.nextButton.alpha = 1
                cell.iconView.alpha = 1
            } else {
                cell.titleLabel.alpha = 0.4
                cell.nextButton.alpha = 0
                cell.iconView.alpha = 0.4
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = optionsTableView.cellForRow(at: indexPath) as! SettingsCell
        if let title = cell.titleLabel.text {
            if title == "Contact Drivewayz" {
//                self.delegate?.moveToContact()
            }
        }
    }
    
}
