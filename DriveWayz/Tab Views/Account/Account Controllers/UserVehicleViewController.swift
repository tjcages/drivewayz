//
//  UserVehicleViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 11/28/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

protocol handleChangeVehicle {
    func bringBackMain()
}

class UserVehicleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, handleChangeVehicle {
    
    var delegate: moveControllers?
    var statusBarColor = false
    
    var options: [String] = []
    var optionsSub: [String] = []
    var optionsKey: [String] = []
    var selectedKey: String = ""
    var optionsImages: [UIImage] = [UIImage(), UIImage(), UIImage(), UIImage()]
    let cellId = "cellId"
    
    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Your vehicles"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH1
        
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "exit")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()

    var optionsTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(VehicleCell.self, forCellReuseIdentifier: "cellId")
        view.isScrollEnabled = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        view.clipsToBounds = false
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    var vehicleGraphic: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        let image = UIImage(named: "gatedGraphic")
        view.image = image
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.clipsToBounds = true
        view.backgroundColor = Theme.WHITE
        
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        scrollView.delegate = self
        
        setupViews()
        observeVehicles()
    }
    
    var gradientHeightAnchor: NSLayoutConstraint!
    var optionsHeight: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(vehicleGraphic)
        vehicleGraphic.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 60).isActive = true
        vehicleGraphic.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -60).isActive = true
        vehicleGraphic.sizeToFit()
        switch device {
        case .iphone8:
            vehicleGraphic.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -32).isActive = true
        case .iphoneX:
            vehicleGraphic.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -72).isActive = true
        }
        
        self.view.addSubview(scrollView)
        self.view.addSubview(gradientContainer)
        gradientContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        switch device {
        case .iphone8:
            gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: 140)
            gradientHeightAnchor.isActive = true
        case .iphoneX:
            gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: 160)
            gradientHeightAnchor.isActive = true
        }
        
        scrollView.contentSize = CGSize(width: phoneWidth, height: 800)
        scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
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
        
        scrollView.addSubview(optionsTableView)
        optionsTableView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16).isActive = true
        optionsTableView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -24).isActive = true
        optionsTableView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        optionsHeight = optionsTableView.heightAnchor.constraint(equalToConstant: 140)
            optionsHeight.isActive = true
        
    }
    
    @objc func backButtonPressed() {
        self.delegate?.dismissActiveController()
        self.dismiss(animated: true) {
            self.backButton.alpha = 0
        }
    }
    
    @objc func bringBackMain() {
        self.checkSelectedVehicle()
        self.scrollExpanded()
        self.view.endEditing(true)
        UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
            self.mainLabel.text = ""
            self.backButton.alpha = 0
            self.scrollView.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.mainLabel.text = "Your vehicles"
            }, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.optionsHeight.constant = CGFloat(80 * self.options.count + 59)
        return self.options.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == self.options.count {
            return 60
        } else {
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = optionsTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! VehicleCell
        cell.separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        cell.selectionStyle = .none
        if indexPath.row == options.count {
            cell.titleTopAnchor.isActive = false
            cell.titleCenterAnchor.isActive = true
            cell.titleLabel.textColor = Theme.BLUE
            cell.plusButton.alpha = 1
            cell.checkmark.alpha = 0
            cell.titleLabel.text = "Add a vehicle"
            cell.subtitleLabel.text = ""
        } else {
            cell.titleLabel.text = options[indexPath.row]
            cell.titleTopAnchor.isActive = true
            cell.titleCenterAnchor.isActive = false
            cell.subtitleLabel.text = optionsSub[indexPath.row]
            cell.titleLabel.textColor = Theme.BLACK
            cell.plusButton.alpha = 0
            if optionsKey[indexPath.row] == selectedKey {
                cell.checkmark.alpha = 1
            } else {
                cell.checkmark.alpha = 0
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = optionsTableView.cellForRow(at: indexPath) as! VehicleCell
        cell.titleLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = optionsTableView.cellForRow(at: indexPath) as! VehicleCell
        if cell.titleLabel.text == "Add a vehicle" {
            cell.titleLabel.textColor = Theme.BLUE
        } else {
            cell.titleLabel.textColor = Theme.BLACK
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = optionsTableView.cellForRow(at: indexPath) as! VehicleCell
        if let title = cell.titleLabel.text, let subtitle = cell.subtitleLabel.text {
            let controller = CurrentVehicleViewController()
            controller.gradientHeight = self.gradientHeightAnchor.constant
            controller.mainLabel.transform = self.mainLabel.transform
            if title != "" && subtitle != "" {
                let key = self.optionsKey[indexPath.row]
                controller.setData(type: title, license: subtitle, key: key)
                controller.setupCurrentVehicle()
                UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                    controller.mainLabel.text = "Your vehicles"
                }, completion: nil)
            } else {
                controller.setupNewVehicle()
                UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                    controller.mainLabel.text = "New vehicle"
                }, completion: { (success) in
                    controller.vehicleMakeLabel.becomeFirstResponder()
                })
            }
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func observeVehicles() {
        self.options = []
        self.optionsSub = []
        self.optionsKey = []
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(userID)
        ref.child("Vehicles").observe(.childAdded) { (snapshot) in
            if let key = snapshot.value as? String {
                ref.observeSingleEvent(of: .value) { (snapshot) in
                    if let dictionary = snapshot.value as? [String:Any] {
                        if let vehicleKey = dictionary["selectedVehicle"] as? String {
                            self.selectedKey = vehicleKey
                            self.optionsTableView.reloadData()
                        }
                    }
                }
                let vehicleRef = Database.database().reference().child("UserVehicles").child(key)
                vehicleRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String: Any] {
                        if let vehicleMake = dictionary["vehicleMake"] as? String, let vehicleModel = dictionary["vehicleModel"] as? String, let vehicleYear = dictionary["vehicleYear"] as? String, let vehicleLicensePlate = dictionary["licensePlate"] as? String {
                            let text = vehicleYear + " " + vehicleMake + " " + vehicleModel
                            self.options.append(text)
                            self.optionsSub.append(vehicleLicensePlate)
                            self.optionsKey.append(snapshot.key)
                            self.options.reverse()
                            self.optionsSub.reverse()
                            self.optionsKey.reverse()
                            self.optionsTableView.reloadData()
                        }
                    }
                })
            }
        }
        ref.child("Vehicles").observe(.childRemoved) { (snapshot) in
            if let key = snapshot.value as? String {
                if let index = self.optionsKey.firstIndex(of: key) {
                    self.options.remove(at: index)
                    self.optionsSub.remove(at: index)
                    self.optionsKey.remove(at: index)
                    self.optionsTableView.reloadData()
                    
                    if self.optionsKey.count > 0 {
                        let selectedKey = self.optionsKey[0]
                        ref.updateChildValues(["selectedVehicle": selectedKey])
                    }
                }
            }
        }
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:Any] {
                if let vehicleKey = dictionary["selectedVehicle"] as? String {
                    self.selectedKey = vehicleKey
                    self.optionsTableView.reloadData()
                }
            }
        }
    }
    
    func checkSelectedVehicle() {
        if let userID = Auth.auth().currentUser?.uid {
            let userRef = Database.database().reference().child("users").child(userID)
            userRef.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String:Any] {
                    if let vehicleKey = dictionary["selectedVehicle"] as? String {
                        self.selectedKey = vehicleKey
                        self.optionsTableView.reloadData()
                    }
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}


extension UserVehicleViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        let state = scrollView.panGestureRecognizer.state
        var totalHeight: CGFloat = 0.0
        switch device {
        case .iphone8:
            totalHeight = 140
        case .iphoneX:
            totalHeight = 160
        }
        if state == .changed {
            if translation > 0 && translation < 60 {
                let percent = translation/60
                self.gradientHeightAnchor.constant = totalHeight - percent * 60
                self.mainLabel.transform = CGAffineTransform(scaleX: 1 - 0.2 * percent, y: 1 - 0.2 * percent)
            }
        } else {
            let translation = scrollView.contentOffset.y
            if translation < 0 && self.gradientHeightAnchor.constant != totalHeight {
                self.scrollExpanded()
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.contentOffset.y
        if translation >= 55 {
            self.scrollMinimized()
        } else {
            self.scrollExpanded()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        if translation >= 55 {
            self.scrollMinimized()
        } else {
            self.scrollExpanded()
        }
    }
    
    func scrollExpanded() {
        switch device {
        case .iphone8:
            self.gradientHeightAnchor.constant = 140
        case .iphoneX:
            self.gradientHeightAnchor.constant = 160
        }
        UIView.animate(withDuration: animationOut, animations: {
            self.mainLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func scrollMinimized() {
        switch device {
        case .iphone8:
            self.gradientHeightAnchor.constant = 80
        case .iphoneX:
            self.gradientHeightAnchor.constant = 100
        }
        UIView.animate(withDuration: animationOut, animations: {
            self.mainLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
