//
//  CurrentSpotViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 7/25/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import UserNotifications

protocol notificationOptions {
    func leaveAReview()
    func extendTime()
    func sendLeaveReview()
}

class ParkingCurrentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, notificationOptions {
    
    var address: String?
    var message: String?
    var parkingID: String?
    var delegate: controlCurrentParkingOptions?
    var extendDelegate: removePurchaseView?
    var navigationDelegate: extendTimeController?
    
    let parkingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var segmentControlView: UIView = {
        let segmentControlView = UIView()
        segmentControlView.translatesAutoresizingMaskIntoConstraints = false
        segmentControlView.backgroundColor = Theme.WHITE
        
        return segmentControlView
    }()
    
    var currentSegment: UIButton = {
        let info = UIButton()
        info.translatesAutoresizingMaskIntoConstraints = false
        info.backgroundColor = UIColor.clear
        info.setTitle("Current", for: .normal)
        info.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        info.setTitleColor(Theme.DARK_GRAY, for: .normal)
        info.titleLabel?.textAlignment = .center
        info.addTarget(self, action: #selector(recentPressed(sender:)), for: .touchUpInside)
        
        return info
    }()
    
    var currentTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = UIColor.clear
        table.isScrollEnabled = false
        
        return table
    }()
    
    lazy var timerController: CurrentParkingViewController = {
        let controller = CurrentParkingViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Timer"
        self.addChild(controller)
        controller.delegate = self
        
        return controller
    }()
    
    var Current = ["Extend time", "Open navigation", "Leave parking spot"]
    var Details = ["Message host"]
    var Payment = ["Total cost", "Additional cost", "Payment method"]
    
    var detailsSegment: UIButton = {
        let availability = UIButton()
        availability.translatesAutoresizingMaskIntoConstraints = false
        availability.backgroundColor = UIColor.clear
        availability.setTitle("Details", for: .normal)
        availability.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        availability.setTitleColor(Theme.DARK_GRAY, for: .normal)
        availability.titleLabel?.textAlignment = .center
        availability.addTarget(self, action: #selector(parkingPressed(sender:)), for: .touchUpInside)
        
        return availability
    }()
    
    var detailsTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = UIColor.clear
        table.isScrollEnabled = false
        
        return table
    }()
    
    var userMessage: UITextView = {
        let label = UITextView()
        label.textAlignment = .left
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "User messages!"
        label.backgroundColor = Theme.WHITE
        label.isEditable = false
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentInset = UIEdgeInsets.init(top: 5, left: 20, bottom: 5, right: 20)
        
        return label
    }()
    
    var paymentSegment: UIButton = {
        let reviews = UIButton()
        reviews.translatesAutoresizingMaskIntoConstraints = false
        reviews.backgroundColor = UIColor.clear
        reviews.setTitle("Payment", for: .normal)
        reviews.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        reviews.setTitleColor(Theme.DARK_GRAY, for: .normal)
        reviews.titleLabel?.textAlignment = .center
        reviews.addTarget(self, action: #selector(vehiclePressed(sender:)), for: .touchUpInside)
        
        return reviews
    }()
    
    var paymentTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = UIColor.clear
        table.isScrollEnabled = false
        
        return table
    }()
    
    var selectionLine: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = Theme.PACIFIC_BLUE
        
        return line
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.isUserInteractionEnabled = true
        let gestureRight = UISwipeGestureRecognizer(target: self, action: #selector(segmentRight(sender:)))
        gestureRight.direction = .right
        self.view.addGestureRecognizer(gestureRight)
        let gestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(segmentLeft(sender:)))
        gestureLeft.direction = .left
        self.view.addGestureRecognizer(gestureLeft)
        
        self.currentTableView.delegate = self
        self.currentTableView.dataSource = self
        self.detailsTableView.delegate = self
        self.detailsTableView.dataSource = self
        self.paymentTableView.delegate = self
        self.paymentTableView.dataSource = self

        setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setData(formattedAddress: String, message: String, parkingID: String) {
        self.address = formattedAddress
        self.parkingID = parkingID
        if message != "" {
            self.userMessage.text = "Host - \(message)"
        } else {
            self.userMessage.text = "No host message"
        }
    }
    
    var currentTableAnchor: NSLayoutConstraint!
    var detailsTableAnchor: NSLayoutConstraint!
    var paymentTableAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(segmentControlView)
        segmentControlView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 5).isActive = true
        segmentControlView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        segmentControlView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: self.view.frame.width/4).isActive = true
        segmentControlView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        segmentControlView.addSubview(currentSegment)
        currentSegment.rightAnchor.constraint(equalTo: segmentControlView.rightAnchor).isActive = true
        currentSegment.widthAnchor.constraint(equalToConstant: self.view.frame.width / 4).isActive = true
        currentSegment.heightAnchor.constraint(equalToConstant: 30).isActive = true
        currentSegment.topAnchor.constraint(equalTo: segmentControlView.topAnchor).isActive = true
        
        segmentControlView.addSubview(detailsSegment)
        detailsSegment.rightAnchor.constraint(equalTo: currentSegment.leftAnchor).isActive = true
        detailsSegment.widthAnchor.constraint(equalToConstant: self.view.frame.width / 4).isActive = true
        detailsSegment.heightAnchor.constraint(equalToConstant: 30).isActive = true
        detailsSegment.topAnchor.constraint(equalTo: segmentControlView.topAnchor).isActive = true
        
        segmentControlView.addSubview(paymentSegment)
        paymentSegment.rightAnchor.constraint(equalTo: detailsSegment.leftAnchor).isActive = true
        paymentSegment.widthAnchor.constraint(equalToConstant: self.view.frame.width / 4).isActive = true
        paymentSegment.heightAnchor.constraint(equalToConstant: 30).isActive = true
        paymentSegment.topAnchor.constraint(equalTo: segmentControlView.topAnchor).isActive = true
        
        self.view.addSubview(selectionLine)
        selectionLine.topAnchor.constraint(equalTo: segmentControlView.bottomAnchor).isActive = true
        selectionLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        selectionLine.widthAnchor.constraint(equalToConstant: self.view.frame.width / 4 - 10).isActive = true
        segmentLineLeftAnchor1 = selectionLine.centerXAnchor.constraint(equalTo: currentSegment.centerXAnchor)
        segmentLineLeftAnchor1.isActive = true
        segmentLineLeftAnchor2 = selectionLine.centerXAnchor.constraint(equalTo: detailsSegment.centerXAnchor)
        segmentLineLeftAnchor2.isActive = false
        segmentLineLeftAnchor3 = selectionLine.centerXAnchor.constraint(equalTo: paymentSegment.centerXAnchor)
        segmentLineLeftAnchor3.isActive = false
        
        self.view.addSubview(parkingView)
        parkingView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        parkingView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        parkingView.topAnchor.constraint(equalTo: segmentControlView.bottomAnchor).isActive = true
        parkingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        parkingView.addSubview(currentTableView)
        currentTableAnchor = currentTableView.centerXAnchor.constraint(equalTo: parkingView.centerXAnchor)
            currentTableAnchor.isActive = true
        currentTableView.widthAnchor.constraint(equalTo: parkingView.widthAnchor, constant: -20).isActive = true
        currentTableView.topAnchor.constraint(equalTo: parkingView.topAnchor).isActive = true
        currentTableView.bottomAnchor.constraint(equalTo: parkingView.bottomAnchor).isActive = true
        
        parkingView.addSubview(detailsTableView)
        detailsTableAnchor = detailsTableView.centerXAnchor.constraint(equalTo: parkingView.centerXAnchor, constant: self.view.frame.width)
            detailsTableAnchor.isActive = true
        detailsTableView.widthAnchor.constraint(equalTo: parkingView.widthAnchor, constant: -20).isActive = true
        detailsTableView.topAnchor.constraint(equalTo: parkingView.topAnchor).isActive = true
        detailsTableView.bottomAnchor.constraint(equalTo: parkingView.bottomAnchor).isActive = true
        
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.3)
        detailsTableView.addSubview(line)
        line.topAnchor.constraint(equalTo: detailsTableView.topAnchor, constant: 45).isActive = true
        line.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        line.widthAnchor.constraint(equalTo: detailsTableView.widthAnchor, constant: -20).isActive = true
        line.centerXAnchor.constraint(equalTo: detailsTableView.centerXAnchor).isActive = true
        
        parkingView.addSubview(paymentTableView)
        paymentTableAnchor = paymentTableView.centerXAnchor.constraint(equalTo: parkingView.centerXAnchor, constant: self.view.frame.width)
            paymentTableAnchor.isActive = true
        paymentTableView.widthAnchor.constraint(equalTo: parkingView.widthAnchor, constant: -20).isActive = true
        paymentTableView.topAnchor.constraint(equalTo: parkingView.topAnchor).isActive = true
        paymentTableView.bottomAnchor.constraint(equalTo: parkingView.bottomAnchor).isActive = true
        
        currentTableView.addSubview(timerController.view)
        timerController.view.leftAnchor.constraint(equalTo: currentTableView.leftAnchor, constant: 10).isActive = true
        timerController.view.topAnchor.constraint(equalTo: currentTableView.topAnchor, constant: 10).isActive = true
        timerController.view.widthAnchor.constraint(equalToConstant: 200).isActive = true
        timerController.view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        detailsTableView.addSubview(userMessage)
        detailsTableView.bringSubviewToFront(userMessage)
        userMessage.centerXAnchor.constraint(equalTo: detailsTableView.centerXAnchor).isActive = true
        userMessage.widthAnchor.constraint(equalTo: parkingView.widthAnchor).isActive = true
        userMessage.topAnchor.constraint(equalTo: detailsTableView.topAnchor, constant: 50).isActive = true
        userMessage.bottomAnchor.constraint(equalTo: parkingView.bottomAnchor, constant: -10).isActive = true
    
    }
    
    var controlTopAnchor1: NSLayoutConstraint!
    var controlTopAnchor2: NSLayoutConstraint!
    var segmentLineLeftAnchor1: NSLayoutConstraint!
    var segmentLineLeftAnchor2: NSLayoutConstraint!
    var segmentLineLeftAnchor3: NSLayoutConstraint!

    @objc func recentPressed(sender: UIButton) {
        recentPressedFunc()
    }
    
    func recentPressedFunc() {
//        self.delegate?.closeExtendTimeView()
        UIView.animate(withDuration: 0.2, animations: {
            self.segmentLineLeftAnchor1.isActive = true
            self.segmentLineLeftAnchor2.isActive = false
            self.segmentLineLeftAnchor3.isActive = false
            self.currentTableView.alpha = 1
            self.detailsTableView.alpha = 0
            self.paymentTableView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: 0.2, animations: {
                self.currentTableAnchor.constant = 0
                self.detailsTableAnchor.constant = self.view.frame.width
                self.paymentTableAnchor.constant = self.view.frame.width
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func parkingPressed(sender: UIButton) {
        parkingPressedFunc()
    }
    
    func parkingPressedFunc() {
//        self.delegate?.closeExtendTimeView()
        UIView.animate(withDuration: 0.2, animations: {
            self.segmentLineLeftAnchor1.isActive = false
            self.segmentLineLeftAnchor2.isActive = true
            self.segmentLineLeftAnchor3.isActive = false
            self.currentTableView.alpha = 0
            self.detailsTableView.alpha = 1
            self.paymentTableView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: 0.2, animations: {
                self.currentTableAnchor.constant = self.view.frame.width
                self.detailsTableAnchor.constant =  0
                self.paymentTableAnchor.constant = self.view.frame.width
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func vehiclePressed(sender: UIButton) {
        vehiclePressedFunc()
    }
    
    func vehiclePressedFunc() {
//        self.delegate?.closeExtendTimeView()
        UIView.animate(withDuration: 0.2, animations: {
            self.segmentLineLeftAnchor1.isActive = false
            self.segmentLineLeftAnchor2.isActive = false
            self.segmentLineLeftAnchor3.isActive = true
            self.currentTableView.alpha = 0
            self.detailsTableView.alpha = 0
            self.paymentTableView.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: 0.2, animations: {
                self.currentTableAnchor.constant = self.view.frame.width
                self.detailsTableAnchor.constant = self.view.frame.width
                self.paymentTableAnchor.constant = 0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    
    @objc func segmentRight(sender: UISwipeGestureRecognizer) {
        if segmentLineLeftAnchor3.isActive == true {
            self.parkingPressedFunc()
        } else if segmentLineLeftAnchor2.isActive == true {
            self.recentPressedFunc()
        }
    }
    
    @objc func segmentLeft(sender: UISwipeGestureRecognizer) {
        if segmentLineLeftAnchor1.isActive == true {
            self.parkingPressedFunc()
        } else if segmentLineLeftAnchor2.isActive == true {
            self.vehiclePressedFunc()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == currentTableView {
            return Current.count
        } else if tableView == detailsTableView {
            return Details.count
        } else {
            return Payment.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        cell.textLabel?.textAlignment = .right
        
        if tableView == currentTableView {
            cell.textLabel?.text = Current[indexPath.row]
            cell.separatorInset = UIEdgeInsets(top: 0, left: 160, bottom: 0, right: 10)
            if indexPath.row == (Current.count-1) {
                cell.textLabel?.textColor = Theme.HARMONY_RED
            } else if indexPath.row == 0 {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
                cell.textLabel?.textColor = Theme.DARK_GRAY
            }
            else {
                cell.textLabel?.textColor = Theme.DARK_GRAY
            }
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            
            return cell
        } else if tableView == detailsTableView {
            cell.textLabel?.text = Details[indexPath.row]
            cell.textLabel?.textColor = Theme.SEA_BLUE
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            self.detailsTableView.separatorStyle = .none
            
            if indexPath.row == 0 {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 100)
            }
            
            return cell
        } else {
            cell.textLabel?.text = Payment[indexPath.row]
            cell.textLabel?.textColor = Theme.DARK_GRAY
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == currentTableView {
            if indexPath.row == (Current.count-1) {
                self.leaveAReview()
                self.delegate?.closeExtendTimeView()
            } else if indexPath.row == (Current.count-2) {
                self.delegate?.closeExtendTimeView()
                if self.Current[indexPath.row] == "Open navigation" {
                    self.navigationDelegate?.openNavigation()
                    self.Current = ["Extend time", "Close navigation", "Leave parking spot"]
                    self.currentTableView.reloadData()
                } else {
                    self.navigationDelegate?.closeNavigation()
                    self.Current = ["Extend time", "Open navigation", "Leave parking spot"]
                    self.currentTableView.reloadData()
                }
            } else if indexPath.row == (Current.count-3) {
                self.extendTime()
            }
        } else if tableView == detailsTableView {
            if indexPath.row == (Details.count-1) {
                self.delegate?.closeExtendTimeView()
                self.delegate?.openMessages()
                self.setUserMessage()
            }
        }
    }
    
    func setUserMessage() {
        let ref = Database.database().reference().child("parking").child(self.parkingID!)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                if let userId = dictionary["id"] as? String {
                    let ref = Database.database().reference()
                    let toID = userId
                    let fromID = Auth.auth().currentUser!.uid
                    let timestamp = Int(Date().timeIntervalSince1970)
                    
                    let childRef = ref.child("messages").child(fromID)
                    var values = ["toID": toID, "fromID": fromID, "timestamp": timestamp] as [String : Any]
                    
                    let properties = ["text": "This is the beginning of your message history."] as [String : AnyObject]
                    properties.forEach({values[$0] = $1})
                    childRef.updateChildValues(values) { (error, ralf) in
                        if error != nil {
                            print(error ?? "")
                            return
                        }
                        if let messageId = childRef.key {
                            let vals = [messageId: 1] as [String: Int]
                            
                            let userMessagesRef = ref.child("user-messages").child(fromID).child(toID)
                            userMessagesRef.updateChildValues(vals)
                            
                            let recipientUserMessagesRef = ref.child("user-messages").child(toID).child(fromID)
                            recipientUserMessagesRef.updateChildValues(vals)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            childRef.removeValue()
                        }
                    }
                }
            }
        }
    }
    
    var users = [Users]()
    var messagesController: UserMessagesViewController = UserMessagesViewController()
    
    func leaveAReview() {
        let alert = UIAlertController(title: "Confirm", message: "Please confirm that you have left the parking space. If you confirm and have not actually left within a certain time you risk being towed.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (pressed) in
            self.endCurrentParking()
            self.delegate?.setupLeaveAReview()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func sendLeaveReview() {
        self.delegate?.setupLeaveAReview()
    }
    
    func endCurrentParking() {
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("users").child(currentUser).child("currentParking")
        let parkingRef = Database.database().reference().child("parking").child(self.parkingID!).child("Current").child(currentUser)
        ref.removeValue()
        parkingRef.removeValue()
        
        timerStarted = false
        notificationSent = false
        currentParking = false
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func extendTime() {
        self.delegate?.extendTimeView()
    }
    
    
}
