//
//  UserParkingViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 7/9/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase

protocol sendBankAccount {
    func sendBankAccount()
}

class UserParkingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, sendBankAccount {
    
    enum UserState {
        case current
        case none
    }
    var userState: UserState = UserState.current
    
    var delegate: handleCurrentParking?
//    var parkingDelegate: controlsNewParking?
//    var viewDelegate: controlsAccountViews?
    var bankDelegate: controlsBankAccount?
    
    lazy var earningsController: DataChartsViewController = {
        let controller = DataChartsViewController()
        self.addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        controller.title = "Charts"
        return controller
    }()
    
    lazy var availabilityController: PersonalAvailabilityViewController = {
        let controller = PersonalAvailabilityViewController()
        self.addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Availability"
        return controller
    }()
    
    var newParkingPage: UIView = {
        let newParkingPage = UIView()
        newParkingPage.backgroundColor = UIColor.white
        newParkingPage.translatesAutoresizingMaskIntoConstraints = false
        newParkingPage.layer.shadowColor = UIColor.darkGray.cgColor
        newParkingPage.layer.shadowOffset = CGSize(width: 0, height: 1)
        newParkingPage.layer.shadowOpacity = 0.8
        newParkingPage.layer.cornerRadius = 10
        newParkingPage.layer.shadowRadius = 1
        
        return newParkingPage
    }()
    
    var addParkingButton: UIButton = {
        let addParkingButton = UIButton(type: .custom)
        let image = UIImage(named: "Plus")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        addParkingButton.setImage(tintedImage, for: .normal)
        addParkingButton.tintColor = Theme.DARK_GRAY
        addParkingButton.translatesAutoresizingMaskIntoConstraints = false
        addParkingButton.layer.borderColor = Theme.DARK_GRAY.cgColor
        addParkingButton.layer.borderWidth = 1
        addParkingButton.layer.cornerRadius = 20
        addParkingButton.addTarget(self, action:#selector(addAParkingButtonPressed(sender:)), for: .touchUpInside)
        addParkingButton.alpha = 0
        
        return addParkingButton
    }()
    
    var addParkingLabel: UILabel = {
        let addParkingLabel = UILabel()
        addParkingLabel.text = "Add a new Parking Spot"
        addParkingLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        addParkingLabel.textColor = Theme.DARK_GRAY
        addParkingLabel.translatesAutoresizingMaskIntoConstraints = false
        addParkingLabel.textAlignment = .center
        addParkingLabel.alpha = 0
        addParkingLabel.isUserInteractionEnabled = true
        
        return addParkingLabel
    }()
    
    lazy var currentParkingImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: 290))
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.white
        imageView.clipsToBounds = true
        imageView.alpha = 0
        
        return imageView
    }()
    
    var parkingInfo: UITextView = {
        let label = UITextView()
        label.text = "Parking Info"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = Theme.DARK_GRAY
        label.backgroundColor = UIColor.clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .top
        label.textAlignment = .left
        label.isUserInteractionEnabled = false
        label.alpha = 0
        
        return label
    }()
    
    var parkingCost: UITextField = {
        let label = UITextField()
        label.text = "Cost"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = Theme.PRIMARY_DARK_COLOR
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .left
        label.isUserInteractionEnabled = false
        label.alpha = 0
        
        return label
    }()
    
    var parkingDate: UITextField = {
        let label = UITextField()
        label.text = "Date"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .left
        label.isUserInteractionEnabled = false
        label.alpha = 0
        
        return label
    }()
    
    var editingContainer: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.white
        container.translatesAutoresizingMaskIntoConstraints = false
//        container.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.5).cgColor
//        container.layer.borderWidth = 0.5
//        container.layer.cornerRadius = 10
        container.layer.shadowColor = UIColor.darkGray.cgColor
        container.layer.shadowOffset = CGSize(width: 0, height: 1)
        container.layer.shadowOpacity = 0.8
        container.layer.cornerRadius = 10
        container.layer.shadowRadius = 1
        container.alpha = 0
        
        return container
    }()
    
    var editingTableView: UITableView = {
        let editing = UITableView()
        editing.translatesAutoresizingMaskIntoConstraints = false
        editing.backgroundColor = UIColor.clear
        editing.isScrollEnabled = false
        editing.isUserInteractionEnabled = true
        editing.alpha = 0
        
        return editing
    }()
    
    var line: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.3)
        line.alpha = 0
        
        return line
    }()
    
    var Edits = ["Make unavailable", "Edit hourly cost", "Edit availability", "Retake picture", "Delete host spot"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        editingTableView.delegate = self
        editingTableView.dataSource = self

        setupViews()
        fetchUserAndSetupParking()
    }
    
    var checkForParking: Bool = true
    
    func fetchUserAndSetupParking() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("users").child(uid).child("Parking")
        ref.observe(.childAdded) { (snapshot) in
            self.checkForParking = false
            let userParkingID = snapshot.value as? String
            if userParkingID != nil {
                parking = parking + 1
            } else { parking = 0 }
            if userParkingID != nil {
                Database.database().reference().child("parking").child(userParkingID!).observeSingleEvent(of: .value, with: { (snap) in
                    if let dictionary = snap.value as? [String:AnyObject] {
                        let parkingAddress = dictionary["parkingAddress"] as? String
                        let parkingImageURL = dictionary["parkingImageURL"] as? String
                        let parkingCost = dictionary["parkingCost"] as? String
                        let timestamp = dictionary["timestamp"] as? TimeInterval
                        
                        if parkingImageURL == nil {
                            self.currentParkingImageView.image = UIImage(named: "profileprofile")
                        } else {
                            self.currentParkingImageView.loadImageUsingCacheWithUrlString(parkingImageURL!)
                        }
                        
                        self.parkingInfo.text = parkingAddress!
                        self.parkingCost.text = parkingCost!
                        
                        let date = Date(timeIntervalSince1970: timestamp!)
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = NSLocale.current
                        dateFormatter.dateFormat = "MM/dd/yyyy"
                        let stringDate = dateFormatter.string(from: date)
                        
                        self.parkingDate.text = "Hosting since:  \(stringDate)"
                        
                        self.setupCurrentViews(state: .current)
                    }
                }, withCancel: nil)
            }
        }
        ref.observe(.childRemoved) { (snapshot) in
            self.setupCurrentViews(state: .none)
        }
        if self.checkForParking == true {
            self.setupCurrentViews(state: .none)
        }
    }
    
    func setupCurrentViews(state: UserState) {
        switch state {
        case .current:
            self.setupCurrent()
//            self.delegate?.changeCurrentView(height: 475)
        case .none:
            self.setupNoView()
//            self.delegate?.changeCurrentView(height: 100)
        }
    }
    
    var containerHeight: NSLayoutConstraint!
    var containerTopAnchor: NSLayoutConstraint!
    var alertInsetAnchor: NSLayoutConstraint!
    var parkingPageHeightAnchorSmall: NSLayoutConstraint!
    var parkingPageHeightAnchorTall: NSLayoutConstraint!
    var parkingTopAnchorTall: NSLayoutConstraint!
    var parkingTopAnchorSmall: NSLayoutConstraint!
    
    func setupViews() {
        self.view.addSubview(newParkingPage)
        self.view.sendSubview(toBack: newParkingPage)
        
        newParkingPage.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        newParkingPage.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        parkingTopAnchorSmall = newParkingPage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 25)
            parkingTopAnchorSmall.isActive = true
        parkingTopAnchorTall = newParkingPage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 345)
            parkingTopAnchorTall.isActive = false
        parkingPageHeightAnchorSmall = newParkingPage.heightAnchor.constraint(equalToConstant: 50)
        parkingPageHeightAnchorTall = newParkingPage.heightAnchor.constraint(equalToConstant: 680)
        
        newParkingPage.addSubview(addParkingButton)
        addParkingButton.leftAnchor.constraint(equalTo: newParkingPage.leftAnchor, constant: 8).isActive = true
        addParkingButton.bottomAnchor.constraint(equalTo: newParkingPage.bottomAnchor, constant: -4).isActive = true
        addParkingButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        addParkingButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        newParkingPage.addSubview(addParkingLabel)
        addParkingLabel.centerXAnchor.constraint(equalTo: newParkingPage.centerXAnchor).isActive = true
        addParkingLabel.centerYAnchor.constraint(equalTo: addParkingButton.centerYAnchor).isActive = true
        addParkingLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addParkingLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(addAParkingButtonTapped(sender:)))
        addParkingLabel.addGestureRecognizer(gesture)

        newParkingPage.addSubview(parkingInfo)
        parkingInfo.leftAnchor.constraint(equalTo: newParkingPage.leftAnchor, constant: 15).isActive = true
        parkingInfo.topAnchor.constraint(equalTo: newParkingPage.topAnchor, constant: 5).isActive = true
        parkingInfo.widthAnchor.constraint(equalTo: newParkingPage.widthAnchor, constant: -20).isActive = true
        parkingInfo.heightAnchor.constraint(equalToConstant: 60).isActive = true

        newParkingPage.addSubview(parkingCost)
        parkingCost.leftAnchor.constraint(equalTo: newParkingPage.leftAnchor, constant: 20).isActive = true
        parkingCost.topAnchor.constraint(equalTo: parkingInfo.bottomAnchor, constant: -15).isActive = true
        parkingCost.widthAnchor.constraint(equalToConstant: 100).isActive = true
        parkingCost.heightAnchor.constraint(equalToConstant: 30).isActive = true

        newParkingPage.addSubview(parkingDate)
        parkingDate.leftAnchor.constraint(equalTo: newParkingPage.leftAnchor, constant: 20).isActive = true
        parkingDate.topAnchor.constraint(equalTo: parkingCost.bottomAnchor, constant: -5).isActive = true
        parkingDate.widthAnchor.constraint(equalTo: newParkingPage.widthAnchor, constant: -20).isActive = true
        parkingDate.heightAnchor.constraint(equalToConstant: 30).isActive = true

        newParkingPage.addSubview(line)
        line.topAnchor.constraint(equalTo: parkingDate.bottomAnchor, constant: 5).isActive = true
        line.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        line.widthAnchor.constraint(equalTo: newParkingPage.widthAnchor).isActive = true
        line.centerXAnchor.constraint(equalTo: newParkingPage.centerXAnchor).isActive = true

        newParkingPage.addSubview(currentParkingImageView)
        currentParkingImageView.leftAnchor.constraint(equalTo: newParkingPage.leftAnchor).isActive = true
        currentParkingImageView.topAnchor.constraint(equalTo: parkingDate.bottomAnchor, constant: 290).isActive = true
        currentParkingImageView.rightAnchor.constraint(equalTo: newParkingPage.rightAnchor).isActive = true
        currentParkingImageView.heightAnchor.constraint(equalToConstant: 290).isActive = true

        self.view.addSubview(editingContainer)
        editingContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        editingContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        editingContainer.topAnchor.constraint(equalTo: newParkingPage.bottomAnchor, constant: 20).isActive = true
        editingContainer.heightAnchor.constraint(equalToConstant: 220).isActive = true

        editingContainer.addSubview(editingTableView)
        editingTableView.leftAnchor.constraint(equalTo: editingContainer.leftAnchor, constant: 5).isActive = true
        editingTableView.rightAnchor.constraint(equalTo: editingContainer.rightAnchor, constant: -5).isActive = true
        editingTableView.topAnchor.constraint(equalTo: editingContainer.topAnchor, constant: 0).isActive = true
        editingTableView.bottomAnchor.constraint(equalTo: editingContainer.bottomAnchor, constant: -5).isActive = true
        
    }

    func setupCurrent() {
        UIView.animate(withDuration: 0.3, animations: {
            self.parkingPageHeightAnchorTall.isActive = true
            self.parkingPageHeightAnchorSmall.isActive = false
            self.parkingTopAnchorTall.isActive = true
            self.parkingTopAnchorSmall.isActive = false
            self.addParkingButton.alpha = 0
            self.addParkingLabel.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: 0.3, animations: {
                self.parkingInfo.alpha = 1
                self.parkingCost.alpha = 1
                self.parkingDate.alpha = 1
                self.currentParkingImageView.alpha = 1
                self.editingContainer.alpha = 1
                self.editingTableView.alpha = 1
                self.line.alpha = 1
                self.view.layoutIfNeeded()
            }) { (success) in
                
                self.view.addSubview(self.earningsController.view)
                self.earningsController.didMove(toParentViewController: self)
                self.addChildViewController(self.earningsController)
                self.earningsController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                self.earningsController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
                self.earningsController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
                self.earningsController.view.heightAnchor.constraint(equalToConstant: 360).isActive = true
                
                self.view.addSubview(self.availabilityController.view)
                self.availabilityController.didMove(toParentViewController: self)
                self.availabilityController.view.centerXAnchor.constraint(equalTo: self.earningsController.view.centerXAnchor).isActive = true
                self.availabilityController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
                self.availabilityController.view.topAnchor.constraint(equalTo: self.earningsController.view.bottomAnchor, constant: 110).isActive = true
                self.availabilityController.view.heightAnchor.constraint(equalToConstant: 275).isActive = true
            }
        }
    }

    func setupNoView() {
        self.earningsController.willMove(toParentViewController: nil)
        self.earningsController.view.removeFromSuperview()
        self.earningsController.removeFromParentViewController()
        self.availabilityController.willMove(toParentViewController: nil)
        self.availabilityController.view.removeFromSuperview()
        self.availabilityController.removeFromParentViewController()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.parkingPageHeightAnchorTall.isActive = false
            self.parkingPageHeightAnchorSmall.isActive = true
            self.parkingTopAnchorTall.isActive = false
            self.parkingTopAnchorSmall.isActive = true
            self.parkingInfo.alpha = 0
            self.parkingCost.alpha = 0
            self.parkingDate.alpha = 0
            self.currentParkingImageView.alpha = 0
            self.editingContainer.alpha = 0
            self.editingTableView.alpha = 0
            self.line.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: 0.3, animations: {
                self.addParkingButton.alpha = 1
                self.addParkingLabel.alpha = 1
                self.view.layoutIfNeeded()
            }) { (success) in

            }
        }
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference(fromURL: "https://drivewayz-e20b9.firebaseio.com")
        let usersRef = ref.child("users").child(uid)
        
        usersRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
        })
    }
    
    @objc func addAParkingButtonPressed(sender: UIButton) {
        self.delegate?.bringNewHostingController()
    }
    
    @objc func addAParkingButtonTapped(sender: UITapGestureRecognizer) {
        self.delegate?.bringNewHostingController()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Edits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = Edits[indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        cell.textLabel?.textAlignment = .center
        cell.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10)
        
        if indexPath.row == (Edits.count-1) {
            cell.textLabel?.textColor = Theme.HARMONY_COLOR
        } else {
            cell.textLabel?.textColor = Theme.PRIMARY_DARK_COLOR
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == (Edits.count-1) {
            sendAlert(title: "Confirm", message: "Are you sure you want to permanently delete your spot? You will lose all untransfered funds.", tag: 1)
        } else if indexPath.row == (Edits.count-2) {
            sendAlert(title: "Sorry..", message: "Currently this functionality is not available. We will let you know when this becomes available.", tag: 2)
//            sendAlert(message: "Are you sure you want to retake your spot's picture? This picture will be available to all users.", tag: 2)
        } else if indexPath.row == (Edits.count-3) {
            sendAlert(title: "Sorry..", message: "Currently this functionality is not available. We will let you know when this becomes available.", tag: 3)
//            sendAlert(message: "Are you sure you want to change your spot's availibility? This will take place immediately.", tag: 3)
        } else if indexPath.row == (Edits.count-4) {
            sendAlert(title: "Sorry..", message: "Currently this functionality is not available. We will let you know when this becomes available.", tag: 4)
//            sendAlert(message: "Are you sure you want to change the cost per hour of your spot? This will only take place if the spot is vacated.", tag: 4)
        } else if indexPath.row == (Edits.count-5) {
            sendAlert(title: "Sorry..", message: "Currently this functionality is not available. We will let you know when this becomes available.", tag: 5)
//            sendAlert(message: "Are you sure you'd like to make your spot unavailable for a while? You will need to manually set it back to available.", tag: 5)
        }
    }
    
    func sendAlert(title: String, message: String, tag: Int) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (true) in
            let userId = Auth.auth().currentUser?.uid
            let userRef = Database.database().reference().child("users").child(userId!)
            userRef.observeSingleEvent(of: .value) { (snapshot) in
                let checkRef = userRef.child("Parking")
                checkRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String:AnyObject] {
                        let parkingID = dictionary["parkingID"] as? String
                        let userParkingRef = Database.database().reference().child("user-parking").child(parkingID!)
                        let parkingRef = Database.database().reference().child("parking").child(parkingID!)
                        if tag == 1 {
                            userRef.child("parkingID").removeValue()
                            userRef.child("Parking").removeValue()
                            userRef.child("parkingImageURL").removeValue()
                            userRef.child("Payments").removeValue()
                            userRef.child("userFunds").removeValue()
                            userRef.child("hostHours").removeValue()
                            userParkingRef.removeValue()
                            parkingRef.removeValue()
                            parking = 0
                            self.delegate?.changeCurrentView(height: 0)
                        } else if tag == 2 {
                            
                        } else if tag == 3 {
                            
                        } else if tag == 4 {
                            
                        } else if tag == 5 {
                            
                        }
                    }
                })
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func sendBankAccount() {
        self.bankDelegate?.setupBankAccount()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
