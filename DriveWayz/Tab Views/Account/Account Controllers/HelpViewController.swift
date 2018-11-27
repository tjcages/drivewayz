//
//  HelpViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 11/26/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

protocol handleHelpViews {
    func bringBackMain()
}

class HelpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, handleHelpViews {
    
    var delegate: moveControllers?

    var options: [String] = ["Contact Drivewayz", "Review last booking", "Someone is in my spot"]
    var optionsSub: [String] = ["", "", ""]
    var optionsImages: [UIImage] = [UIImage(), UIImage(), UIImage()]
    let cellId = "cellId"
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true
        
        return view
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
        
        return view
    }()
    
    lazy var contactDrivewayzController: ContactDrivewayzViewController = {
        let controller = ContactDrivewayzViewController()
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
    var contactDrivewayzAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        containerHeightAnchor = container.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120)
            containerHeightAnchor.isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 50).isActive = true
        container.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height - 120)
        containerCenterAnchor = scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            containerCenterAnchor.isActive = true
        scrollView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        scrollView.addSubview(optionsTableView)
        optionsTableView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        optionsTableView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        optionsTableView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        optionsHeight = optionsTableView.heightAnchor.constraint(equalToConstant: 60)
            optionsHeight.isActive = true
        
        self.view.addSubview(contactDrivewayzController.view)
        contactDrivewayzController.view.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        contactDrivewayzController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        contactDrivewayzController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        contactDrivewayzAnchor = contactDrivewayzController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width)
            contactDrivewayzAnchor.isActive = true
        
    }
    
    func bringBackMain() {
        UIView.animate(withDuration: animationOut) {
            self.delegate?.changeMainLabel(text: "Help")
            self.delegate?.moveMainLabel(percent: 0)
            self.containerHeightAnchor.constant = 120
            self.containerCenterAnchor.constant = 0
            self.contactDrivewayzAnchor.constant = self.view.frame.width
            self.view.layoutIfNeeded()
        }
    }
    
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
                    self.contactDrivewayzAnchor.constant = 0
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
