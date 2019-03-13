//
//  HostingAllGuestsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/15/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol handleGuestScroll {
    func animateScroll(translation: CGFloat, active: Bool)
}

class HostingAllGuestsViewController: UIViewController {

    var delegate: handleHostingScroll?
    var sections = 6
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.withAlphaComponent(0.6).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 1
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(GuestsTableCell.self, forCellReuseIdentifier: "Cell")
        view.register(GuestsHeaderCell.self, forCellReuseIdentifier: "HeaderCell")
        view.separatorStyle = .none
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 72, right: 0)
        view.decelerationRate = .fast
        
        return view
    }()
    
    lazy var previousView: HostingPreviousViewController = {
        let controller = HostingPreviousViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupViews()
    }

    var tableViewCenterAnchor: NSLayoutConstraint!
    var previousAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        container.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        container.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableViewCenterAnchor = tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        tableViewCenterAnchor.isActive = true
        tableView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true
        
        self.view.addSubview(previousView.view)
        previousView.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        previousAnchor = previousView.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width)
        previousAnchor.isActive = true
        previousView.view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        previousView.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
    }
    
}

extension HostingAllGuestsViewController: UITableViewDelegate, UITableViewDataSource, handleGuestScroll {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else if section == 1 {
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GuestsTableCell
        cell.parkingImage = UIImage(named: "background4")
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.changeMainLabel(text: "")
        UIView.animate(withDuration: animationIn) {
            self.previousAnchor.constant = 0
            self.tableViewCenterAnchor.constant = -self.view.frame.width/2
            self.view.layoutIfNeeded()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
        footerView.backgroundColor = UIColor.clear
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! GuestsHeaderCell
        if section > 0 {
            headerCell.headerLabelAnchor.constant = 0
        } else {
            headerCell.headerLabelAnchor.constant = (headerCell.headerLabel.text?.width(withConstrainedHeight: 40, font: Fonts.SSPSemiBoldH2))! - 16
        }
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section < self.sections - 1 {
            return 40
        } else {
            return 0
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentSize.height > self.view.frame.height {
            let translation = scrollView.contentOffset.y
            self.animateScroll(translation: translation, active: true)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.contentOffset.y
        self.animateScroll(translation: translation, active: false)
    }
    
    func animateScroll(translation: CGFloat, active: Bool) {
        self.delegate?.animateScroll(translation: translation, active: active)
    }
    
}
