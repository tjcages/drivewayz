//
//  HelpViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 11/26/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    
    var delegate: moveControllers?

    var options: [String] = ["Contact Drivewayz", "Review last booking", "Someone is in my spot"]
    var optionsSub: [String] = ["", "", ""]
    var optionsImages: [UIImage] = [UIImage(), UIImage(), UIImage()]
    let cellId = "cellId"
    
    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Help"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPBoldH0
        
        return label
    }()
    
    var optionsTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(SettingsCell.self, forCellReuseIdentifier: "cellId")
        view.isScrollEnabled = false
        view.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        return view
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -1)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.4
        view.decelerationRate = .fast
        
        return view
    }()
    
    lazy var contactDrivewayzController: ContactDrivewayzViewController = {
        let controller = ContactDrivewayzViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        
        return controller
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        button.addTarget(self, action: #selector(backButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = true
        
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        scrollView.delegate = self
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(bringBackMain))
        swipeGesture.direction = .right
        view.addGestureRecognizer(swipeGesture)
        
        setupViews()
    }
    
    var gradientHeightAnchor: NSLayoutConstraint!
    var containerCenterAnchor: NSLayoutConstraint!
    var optionsHeight: NSLayoutConstraint!
    var contactDrivewayzAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(gradientContainer)
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth, height: phoneHeight)
        containerCenterAnchor = scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            containerCenterAnchor.isActive = true
        scrollView.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        gradientContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        switch device {
        case .iphone8:
            gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: 160)
                gradientHeightAnchor.isActive = true
        case .iphoneX:
            gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: 180)
                gradientHeightAnchor.isActive = true
        }
        
        scrollView.addSubview(optionsTableView)
        optionsTableView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        optionsTableView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        optionsTableView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        optionsHeight = optionsTableView.heightAnchor.constraint(equalToConstant: 60)
            optionsHeight.isActive = true
        
        self.view.addSubview(contactDrivewayzController.view)
        self.view.bringSubviewToFront(gradientContainer)
        self.addChild(contactDrivewayzController)
        contactDrivewayzController.view.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contactDrivewayzController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        contactDrivewayzController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        contactDrivewayzAnchor = contactDrivewayzController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width)
            contactDrivewayzAnchor.isActive = true
        
        self.view.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        switch device {
        case .iphone8:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 28).isActive = true
        case .iphoneX:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 48).isActive = true
        }
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: -16).isActive = true
        
    }
    
    @objc func backButtonPressed(sender: UIButton) {
        self.view.endEditing(true)
        self.bringBackMain()
    }
    
    @objc func bringBackMain() {
        self.mainLabel.text = "Help"
        UIView.animate(withDuration: animationOut, animations: {
            self.containerCenterAnchor.constant = 0
            self.contactDrivewayzAnchor.constant = self.view.frame.width
            self.backButton.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.bringExitButton()
        }
    }
    
}

extension HelpViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.optionsHeight.constant = CGFloat(60 * self.options.count)
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
            cell.titleLeftAnchor.constant = -40
        } else {
            cell.titleTopAnchor.isActive = true
            cell.titleCenterAnchor.isActive = false
            cell.titleLeftAnchor.constant = -40
        }
        if cell.titleLabel.text == "Contact Drivewayz" {
            cell.titleLabel.alpha = 1
            cell.nextButton.alpha = 1
        } else {
            cell.titleLabel.alpha = 0.4
            cell.nextButton.alpha = 0
        }
        cell.subtitleLabel.text = optionsSub[indexPath.row]
        cell.iconView.setImage(optionsImages[indexPath.row], for: .normal)
        cell.separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
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
            if title == "Contact Drivewayz" {
                self.mainLabel.text = "Contact Drivewayz"
                UIView.animate(withDuration: animationIn) {
                    self.delegate?.hideExitButton()
                    self.backButton.alpha = 1
                    self.containerCenterAnchor.constant = -self.view.frame.width/2
                    self.contactDrivewayzAnchor.constant = 0
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
}


extension HelpViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var totalHeight: CGFloat = 0.0
        switch device {
        case .iphone8:
            totalHeight = 160
        case .iphoneX:
            totalHeight = 180
        }
        let translation = scrollView.contentOffset.y
        if translation > 0 && translation < 80 {
            let percent = translation/80
            self.gradientHeightAnchor.constant = totalHeight - percent * 80
            self.mainLabel.transform = CGAffineTransform(scaleX: 1 - 0.2 * percent, y: 1 - 0.2 * percent)
        } else if translation >= 80 {
            self.gradientHeightAnchor.constant = totalHeight - 80
            self.mainLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } else if translation <= 0 {
            self.gradientHeightAnchor.constant = totalHeight
            self.mainLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
}
