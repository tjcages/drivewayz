//
//  AccountSlideViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 9/16/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FacebookLogin
import Cosmos

class AccountSlideViewController: UIViewController, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var delegate: controlsAccountOptions?
    var moveDelegate: moveControllers?
    
    var options: [String] = ["Book a spot", "My bookings", "Become a host", "Contact us", "Help", "Settings"]
    let cellId = "cellId"
    var selectedIndex: Int = 0 {
        didSet {
            optionsTableView.reloadData()
        }
    }
    
    lazy var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.clipsToBounds = false
        
        return view
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.decelerationRate = .fast
        view.clipsToBounds = false
        
        return view
    }()
    
    var profileImageView: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: "background4")?.withRenderingMode(.alwaysTemplate)
        view.image = image
        view.tintColor = lineColor
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.backgroundColor = Theme.PRUSSIAN_BLUE
        view.layer.cornerRadius = 50
        view.clipsToBounds = true
        
        return view
    }()
    
    var profileView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE
        view.clipsToBounds = true
        view.layer.cornerRadius = 52
        
        return view
    }()
    
    var profileName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.textAlignment = .center
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var stars: CosmosView = {
        let view = CosmosView()
        view.rating = 5.0
        view.settings.fillMode = .precise
        view.settings.updateOnTouch = false
        view.settings.starSize = 16
        view.settings.starMargin = 2
        view.settings.filledColor = Theme.GOLD
        view.settings.emptyBorderColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        view.settings.filledBorderColor = Theme.GOLD
        view.settings.emptyColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.settings.filledImage = UIImage(named: "Star Filled")?.withRenderingMode(.alwaysOriginal)
        view.settings.emptyImage = UIImage(named: "Star Empty")?.withRenderingMode(.alwaysOriginal)
        view.settings.textFont = Fonts.SSPRegularH5
        view.settings.textColor = Theme.WHITE
        view.text = "5.0"
        
        return view
    }()
    
    var profileLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY
        
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = lineColor
        view.addSubview(line)
        line.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        line.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        line.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        return view
    }()
    
    var optionsTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.separatorStyle = .none
        view.register(OptionsCell.self, forCellReuseIdentifier: "cellId")
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 110, right: 0)
        view.contentOffset = CGPoint.zero
        view.decelerationRate = .fast
        view.showsVerticalScrollIndicator = false
        view.clipsToBounds = false
        view.isScrollEnabled = false
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        
        optionsTableView.delegate = self
        optionsTableView.dataSource = self

        setupMainView()
        setupTopView()
        fetchUser()
        configureHosts()
        observeCorrectID()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupMainView() {
        
        view.addSubview(container)
        container.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        container.widthAnchor.constraint(equalToConstant: phoneWidth/2 + 80).isActive = true
        container.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth/2 + 80, height: 840)
        scrollView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        
    }
    
    func setupTopView() {
        
        scrollView.addSubview(profileLine)
        scrollView.addSubview(profileView)
        scrollView.addSubview(profileImageView)
        
        profileImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 32).isActive = true
        
        profileView.anchor(top: profileImageView.topAnchor, left: profileImageView.leftAnchor, bottom: profileImageView.bottomAnchor, right: profileImageView.rightAnchor, paddingTop: -2, paddingLeft: -2, paddingBottom: -2, paddingRight: -2, width: 0, height: 0)
        
        scrollView.addSubview(profileName)
        profileName.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        profileName.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 2).isActive = true
        profileName.widthAnchor.constraint(lessThanOrEqualToConstant: 400).isActive = true
        profileName.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(stars)
        stars.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: 2).isActive = true
        stars.leftAnchor.constraint(equalTo: profileName.leftAnchor).isActive = true
        stars.heightAnchor.constraint(equalToConstant: 20).isActive = true
        stars.sizeToFit()
        
        scrollView.addSubview(optionsTableView)
        optionsTableView.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        optionsTableView.topAnchor.constraint(equalTo: stars.bottomAnchor, constant: 44).isActive = true
        optionsTableView.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        optionsTableView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        
        profileLine.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        profileLine.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        profileLine.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        profileLine.bottomAnchor.constraint(equalTo: optionsTableView.topAnchor, constant: -12).isActive = true
    
    }
    
    func openAccountView() {
        self.delegate?.openAccountView()
    }
    
    func fetchUser() {
        if let isUserName: String = UserDefaults.standard.object(forKey: "userName") as? String {
            self.profileName.text = isUserName
            self.stars.alpha = 1
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
                    self.stars.alpha = 1
                }
                if let email = dictionary["email"] as? String {
                    userEmail = email
                }
                if let userPicture = dictionary["picture"] as? String {
                    if userPicture == "" {
                        self.profileImageView.image = UIImage(named: "background4")
                    } else {
                        self.profileImageView.loadImageUsingCacheWithUrlString(userPicture) { (bool) in
                            if !bool {
                                self.profileImageView.image = UIImage(named: "background4")
                            }
                        }
                    }
                }
                if let userRating = dictionary["rating"] as? Double {
                    self.stars.rating = userRating
                    self.stars.text = String(format:"%.01f", userRating)
                } else {
                    self.stars.rating = 5.0
                    self.stars.text = "5.0"
                }
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.options.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = optionsTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! OptionsCell
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
        self.optionsTableView.reloadData()
        delayWithSeconds(animationOut) {
            self.optionsTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            self.optionsTableView.delegate?.tableView!(self.optionsTableView, didSelectRowAt: indexPath)
        }
    }
    
    var analControllerAnchor: NSLayoutConstraint!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        delayWithSeconds(animationIn) {
            if tableView == self.optionsTableView {
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
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(currentUser).child("Hosting Spots")
        ref.observe(.childAdded) { (snapshot) in
            self.options = ["Book a spot", "My bookings", "Hosted spaces", "Contact us", "Help", "Settings"]
            self.optionsTableView.reloadData()
        }
        ref.observe(.childRemoved) { (snapshot) in
            self.options = ["Book a spot", "My bookings", "Become a host", "Contact us", "Help", "Settings"]
            self.delegate?.closeAccountView()
//            self.delegate?.hideHostingController()
            self.optionsTableView.reloadData()
        }
    }
    
    func observeCorrectID() {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("ConfirmedID")
        ref.observe(.childAdded) { (snapshot) in
            if let key = snapshot.value as? String {
                if key == currentUser {
                    if self.options.contains("Become a host") {
                        self.options = ["Book a spot", "My bookings", "Become a host", "Contact us", "Analytics", "Help", "Settings"]
                        self.optionsTableView.reloadData()
                    } else {
                        self.options = ["Book a spot", "My bookings", "Hosted spaces", "Contact us", "Analytics", "Help", "Settings"]
                        self.optionsTableView.reloadData()
                    }
                }
            }
        }
    }

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
