//
//  ChooseVehicleView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/28/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ChooseVehicleView: UIViewController {

    var extendedDelegate: handleExtendPaymentMethod?
    var bottomAnchor: CGFloat = 0.0
    var shouldDismiss: Bool = true
    
    var vehicleMethods: [Vehicles] = [] {
        didSet {
            optionsTableView.reloadData()
        }
    }
    
    lazy var dimView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight))
        
        return view
    }()
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true
        
        return view
    }()
    
    lazy var pullButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "pull-up")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        return button
    }()
    
    var optionsTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(VehicleMethodsCell.self, forCellReuseIdentifier: "cellId")
        view.isScrollEnabled = false
        
        return view
    }()
    
    var newCreditCard: UIImageView = {
        let image = UIImage(named: "gatedGraphic")
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = false
        view.alpha = 0
        
        return view
    }()
    
    var newCardButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.DARK_GRAY
        button.setTitle("Add vehicle", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        let icon = UIImage(named: "plusIcon")?.withRenderingMode(.alwaysTemplate)
        button.tintColor = Theme.WHITE
        button.setImage(icon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(newCardPressed), for: .touchUpInside)
        
        return button
    }()
    
    var loadingActivity: NVActivityIndicatorView = {
        let loading = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballPulse, color: Theme.WHITE, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.alpha = 0
        
        return loading
    }()
    
    func observeVehicles() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore().collection("stripe_customers").document(userId).collection("vehicles")
        db.addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            self.vehicleMethods = []
            for document in documents {
                let dataDescription = document.data()
                let vehicle = Vehicles(dictionary: dataDescription)
                self.vehicleMethods.append(vehicle)
            }
            self.endLoadingVehicles()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(sender:)))
        view.addGestureRecognizer(pan)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        dimView.addGestureRecognizer(tap)
        
        setupViews()
        observeVehicles()
    }
    
    var profitsBottomAnchor: NSLayoutConstraint!
    var tableViewHeight: NSLayoutConstraint!
    var containerTopAnchor: NSLayoutConstraint!
    var emptyContainerTopAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(dimView)
        view.addSubview(container)
        
        container.addSubview(cancelButton)
        cancelButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        switch device {
        case .iphone8:
            profitsBottomAnchor = cancelButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -32)
            profitsBottomAnchor.isActive = true
            self.bottomAnchor = -32
        case .iphoneX:
            profitsBottomAnchor = cancelButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -52)
            profitsBottomAnchor.isActive = true
            self.bottomAnchor = -52
        }
        
        view.addSubview(pullButton)
        pullButton.bottomAnchor.constraint(equalTo: container.topAnchor, constant: -16).isActive = true
        pullButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pullButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        pullButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        pullButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        container.addSubview(newCardButton)
        newCardButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -16).isActive = true
        newCardButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        newCardButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        newCardButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        container.addSubview(optionsTableView)
        optionsTableView.bottomAnchor.constraint(equalTo: newCardButton.topAnchor, constant: -32).isActive = true
        optionsTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        optionsTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableViewHeight = optionsTableView.heightAnchor.constraint(equalToConstant: 60)
            tableViewHeight.isActive = true
        
        container.addSubview(newCreditCard)
        newCreditCard.bottomAnchor.constraint(equalTo: newCardButton.topAnchor, constant: -32).isActive = true
        newCreditCard.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        newCreditCard.widthAnchor.constraint(equalTo: newCreditCard.heightAnchor).isActive = true
        newCreditCard.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        container.addSubview(loadingActivity)
        loadingActivity.centerXAnchor.constraint(equalTo: newCardButton.centerXAnchor).isActive = true
        loadingActivity.centerYAnchor.constraint(equalTo: newCardButton.centerYAnchor).isActive = true
        loadingActivity.widthAnchor.constraint(equalToConstant: 40).isActive = true
        loadingActivity.heightAnchor.constraint(equalTo: loadingActivity.widthAnchor).isActive = true
        
        container.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 80).isActive = true
        container.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        containerTopAnchor = container.topAnchor.constraint(equalTo: optionsTableView.topAnchor, constant: -16)
            containerTopAnchor.isActive = false
        emptyContainerTopAnchor = container.topAnchor.constraint(equalTo: newCreditCard.topAnchor, constant: -32)
            emptyContainerTopAnchor.isActive = true
        
        view.layoutIfNeeded()
        
    }
    
    @objc func viewPanned(sender: UIPanGestureRecognizer) {
        let state = sender.state
        let translation = sender.translation(in: self.view).y
        if state == .changed {
            self.profitsBottomAnchor.constant = self.bottomAnchor + translation/1.5
            self.view.layoutIfNeeded()
            if translation >= 160 || translation <= -320 {
                self.profitsBottomAnchor.constant = self.bottomAnchor
                UIView.animate(withDuration: animationOut) {
                    self.view.layoutIfNeeded()
                }
                if self.shouldDismiss == true {
                    self.dismissView()
                }
            }
        } else if state == .ended {
            self.view.endEditing(true)
            let difference = abs(self.profitsBottomAnchor.constant) + self.bottomAnchor
            if difference >= 160 {
                if self.shouldDismiss == true {
                    self.dismissView()
                    self.profitsBottomAnchor.constant = self.bottomAnchor
                    UIView.animate(withDuration: animationOut) {
                        self.view.layoutIfNeeded()
                    }
                }
            } else {
                self.profitsBottomAnchor.constant = self.bottomAnchor
                UIView.animate(withDuration: animationOut) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc func dismissView() {
        self.extendedDelegate?.closeBackground()
        self.dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension ChooseVehicleView: updatePaymentMethod {
    
    func noCards() {
        containerTopAnchor.isActive = false
        emptyContainerTopAnchor.isActive = true
        UIView.animate(withDuration: animationIn) {
            self.newCreditCard.alpha = 1
            self.optionsTableView.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func cards() {
        containerTopAnchor.isActive = true
        emptyContainerTopAnchor.isActive = false
        UIView.animate(withDuration: animationIn) {
            self.newCreditCard.alpha = 0
            self.optionsTableView.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func newCardPressed() {
        let controller = NewVehicleView()
        controller.vehicleMethods = vehicleMethods
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func loadPayments() {
        loadingActivity.alpha = 1
        loadingActivity.startAnimating()
        newCardButton.imageView?.isHidden = true
        newCardButton.titleLabel?.isHidden = true
    }
    
    func endLoadingVehicles() {
        if loadingActivity.alpha == 1 {
            loadingActivity.alpha = 0
            loadingActivity.stopAnimating()
            newCardButton.imageView?.isHidden = false
            newCardButton.titleLabel?.isHidden = false
        }
    }
    
}

extension ChooseVehicleView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewHeight.constant = CGFloat(60 * vehicleMethods.count) - 1
        if vehicleMethods.count == 0 {
            noCards()
        } else {
            cards()
        }
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
        }
        return vehicleMethods.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = optionsTableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! VehicleMethodsCell
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        if indexPath.row < vehicleMethods.count {
            let vehicle = vehicleMethods[indexPath.row]
            cell.vehicleMethod = vehicle
            if vehicle.defaultVehicle {
                cell.checkmark.alpha = 1
                cell.defaultButton.alpha = 1
            } else {
                cell.checkmark.alpha = 0
                cell.defaultButton.alpha = 0
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! VehicleMethodsCell
        guard let userId = Auth.auth().currentUser?.uid else { return }
        tableView.allowsSelection = false
        if let id = cell.vehicleMethod?.fingerprint {
            loadingActivity.alpha = 1
            loadingActivity.startAnimating()
            newCardButton.setTitle("", for: .normal)
            newCardButton.tintColor = UIColor.clear
            let ref = Database.database().reference().child("users").child(userId)
            ref.updateChildValues(["selectedVehicle": id]) { (error, ref) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                    
                }
                delayWithSeconds(animationOut, completion: {
                    tableView.allowsSelection = true
                    self.loadingActivity.alpha = 0
                    self.loadingActivity.stopAnimating()
                    self.newCardButton.setTitle("Add vehicle", for: .normal)
                    self.newCardButton.tintColor = Theme.WHITE
                    self.dismissView()
                })
            }
        }
    }
    
}
