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
    
    var options: [String] = []
    var optionsSub: [String] = []
    var optionsKey: [String] = []
    var selectedKey: String = ""
    var optionsImages: [UIImage] = [UIImage(), UIImage(), UIImage(), UIImage()]
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
        label.text = "Your Vehicles"
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPBoldH1
        
        return label
    }()
    
    var backgroundCircle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.borderColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.05).cgColor
        view.layer.borderWidth = 80
        view.layer.cornerRadius = 180
        
        return view
    }()
    
    var optionsTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(VehicleCell.self, forCellReuseIdentifier: "cellId")
        view.isScrollEnabled = false
        view.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        
        return view
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.2
        view.layer.cornerRadius = 4
        view.clipsToBounds = false
        
        return view
    }()
    
    lazy var currentVehicleController: CurrentVehicleViewController = {
        let controller = CurrentVehicleViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self

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
        view.backgroundColor = Theme.OFF_WHITE
        view.layer.cornerRadius = 4
        
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        scrollView.delegate = self
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(bringBackMain))
        swipeGesture.direction = .right
        view.addGestureRecognizer(swipeGesture)
        
        setupViews()
        observeVehicles()
    }
    
    var gradientHeightAnchor: NSLayoutConstraint!
    var optionsHeight: NSLayoutConstraint!
    var currentAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(backgroundCircle)
        backgroundCircle.centerXAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        backgroundCircle.centerYAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
        backgroundCircle.widthAnchor.constraint(equalToConstant: 360).isActive = true
        backgroundCircle.heightAnchor.constraint(equalTo: backgroundCircle.widthAnchor).isActive = true
        
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
        
        self.view.addSubview(gradientContainer)
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth, height: 600)
        scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: 500).isActive = true
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
        optionsTableView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -48).isActive = true
        optionsTableView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        optionsHeight = optionsTableView.heightAnchor.constraint(equalToConstant: 188)
            optionsHeight.isActive = true

        self.view.addSubview(currentVehicleController.view)
        self.view.bringSubviewToFront(gradientContainer)
        currentVehicleController.view.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        currentVehicleController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        currentVehicleController.view.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        currentAnchor = currentVehicleController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width)
        currentAnchor.isActive = true
        
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
        self.currentVehicleController.scrollView.setContentOffset(.zero, animated: true)
        self.bringBackMain()
    }
    
    @objc func bringBackMain() {
        self.checkSelectedVehicle()
        self.scrollExpanded()
        self.view.endEditing(true)
        UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
            self.mainLabel.text = ""
            self.currentAnchor.constant = self.view.frame.width
            self.backButton.alpha = 0
            self.scrollView.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.bringExitButton()
            UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.mainLabel.text = "Your Vehicles"
            }, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.optionsHeight.constant = CGFloat(80 * (self.options.count + 1) - 8)
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
            if title != "" && subtitle != "" {
                let key = self.optionsKey[indexPath.row]
                self.currentVehicleController.setData(type: title, license: subtitle, key: key)
                self.currentVehicleController.setupCurrentVehicle()
                UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                    self.mainLabel.text = ""
                    self.view.layoutIfNeeded()
                }) { (success) in
                    UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                        self.mainLabel.text = "Edit Vehicle"
                    }, completion: nil)
                }
            } else {
                self.currentVehicleController.setupNewVehicle()
                UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                    self.mainLabel.text = ""
                    self.view.layoutIfNeeded()
                }) { (success) in
                    UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                        self.mainLabel.text = "New Vehicle"
                    }, completion: nil)
                }
            }
            self.moveToNext()
        }
    }
    
    func observeVehicles() {
        self.options = []
        self.optionsSub = []
        self.optionsKey = []
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
            let ref = Database.database().reference().child("users").child(userID).child("Vehicles")
            ref.observe(.childAdded) { (snapshot) in
                let vehicleRef = Database.database().reference().child("UserVehicles").child(snapshot.key)
                vehicleRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String:Any] {
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
            ref.observe(.childRemoved) { (snapshot) in
                let vehicleRef = Database.database().reference().child("UserVehicles").child(snapshot.key)
                vehicleRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String:Any] {
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
    
    func moveToNext() {
        self.scrollMinimized()
        UIView.animate(withDuration: animationIn) {
            self.delegate?.hideExitButton()
            self.backButton.alpha = 1
            self.currentAnchor.constant = 0
            self.scrollView.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}


extension UserVehicleViewController: UIScrollViewDelegate {
    
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
            if self.backgroundCircle.alpha == 0 {
                UIView.animate(withDuration: animationIn) {
                    self.gradientContainer.layer.shadowOpacity = 0
                    self.backgroundCircle.alpha = 1
                }
            }
            if self.gradientContainer.backgroundColor == Theme.DARK_GRAY {
                self.scrollExpanded()
            }
        } else if translation >= 40 && self.backgroundCircle.alpha == 1 {
            UIView.animate(withDuration: animationIn) {
                self.gradientContainer.layer.shadowOpacity = 0.2
                self.backgroundCircle.alpha = 0
            }
        } else if translation >= 80 {
            self.gradientHeightAnchor.constant = totalHeight - 80
            self.mainLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            if self.gradientContainer.backgroundColor != Theme.DARK_GRAY {
                self.scrollMinimized()
            }
        } else if translation <= 0 {
            self.gradientHeightAnchor.constant = totalHeight
            self.mainLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.contentOffset.y
        if translation >= 75 {
            self.scrollMinimized()
        } else {
            self.scrollExpanded()
        }
    }
    
    func scrollExpanded() {
        self.delegate?.defaultContentStatusBar()
        self.scrollView.setContentOffset(.zero, animated: true)
        UIView.animate(withDuration: animationIn) {
            self.backgroundCircle.alpha = 1
            self.gradientContainer.backgroundColor = UIColor.clear
            self.backButton.tintColor = Theme.DARK_GRAY
            self.mainLabel.textColor = Theme.DARK_GRAY
        }
    }
    
    func scrollMinimized() {
        self.delegate?.lightContentStatusBar()
        UIView.animate(withDuration: animationIn) {
            self.backgroundCircle.alpha = 0
            self.gradientContainer.backgroundColor = Theme.DARK_GRAY
            self.backButton.tintColor = Theme.WHITE
            self.mainLabel.textColor = Theme.WHITE
        }
    }
    
}
