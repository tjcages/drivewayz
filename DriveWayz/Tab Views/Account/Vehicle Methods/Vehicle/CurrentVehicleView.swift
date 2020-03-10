//
//  CurrentVehicleView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/1/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Stripe
import FirebaseFirestore

class CurrentVehicleView: UIViewController {
    
    var delegate: updateVehicleMethod?
    var vehicleMethod: Vehicles?
    var vehicleMethods: [Vehicles] = []
    var hasAlreadyMadeDefault: Bool = false
    
    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.BLACK
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        //        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Vehicle methods"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH1
        
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var loadingLine: LoadingLine = {
        let view = LoadingLine()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var optionsTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(VehicleDetailsCell.self, forCellReuseIdentifier: "cellId")
        view.isScrollEnabled = false
        
        return view
    }()
    
    func observeVehicles(vehicle: Vehicles) {
        vehicleMethod = vehicle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.BACKGROUND_GRAY
        view.clipsToBounds = true
        
        scrollView.delegate = self
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        
        setupViews()
    }
    
    var gradientHeightAnchor: NSLayoutConstraint!
    var tableViewHeight: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(optionsTableView)
        view.addSubview(gradientContainer)
        gradientContainer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        switch device {
        case .iphone8:
            gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: 140)
            gradientHeightAnchor.isActive = true
        case .iphoneX:
            gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: 160)
            gradientHeightAnchor.isActive = true
        }
        
        scrollView.contentSize = CGSize(width: phoneWidth, height: 800)
        scrollView.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        optionsTableView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        optionsTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        optionsTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableViewHeight = optionsTableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeight.isActive = true
        
        view.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        switch device {
        case .iphone8:
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 28).isActive = true
        case .iphoneX:
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 48).isActive = true
        }
        
        view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: -16).isActive = true
        
        gradientContainer.addSubview(loadingLine)
        loadingLine.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        loadingLine.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        loadingLine.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        loadingLine.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
    }
    
}

extension CurrentVehicleView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewHeight.constant = 5 * 72 + 32 - 1
        self.view.layoutIfNeeded()
        
        if section == 0 {
            return 3
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: 16))
        view.backgroundColor = Theme.BACKGROUND_GRAY
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = optionsTableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! VehicleDetailsCell
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        if let method = vehicleMethod {
            if let make = method.vehicleMake {
                mainLabel.text = make
            }
            if indexPath.row == 0, let model = method.vehicleModel {
                cell.mainLabel.text = "Vehicle model"
                cell.subLabel.text = model
            } else if indexPath.row == 1, let year = method.vehicleYear {
                cell.mainLabel.text = "Year"
                cell.subLabel.text = year
            } else if indexPath.row == 2, let license = method.vehicleLicensePlate {
                cell.mainLabel.text = "License plate"
                cell.subLabel.text = license
            }
        }
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                cell.subLabel.text = "Make preffered vehicle"
                cell.subLabel.textColor = Theme.BLUE
            } else {
                cell.subLabel.text = "Delete vehicle"
                cell.subLabel.textColor = Theme.SALMON
            }
            cell.mainLabel.alpha = 0
            cell.mainLabelCenterYAnchor.isActive = true
            cell.mainLabelTopAnchor.isActive = false
        } else {
            cell.subLabel.textColor = Theme.BLACK
            cell.mainLabel.alpha = 1
            cell.mainLabelCenterYAnchor.isActive = false
            cell.mainLabelTopAnchor.isActive = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let cell = tableView.cellForRow(at: indexPath) as! VehicleDetailsCell
        if cell.subLabel.text == "Make preffered vehicle", let method = vehicleMethod {
            loadingLine.alpha = 1
            loadingLine.startAnimating()
            self.delegate?.loadVehicles()
            tableView.allowsSelection = false
            let ref = Database.database().reference().child("users").child(userId).child("selectedVehicle").child("vehicles")
            ref.removeValue()
            if let dictionary = method.dictionary {
                ref.updateChildValues(dictionary) { (error, ref) in
                    if error != nil {
                        print(error?.localizedDescription as Any)
                    }
                    
                    // Set all other cards to false for default
                    for method in self.vehicleMethods {
                        if let currentMethod = self.vehicleMethod {
                            if method == currentMethod {
                                // Set default was pressed for the current card
                                if let fingerprint = method.fingerprint, var dictionary = method.dictionary {
                                    dictionary["default"] = true
                                    let db = Firestore.firestore().collection("stripe_customers").document(userId).collection("vehicles").document(fingerprint)
                                    db.setData(dictionary)
                                }
                            } else {
                                if let fingerprint = method.fingerprint, var dictionary = method.dictionary {
                                    dictionary["default"] = false
                                    let db = Firestore.firestore().collection("stripe_customers").document(userId).collection("vehicles").document(fingerprint)
                                    db.setData(dictionary)
                                }
                            }
                        }
                    }
                    
                    self.loadingLine.alpha = 0
                    self.loadingLine.endAnimating()
                    tableView.allowsSelection = true
                    self.backButtonPressed()
                }
            }
        } else if cell.subLabel.text == "Delete vehicle" {
            let alert = UIAlertController(title: "Delete vehicle?", message: "You will not be able to undo this action.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action) in
                self.loadingLine.alpha = 1
                self.loadingLine.startAnimating()
                self.delegate?.loadVehicles()
                tableView.allowsSelection = false
                
                // Set all other cards to false for default
                for method in self.vehicleMethods {
                    if let currentMethod = self.vehicleMethod {
                        if method == currentMethod {
                            // Check if card is default
                            if method.defaultVehicle {
                                // If it's default then remove from Database
                                let ref = Database.database().reference().child("users").child(userId).child("selectedVehicle")
                                ref.removeValue()
                                // Remove from Firestore
                                if let fingerprint = method.fingerprint {
                                    let db = Firestore.firestore().collection("stripe_customers").document(userId).collection("vehicles").document(fingerprint)
                                    db.delete { (err) in
                                        if err != nil {
                                            print(err?.localizedDescription as Any)
                                        }
                                        self.loadingLine.alpha = 0
                                        self.loadingLine.endAnimating()
                                        tableView.allowsSelection = true
                                        self.backButtonPressed()
                                    }
                                }
                            } else {
                                // Current card is not default
                                if let fingerprint = method.fingerprint {
                                    let db = Firestore.firestore().collection("stripe_customers").document(userId).collection("vehicles").document(fingerprint)
                                    db.delete { (err) in
                                        if err != nil {
                                            print(err?.localizedDescription as Any)
                                        }
                                        self.loadingLine.alpha = 0
                                        self.loadingLine.endAnimating()
                                        tableView.allowsSelection = true
                                        self.backButtonPressed()
                                    }
                                }
                            }
                        } else {
                            // Make next card default
                            if let fingerprint = method.fingerprint, var dictionary = method.dictionary, !self.hasAlreadyMadeDefault {
                                dictionary["default"] = true
                                self.hasAlreadyMadeDefault = true
                                let db = Firestore.firestore().collection("stripe_customers").document(userId).collection("vehicles").document(fingerprint)
                                db.setData(dictionary)
                            }
                            self.loadingLine.alpha = 0
                            self.loadingLine.endAnimating()
                            tableView.allowsSelection = true
                            self.backButtonPressed()
                        }
                    }
                }
                self.hasAlreadyMadeDefault = false
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
    
}



extension CurrentVehicleView: UIScrollViewDelegate {
    
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
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

class VehicleDetailsCell: UITableViewCell {
    
    var mainLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.SSPRegularH6
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLACK.withAlphaComponent(0.4)
        
        return view
    }()
    
    var subLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.SSPRegularH4
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLACK
        
        return view
    }()
    
    var mainLabelTopAnchor: NSLayoutConstraint!
    var mainLabelCenterYAnchor: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Theme.WHITE
        
        addSubview(mainLabel)
        mainLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -12).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()
        
        addSubview(subLabel)
        mainLabelTopAnchor = subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor)
        mainLabelTopAnchor.isActive = true
        mainLabelCenterYAnchor = subLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        mainLabelCenterYAnchor.isActive = false
        subLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        subLabel.sizeToFit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


