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
import Cosmos

class AccountSlideViewController: UIViewController, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, GIDSignInUIDelegate, InviteDelegate, GIDSignInDelegate {
    
    var delegate: controlsAccountOptions?
    var moveDelegate: moveControllers?
    
    var options: [String] = ["Book a spot", "My bookings", "Vehicle", "Inbox", "Become a host", "Help", "Settings"]
    var optionsImages: [UIImage] = [UIImage(named: "location")!, UIImage(named: "calendar")!, UIImage(named: "car")!, UIImage(named: "inbox")!, UIImage(named: "home-1")!, UIImage(named: "tool")!, UIImage(named: "gear")!]
    let cellId = "cellId"
    
    lazy var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
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
    
    var backgroundProfile: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().purpleColor()
        background.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        background.zPosition = -10
        view.layer.addSublayer(background)
        view.layer.cornerRadius = 50
        view.clipsToBounds = true
        
        return view
    }()
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        let origImage = UIImage(named: "background4")
        imageView.image = origImage
        imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Theme.OFF_WHITE
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.clear
        imageView.layer.cornerRadius = 50
        imageView.layer.borderColor = Theme.WHITE.cgColor
        imageView.layer.borderWidth = 3
        imageView.clipsToBounds = true
//        imageView.layer.borderColor = Theme.BLACK.cgColor
//        imageView.layer.borderWidth = 1
        
        return imageView
    }()
    
    var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 50
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        view.clipsToBounds = false
        
        return view
    }()
    
    var profileName: UILabel = {
        let profileName = UILabel()
        profileName.translatesAutoresizingMaskIntoConstraints = false
        profileName.textColor = Theme.BLACK
        profileName.textAlignment = .center
        profileName.font = Fonts.SSPSemiBoldH3
        profileName.text = ""
        
        return profileName
    }()
    
    var stars: CosmosView = {
        let view = CosmosView()
        view.rating = 5
        view.settings.updateOnTouch = false
        view.settings.fillMode = StarFillMode.precise
        view.settings.starSize = 18
        view.settings.starMargin = 2
        view.settings.filledColor = Theme.GOLD
        view.settings.emptyBorderColor = Theme.DARK_GRAY.withAlphaComponent(0.1)
        view.settings.filledBorderColor = Theme.GOLD
        view.settings.emptyColor = Theme.OFF_WHITE
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.alpha = 0
        
        return view
    }()
    
    var profileLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var optionsTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        view.separatorStyle = .none
        view.register(OptionsCell.self, forCellReuseIdentifier: "cellId")
        view.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 110, right: 0)
        view.contentOffset = CGPoint.zero
        view.decelerationRate = .fast
        view.showsVerticalScrollIndicator = false
        view.clipsToBounds = false
        view.isScrollEnabled = false
        
        return view
    }()
    
    lazy var whiteBlurView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().lightBlurColor()
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: 72)
        background.zPosition = -10
        view.layer.insertSublayer(background, at: 0)
        
        return view
    }()
    
    lazy var whiteBlurView2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().lightBlurColor()
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: 120)
        background.zPosition = -10
        view.layer.insertSublayer(background, at: 0)
        view.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        
        return view
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
    
    var settingsSelect: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        
        self.optionsTableView.delegate = self
        self.optionsTableView.dataSource = self

        setupMainView()
        setupTopView()
        fetchUser()
        checkForMarks()
        checkForUpcoming()
        configureHosts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupMainView() {
        
        self.view.addSubview(container)
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        container.widthAnchor.constraint(equalToConstant: self.view.frame.width/2 + 80).isActive = true
        container.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.width/2 + 80, height: 900)
        scrollView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        
    }
    
    func setupTopView() {
        
        scrollView.addSubview(profileLine)
        scrollView.addSubview(settingsSelect)
        settingsSelect.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        settingsSelect.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        settingsSelect.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        settingsSelect.bottomAnchor.constraint(equalTo: profileLine.topAnchor).isActive = true
        
        scrollView.addSubview(backgroundView)
        scrollView.addSubview(backgroundProfile)
        backgroundProfile.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        backgroundProfile.widthAnchor.constraint(equalToConstant: 100).isActive = true
        backgroundProfile.heightAnchor.constraint(equalToConstant: 100).isActive = true
        switch device {
        case .iphone8:
            backgroundProfile.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 90).isActive = true
        case .iphoneX:
            backgroundProfile.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: UIApplication.shared.statusBarFrame.height + 60).isActive = true
        }
        
        scrollView.addSubview(profileImageView)
        profileImageView.topAnchor.constraint(equalTo: backgroundProfile.topAnchor).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: backgroundProfile.leftAnchor).isActive = true
        profileImageView.rightAnchor.constraint(equalTo: backgroundProfile.rightAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: backgroundProfile.bottomAnchor).isActive = true
        
        backgroundView.topAnchor.constraint(equalTo: backgroundProfile.topAnchor).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: backgroundProfile.leftAnchor).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: backgroundProfile.rightAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: backgroundProfile.bottomAnchor).isActive = true
        
        scrollView.addSubview(profileName)
        profileName.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        profileName.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 2).isActive = true
        profileName.widthAnchor.constraint(lessThanOrEqualToConstant: 400).isActive = true
        profileName.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(stars)
        stars.leftAnchor.constraint(equalTo: profileName.leftAnchor, constant: -2).isActive = true
        stars.widthAnchor.constraint(equalToConstant: 100).isActive = true
        stars.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: -2).isActive = true
        stars.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        profileLine.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        profileLine.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        profileLine.topAnchor.constraint(equalTo: stars.bottomAnchor, constant: 24).isActive = true
        profileLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        scrollView.addSubview(optionsTableView)
        optionsTableView.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        optionsTableView.topAnchor.constraint(equalTo: profileLine.bottomAnchor).isActive = true
        optionsTableView.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        optionsTableView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        
        scrollView.addSubview(whiteBlurView)
        whiteBlurView.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        whiteBlurView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        whiteBlurView.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        whiteBlurView.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
        scrollView.addSubview(whiteBlurView2)
        whiteBlurView2.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        whiteBlurView2.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        whiteBlurView2.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        whiteBlurView2.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        scrollView.addSubview(upcomingMark)
        upcomingMark.topAnchor.constraint(equalTo: optionsTableView.topAnchor, constant: 57.5).isActive = true
        upcomingMark.rightAnchor.constraint(equalTo: optionsTableView.rightAnchor, constant: -20).isActive = true
        upcomingMark.widthAnchor.constraint(equalToConstant: 20).isActive = true
        upcomingMark.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(hostingMark)
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
                    self.stars.alpha = 1
                }
                if let email = dictionary["email"] as? String {
                    userEmail = email
                }
                if let userPicture = dictionary["picture"] as? String {
                    if userPicture == "" {
                        self.profileImageView.image = UIImage(named: "background4")
                        self.addShouldShow = true
                    } else {
                        self.profileImageView.loadImageUsingCacheWithUrlString(userPicture)
                        self.addShouldShow = false
                    }
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
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.options.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = optionsTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! OptionsCell
        cell.message = options[indexPath.row]
//        cell.profileImageView.setImage(optionsImages[indexPath.row], for: .normal)
        let image = optionsImages[indexPath.row]
        let tintedImage = image.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        cell.profileImageView.setImage(tintedImage, for: .normal)
        cell.profileImageView.tintColor = Theme.BLACK
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
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        tableView.reloadData()
        delayWithSeconds(animationOut) {
            self.optionsTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            self.optionsTableView.delegate?.tableView!(self.optionsTableView, didSelectRowAt: indexPath)
        }
//        cell.profileImageView.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
    }
    
//    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
//        let cell = optionsTableView.cellForRow(at: indexPath) as! OptionsCell
//        cell.messageTextView.textColor = Theme.BLACK
//        cell.profileImageView.tintColor = Theme.BLACK
//    }
    
    var analControllerAnchor: NSLayoutConstraint!
    var selectedIndex: Int = 0
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: animationIn) {
            self.hostingMark.alpha = 0
            self.upcomingMark.alpha = 0
        }
        if tableView == optionsTableView {
            if options[indexPath.row] == "My bookings" {
                self.openAccountView()
                self.delegate?.bringUpcomingController()
            } else if options[indexPath.row] == "Hosted spaces" {
                self.openAccountView()
                self.delegate?.bringHostingController()
            } else if options[indexPath.row] == "Become a host" {
                self.openAccountView()
                self.delegate?.bringNewHostingController()
            } else if options[indexPath.row] == "Vehicle" {
                self.openAccountView()
                self.delegate?.bringVehicleController()
            } else if options[indexPath.row] == "Inbox" {
                self.openAccountView()
                self.delegate?.bringMessagesController()
            } else if options[indexPath.row] == "Coupons" {
                self.delegate?.moveToMap()
                self.delegate?.bringCouponsController()
            } else if options[indexPath.row] == "Contact us!" {
                self.delegate?.moveToMap()
                self.delegate?.bringContactUsController()
            } else if options[indexPath.row] == "Settings" {
                self.settingSelected()
            } else if options[indexPath.row] == "Help" {
                self.openAccountView()
                self.delegate?.bringHelpController()
            } else if options[indexPath.row] == "Book a spot" {
                self.delegate?.moveToMap()
            }
        } else {
            self.delegate?.moveToMap()
//            self.delegate?.bringTermsController()
        }
    }
    
    @objc func goBackToMap() {
        self.delegate?.moveToMap()
    }
    
    @objc func settingSelected() {
        self.openAccountView()
        if let image = self.profileImageView.image, let name = self.profileName.text {
            self.delegate?.bringSettingsController(image: image, name: name)
        }
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
            self.options = ["Book a spot", "My bookings", "Vehicle", "Inbox", "Hosted spaces", "Help", "Settings"]
            self.optionsTableView.reloadData()
        }
        ref.observe(.childRemoved) { (snapshot) in
            self.options = ["Book a spot", "My bookings", "Vehicle", "Inbox", "Become a host", "Help", "Settings"]
            self.optionsTableView.reloadData()
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
