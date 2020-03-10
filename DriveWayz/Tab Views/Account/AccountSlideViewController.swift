//
//  AccountSlideViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 9/16/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import SVGKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FacebookLogin

class AccountSlideViewController: UIViewController {
    
    var delegate: controlsAccountOptions?
    var moveDelegate: moveControllers?
    
    var options: [String] = ["Book a spot", "Contact us", "Help", "Settings"]
    let cellId = "cellId"
    var selectedIndex: Int = 0 {
        didSet {
            tableView.reloadData()
        }
    }
    
    var profileIcon: SVGKImageView = {
        let image = SVGKImage(named: "MaleProfile_2")
        let view = SVGKFastImageView(svgkImage: image)!
        view.translatesAutoresizingMaskIntoConstraints = false
        view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        return view
    }()
    
    var profileName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH2
        
        return label
    }()
    
    var profileButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("View profile", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.separatorStyle = .none
        view.register(OptionsCell.self, forCellReuseIdentifier: "cellId")
        view.decelerationRate = .fast
        view.showsVerticalScrollIndicator = false
        view.delegate = self
        view.dataSource = self
        view.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 20, right: 0)
        
        return view
    }()
    
    var bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        
        return view
    }()
    
    var helpButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Help Center", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    var parkingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Free parking", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.contentHorizontalAlignment = .left
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE

        setupViews()
        setupBottom()
        
        fetchUser()
//        configureHosts()
        observeCorrectID()
    }
    
    func setupViews() {
        
        view.addSubview(profileIcon)
        view.addSubview(profileName)
        view.addSubview(profileButton)
        view.addSubview(line)
        
        profileIcon.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 32, paddingBottom: 0, paddingRight: 0, width: 60, height: 60)
        
        profileName.leftAnchor.constraint(equalTo: profileIcon.leftAnchor).isActive = true
        profileName.topAnchor.constraint(equalTo: profileIcon.bottomAnchor, constant: 20).isActive = true
        profileName.sizeToFit()
        
        profileButton.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: 0).isActive = true
        profileButton.leftAnchor.constraint(equalTo: profileIcon.leftAnchor).isActive = true
        profileButton.sizeToFit()
        
        line.anchor(top: profileButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
    
    }
    
    func setupBottom() {
        
        view.addSubview(tableView)
        view.addSubview(bottomView)
        view.addSubview(helpButton)
        view.addSubview(parkingButton)
        
        parkingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        parkingButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        parkingButton.sizeToFit()
        
        helpButton.bottomAnchor.constraint(equalTo: parkingButton.topAnchor, constant: -20).isActive = true
        helpButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        helpButton.sizeToFit()
        
        bottomView.anchor(top: helpButton.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: -20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        tableView.anchor(top: line.bottomAnchor, left: view.leftAnchor, bottom: bottomView.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    func openAccountView() {
        delegate?.openAccountView()
    }
    
    func fetchUser() {
        if let isUserName: String = UserDefaults.standard.object(forKey: "userName") as? String {
            self.profileName.text = isUserName
        }
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                if let userName = dictionary["name"] as? String {
                    self.profileName.text = userName
                    UserDefaults.standard.set(userName, forKey: "userName")
                    UserDefaults.standard.synchronize()
                }
//                if let email = dictionary["email"] as? String {
//                    userEmail = email
//                }
//                if let userPicture = dictionary["picture"] as? String {
//                    if userPicture == "" {
//                        self.profileImageView.image = UIImage(named: "background4")
//                    } else {
//                        self.profileImageView.loadImageUsingCacheWithUrlString(userPicture) { (bool) in
//                            if !bool {
//                                self.profileImageView.image = UIImage(named: "background4")
//                            }
//                        }
//                    }
//                }
            }
        }, withCancel: nil)
        return
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
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func goBackToMap() {
        self.delegate?.moveToMap()
    }
    
    func displayAlertMessage(userMessage: String, title: String) {
        let alert = UIAlertController(title: title, message: userMessage, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func configureHosts() {
//        guard let currentUser = Auth.auth().currentUser?.uid else { return }
//        let ref = Database.database().reference().child("users").child(currentUser).child("Hosting Spots")
//        ref.observe(.childAdded) { (snapshot) in
//            self.options = ["Book a spot", "My bookings", "Hosted spaces", "Contact us", "Help", "Settings"]
//            self.tableView.reloadData()
//        }
//        ref.observe(.childRemoved) { (snapshot) in
//            self.options = ["Book a spot", "My bookings", "Become a host", "Contact us", "Help", "Settings"]
//            self.delegate?.closeAccountView()
////            self.delegate?.hideHostingController()
//            self.tableView.reloadData()
//        }
    }
    
    func observeCorrectID() {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("ConfirmedID")
        ref.observe(.childAdded) { (snapshot) in
            if let key = snapshot.value as? String {
                if key == currentUser {
                    self.options = ["Book a spot", "Contact us", "Analytics", "Help", "Settings"]
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension AccountSlideViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.options.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = options[indexPath.row]
        if message == "Contact us" {
            return 72
        } else {
            return 64
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! OptionsCell
        cell.message = options[indexPath.row]
        if cell.message == "Contact us" {
            cell.openSubText()
            cell.subTextView.text = "Share your feedback"
        } else {
            cell.closeSubText()
        }
        cell.selectionStyle = .none
        if self.selectedIndex == indexPath.row {
            cell.animate()
            cell.clipsToBounds = false
        } else {
            cell.clipsToBounds = true
        }
        
        return cell
    }
    
    func forceSelectBook() {
        let indexPath = IndexPath(row: 0, section: 0)
        self.selectedIndex = indexPath.row
        self.tableView.reloadData()
        delayWithSeconds(animationOut) {
            self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            self.tableView.delegate?.tableView!(self.tableView, didSelectRowAt: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        delayWithSeconds(animationIn) {
            if tableView == self.tableView {
                if self.options[indexPath.row] == "My bookings" {
                    self.openAccountView()
                    self.delegate?.bringUpcomingController()
                } else if self.options[indexPath.row] == "Hosted spaces" {
                    self.openAccountView()
                    self.delegate?.bringHostingController()
                } else if self.options[indexPath.row] == "Become a host" {
                    self.openAccountView()
                    self.delegate?.bringNewHostingController()
                } else if self.options[indexPath.row] == "Settings" {
                    self.openAccountView()
                    self.delegate?.bringSettingsController()
                } else if self.options[indexPath.row] == "Help" {
                    self.openAccountView()
                    self.delegate?.bringHelpController()
                } else if self.options[indexPath.row] == "Book a spot" {
                    self.delegate?.moveToMap()
                } else if self.options[indexPath.row] == "Contact us" {
                    self.delegate?.bringFeedbackController()
                } else if self.options[indexPath.row] == "Analytics" {
                    self.delegate?.bringAnalyticsController()
                }
            } else {
                self.delegate?.moveToMap()
            }
        }
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
