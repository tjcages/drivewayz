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

class AccountSlideViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
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
        view.backgroundColor = Theme.WHITE
        view.layer.shadowRadius = 5
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: -1, height: 1)
        view.layer.shadowOpacity = 0.8
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.roundCorners(corners: .topLeft, radius: 10)
        
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
        imageView.layer.borderColor = Theme.HARMONY_COLOR.cgColor
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
        profileName.textColor = Theme.BLACK
        profileName.textAlignment = .center
        profileName.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        profileName.text = "Name"
        
        return profileName
    }()
    
    var addButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "Add")
        button.setImage(image, for: .normal)
        button.layer.shadowColor = Theme.DARK_GRAY.cgColor
        button.layer.shadowOpacity = 0.8
        button.layer.shadowRadius = 1
        button.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2)
        button.alpha = 1
        
        return button
    }()
    
    var profileLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        
        return view
    }()
    
    var optionsTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.separatorStyle = .none
        view.register(OptionsCell.self, forCellReuseIdentifier: "cellId")
        view.isScrollEnabled = false
        
        return view
    }()
    
    var termsTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.separatorStyle = .none
        view.register(OptionsCell.self, forCellReuseIdentifier: "cellId")
        view.isScrollEnabled = false
        
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
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.alpha = 0
        
        return label
    }()
    
    var hostingMark: UIButton = {
        let mark = UIButton()
        let image = UIImage(named: "Mark")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        mark.setImage(tintedImage, for: .normal)
        mark.tintColor = Theme.WHITE
        mark.backgroundColor = Theme.HARMONY_COLOR
        mark.layer.cornerRadius = 10
        mark.alpha = 0
        mark.translatesAutoresizingMaskIntoConstraints = false
        mark.imageEdgeInsets = UIEdgeInsetsMake(2, 0, 2, 0)
        
        return mark
    }()
    
    var upcomingMark: UIButton = {
        let mark = UIButton()
        let image = UIImage(named: "Mark")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        mark.setImage(tintedImage, for: .normal)
        mark.tintColor = Theme.WHITE
        mark.backgroundColor = Theme.HARMONY_COLOR
        mark.layer.cornerRadius = 10
        mark.alpha = 0
        mark.translatesAutoresizingMaskIntoConstraints = false
        mark.imageEdgeInsets = UIEdgeInsetsMake(2, 0, 2, 0)
        
        return mark
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
        configureOptions()
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
        switch device {
        case .iphone8:
            let background = CAGradientLayer().blueColor()
            background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200)
            background.zPosition = -10
            container.layer.insertSublayer(background, at: 0)
            container.layer.cornerRadius = 10
        case .iphoneX:
            let background = CAGradientLayer().blueColor()
            background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: UIApplication.shared.statusBarFrame.height + 200)
            background.zPosition = -10
            container.layer.insertSublayer(background, at: 0)
            container.layer.cornerRadius = 10
        }
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        mainLabelAnchor = mainLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 82)
            mainLabelAnchor.isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    func setupTopView() {
        
        container.addSubview(profileImageView)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView(sender:)))
        profileImageView.addGestureRecognizer(gesture)
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
        imageView.addGestureRecognizer(gesture)
        imageView.leftAnchor.constraint(equalTo: profileImageView.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: profileImageView.rightAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: profileImageView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor).isActive = true
        
        container.addSubview(addButton)
        container.bringSubview(toFront: addButton)
        addButton.addGestureRecognizer(gesture)
        addButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 40).isActive = true
        addButton.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor, constant: 40).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
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
        
        container.addSubview(optionsTableView)
        optionsTableView.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        optionsTableView.topAnchor.constraint(equalTo: profileLine.bottomAnchor).isActive = true
        optionsTableView.heightAnchor.constraint(equalToConstant: 360).isActive = true
        optionsTableView.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -self.view.frame.width/3.5).isActive = true
        
        container.addSubview(termsTableView)
        termsTableView.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        termsTableView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        termsTableView.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -self.view.frame.width/3.5).isActive = true
        switch device {
        case .iphone8:
            termsTableView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10).isActive = true
        case .iphoneX:
            termsTableView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -30).isActive = true
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
    
    var pickerProfile: UIImagePickerController?
    
    @objc func handleSelectProfileImageView(sender: UITapGestureRecognizer) {
        pickerProfile = UIImagePickerController()
        pickerProfile?.delegate = self
        pickerProfile?.allowsEditing = true
        
        present(pickerProfile!, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            if picker == pickerProfile {
                profileImageView.image = selectedImage
                self.addButton.alpha = 0
            }
        }
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let imageName = NSUUID().uuidString
        
        if picker == pickerProfile {
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
            if let uploadData = UIImageJPEGRepresentation(self.profileImageView.image!, 0.5) {
                //        if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!) {
                storageRef.putData(uploadData, metadata: nil, completion: {  (metadata, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    storageRef.downloadURL(completion: { (url, error) in
                        guard let profileImageURL = url?.absoluteString else {
                            print("Error finding image url:", error!)
                            return
                        }
                        let values = ["picture": profileImageURL]
                        self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                    })
                })
            }
        }
        dismiss(animated: true, completion: nil)
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
                    self.addButton.alpha = 1
                    self.addShouldShow = true
                } else {
                    self.profileImageView.loadImageUsingCacheWithUrlString(userPicture!)
                    self.addButton.alpha = 0
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
            self.addButton.alpha = 0
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
            cell.messageTextView.textColor = Theme.HARMONY_COLOR
            cell.imageView?.tintColor = Theme.PRIMARY_COLOR
            cell.backgroundColor = Theme.HARMONY_COLOR.withAlphaComponent(0.05)
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
                    self.displayAlertMessage(userMessage: "Currently this functionality is unavailable.", title: "Sorry!")
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
        let alert = UIAlertController(title: title, message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
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
        let index = IndexPath(row: 0, section: 0)
        self.optionsTableView.selectRow(at: index, animated: true, scrollPosition: .top)
        optionsTableView.delegate?.tableView!(optionsTableView, didSelectRowAt: index)
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
                        return
                    } else {
                        self.emailConfirmed = .unconfirmed
                    }
                }
            }
        }
    }


}
