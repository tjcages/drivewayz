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
import GoogleSignIn
import FirebaseInvites

class AccountSlideViewController: UIViewController, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, GIDSignInUIDelegate, InviteDelegate, GIDSignInDelegate {
    
    var delegate: controlsAccountOptions?
    var moveDelegate: moveControllers?
    
    enum emailConfirmation {
        case confirmed
        case unconfirmed
    }
    var emailConfirmed: emailConfirmation = .unconfirmed
    
    var options: [String] = ["Home", "Reservations", "Hosting", "Vehicle", "Messages", "Coupons", "Contact us!", "Logout"]
    var terms: [String] = ["Terms"]
    var optionsImages: [UIImage] = [UIImage(named: "Home")!, UIImage(named: "parkingIcon")!, UIImage(named: "analytics")!, UIImage(named: "vehicle")!, UIImage(named: "account")!, UIImage(named: "coupon")!, UIImage(named: "contactUs")!, UIImage(named: "logout")!, UIImage(named: "terms")!]
    let cellId = "cellId"
    
    lazy var container: UIView = {
        let view = UIView()
        view.layer.shadowRadius = 5
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: -1, height: 1)
        view.layer.shadowOpacity = 0.8
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.roundCorners(corners: .topLeft, radius: 10)
        view.backgroundColor = Theme.SEA_BLUE
        
        return view
    }()
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "background4")
        imageView.image = image
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.white
        imageView.layer.borderColor = Theme.HARMONY_RED.cgColor
        imageView.layer.borderWidth = 0.5
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    var imageView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 50
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    var profileName: UILabel = {
        let profileName = UILabel()
        profileName.translatesAutoresizingMaskIntoConstraints = false
        profileName.textColor = Theme.WHITE
        profileName.textAlignment = .center
        profileName.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        profileName.text = "Name"
        
        return profileName
    }()
    
    var profileLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        
        return view
    }()
    
    var optionsTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        view.separatorStyle = .none
        view.register(OptionsCell.self, forCellReuseIdentifier: "cellId")
        view.isScrollEnabled = false
        view.roundCorners(corners: .bottomLeft, radius: 10)
//        view.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        return view
    }()
    
    var termsTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.separatorStyle = .none
        view.register(OptionsCell.self, forCellReuseIdentifier: "cellId")
        view.isScrollEnabled = false
        view.roundCorners(corners: .bottomLeft, radius: 10)
        
        return view
    }()
    
    var termsLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Analytics"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 26, weight: .semibold)
        label.alpha = 0
        
        return label
    }()
    
    var hostingMark: UIButton = {
        let mark = UIButton()
        let image = UIImage(named: "Mark")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        mark.setImage(tintedImage, for: .normal)
        mark.tintColor = Theme.WHITE
        mark.backgroundColor = Theme.HARMONY_RED
        mark.layer.cornerRadius = 10
        mark.alpha = 0
        mark.translatesAutoresizingMaskIntoConstraints = false
        mark.imageEdgeInsets = UIEdgeInsets.init(top: 2, left: 0, bottom: 2, right: 0)
        
        return mark
    }()
    
    var upcomingMark: UIButton = {
        let mark = UIButton()
        let image = UIImage(named: "Mark")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        mark.setImage(tintedImage, for: .normal)
        mark.tintColor = Theme.WHITE
        mark.backgroundColor = Theme.HARMONY_RED
        mark.layer.cornerRadius = 10
        mark.alpha = 0
        mark.translatesAutoresizingMaskIntoConstraints = false
        mark.imageEdgeInsets = UIEdgeInsets.init(top: 2, left: 0, bottom: 2, right: 0)
        
        return mark
    }()
    
    var moreColorsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "moreColors"), for: .normal)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(blurEffectView)
        blurEffectView.leftAnchor.constraint(equalTo: button.leftAnchor).isActive = true
        blurEffectView.rightAnchor.constraint(equalTo: button.rightAnchor).isActive = true
        blurEffectView.topAnchor.constraint(equalTo: button.topAnchor).isActive = true
        blurEffectView.bottomAnchor.constraint(equalTo: button.bottomAnchor).isActive = true
        
        let label = UILabel()
        label.text = "Invite a friend and get 10% off!"
        label.textColor = Theme.WHITE
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(label)
        label.leftAnchor.constraint(equalTo: button.leftAnchor, constant: 12).isActive = true
        label.rightAnchor.constraint(equalTo: button.rightAnchor).isActive = true
        label.topAnchor.constraint(equalTo: button.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: button.bottomAnchor).isActive = true

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        
        self.optionsTableView.delegate = self
        self.optionsTableView.dataSource = self
        self.termsTableView.delegate = self
        self.termsTableView.dataSource = self

        setupMainView()
        setupTopView()
        fetchUser()
        setHomeIndex()
        checkForMarks()
        checkForUpcoming()
//        configureOptions()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var mainLabelAnchor: NSLayoutConstraint!
    
    func setupMainView() {
        
        self.view.addSubview(container)
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 5).isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 5).isActive = true
        container.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        mainLabelAnchor = mainLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 82)
            mainLabelAnchor.isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    func setupTopView() {
        
        container.addSubview(profileImageView)
        profileImageView.centerXAnchor.constraint(equalTo: container.centerXAnchor, constant: -self.view.frame.width/7).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        switch device {
        case .iphone8:
            profileImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 30).isActive = true
        case .iphoneX:
            profileImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: UIApplication.shared.statusBarFrame.height + 30).isActive = true
        }
        
        container.addSubview(imageView)
        imageView.leftAnchor.constraint(equalTo: profileImageView.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: profileImageView.rightAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: profileImageView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor).isActive = true
        
        container.addSubview(profileName)
        profileName.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        profileName.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 5).isActive = true
        profileName.widthAnchor.constraint(lessThanOrEqualToConstant: 400).isActive = true
        profileName.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        container.addSubview(profileLine)
        profileLine.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        profileLine.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        profileLine.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: 20).isActive = true
        profileLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        container.addSubview(moreColorsButton)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(inviteNewUser(sender:)))
        moreColorsButton.addGestureRecognizer(gesture)
        moreColorsButton.topAnchor.constraint(equalTo: profileLine.bottomAnchor, constant: -10).isActive = true
        moreColorsButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        moreColorsButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -self.view.frame.width/3.5).isActive = true
        moreColorsButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        container.addSubview(optionsTableView)
        optionsTableView.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        optionsTableView.topAnchor.constraint(equalTo: moreColorsButton.bottomAnchor).isActive = true
        optionsTableView.bottomAnchor.constraint(greaterThanOrEqualTo: container.bottomAnchor).isActive = true
//        optionsTableView.heightAnchor.constraint(equalToConstant: 360).isActive = true
        optionsTableView.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -self.view.frame.width/3.5).isActive = true
        
        container.addSubview(termsTableView)
        termsTableView.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        termsTableView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 0).isActive = true
        termsTableView.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -self.view.frame.width/3.5).isActive = true
        switch device {
        case .iphone8:
            termsTableView.heightAnchor.constraint(equalToConstant: 55).isActive = true
        case .iphoneX:
            termsTableView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        }
        
        container.addSubview(termsLine)
        termsLine.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        termsLine.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        termsLine.bottomAnchor.constraint(equalTo: termsTableView.topAnchor, constant: -10).isActive = true
        termsLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        container.addSubview(upcomingMark)
        upcomingMark.topAnchor.constraint(equalTo: optionsTableView.topAnchor, constant: 57.5).isActive = true
        upcomingMark.rightAnchor.constraint(equalTo: optionsTableView.rightAnchor, constant: -20).isActive = true
        upcomingMark.widthAnchor.constraint(equalToConstant: 20).isActive = true
        upcomingMark.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        container.addSubview(hostingMark)
        hostingMark.topAnchor.constraint(equalTo: optionsTableView.topAnchor, constant: 102.5).isActive = true
        hostingMark.rightAnchor.constraint(equalTo: optionsTableView.rightAnchor, constant: -20).isActive = true
        hostingMark.widthAnchor.constraint(equalToConstant: 20).isActive = true
        hostingMark.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    func openAccountView() {
        self.delegate?.openAccountView()
    }
    
    var addShouldShow: Bool = false
    var upcomingMarkShouldShow: Bool = false
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                if let userName = dictionary["name"] as? String {
                    self.profileName.text = userName
                }
                if let email = dictionary["email"] as? String {
                    userEmail = email
                }
                let userPicture = dictionary["picture"] as? String
                if userPicture == "" {
                    self.profileImageView.image = UIImage(named: "background4")
                    self.addShouldShow = true
                } else {
                    self.profileImageView.loadImageUsingCacheWithUrlString(userPicture!)
                    self.addShouldShow = false
                }
                if (dictionary["upcomingParking"] as? [String:AnyObject]) != nil {
                    self.upcomingMark.alpha = 1
                    self.upcomingMarkShouldShow = true
                } else {
                    self.upcomingMark.alpha = 0
                    self.upcomingMarkShouldShow = false
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
    
    var hostMarkShouldShow: Bool = false
    
    func checkForMarks() {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference()
        ref.child("users").child(currentUser).child("Parking").observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                if let parkingId = dictionary["parkingID"] as? String {
                    let parkingRef = ref.child("parking").child(parkingId).child("Current")
                    parkingRef.observe(.childAdded, with: { (park) in
                        self.hostingMark.alpha = 1
                        self.hostMarkShouldShow = true
                    })
                    parkingRef.observe(.childRemoved, with: { (park) in
                        self.hostingMark.alpha = 0
                        self.hostMarkShouldShow = false
                    })

                }
            }
        }
    }
    
    func checkForUpcoming() {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(currentUser).child("upcomingParking")
        ref.observe(.childAdded) { (snapshot) in
            self.upcomingMark.alpha = 1
            self.upcomingMarkShouldShow = true
            return
        }
        ref.observe(.childRemoved) { (snapshot) in
            self.upcomingMark.alpha = 0
            self.upcomingMarkShouldShow = false
            return
        }
        self.upcomingMark.alpha = 0
        self.upcomingMarkShouldShow = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == optionsTableView {
            return self.options.count
        } else {
            return self.terms.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = optionsTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! OptionsCell
        if tableView == optionsTableView {
            cell.messageTextView.text = options[indexPath.row]
            cell.profileImageView.setImage(optionsImages[indexPath.row], for: .normal)
            cell.imageView?.image = cell.imageView?.image?.withRenderingMode(.alwaysTemplate)
            cell.imageView?.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        } else {
            cell.messageTextView.text = terms[0]
            cell.profileImageView.setImage(optionsImages[optionsImages.count-1], for: .normal)
            cell.imageView?.image = cell.imageView?.image?.withRenderingMode(.alwaysTemplate)
            cell.imageView?.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        }
        cell.selectionStyle = .none
        
        return cell
    }
    
    var analControllerAnchor: NSLayoutConstraint!
    var previousCell: OptionsCell!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            self.hostingMark.alpha = 0
            self.upcomingMark.alpha = 0
        }
        if self.previousCell != nil {
            self.previousCell.messageTextView.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
            self.previousCell.imageView?.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
            self.previousCell.backgroundColor = UIColor.clear
            self.previousCell.messageTextView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        }
        if let cell = optionsTableView.cellForRow(at: indexPath) as? OptionsCell {
            cell.messageTextView.textColor = Theme.BLACK
            cell.imageView?.tintColor = Theme.PACIFIC_BLUE
            cell.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.05)
            cell.messageTextView.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            self.previousCell = cell
        }
        if tableView == optionsTableView {
            if options[indexPath.row] == "Reservations" {
                self.openAccountView()
                self.delegate?.bringUpcomingController()
            } else if options[indexPath.row] == "Hosting" {
                self.openAccountView()
                self.delegate?.bringHostingController()
            } else if options[indexPath.row] == "Vehicle" {
                self.openAccountView()
                self.delegate?.bringVehicleController()
            } else if options[indexPath.row] == "Messages" {
                if self.emailConfirmed == .confirmed {
                    self.openAccountView()
                    self.delegate?.bringAnalyticsController()
                } else {
                    self.openAccountView()
                    self.delegate?.bringMessagesController()
                }
            } else if options[indexPath.row] == "Coupons" {
                self.delegate?.moveToMap()
                self.delegate?.bringCouponsController()
            } else if options[indexPath.row] == "Contact us!" {
                self.delegate?.moveToMap()
                self.delegate?.bringContactUsController()
            } else if options[indexPath.row] == "Logout" {
                self.handleLogout()
            }  else if options[indexPath.row] == "Home" {
                self.delegate?.moveToMap()
            }
        } else {
            self.delegate?.moveToMap()
            self.delegate?.bringTermsController()
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.optionsTableView.deselectRow(at: indexPath, animated: true)
        if let cell = optionsTableView.cellForRow(at: indexPath) as? OptionsCell {
            cell.messageTextView.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
            cell.imageView?.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
            cell.backgroundColor = UIColor.clear
            cell.messageTextView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        }
    }
    
    func handleLogout() {
        do {
            try Auth.auth().signOut()
            let loginManager = LoginManager()
            loginManager.logOut()
        } catch let logoutError {
            print(logoutError)
        }
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        UserDefaults.standard.synchronize()
        let viewController: SignInViewController = SignInViewController()
        present(viewController, animated: true, completion: nil)
    }
    
    func displayAlertMessage(userMessage: String, title: String) {
        let alert = UIAlertController(title: title, message: userMessage, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func moveMainLabelUp() {
        UIView.animate(withDuration: 0.2) {
            self.mainLabelAnchor.constant = 48
            self.view.layoutIfNeeded()
        }
    }
    
    func moveMainLabelDown() {
        UIView.animate(withDuration: 0.2) {
            self.mainLabelAnchor.constant = 82
            self.view.layoutIfNeeded()
        }
    }
    
    func setHomeIndex() {
        if self.previousCell != nil {
            self.previousCell.messageTextView.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
            self.previousCell.imageView?.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
            self.previousCell.backgroundColor = UIColor.clear
            self.previousCell.messageTextView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        }
        if let cell = optionsTableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? OptionsCell {
            cell.messageTextView.textColor = Theme.BLACK
            cell.imageView?.tintColor = Theme.PACIFIC_BLUE
            cell.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.05)
            cell.messageTextView.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            self.previousCell = cell
        }
    }
    
    func configureOptions() {
        guard let currentUser = Auth.auth().currentUser?.email else { return }
        let ref = Database.database().reference().child("ConfirmedEmails")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String] {
                let count = dictionary.count
                for i in 0..<count {
                    let email = dictionary[i]
                    if email == currentUser {
                        self.emailConfirmed = .confirmed
                        self.options = ["Home", "Reservations", "Hosting", "Vehicle", "Analytics", "Coupons", "Contact us!", "Logout"]
                        self.optionsTableView.reloadData()
                        return
                    } else {
                        self.emailConfirmed = .unconfirmed
                        self.options = ["Home", "Reservations", "Hosting", "Vehicle", "Messages", "Coupons", "Contact us!", "Logout"]
                        self.optionsTableView.reloadData()
                    }
                }
            }
        }
    }
    
    func bringBankAccountOptions() {
        self.delegate?.bringBankAccountController()
    }
    
    @objc func inviteNewUser(sender: UITapGestureRecognizer) {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
    }
    
    func inviteFinished(withInvitations invitationIds: [String], error: Error?) {
        if let error = error {
            print("Failed: " + error.localizedDescription)
        } else {
            guard let currentUser = Auth.auth().currentUser?.uid else {return}
            let ref = Database.database().reference().child("users").child(currentUser).child("Coupons")
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    if (dictionary["invite10"] as? String) != nil {
                        let alert = UIAlertController(title: "Sorry!", message: "You can only get one 10% off coupon for sharing.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        return
                    } else {
                        ref.updateChildValues(["invite10": "10% off coupon!"])
                        let alert = UIAlertController(title: "Thanks for sharing!", message: "You have successfully invited your friend and recieved a 10% off coupon for your next rental!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if error != nil {
            // ...
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        guard let prevUser = Auth.auth().currentUser else {return}
        prevUser.linkAndRetrieveData(with: credential) { (authResult, error) in
            if let invite = Invites.inviteDialog() {
                invite.setInviteDelegate(self)
                
                invite.setMessage("Check out Drivewayz! The best new way to find parking. \n -\(GIDSignIn.sharedInstance().currentUser.profile.name!)")
                invite.setTitle("Drivewayz")
                //            invite.setDeepLink("app_url")
                invite.setCallToActionText("Install!")
                invite.open()
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }


}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
