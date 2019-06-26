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
    
    var options: [String] = ["Book a spot", "My bookings", "Vehicle", "Inbox", "Become a host", "Help", "Settings"]
    var optionsImages: [UIImage] = [UIImage(named: "location")!, UIImage(named: "calendar")!, UIImage(named: "car")!, UIImage(named: "inbox")!, UIImage(named: "home-1")!, UIImage(named: "tool")!, UIImage(named: "gear")!]
    let cellId = "cellId"
    
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
    
    var backgroundCircle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.borderColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.05).cgColor
        view.layer.borderWidth = 80
        view.layer.cornerRadius = 180
        
        return view
    }()
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        let origImage = UIImage(named: "background4")
        imageView.image = origImage
        imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.clear
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        
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
        view.rating = 4.65
        view.settings.updateOnTouch = false
        view.settings.fillMode = StarFillMode.precise
        view.settings.starSize = 20
        view.settings.starMargin = 0
        view.settings.filledColor = Theme.GOLD
        view.settings.emptyBorderColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        view.settings.filledBorderColor = Theme.GOLD
        view.settings.emptyColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        
        return view
    }()
    
    var starLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "4.65"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .right
        
        return label
    }()
    
    var profileLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var optionsTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.clear
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
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: 92)
        background.zPosition = -10
        view.layer.insertSublayer(background, at: 0)
        
        return view
    }()
    
    lazy var whiteBlurView2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().lightBlurColor()
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: 128)
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        
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
        container.widthAnchor.constraint(equalToConstant: phoneWidth/2 + 80).isActive = true
        container.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.width/2 + 80, height: 860)
        scrollView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        
        scrollView.addSubview(backgroundCircle)
        backgroundCircle.centerXAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        backgroundCircle.centerYAnchor.constraint(equalTo: scrollView.topAnchor, constant: 60).isActive = true
        backgroundCircle.widthAnchor.constraint(equalToConstant: 360).isActive = true
        backgroundCircle.heightAnchor.constraint(equalTo: backgroundCircle.widthAnchor).isActive = true
        
    }
    
    func setupTopView() {
        
        scrollView.addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        switch device {
        case .iphone8:
            profileImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 70).isActive = true
        case .iphoneX:
            profileImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 60).isActive = true
        }
        
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
        
        scrollView.addSubview(starLabel)
        starLabel.centerYAnchor.constraint(equalTo: stars.centerYAnchor).isActive = true
        starLabel.leftAnchor.constraint(equalTo: stars.rightAnchor, constant: 6).isActive = true
        starLabel.sizeToFit()
        
        scrollView.addSubview(profileLine)
        profileLine.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        profileLine.widthAnchor.constraint(equalToConstant: phoneWidth - 48).isActive = true
        profileLine.topAnchor.constraint(equalTo: stars.bottomAnchor, constant: 24).isActive = true
        profileLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        scrollView.addSubview(optionsTableView)
        optionsTableView.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        optionsTableView.topAnchor.constraint(equalTo: profileLine.bottomAnchor).isActive = true
        optionsTableView.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        optionsTableView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        
        scrollView.addSubview(whiteBlurView)
        whiteBlurView.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        whiteBlurView.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        whiteBlurView.heightAnchor.constraint(equalToConstant: 92).isActive = true
        switch device {
        case .iphone8:
            whiteBlurView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 30).isActive = true
        case .iphoneX:
            whiteBlurView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        }
        
        scrollView.addSubview(whiteBlurView2)
        whiteBlurView2.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        whiteBlurView2.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        whiteBlurView2.heightAnchor.constraint(equalToConstant: 128).isActive = true
        switch device {
        case .iphone8:
            whiteBlurView2.topAnchor.constraint(equalTo: container.topAnchor, constant: -26).isActive = true
        case .iphoneX:
            whiteBlurView2.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        }
        
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
                if let userRating = dictionary["rating"] as? Double {
                    self.stars.rating = userRating
                    self.starLabel.text = String(format:"%.01f", userRating)
                } else {
                    self.stars.rating = 5.0
                    self.starLabel.text = "5.0"
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
            self.delegate?.closeAccountView()
            self.delegate?.hideHostingController()
            self.optionsTableView.reloadData()
        }
    }
    
    func bringBankAccountOptions() {
        self.delegate?.bringBankAccountController()
    }


}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
