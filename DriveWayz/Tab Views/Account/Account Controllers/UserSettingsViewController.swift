//
//  SettingsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 11/26/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class UserSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, handleHelpViews {
    
    var delegate: moveControllers?
    
    var options: [String] = ["Email", "Phone", "Payment", "Vehicle", "", "Notifications", "Accessibility", "Terms", "", "Logout"]
    var optionsSub: [String] = ["tyler.cagle@colorado.edu", "+1 (303) 564-4120", "Visa 4424", "000-XXX", "", "Update your preferences", "Wheelchair access", "", "", ""]
    var optionsImages: [UIImage] = [UIImage(named: "email")!, UIImage(named: "phone")!, UIImage(named: "credit_card")!, UIImage(named: "car")!, UIImage(), UIImage(named: "bell_notification")!,UIImage(named: "tool")!, UIImage(), UIImage(), UIImage()]
    let cellId = "cellId"
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true
        
        return view
    }()
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "background2")
        imageView.image = image
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.white
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.layer.borderColor = Theme.PURPLE.cgColor
        imageView.layer.borderWidth = 0.5
        
        return imageView
    }()
    
    var profileName: UILabel = {
        let profileName = UILabel()
        profileName.translatesAutoresizingMaskIntoConstraints = false
        profileName.textColor = Theme.BLACK
        profileName.font = Fonts.SSPRegularH3
        profileName.text = "Name"
        
        return profileName
    }()
    
    var editImage: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit photo", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.6), for: .normal)
        button.titleLabel?.font = Fonts.SSPLightH5
        
        return button
    }()
    
    var profileLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        
        return view
    }()
    
    var optionsTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(SettingsCell.self, forCellReuseIdentifier: "cellId")
        view.isScrollEnabled = false
        
        return view
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        
        return view
    }()
    
    lazy var emailController: UserEmailViewController = {
        let controller = UserEmailViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        scrollView.delegate = self
        
        setupViews()
    }
    
    var containerHeightAnchor: NSLayoutConstraint!
    var containerCenterAnchor: NSLayoutConstraint!
    var optionsHeight: NSLayoutConstraint!
    var emailAnchor: NSLayoutConstraint!

    func setupViews() {
        
        self.view.addSubview(container)
        container.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        containerHeightAnchor = container.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120)
            containerHeightAnchor.isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 50).isActive = true
        container.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 700)
        containerCenterAnchor = scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            containerCenterAnchor.isActive = true
        scrollView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        scrollView.addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 24).isActive = true
        profileImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
        
        scrollView.addSubview(profileName)
        profileName.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        profileName.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 2).isActive = true
        profileName.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        profileName.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(editImage)
        editImage.leftAnchor.constraint(equalTo: profileName.leftAnchor).isActive = true
        editImage.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -2).isActive = true
        editImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        if let width = editImage.titleLabel?.text?.width(withConstrainedHeight: 40, font: (editImage.titleLabel?.font)!) {
            editImage.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        scrollView.addSubview(profileLine)
        profileLine.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 24).isActive = true
        profileLine.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        profileLine.topAnchor.constraint(equalTo: editImage.bottomAnchor, constant: 20).isActive = true
        profileLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(optionsTableView)
        optionsTableView.topAnchor.constraint(equalTo: profileLine.bottomAnchor).isActive = true
        optionsTableView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        optionsTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        optionsHeight = optionsTableView.heightAnchor.constraint(equalToConstant: 60)
            optionsHeight.isActive = true
        
        self.view.addSubview(emailController.view)
        emailController.view.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        emailController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        emailController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        emailAnchor = emailController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width)
            emailAnchor.isActive = true
        
    }
    
    func bringBackMain() {
        UIView.animate(withDuration: animationOut) {
            self.delegate?.changeMainLabel(text: "Settings")
            self.delegate?.moveMainLabel(percent: 0)
            self.containerHeightAnchor.constant = 120
            self.containerCenterAnchor.constant = 0
            self.emailAnchor.constant = self.view.frame.width
            self.view.layoutIfNeeded()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.optionsHeight.constant = CGFloat(60 * self.options.count - 60)
        return self.options.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if options[indexPath.row] == "" {
            return 30
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = optionsTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SettingsCell
        cell.titleLabel.text = options[indexPath.row]
        if options[indexPath.row] == "" {
            cell.nextButton.alpha = 0
            cell.backgroundColor = Theme.OFF_WHITE
        }
        if optionsSub[indexPath.row] == "" {
            cell.titleTopAnchor.isActive = false
            cell.titleCenterAnchor.isActive = true
            cell.titleLeftAnchor.constant = -20
        } else {
            cell.titleTopAnchor.isActive = true
            cell.titleCenterAnchor.isActive = false
            cell.titleLeftAnchor.constant = 30
        }
        cell.subtitleLabel.text = optionsSub[indexPath.row]
        cell.iconView.setImage(optionsImages[indexPath.row], for: .normal)
        cell.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = optionsTableView.cellForRow(at: indexPath) as! SettingsCell
        cell.titleLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = optionsTableView.cellForRow(at: indexPath) as! SettingsCell
        cell.titleLabel.textColor = Theme.BLACK
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = optionsTableView.cellForRow(at: indexPath) as! SettingsCell
        if let title = cell.titleLabel.text {
            if title != "" {
                UIView.animate(withDuration: animationIn) {
                    self.delegate?.changeMainLabel(text: title)
                    self.delegate?.moveMainLabel(percent: 1)
                    self.containerHeightAnchor.constant = 70
                    self.containerCenterAnchor.constant = -self.view.frame.width/2
                    self.emailAnchor.constant = 0
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        if translation <= 50 && translation >= 10 {
            let percent = (translation-10)/40
            self.containerHeightAnchor.constant = 120 - (percent * 50)
            self.delegate?.moveMainLabel(percent: percent)
        } else if translation < 10 {
            self.containerHeightAnchor.constant = 120
            self.delegate?.moveMainLabel(percent: 0)
        } else {
            self.delegate?.moveMainLabel(percent: 1)
            self.containerHeightAnchor.constant = 70
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.contentOffset.y
        if translation < 30 {
            UIView.animate(withDuration: 0.2) {
                scrollView.contentOffset.y = 0
            }
        } else if translation >= 30 && translation <= 50 {
            UIView.animate(withDuration: 0.2) {
                scrollView.contentOffset.y = 50
            }
        }
    }

}
