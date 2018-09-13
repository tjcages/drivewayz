//
//  CouponsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 7/23/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase
import TextFieldEffects

class CouponsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var delegate: controlsAccountViews?
    
    var termsContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE
        view.clipsToBounds = true
        view.alpha = 0.8
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    var blurBackgroundStartup: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.isUserInteractionEnabled = false
        blurView.alpha = 0.8
        
        return blurView
    }()
    
    lazy var redeemField: MadokaTextField = {
        let redeemField = MadokaTextField(frame: CGRect(x: 0, y: 0, width: 150, height: 63))
        redeemField.placeholderColor = Theme.DARK_GRAY
        redeemField.borderColor = Theme.PRIMARY_COLOR
        redeemField.text = ""
        redeemField.placeholder = "Enter coupon code"
        redeemField.textColor = Theme.DARK_GRAY
        redeemField.font = UIFont.systemFont(ofSize: 18, weight: .light)
        redeemField.translatesAutoresizingMaskIntoConstraints = false
        redeemField.alpha = 0
        
        return redeemField
    }()
    
    var currentCoupons: UILabel = {
        let label = UILabel()
        label.textColor = Theme.PRIMARY_COLOR
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.numberOfLines = 2
        label.text = "Current Coupons"
        
        return label
    }()
    
    var redeem: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Redeem", for: .normal)
        button.setTitleColor(Theme.PRIMARY_DARK_COLOR, for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.borderColor = Theme.PRIMARY_COLOR.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(redeemPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var accept: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Activate", for: .normal)
        button.setTitleColor(Theme.PRIMARY_DARK_COLOR, for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.borderColor = Theme.PRIMARY_COLOR.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(nextPressed(sender:)), for: .touchUpInside)
        button.alpha = 1
        
        return button
    }()
    
    var back: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.borderColor = Theme.DARK_GRAY.cgColor
        button.alpha = 0.6
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(backPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var couponsTableView: UITableView = {
        let parking = UITableView()
        parking.translatesAutoresizingMaskIntoConstraints = false
        parking.backgroundColor = Theme.WHITE
        parking.allowsSelection = true
        
        return parking
    }()
    
    var Coupons: [String] = [""]
    var Codes: [String] = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.couponsTableView.delegate = self
        self.couponsTableView.dataSource = self
        
        setupTerms()
        observeUserCoupons()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var termsHeightAnchor: NSLayoutConstraint!
    
    func setupTerms() {
        
        self.view.addSubview(blurBackgroundStartup)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        blurBackgroundStartup.addGestureRecognizer(tap)
        blurBackgroundStartup.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        blurBackgroundStartup.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        blurBackgroundStartup.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        blurBackgroundStartup.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.view.addSubview(termsContainer)
        termsContainer.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -20).isActive = true
        termsHeightAnchor = termsContainer.heightAnchor.constraint(equalToConstant: 300)
            termsHeightAnchor.isActive = true
        termsContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        termsContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        
        termsContainer.addSubview(currentCoupons)
        currentCoupons.centerXAnchor.constraint(equalTo: termsContainer.centerXAnchor).isActive = true
        currentCoupons.widthAnchor.constraint(equalTo: termsContainer.widthAnchor, constant: -20).isActive = true
        currentCoupons.centerYAnchor.constraint(equalTo: termsContainer.topAnchor, constant: 30).isActive = true
        currentCoupons.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        termsContainer.addSubview(accept)
        accept.centerXAnchor.constraint(equalTo: termsContainer.centerXAnchor, constant: 60).isActive = true
        accept.widthAnchor.constraint(equalTo: termsContainer.widthAnchor, constant: -200).isActive = true
        accept.centerYAnchor.constraint(equalTo: termsContainer.bottomAnchor, constant: -70).isActive = true
        accept.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        termsContainer.addSubview(back)
        back.centerXAnchor.constraint(equalTo: termsContainer.centerXAnchor, constant: -60).isActive = true
        back.widthAnchor.constraint(equalTo: termsContainer.widthAnchor, constant: -200).isActive = true
        back.centerYAnchor.constraint(equalTo: termsContainer.bottomAnchor, constant: -70).isActive = true
        back.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        termsContainer.addSubview(redeem)
        redeem.centerXAnchor.constraint(equalTo: termsContainer.centerXAnchor).isActive = true
        redeem.widthAnchor.constraint(equalToConstant: 150).isActive = true
        redeem.topAnchor.constraint(equalTo: back.bottomAnchor, constant: 5).isActive = true
        redeem.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        termsContainer.addSubview(redeemField)
        redeemField.bottomAnchor.constraint(equalTo: termsContainer.bottomAnchor, constant: -60).isActive = true
        redeemField.widthAnchor.constraint(equalTo: termsContainer.widthAnchor, constant: -20).isActive = true
        redeemField.centerXAnchor.constraint(equalTo: termsContainer.centerXAnchor).isActive = true
        redeemField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    
    @objc func redeemPressed(sender: UIButton) {
        self.check = true
        if accept.alpha == 1 {
            UIView.animate(withDuration: 0.3, animations: {
                self.termsHeightAnchor.constant = 180
                self.back.alpha = 0
                self.accept.alpha = 0
                self.couponsTableView.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: 0.3, animations: {
                    self.redeemField.alpha = 1
                    self.currentCoupons.text = "Redeem Coupons"
                    self.view.layoutIfNeeded()
                }, completion: { (success) in
                    //
                })
            }
        } else {
            if redeemField.text != "" {
                updateUserProfile(coupon: self.redeemField.text!)
            }
            self.redeemField.endEditing(true)
            UIView.animate(withDuration: 0.3, animations: {
                self.redeemField.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: 0.3, animations: {
                    self.currentCoupons.text = "Current Coupons"
                    self.termsHeightAnchor.constant = 300
                    self.back.alpha = 1
                    self.accept.alpha = 1
                    self.couponsTableView.alpha = 1
                    self.view.layoutIfNeeded()
                }, completion: { (success) in
                    //
                })
            }
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.redeemField.endEditing(true)
    }
    
    @objc func nextPressed(sender: UIButton) {
        let coupon = self.oldSelectedCell?.textLabel?.text
        guard let count = self.oldSelectedCell?.tag else {
            sendAlert(title: "Please select an available coupon", message: "")
            return
        }
        if (self.Codes.count - 1) >= count {
            let alert = UIAlertController(title: "Confirm", message: "Would you like to activate this coupon now? It will be applied to your next purchase.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (pressed) in
                guard let currentUser = Auth.auth().currentUser?.uid else {return}
                let code = self.Codes[count]
                let stringArray = coupon!.components(separatedBy: CharacterSet.decimalDigits.inverted)
                for item in stringArray {
                    if let number = Int(item) {
                        let ref = Database.database().reference().child("users").child(currentUser)
                        ref.child("CurrentCoupon").updateChildValues(["coupon": number])
                        ref.child("Coupons").updateChildValues([code: ""])
                        self.Coupons.remove(at: (self.oldSelectedCell?.tag)!)
                        self.Codes.remove(at: (self.oldSelectedCell?.tag)!)
                        DispatchQueue.main.async(execute: {
                            self.couponsTableView.reloadData()
                        })
                        self.sendAlert(title: "Success", message: "You have redeemed this coupon and it will be applied to your next purchase!")
                        UIView.animate(withDuration: 0.3, animations: {
                            self.view.alpha = 0
                        }) { (success) in
                            self.delegate?.removeOptionsFromView()
                        }
                    } else {
                        let ref = Database.database().reference().child("users").child(currentUser)
                        ref.observeSingleEvent(of: .value, with: { (snapshot) in
                            if let dictionary = snapshot.value as? [String:AnyObject] {
                                if let parking = dictionary["Parking"] as? [String:AnyObject] {
                                    let parkingID = parking["parkingID"] as? String
                                    ref.child("Coupons").updateChildValues([code: ""])
                                    let couponArray = coupon!.split(separator: " ")
                                    let value: String = String(couponArray[0])
                                    var dollars: Int = 0
                                    if value == "Five" {
                                        dollars = 5
                                    } else if value == "Ten" {
                                        dollars = 10
                                    }
                                    if let previousFunds = dictionary["userFunds"] {
                                        let funds = Double(truncating: previousFunds as! NSNumber) + Double(dollars)
                                        ref.updateChildValues(["userFunds": funds])
                                    } else {
                                        ref.updateChildValues(["userFunds": dollars])
                                    }
                                    self.sendAlert(title: "Success!", message: "Your account has been credited $\(dollars) for becoming a host!")
                                    
                                    let timestamp = Date().timeIntervalSince1970
                                    let paymentRef = Database.database().reference().child("users").child(currentUser).child("Payments")
                                    let currentRef = Database.database().reference().child("users").child(currentUser)
                                    currentRef.observeSingleEvent(of: .value) { (current) in
                                        let dictionary = current.value as? [String:AnyObject]
                                        var currentFunds = dictionary!["userFunds"] as? Double
                                        if currentFunds != nil {} else {currentFunds = 0}
                                        paymentRef.observeSingleEvent(of: .value) { (snapshot) in
                                            self.count =  Int(snapshot.childrenCount)
                                            let payRef = paymentRef.child("\(self.count)")
                                            let newFunds = Double(currentFunds!) + (Double(dollars))
                                            payRef.updateChildValues(["cost": dollars, "currentFunds": newFunds, "hours": 0, "user": currentUser, "timestamp": timestamp, "parkingID": parkingID!])
                                        }
                                    }
                                    
                                    self.delegate?.removeOptionsFromView()
                                } else {
                                    self.sendAlert(title: "Not quite!", message: "You must first become a host by signing up your parking space.")
                                }
                            }
                        })
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        } else {
            sendAlert(title: "Please select an available coupon", message: "")
        }
    }

    
    @objc func backPressed(sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 0
        }) { (success) in
            self.delegate?.removeOptionsFromView()
        }
    }
    
    var count: Int = 0
    var check: Bool = true
    
    private func updateUserProfile(coupon: String) {
        let speller = coupon.replacingOccurrences(of: "[\\[\\]^+<>.#$ ]", with: "", options: .regularExpression, range: nil)
        if let user = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("users").child(user).child("Coupons")
            ref.observe(.value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    var checkArray: [String] = []
                    for dic in dictionary {
                        checkArray.append(dic.key)
                    }
                    if checkArray.contains(speller) {
                        self.sendAlert(title: "Whoops!", message: "Looks like you've already redeemed this coupon code.")
                    } else {
                        let checkRef = Database.database().reference().child("coupons").child(speller)
                        checkRef.observeSingleEvent(of: .value) { (snapshot) in
                            if (snapshot.value as? String) != nil {
                                let couponValue = snapshot.value as! String
                                if self.check == true {
                                    self.check = false
                                    let currentUser = Auth.auth().currentUser?.uid
                                    let couponRef = Database.database().reference().child("users").child(currentUser!).child("Coupons")
                                    couponRef.observeSingleEvent(of: .value) { (snapshot) in
                                        self.count =  Int(snapshot.childrenCount)
                                        couponRef.updateChildValues([speller: couponValue])
                                        self.Coupons.removeAll()
                                        self.Codes.removeAll()
                                        self.Coupons.append(couponValue)
                                        self.Codes.append(speller)
                                    }
                                } else if self.check == true {
                                    self.sendAlert(title: "Whoops!", message: "Looks like you've already redeemed this coupon code.")
                                }
                            } else {
                                self.sendAlert(title: "Hmmm", message: "This doesn't look like a correct coupon code.")
                            }
                        }
                    }
                } else {
                    let checkRef = Database.database().reference().child("coupons").child(speller)
                    checkRef.observeSingleEvent(of: .value) { (snapshot) in
                        if (snapshot.value as? String) != nil {
                            let couponValue = snapshot.value as! String
                            let currentUser = Auth.auth().currentUser?.uid
                            let couponRef = Database.database().reference().child("users").child(currentUser!).child("Coupons")
                            couponRef.observeSingleEvent(of: .value) { (snapshot) in
                                self.count =  Int(snapshot.childrenCount)
                                couponRef.updateChildValues([speller: couponValue])
                                self.Coupons.removeAll()
                                self.Codes.removeAll()
                                self.Coupons.append(couponValue)
                                self.Codes.append(speller)
                            }
                        } else {
                            self.sendAlert(title: "Hmmm", message: "This doesn't look like a correct coupon code.")
                        }
                    }
                }
            }, withCancel: nil)
        }
    }
    
    func observeUserCoupons() {
        if let user = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("users").child(user).child("Coupons")
            ref.observe(.value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    for key in dictionary.keys {
                        let coupon = dictionary[key] as? String
                        self.Coupons.append(coupon!)
                        self.Codes.append(key)
                        DispatchQueue.main.async(execute: {
                            self.couponsTableView.reloadData()
                        })
                    }
                    self.Codes.remove(at: 0)
                    self.Coupons.remove(at: 0)
                }
            }, withCancel: nil)
            ref.observe(.childRemoved, with: { (snapshot) in
                self.couponsTableView.reloadData()
            }, withCancel: nil)
        } else {
            return
        }
        
        termsContainer.addSubview(couponsTableView)
        couponsTableView.topAnchor.constraint(equalTo: currentCoupons.bottomAnchor, constant: 10).isActive = true
        couponsTableView.bottomAnchor.constraint(equalTo: termsContainer.bottomAnchor, constant: -100).isActive = true
        couponsTableView.leftAnchor.constraint(equalTo: termsContainer.leftAnchor).isActive = true
        couponsTableView.rightAnchor.constraint(equalTo: termsContainer.rightAnchor).isActive = true
        
        self.couponsTableView.reloadData()
    }
    
    func sendAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Coupons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = Coupons[indexPath.row]
        cell.tag = indexPath.row
        cell.textLabel?.textColor = Theme.DARK_GRAY
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        cell.backgroundColor = UIColor.white
        cell.selectionStyle = .gray
    
        return cell
    }
    
    var oldSelectedCell: UITableViewCell?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell: UITableViewCell = tableView.cellForRow(at: indexPath as IndexPath)!
        selectedCell.contentView.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.1)
        oldSelectedCell = selectedCell
        
        accept.alpha = 1
        accept.isUserInteractionEnabled = true
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cellToDeSelect: UITableViewCell = tableView.cellForRow(at: indexPath as IndexPath)!
        cellToDeSelect.contentView.backgroundColor = Theme.WHITE
    }
    

}
