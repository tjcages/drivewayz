//
//  AccountViewController.swift
//  CollegeFeed
//
//  Created by Tyler Jordan Cagle on 7/20/17.
//  Copyright © 2017 COAppDesign. All rights reserved.
//

import UIKit
import Firebase
import Floaty
import FacebookLogin

var database: Database!
var storage: Storage!
var lattitudeConstant: Double = 0
var longitudeConstant: Double = 0
var formattedAddress: String = ""
var cityAddress: String = ""
var parkingSpotImage: UIImage?
var parking: Int = 0

var newParkingController: AddANewParkingSpotViewController = {
    let controller = AddANewParkingSpotViewController()
    controller.view.translatesAutoresizingMaskIntoConstraints = false
    controller.title = "New Parking"
    controller.view.alpha = 0
    return controller
}()

class AccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {

    var visualBlurEffect = UIVisualEffectView()
    
    var picker = UIImagePickerController()
    
    var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var earningsController: DataChartsViewController = {
        let controller = DataChartsViewController()
        self.addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Charts"
        return controller
    }()
    
    lazy var parkingController: UserParkingViewController = {
        let controller = UserParkingViewController()
        self.addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Parking"
        return controller
    }()
    
    lazy var vehicleController: UserVehicleViewController = {
        let controller = UserVehicleViewController()
        self.addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Vehicle"
        return controller
    }()
    
    var profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        let image = UIImage(named: "background4")
        profileImageView.image = image
        profileImageView.isUserInteractionEnabled = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.backgroundColor = UIColor.white
        profileImageView.layer.cornerRadius = 50
        profileImageView.clipsToBounds = true
        
        return profileImageView
    }()
    
    var profileName: UILabel = {
        let profileName = UILabel()
        profileName.translatesAutoresizingMaskIntoConstraints = false
        profileName.textColor = UIColor.white
        profileName.layer.shadowColor = UIColor.darkGray.cgColor
        profileName.layer.shadowRadius = 3
        profileName.layer.shadowOpacity = 0.8
        profileName.layer.shadowOffset = CGSize(width: 2, height: 2)
        profileName.layer.masksToBounds = false
        profileName.clipsToBounds = false
        profileName.contentMode = .topLeft
        profileName.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        
        return profileName
    }()
    
    lazy var profileWrap: UIView = {
        let grayView = UIView()
        grayView.backgroundColor = Theme.PRIMARY_COLOR
        grayView.translatesAutoresizingMaskIntoConstraints = false
        grayView.isUserInteractionEnabled = true
        grayView.alpha = 0.9
        
        return grayView
    }()
    
    lazy var profileSettings: UIView = {
        let profileSettings = Floaty()
        profileSettings.addItem("Profile", icon: #imageLiteral(resourceName: "account"))
        profileSettings.addItem("Settings", icon: #imageLiteral(resourceName: "settings"), handler: { (item) in
            let dataChartsView = DataChartsViewController()
            self.navigationController?.pushViewController(dataChartsView, animated: true)
        })
        profileSettings.addItem("Logout", icon: #imageLiteral(resourceName: "logout"), handler: { (item) in
            self.handleLogout()
            return
        })
        profileSettings.friendlyTap = true
        profileSettings.translatesAutoresizingMaskIntoConstraints = false
        return profileSettings
    }()
  
    lazy var fullBlurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 1
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        return blurEffectView
    }()
    
    var overlay: UIView = {
        let overlay = UIView(frame: CGRect(x: 50, y: 50, width: 50, height: 50))
        overlay.layer.borderColor = Theme.PRIMARY_COLOR.cgColor
        overlay.layer.borderWidth = 2
        overlay.backgroundColor = Theme.PRIMARY_COLOR.withAlphaComponent(0.5)
        
        return overlay
    }()
    
    let startActivityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    var segmentControlView: UIView = {
        let segmentControlView = UIView()
        segmentControlView.translatesAutoresizingMaskIntoConstraints = false
        segmentControlView.backgroundColor = Theme.OFF_WHITE
        segmentControlView.layer.cornerRadius = 5
        
        return segmentControlView
    }()
    
    var graphsSegment: UIButton = {
        let info = UIButton()
        info.translatesAutoresizingMaskIntoConstraints = false
        info.backgroundColor = UIColor.clear
        info.setTitle("Earnings", for: .normal)
        info.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        info.setTitleColor(Theme.DARK_GRAY, for: .normal)
        info.titleLabel?.textAlignment = .center
        info.addTarget(self, action: #selector(infoPressed(sender:)), for: .touchUpInside)
        
        return info
    }()
    
    var parkingSegment: UIButton = {
        let availability = UIButton()
        availability.translatesAutoresizingMaskIntoConstraints = false
        availability.backgroundColor = UIColor.clear
        availability.setTitle("Parking", for: .normal)
        availability.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        availability.setTitleColor(Theme.DARK_GRAY, for: .normal)
        availability.titleLabel?.textAlignment = .center
        availability.addTarget(self, action: #selector(availabilityPressed(sender:)), for: .touchUpInside)
        
        return availability
    }()
    
    var vehicleSegment: UIButton = {
        let reviews = UIButton()
        reviews.translatesAutoresizingMaskIntoConstraints = false
        reviews.backgroundColor = UIColor.clear
        reviews.setTitle("Vehicle", for: .normal)
        reviews.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        reviews.setTitleColor(Theme.DARK_GRAY, for: .normal)
        reviews.titleLabel?.textAlignment = .center
        reviews.addTarget(self, action: #selector(reviewPressed(sender:)), for: .touchUpInside)
        
        return reviews
    }()
    
    var selectionLine: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = Theme.PRIMARY_COLOR
        
        return line
    }()
    
    var effect: UIVisualEffect!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = Theme.OFF_WHITE
        self.tabBarController?.tabBar.isHidden = true

        view.addSubview(scrollView)
        view.bringSubview(toFront: scrollView)
        
        effect = visualBlurEffect.effect
        visualBlurEffect.effect = nil
        UIApplication.shared.statusBarStyle = .lightContent

        setupTerms()
        fetchUser()
        setupTopView()
        setupViews()
        setupViewControllers()
        startUpActivity()

    }
    
    var blurSquare: UIVisualEffectView!
    
    func startUpActivity() {
        
        let blurEffect = UIBlurEffect(style: .dark)
        blurSquare = UIVisualEffectView(effect: blurEffect)
        blurSquare.layer.cornerRadius = 15
        blurSquare.alpha = 1
        blurSquare.clipsToBounds = true
        blurSquare.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(blurSquare)
        blurSquare.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        blurSquare.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        blurSquare.widthAnchor.constraint(equalToConstant: 120).isActive = true
        blurSquare.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        self.view.addSubview(startActivityIndicatorView)
        
        startActivityIndicatorView.centerXAnchor.constraint(equalTo: blurSquare.centerXAnchor).isActive = true
        startActivityIndicatorView.centerYAnchor.constraint(equalTo: blurSquare.centerYAnchor).isActive = true
        startActivityIndicatorView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        startActivityIndicatorView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.startActivityIndicatorView.startAnimating()
        
    }
    
    func setupTopView() {
        
        scrollView.addSubview(profileWrap)
        profileWrap.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        profileWrap.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        profileWrap.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        profileWrap.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        profileWrap.addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: profileWrap.leftAnchor, constant: 10).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: profileWrap.centerYAnchor, constant: 20).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        profileWrap.addSubview(profileName)
        profileName.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 15).isActive = true
        profileName.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 25).isActive = true
        profileName.widthAnchor.constraint(lessThanOrEqualToConstant: 400).isActive = true
        profileName.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        scrollView.addSubview(profileSettings)
        profileSettings.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32).isActive = true
        profileSettings.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50).isActive = true
        profileSettings.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileSettings.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
    }
    
    var controlTopAnchor1: NSLayoutConstraint!
    var controlTopAnchor2: NSLayoutConstraint!
    var segmentLineLeftAnchor1: NSLayoutConstraint!
    var segmentLineLeftAnchor2: NSLayoutConstraint!
    var segmentLineLeftAnchor3: NSLayoutConstraint!
    
    func setupViews() {
        let statusHeight = UIApplication.shared.statusBarFrame.height
        scrollView.delegate = self
        
        self.view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: -statusHeight).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 240)
        
        self.view.addSubview(segmentControlView)
        controlTopAnchor1 = segmentControlView.topAnchor.constraint(equalTo: profileWrap.bottomAnchor, constant: 20)
        controlTopAnchor1.isActive = true
        controlTopAnchor2 = segmentControlView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40)
        controlTopAnchor2.isActive = false
        segmentControlView.widthAnchor.constraint(equalToConstant: self.view.frame.width * 5/6).isActive = true
        segmentControlView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        segmentControlView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        self.view.addSubview(graphsSegment)
        graphsSegment.leftAnchor.constraint(equalTo: segmentControlView.leftAnchor).isActive = true
        graphsSegment.topAnchor.constraint(equalTo: segmentControlView.topAnchor).isActive = true
        graphsSegment.bottomAnchor.constraint(equalTo: segmentControlView.bottomAnchor).isActive = true
        graphsSegment.widthAnchor.constraint(equalToConstant: (self.view.frame.width * 5/6) / 3).isActive = true
        
        self.view.addSubview(vehicleSegment)
        vehicleSegment.rightAnchor.constraint(equalTo: segmentControlView.rightAnchor).isActive = true
        vehicleSegment.topAnchor.constraint(equalTo: segmentControlView.topAnchor).isActive = true
        vehicleSegment.bottomAnchor.constraint(equalTo: segmentControlView.bottomAnchor).isActive = true
        vehicleSegment.widthAnchor.constraint(equalToConstant: (self.view.frame.width * 5/6) / 3).isActive = true
        
        self.view.addSubview(parkingSegment)
        parkingSegment.leftAnchor.constraint(equalTo: graphsSegment.rightAnchor).isActive = true
        parkingSegment.topAnchor.constraint(equalTo: segmentControlView.topAnchor).isActive = true
        parkingSegment.bottomAnchor.constraint(equalTo: segmentControlView.bottomAnchor).isActive = true
        parkingSegment.widthAnchor.constraint(equalToConstant: (self.view.frame.width * 5/6) / 3).isActive = true
        
        self.view.addSubview(selectionLine)
        selectionLine.topAnchor.constraint(equalTo: segmentControlView.bottomAnchor).isActive = true
        selectionLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        selectionLine.widthAnchor.constraint(equalToConstant: (self.view.frame.width * 5/6) / 3).isActive = true
        segmentLineLeftAnchor1 = selectionLine.leftAnchor.constraint(equalTo: graphsSegment.leftAnchor)
        segmentLineLeftAnchor1.isActive = true
        segmentLineLeftAnchor2 = selectionLine.leftAnchor.constraint(equalTo: parkingSegment.leftAnchor)
        segmentLineLeftAnchor2.isActive = false
        segmentLineLeftAnchor3 = selectionLine.leftAnchor.constraint(equalTo: vehicleSegment.leftAnchor)
        segmentLineLeftAnchor3.isActive = false
        
        self.view.bringSubview(toFront: self.profileSettings)
        
    }
    
    var earningsViewAnchor: NSLayoutConstraint!
    var parkingViewAnchor: NSLayoutConstraint!
    var vehicleViewAnchor: NSLayoutConstraint!
    
    func setupViewControllers() {
        
        scrollView.addSubview(earningsController.view)
        earningsController.didMove(toParentViewController: self)
        earningsViewAnchor = earningsController.view.leftAnchor.constraint(equalTo: scrollView.leftAnchor)
        earningsViewAnchor.isActive = true
        earningsController.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        earningsController.view.topAnchor.constraint(equalTo: profileWrap.bottomAnchor, constant: 50).isActive = true
        earningsController.view.heightAnchor.constraint(equalToConstant: 500).isActive = true
        
        scrollView.addSubview(parkingController.view)
        parkingController.didMove(toParentViewController: self)
        parkingViewAnchor = parkingController.view.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: self.view.frame.width)
        parkingViewAnchor.isActive = true
        parkingController.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        parkingController.view.topAnchor.constraint(equalTo: profileWrap.bottomAnchor, constant: 50).isActive = true
        parkingController.view.heightAnchor.constraint(equalToConstant: 500).isActive = true
        
        scrollView.addSubview(vehicleController.view)
        vehicleController.didMove(toParentViewController: self)
        vehicleViewAnchor = vehicleController.view.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: (self.view.frame.width) * 2)
        vehicleViewAnchor.isActive = true
        vehicleController.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        vehicleController.view.topAnchor.constraint(equalTo: profileWrap.bottomAnchor, constant: 50).isActive = true
        vehicleController.view.heightAnchor.constraint(equalToConstant: 500).isActive = true
        
        self.addChildViewController(newParkingController)
        newParkingController.didMove(toParentViewController: self)
        self.view.addSubview(newParkingController.view)
        newParkingController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        newParkingController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        newParkingController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        newParkingController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
    }
    
    @objc func infoPressed(sender: UIButton) {
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 240)
        segmentLineLeftAnchor1.isActive = true
        segmentLineLeftAnchor2.isActive = false
        segmentLineLeftAnchor3.isActive = false
        earningsViewAnchor.constant = 0
        parkingViewAnchor.constant = self.view.frame.width
        vehicleViewAnchor.constant = (self.view.frame.width) * 2
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    @objc func availabilityPressed(sender: UIButton) {
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 240)
        segmentLineLeftAnchor1.isActive = false
        segmentLineLeftAnchor2.isActive = true
        segmentLineLeftAnchor3.isActive = false
        earningsViewAnchor.constant = -self.view.frame.width
        parkingViewAnchor.constant = 0
        vehicleViewAnchor.constant = self.view.frame.width
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    @objc func reviewPressed(sender: UIButton) {
        reviewPressedFunc()
    }
    
    func reviewPressedFunc() {
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: (self.view.frame.height) * 2)
        segmentLineLeftAnchor1.isActive = false
        segmentLineLeftAnchor2.isActive = false
        segmentLineLeftAnchor3.isActive = true
        earningsViewAnchor.constant = -(self.view.frame.width) * 2
        parkingViewAnchor.constant = -self.view.frame.width
        vehicleViewAnchor.constant = 0
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
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
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let userName = dictionary["name"] as? String
                let email = dictionary["email"] as? String
                let userPicture = dictionary["picture"] as? String
                let userVehicleID = dictionary["vehicleID"] as? String
                let userParkingID = dictionary["parkingID"] as? String
                self.profileName.text = userName
                userEmail = email
                if userPicture == "" {
                    self.profileImageView.image = UIImage(named: "background4")
                } else {
                    self.profileImageView.loadImageUsingCacheWithUrlString(userPicture!)
                }
                if userVehicleID == nil && userParkingID == nil {
                    self.view.bringSubview(toFront: self.blurBackgroundStartup)
                    self.view.bringSubview(toFront: self.termsContainer)
                    self.termsContainer.alpha = 1
                    self.blurBackgroundStartup.alpha = 0.5
                }
            }
            self.startActivityIndicatorView.stopAnimating()
            self.blurSquare.alpha = 0
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
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            let loginManager = LoginManager()
            loginManager.logOut()
        } catch let logoutError {
            print(logoutError)
        }
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StartUpViewController") as! StartUpViewController
            present(viewController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var termsContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE
        view.clipsToBounds = true
        view.alpha = 0
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    var blurBackgroundStartup: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.isUserInteractionEnabled = false
        blurView.alpha = 0
        
        return blurView
    }()
    
    var terms: UILabel = {
        let label = UILabel()
        label.textColor = Theme.PRIMARY_COLOR
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 2
        label.text = "Thanks for downloading Drivewayz!"
        
        return label
    }()
    
    var segmentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var text1: UILabel = {
        let label = UILabel()
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = """
        Welcome!
        
        We hope to change the way that you think about parking forever by creating a network of brand new options that have been unavailable until now.
        
        Park closer, quicker, safer and cheaper in any of our host's spots or become a host and make easy money by renting out your parking spot!
        """
        label.numberOfLines = 15
        
        return label
    }()
    
    var image2: UIImageView = {
        let image = UIImageView()
        let parking = UIImage(named: "background1")
        image.image = parking
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        
        return image
    }()
    
    var text2: UILabel = {
        let label = UILabel()
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "List your empty parking spot here and make quick and easy cash while helping others!"
        label.numberOfLines = 3
        
        return label
    }()
    
    var image3: UIImageView = {
        let image = UIImageView()
        let parking = UIImage(named: "exampleCar")
        image.image = parking
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        
        return image
    }()
    
    var text3: UILabel = {
        let label = UILabel()
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "All you need to begin finding cheap parking is upload some information about your vehicle!"
        label.numberOfLines = 3
        
        return label
    }()
    
    var startupPages: UIPageControl = {
        let page = UIPageControl(frame: CGRect(x: 50, y: 300, width: 200, height: 20))
        page.numberOfPages = 3
        page.currentPage = 0
        page.tintColor = Theme.DARK_GRAY
        page.pageIndicatorTintColor = Theme.DARK_GRAY
        page.currentPageIndicatorTintColor = Theme.PRIMARY_COLOR
        page.translatesAutoresizingMaskIntoConstraints = false
        page.isUserInteractionEnabled = false
        
        return page
    }()
    
    var accept: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next", for: .normal)
        button.setTitleColor(Theme.PRIMARY_DARK_COLOR, for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.borderColor = Theme.PRIMARY_COLOR.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(nextPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var back: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Back", for: .normal)
        button.setTitleColor(Theme.PRIMARY_DARK_COLOR, for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.borderColor = Theme.PRIMARY_COLOR.cgColor
        button.alpha = 0
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(backPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var nextAnchor: NSLayoutConstraint!
    var lastAnchor: NSLayoutConstraint!
    var confirmAnchor: NSLayoutConstraint!
    var confirmWidthAnchor: NSLayoutConstraint!
    
    func setupTerms() {
        
        self.view.addSubview(blurBackgroundStartup)
        blurBackgroundStartup.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        blurBackgroundStartup.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        blurBackgroundStartup.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        blurBackgroundStartup.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.view.addSubview(termsContainer)
        termsContainer.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120).isActive = true
        termsContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -120).isActive = true
        termsContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 40).isActive = true
        termsContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -40).isActive = true
        
        termsContainer.addSubview(segmentView)
        segmentView.topAnchor.constraint(equalTo: termsContainer.topAnchor, constant: 60).isActive = true
        segmentView.bottomAnchor.constraint(equalTo: termsContainer.bottomAnchor, constant: -60).isActive = true
        segmentView.leftAnchor.constraint(equalTo: termsContainer.leftAnchor).isActive = true
        segmentView.rightAnchor.constraint(equalTo: termsContainer.rightAnchor).isActive = true
        
        segmentView.addSubview(text1)
        text1.topAnchor.constraint(equalTo: segmentView.topAnchor, constant: 0).isActive = true
        text1.bottomAnchor.constraint(equalTo: segmentView.bottomAnchor, constant: -20).isActive = true
        text1.leftAnchor.constraint(equalTo: segmentView.leftAnchor, constant: 10).isActive = true
        text1.rightAnchor.constraint(equalTo: segmentView.rightAnchor, constant: -10).isActive = true
        
        segmentView.addSubview(image2)
        image2.topAnchor.constraint(equalTo: segmentView.topAnchor, constant: 0).isActive = true
        image2.heightAnchor.constraint(equalToConstant: 200).isActive = true
        nextAnchor = image2.centerXAnchor.constraint(equalTo: termsContainer.centerXAnchor, constant: self.view.frame.width)
        nextAnchor.isActive = true
        image2.widthAnchor.constraint(equalTo: segmentView.widthAnchor).isActive = true
        
        segmentView.addSubview(text2)
        text2.topAnchor.constraint(equalTo: image2.bottomAnchor, constant: 0).isActive = true
        text2.bottomAnchor.constraint(equalTo: segmentView.bottomAnchor, constant: -20).isActive = true
        text2.centerXAnchor.constraint(equalTo: image2.centerXAnchor).isActive = true
        text2.widthAnchor.constraint(equalTo: segmentView.widthAnchor, constant: -20).isActive = true
        
        segmentView.addSubview(image3)
        image3.topAnchor.constraint(equalTo: segmentView.topAnchor, constant: 0).isActive = true
        image3.heightAnchor.constraint(equalToConstant: 200).isActive = true
        lastAnchor = image3.centerXAnchor.constraint(equalTo: termsContainer.centerXAnchor, constant: self.view.frame.width)
        lastAnchor.isActive = true
        image3.widthAnchor.constraint(equalTo: segmentView.widthAnchor).isActive = true
        
        segmentView.addSubview(text3)
        text3.topAnchor.constraint(equalTo: image3.bottomAnchor, constant: 0).isActive = true
        text3.bottomAnchor.constraint(equalTo: segmentView.bottomAnchor, constant: -20).isActive = true
        text3.centerXAnchor.constraint(equalTo: image3.centerXAnchor).isActive = true
        text3.widthAnchor.constraint(equalTo: segmentView.widthAnchor, constant: -20).isActive = true
        
        termsContainer.addSubview(startupPages)
        startupPages.widthAnchor.constraint(equalToConstant: 200).isActive = true
        startupPages.heightAnchor.constraint(equalToConstant: 20).isActive = true
        startupPages.centerXAnchor.constraint(equalTo: termsContainer.centerXAnchor).isActive = true
        startupPages.bottomAnchor.constraint(equalTo: segmentView.bottomAnchor, constant: -10).isActive = true
        
        termsContainer.addSubview(terms)
        terms.centerXAnchor.constraint(equalTo: termsContainer.centerXAnchor).isActive = true
        terms.widthAnchor.constraint(equalTo: termsContainer.widthAnchor).isActive = true
        terms.centerYAnchor.constraint(equalTo: termsContainer.topAnchor, constant: 30).isActive = true
        terms.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        termsContainer.addSubview(accept)
        confirmAnchor = accept.centerXAnchor.constraint(equalTo: termsContainer.centerXAnchor)
        confirmAnchor.isActive = true
        confirmWidthAnchor = accept.widthAnchor.constraint(equalTo: termsContainer.widthAnchor, constant: -80)
        confirmWidthAnchor.isActive = true
        accept.centerYAnchor.constraint(equalTo: termsContainer.bottomAnchor, constant: -30).isActive = true
        accept.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        termsContainer.addSubview(back)
        back.centerXAnchor.constraint(equalTo: termsContainer.centerXAnchor, constant: -60).isActive = true
        back.widthAnchor.constraint(equalTo: termsContainer.widthAnchor, constant: -200).isActive = true
        back.centerYAnchor.constraint(equalTo: termsContainer.bottomAnchor, constant: -30).isActive = true
        back.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    @objc func nextPressed(sender: UIButton) {
        
        if nextAnchor.constant == self.view.frame.width {
            UIView.animate(withDuration: 0.3, animations: {
                self.confirmAnchor.constant = 60
                self.confirmWidthAnchor.constant = -200
                self.text1.alpha = 0
                self.startupPages.currentPage = 1
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: 0.3, animations: {
                    self.nextAnchor.constant = 0
                    self.back.alpha = 1
                    self.view.layoutIfNeeded()
                })
            }
        } else if self.nextAnchor.constant == 0 && text2.alpha == 1 {
            UIView.animate(withDuration: 0.3, animations: {
                self.confirmAnchor.constant = 0
                self.confirmWidthAnchor.constant = -80
                self.back.alpha = 0
                self.text2.alpha = 0
                self.image2.alpha = 0
                self.startupPages.currentPage = 2
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: 0.3, animations: {
                    self.lastAnchor.constant = 0
                    self.view.layoutIfNeeded()
                })
                self.accept.setTitle("Get started!", for: .normal)
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.termsContainer.alpha = 0
                self.blurBackgroundStartup.alpha = 0
                self.reviewPressedFunc()
            }
        }
        
    }
    
    @objc func backPressed(sender: UIButton) {
        
        if nextAnchor.constant == 0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.nextAnchor.constant = self.view.frame.width
                self.back.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: 0.3, animations: {
                    self.confirmAnchor.constant = 0
                    self.confirmWidthAnchor.constant = -80
                    self.text1.alpha = 1
                    self.startupPages.currentPage = 0
                    self.view.layoutIfNeeded()
                })
            }
        }
    }

}


