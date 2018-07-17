//
//  ParkingDetailsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/19/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import Stripe

var parkingAddress: String?
var parkingDistances: String?
var imageURL: String?
var parkingCost: String?
var formattedLocation: String?
var hours: Int?
var timestamps: NSNumber?
var ids: String?
var parkingIDs: String?

var Monday: Int?
var Tuesday: Int?
var Wednesday: Int?
var Thursday: Int?
var Friday: Int?
var Saturday: Int?
var Sunday: Int?

var MondayFrom: String?
var MondayTo: String?
var TuesdayFrom: String?
var TuesdayTo: String?
var WednesdayFrom: String?
var WednesdayTo: String?
var ThursdayFrom: String?
var ThursdayTo: String?
var FridayFrom: String?
var FridayTo: String?
var SaturdayFrom: String?
var SaturdayTo: String?
var SundayFrom: String?
var SundayTo: String?

class ParkingDetailsViewController: UIViewController {
    
    var account: String? = "No account."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.OFF_WHITE
        self.navigationController?.navigationBar.isHidden = true
        
        checkAccount()
        setupViews()
    }
    
//    func setData(cityAddress: String, imageURL: String, parkingCost: String, formattedAddress: String, timestamp: NSNumber, id: String, parkingID: String, parkingDistance: String) {
//        labelTitle.text = "Parking in \(cityAddress)"
//        parkingAddress = cityAddress
//        parkingDistances = parkingDistance
//        labelDistance.text = "\(parkingDistance) miles"
//        imageView.loadImageUsingCacheWithUrlString(imageURL)
//        labelCost.text = parkingCost
//        formattedLocation = formattedAddress
//        timestamps = timestamp
//        ids = id
//        parkingIDs = parkingID
//    }
    
    func setupViews() {
        
        self.view.addSubview(reserveContainer)
        reserveContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        reserveContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        reserveContainer.widthAnchor.constraint(equalToConstant: 300).isActive = true
        reserveContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = Theme.OFF_WHITE
        reserveContainer.addSubview(line)
        line.centerYAnchor.constraint(equalTo: reserveContainer.centerYAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line.widthAnchor.constraint(equalTo: reserveContainer.widthAnchor).isActive = true
        line.centerXAnchor.constraint(equalTo: reserveContainer.centerXAnchor).isActive = true

        self.view.addSubview(saveReservationButton)
        saveReservationButton.rightAnchor.constraint(equalTo: reserveContainer.rightAnchor).isActive = true
        saveReservationButton.bottomAnchor.constraint(equalTo: reserveContainer.bottomAnchor).isActive = true
        saveReservationButton.leftAnchor.constraint(equalTo: reserveContainer.leftAnchor).isActive = true
        saveReservationButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(paymentButton)
        paymentButton.leftAnchor.constraint(equalTo: reserveContainer.leftAnchor).isActive = true
        paymentButton.topAnchor.constraint(equalTo: reserveContainer.topAnchor).isActive = true
        paymentButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        paymentButton.heightAnchor.constraint(equalToConstant: 40)

        let line2 = UIView()
        line2.translatesAutoresizingMaskIntoConstraints = false
        line2.backgroundColor = Theme.OFF_WHITE
        self.view.addSubview(line2)
        line2.bottomAnchor.constraint(equalTo: saveReservationButton.topAnchor).isActive = true
        line2.widthAnchor.constraint(equalToConstant: 1).isActive = true
        line2.heightAnchor.constraint(equalToConstant: 40).isActive = true
        line2.rightAnchor.constraint(equalTo: reserveContainer.rightAnchor, constant: -100).isActive = true
        
        self.view.addSubview(unavailable)
        unavailable.centerXAnchor.constraint(equalTo: reserveContainer.centerXAnchor).isActive = true
        unavailable.topAnchor.constraint(equalTo: line.bottomAnchor).isActive = true
        unavailable.widthAnchor.constraint(equalTo: reserveContainer.widthAnchor).isActive = true
        unavailable.bottomAnchor.constraint(equalTo: saveReservationButton.topAnchor, constant: -1).isActive = true
        
    }

    func spotIsAvailable() {
        unavailable.alpha = 0
    }
    
    func spotIsNotAvailable() {
        unavailable.alpha = 1
    }
    
//    @objc func saveReservationButtonPressed(sender: UIButton) {
//
//        let product = labelTitle.text
//
//        let price = labelCost.text
//        let edited = price?.replacingOccurrences(of: "$", with: "")
//        let editedPrice = edited?.replacingOccurrences(of: ".", with: "")
//        let editedHour = editedPrice?.replacingOccurrences(of: "/hour", with: "")
//        let cost: Int = Int(editedHour!)!
//
//        let totalCost = cost * hours!
//        let checkoutViewController = CheckoutViewController(product: product!,
//                                                            price: totalCost,
//                                                            hours: hours!,
//                                                            ID: ids!,
//                                                            account: account!,
//                                                            parkingID: parkingIDs!)
//        let geoCoder = CLGeocoder()
//        geoCoder.geocodeAddressString(formattedLocation!) { (placemarks, error) in
//            guard
//                let placemarks = placemarks,
//                let _ = placemarks.first?.location
//                else {
//                    print("No associated location")
//                    return
//            }
//        }
//        UIApplication.shared.statusBarStyle = .default
//        self.navigationController?.pushViewController(checkoutViewController, animated: true)
//    }
//
    func checkAccount() {
        if let currentUser = Auth.auth().currentUser?.uid {
            let checkRef = Database.database().reference().child("users").child(currentUser)
            checkRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    if let account = dictionary["accountID"] as? String {
                        self.account = account
                    } else {
                        return
                    }
                }
            }, withCancel: nil)
        }
    }
    
    @objc func dismissDetails(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        saveReservationButton.alpha = 0.5
        saveReservationButton.isUserInteractionEnabled = false
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    var reserveContainer: UIView = {
        let reserve = UIView()
        reserve.translatesAutoresizingMaskIntoConstraints = false
        reserve.backgroundColor = Theme.WHITE
        reserve.layer.cornerRadius = 5
        reserve.clipsToBounds = false
        reserve.layer.shadowColor = Theme.DARK_GRAY.cgColor
        reserve.layer.shadowOffset = CGSize(width: 1, height: 1)
        reserve.layer.shadowRadius = 1
        reserve.layer.shadowOpacity = 0.8
        reserve.alpha = 0.9
        
        return reserve
    }()
    
    var saveReservationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reserve Spot", for: .normal)
        button.setTitle("", for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        button.backgroundColor = UIColor.clear
        button.alpha = 0.5
        button.translatesAutoresizingMaskIntoConstraints = false
//        button(self, action: #selector(saveReservationButtonPressed(sender:)), for: .touchUpInside)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var paymentButton: UIButton = {
        let button = UIButton()
        button.setTitle("Payment", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        button.backgroundColor = UIColor.clear
        button.alpha = 0.5
        button.translatesAutoresizingMaskIntoConstraints = false
        //        button(self, action: #selector(saveReservationButtonPressed(sender:)), for: .touchUpInside)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
}

protocol dropDownProtocol {
    func dropDownPressed(string : String)
}

class dropDownButton: UIButton, dropDownProtocol {
    
    func dropDownPressed(string: String) {
        self.setTitle(string, for: .normal)
        self.dismissDropDown()
    }
    
    var dropView = dropDownView()
    var height = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = Theme.WHITE
        
        dropView = dropDownView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        dropView.delegate = self
        dropView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func didMoveToSuperview() {
        self.superview?.addSubview(dropView)
        self.superview?.bringSubview(toFront: dropView)
        dropView.bottomAnchor.constraint(equalTo: self.topAnchor).isActive = true
        dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dropView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -10).isActive = true
        height = dropView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    var isOpen = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen == false {
            
            isOpen = true
            
            NSLayoutConstraint.deactivate([self.height])
            
            if self.dropView.tableView.contentSize.height > 120 {
                self.height.constant = 120
            } else {
                self.height.constant = self.dropView.tableView.contentSize.height
            }
            
            
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y -= self.dropView.frame.height / 2
            }, completion: nil)
            
        } else {
            isOpen = false
            
            NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 0
            NSLayoutConstraint.activate([self.height])
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.center.y += self.dropView.frame.height / 2
                self.dropView.layoutIfNeeded()
            }, completion: nil)
            
        }
    }
    
    func dismissDropDown() {
        isOpen = false
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.dropView.center.y += self.dropView.frame.height / 2
            self.dropView.layoutIfNeeded()
        }, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class dropDownView: UIView, UITableViewDelegate, UITableViewDataSource  {
    
    var dropDownOptions = [String]()
    var tableView = UITableView()
    var delegate : dropDownProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.backgroundColor = Theme.WHITE
        self.backgroundColor = Theme.WHITE
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 5
        
        self.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = dropDownOptions[indexPath.row]
        cell.textLabel?.textColor = Theme.DARK_GRAY
        cell.backgroundColor = Theme.WHITE
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.dropDownPressed(string: dropDownOptions[indexPath.row])
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        reserveButton.alpha = 1
        reserveButton.isUserInteractionEnabled = true
    }
    
}


var unavailable: UIButton = {
    let button = UIButton()
    button.backgroundColor = Theme.PRIMARY_COLOR
    button.setTitle("Unavailable currently", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.alpha = 1
    button.clipsToBounds = true
    
    return button
}()





