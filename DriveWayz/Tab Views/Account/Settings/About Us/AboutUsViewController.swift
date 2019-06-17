//
//  AboutUsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/11/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    var delegate: changeSettingsHandler?
    let cellId = "cellId"
    var options: [String] = ["Terms & Conditions", "Privacy Policy"]
    var optionsSub: [String] = ["", ""]
    var optionsColorsTop: [UIColor] = [Theme.LightOrange, Theme.LightTeal]
    var optionsColorsBottom: [UIColor] = [Theme.DarkOrange, Theme.DarkTeal]
    var optionsIcons: [UIImage] = [UIImage(named: "settingsAbout")!, UIImage(named: "settingsAbout")!]
    
    var optionsTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 4
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
        
        view.backgroundColor = Theme.OFF_WHITE
        
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


extension AboutUsViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        cell.separatorInset = UIEdgeInsets(top: 0, left: 58, bottom: 0, right: 0)
        if indexPath.row == 1 {
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
            
            if optionsSub[indexPath.row] == "" {
                cell.titleLabelTopAnchor.isActive = false
                cell.titleLabelCenterAnchor.isActive = true
            } else {
                cell.titleLabelTopAnchor.isActive = true
                cell.titleLabelCenterAnchor.isActive = false
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if options.count > indexPath.row {
            let title = options[indexPath.row]
            if title == "Terms & Conditions" {
                self.delegate?.moveToTerms()
            } else if title == "Privacy Policy" {
                self.delegate?.moveToPrivacy()
            }
        }
    }
    
}
