//
//  AddANewParkingSpotViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 7/9/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase
import TextFieldEffects
import GoogleMaps
import GooglePlaces

let DenverLocation = CLLocation(latitude: 39.7392, longitude: -104.9903)
let tenMiles = 16093.4 //meters
var expensesListing: Int = 1
var searchController: UISearchController?
var resultView: UITextView?

protocol controlPano {
    func endPano()
}

class AddANewParkingSpotViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, GMSAutocompleteViewControllerDelegate, GMSMapViewDelegate, controlPano {
    
    var delegate: controlsNewParking?
    
    var parkingLicensePlate: MadokaTextField!
    var parkingYear: MadokaTextField!
    var parkingModel: MadokaTextField!
    var parkingMake: MadokaTextField!
    var parkingImageView: UIImageView!
    var parkingImageURL: String?
    
    var visualBlurEffect: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurparkingInfoView = UIVisualEffectView(effect: blurEffect)
        blurparkingInfoView.alpha = 0.8
        blurparkingInfoView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurparkingInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        return blurparkingInfoView
    }()

    var addANewParkingView: UIView = {
        let addANewParkingView = UIView()
        addANewParkingView.layer.cornerRadius = 20
        addANewParkingView.clipsToBounds = true
        addANewParkingView.isUserInteractionEnabled = true
        addANewParkingView.translatesAutoresizingMaskIntoConstraints = false
        
        return addANewParkingView
    }()
    
    let mapView: GMSMapView = {
        let view = GMSMapView()
        view.alpha = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let searchBar: UITextField = {
        let search = UITextField()
        search.borderStyle = .roundedRect
        search.backgroundColor = .white
        search.layer.borderColor = UIColor.darkGray.cgColor
        search.placeholder = "Search.."
        search.translatesAutoresizingMaskIntoConstraints = false
        search.addTarget(self, action: #selector(searchBarSearching), for: .editingDidBegin)
        return search
    }()
    
    lazy var fullBlurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 1
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        return blurEffectView
    }()
    
    lazy var panoLabel: UILabel = {
        let panoLabel = UILabel()
        panoLabel.text = "Please pan around until you can clearly see the parking spot. Try to fit the entire view within the line on the left."
        panoLabel.textColor = UIColor.white
        panoLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        panoLabel.contentMode = .center
        panoLabel.numberOfLines = 4
        panoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return panoLabel
    }()
    
    lazy var panoLine: UIView = {
        let panoLine = UIView()
        panoLine.backgroundColor = Theme.PRIMARY_COLOR
        panoLine.layer.borderColor = Theme.PRIMARY_DARK_COLOR.cgColor
        panoLine.layer.borderWidth = 1
        panoLine.translatesAutoresizingMaskIntoConstraints = false
        
        return panoLine
    }()
    
    lazy var exitButton: UIButton = {
        let exitButton = UIButton()
        let exitImage = UIImage(named: "exit")
        exitButton.setImage(exitImage, for: .normal)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.addTarget(self, action: #selector(dismissPano), for: .touchUpInside)
        
        return exitButton
    }()
    
    
    var overlay: UIView = {
        let overlay = UIView(frame: CGRect(x: 50, y: 50, width: 50, height: 50))
        overlay.layer.borderColor = Theme.PRIMARY_COLOR.cgColor
        overlay.layer.borderWidth = 2
        overlay.backgroundColor = Theme.PRIMARY_COLOR.withAlphaComponent(0.5)
        
        return overlay
    }()
    
    lazy var dotLabel: UILabel = {
        let panoLabel = UILabel()
        panoLabel.text = "Please move the dots to highlight the area for parking. Press confirm when the dots clearly indicate the spot."
        panoLabel.textColor = UIColor.white
        panoLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        panoLabel.contentMode = .center
        panoLabel.numberOfLines = 4
        panoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return panoLabel
    }()
    
    lazy var dotShotButton: UIButton = {
        let screenShot = UIButton()
        screenShot.backgroundColor = Theme.PRIMARY_COLOR
        screenShot.layer.shadowColor = Theme.PRIMARY_DARK_COLOR.cgColor
        screenShot.layer.shadowRadius = 3
        screenShot.layer.shadowOpacity = 0
        screenShot.translatesAutoresizingMaskIntoConstraints = false
        screenShot.setTitle("Confirm Parking Spot", for: .normal)
        screenShot.tintColor = UIColor.white
        screenShot.layer.cornerRadius = 15
        screenShot.alpha = 1
        screenShot.addTarget(self, action: #selector(finalScreenShot(sender:)), for: .touchUpInside)
        
        return screenShot
    }()
    
    let fullBlur: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 1
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        return blurEffectView
    }()
    
    var screenShotView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        self.tabBarController?.tabBar.isHidden = true

        mapView.delegate = self
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        setupAddAParkingView()
        
    }

    var pickerParking: UIImagePickerController?
    
    @objc func handleSelectParkingImageView() {
        pickerParking = UIImagePickerController()
        pickerParking?.delegate = self
        pickerParking?.allowsEditing = true
        
        present(pickerParking!, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            if picker == pickerParking {
                parkingSpotImage = selectedImage
                self.takeScreenShot()
            }
        }
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let imageName = NSUUID().uuidString
        
        if picker == pickerParking {
            let storageRef = Storage.storage().reference().child("parking_images").child("\(imageName).jpg")
            if let uploadData = UIImageJPEGRepresentation(selectedImageFromPicker!, 0.5) {
                storageRef.putData(uploadData, metadata: nil, completion: {  (metadata, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    storageRef.downloadURL(completion: { (url, error) in
                        if url?.absoluteString != nil {
                            self.parkingImageURL = url?.absoluteString
                            let values = ["parkingImageURL": self.parkingImageURL]
                            self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                        } else {
                            print("Error finding image url:", error!)
                            return
                        }
                    })
                })
            }
        }
        dismiss(animated: true, completion: nil)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var correctButton: UIButton!
    var parkingContainerView: UIView!
    var correctButtonBottomAnchor: NSLayoutConstraint!
    
    func setupAddAParkingView() {
        
        self.view.addSubview(visualBlurEffect)
        visualBlurEffect.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        visualBlurEffect.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        visualBlurEffect.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        visualBlurEffect.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true
        
        self.view.addSubview(addANewParkingView)
        addANewParkingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        addANewParkingView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        addANewParkingView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 50).isActive = true
        addANewParkingView.heightAnchor.constraint(equalToConstant: self.view.frame.height - 170).isActive = true
        
        addANewParkingView.addSubview(mapView)
        mapView.centerXAnchor.constraint(equalTo: addANewParkingView.centerXAnchor).isActive = true
        mapView.centerYAnchor.constraint(equalTo: addANewParkingView.centerYAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo: addANewParkingView.heightAnchor).isActive = true
        mapView.widthAnchor.constraint(equalTo: addANewParkingView.widthAnchor).isActive = true
        
        addANewParkingView.addSubview(searchBar)
        searchBar.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 10).isActive = true
        searchBar.centerXAnchor.constraint(equalTo: addANewParkingView.centerXAnchor).isActive = true
        searchBar.widthAnchor.constraint(equalToConstant: 200).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 35).isActive = true
        let searchImage = UIImage(named: "map_Pin")
        setupTextField(textField: searchBar, img: searchImage!)
        
        correctButton = UIButton()
        correctButton.backgroundColor = Theme.PRIMARY_COLOR
        correctButton.layer.shadowColor = Theme.PRIMARY_DARK_COLOR.cgColor
        correctButton.layer.shadowRadius = 3
        correctButton.layer.shadowOpacity = 0
        correctButton.translatesAutoresizingMaskIntoConstraints = false
        correctButton.setTitle("Correct Location?", for: .normal)
        correctButton.tintColor = UIColor.white
        correctButton.layer.cornerRadius = 15
        correctButton.alpha = 0
        
        addANewParkingView.addSubview(correctButton)
        correctButton.centerXAnchor.constraint(equalTo: addANewParkingView.centerXAnchor).isActive = true
        correctButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        correctButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
        correctButtonBottomAnchor = correctButton.bottomAnchor.constraint(equalTo: addANewParkingView.bottomAnchor, constant: 40)
        correctButtonBottomAnchor.isActive = true
        
        let exitButton = UIButton()
        let exitImage = UIImage(named: "exit")
        exitButton.setImage(exitImage, for: .normal)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.addTarget(self, action: #selector(exitAddParking), for: .touchUpInside)
        addANewParkingView.addSubview(exitButton)
        
        exitButton.rightAnchor.constraint(equalTo: addANewParkingView.rightAnchor, constant: 16).isActive = true
        exitButton.topAnchor.constraint(equalTo: addANewParkingView.topAnchor, constant: -16).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    @objc func exitAddParking(sender: UIButton) {
        delegate?.removeNewParkingView()
    }
    
    @objc func searchBarSearching() {
        
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        let filter = GMSAutocompleteFilter()
        autoCompleteController.autocompleteFilter = filter
        
        self.present(autoCompleteController, animated: true, completion: nil)
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        lattitudeConstant = place.coordinate.latitude
        longitudeConstant = place.coordinate.longitude
        
        let camera = GMSCameraPosition.camera(withLatitude: lattitudeConstant, longitude: longitudeConstant, zoom: 18.0)
        mapView.camera = camera
        searchBar.text = place.formattedAddress
        formattedAddress = place.formattedAddress!
        
        let addressSeparated = formattedAddress.components(separatedBy: ",")
        cityAddress = addressSeparated[1] + addressSeparated[2]
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lattitudeConstant, longitude: longitudeConstant)
        marker.title = "\(place.name)"
        marker.snippet = "\(place.formattedAddress!)"
        marker.map = mapView
        
        checkDistance()
        
        self.dismiss(animated: true) {
            self.correctButtonBottomAnchor.constant = -20
            self.correctButton.addTarget(self, action: #selector(self.selectPanoView(sender:)), for: .touchUpInside)
            UIView.animate(withDuration: 1, animations: {
                self.correctButton.alpha = 1
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func checkDistance() {
        let location = CLLocation(latitude: lattitudeConstant, longitude: longitudeConstant)
        let distanceFromLocation = location.distance(from: DenverLocation)
        print(distanceFromLocation)
        if distanceFromLocation <= tenMiles {
            expensesListing = 1
        } else {
            expensesListing = 0
        }
    }
    
    @objc func selectPanoView(sender: UIButton) {
        let alert = UIAlertController(title: "Select an Image:", message: "How would you like to upload an image of the parking spot?", preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.addAction(UIAlertAction(title: "Camera Roll", style: UIAlertActionStyle.default, handler: { action in
            self.handleSelectParkingImageView()
        }))
        alert.addAction(UIAlertAction(title: "Google Street View", style: UIAlertActionStyle.default, handler: { action in
            self.sendAlready()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func sendAlready() {
        let panoViewController = PanoViewController()
        panoViewController.delegate = self
        present(panoViewController, animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("ERROR AUTO COMPLETE \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupTextField(textField: UITextField, img: UIImage){
        textField.leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
        imageView.image = img
        let paddingView = UIView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
        paddingView.addSubview(imageView)
        textField.leftView = paddingView
    }
    
    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StartUpViewController") as! StartUpViewController
        
        present(viewController, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        addANewParkingView.endEditing(true)
    }
    
    @objc func tabBarRight() {
        print("Rightmost VC")
    }
    @objc func tabBarLeft() {
        UIView.animate(withDuration: 0.5, animations: {
            self.tabBarController?.selectedIndex = 1
        }, completion: nil)
    }
    
    
    @IBAction func unwindToAccount(segue: UIStoryboardSegue) {}
    
    func takeScreenShot() {
        
        self.view.addSubview(fullBlurView)
        fullBlurView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        fullBlurView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        fullBlurView.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true
        fullBlurView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        
        screenShotView = UIImageView(image: parkingSpotImage)
        screenShotView.contentMode = .scaleAspectFit
        screenShotView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(screenShotView)
        
        screenShotView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        screenShotView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        screenShotView.heightAnchor.constraint(equalToConstant: self.view.frame.height - 120).isActive = true
        screenShotView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        
        self.view.addSubview(exitButton)
        exitButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        exitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.view.addSubview(dotLabel)
        dotLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 24).isActive = true
        dotLabel.rightAnchor.constraint(equalTo: exitButton.leftAnchor, constant: 4).isActive = true
        dotLabel.centerYAnchor.constraint(equalTo: exitButton.centerYAnchor).isActive = true
        dotLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        
        self.view.addSubview(dotShotButton)
        dotShotButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dotShotButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        dotShotButton.widthAnchor.constraint(equalToConstant: 215).isActive = true
        dotShotButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true

        addOverlay()
    }
    
    @objc func finalScreenShot(sender: UIButton) {
        let contextImage = view?.snapshot
        let rect = CGRect(x: 0, y: 300, width: self.view.frame.width, height: self.view.frame.height + 80)
        let croppedImage = cropping(contextImage!, toRect: rect)
        parkingSpotImage = croppedImage
        parking = parking + 1
        startActivityIndicator()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.screenShotView.removeFromSuperview()
            self.activityIndicatorView.stopAnimating()
            self.fullBlurView.removeFromSuperview()
            self.fullBlur.removeFromSuperview()
            self.dotLabel.removeFromSuperview()
            self.dotShotButton.removeFromSuperview()
            self.overlay.removeFromSuperview()
            self.exitButton.removeFromSuperview()
            dot1.removeFromSuperview()
            dot2.removeFromSuperview()
            dot3.removeFromSuperview()
            dot4.removeFromSuperview()
            self.shapeLayer.removeFromSuperlayer()
            self.delegate?.setupNewParking(parkingImage: ParkingImage.yesImage)
        })
    }
    
    func endPano() {
        self.delegate?.setupNewParking(parkingImage: ParkingImage.yesImage)
    }
    
    @objc func dismissPano() {
        self.delegate?.removeNewParkingView()
        self.screenShotView.removeFromSuperview()
    }
    
    func startActivityIndicator() {
        self.view.addSubview(self.fullBlur)
        
        self.fullBlur.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.fullBlur.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.fullBlur.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.fullBlur.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        self.view.addSubview(self.activityIndicatorView)
        self.activityIndicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.activityIndicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.activityIndicatorView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.activityIndicatorView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.activityIndicatorView.startAnimating()
    }
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    let startActivityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    var dot1View: UIView!
    var dot2View: UIView!
    var dot3View: UIView!
    var dot4View: UIView!
    
    func addOverlay() {
        
        dot1 = UIButton(frame: CGRect(x: 100, y: 300, width: 36, height: 36))
        dot1.layer.cornerRadius = 18
        dot1.layer.backgroundColor = UIColor.clear.cgColor
        dot1.translatesAutoresizingMaskIntoConstraints = false
        let pan1 = UIPanGestureRecognizer(target: self, action: #selector(panButton1(sender:)))
        dot1.addGestureRecognizer(pan1)
        view.addSubview(dot1)
        
        dot1View = UIView()
        dot1View.layer.cornerRadius = 4
        dot1View.backgroundColor = Theme.PRIMARY_COLOR
        dot1View.center = dot1.center
        dot1View.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dot1View)
        
        dot1View.widthAnchor.constraint(equalToConstant: 8).isActive = true
        dot1View.heightAnchor.constraint(equalToConstant: 8).isActive = true
        dot1View.centerXAnchor.constraint(equalTo: dot1.centerXAnchor).isActive = true
        dot1View.centerYAnchor.constraint(equalTo: dot1.centerYAnchor).isActive = true
        
        dot1.widthAnchor.constraint(equalToConstant: 36).isActive = true
        dot1.heightAnchor.constraint(equalToConstant: 36).isActive = true
        dot1.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: 100).isActive = true
        dot1.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 300).isActive = true
        
        dot2 = UIButton(frame: CGRect(x: 200, y: 300, width: 36, height: 36))
        dot2.layer.cornerRadius = 18
        dot2.backgroundColor = UIColor.clear
        dot2.translatesAutoresizingMaskIntoConstraints = false
        let pan2 = UIPanGestureRecognizer(target: self, action: #selector(panButton2(sender:)))
        dot2.addGestureRecognizer(pan2)
        view.addSubview(dot2)
        
        dot2View = UIView()
        dot2View.layer.cornerRadius = 4
        dot2View.backgroundColor = Theme.PRIMARY_COLOR
        dot2View.center = dot1.center
        dot2View.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dot2View)
        
        dot2View.widthAnchor.constraint(equalToConstant: 8).isActive = true
        dot2View.heightAnchor.constraint(equalToConstant: 8).isActive = true
        dot2View.centerXAnchor.constraint(equalTo: dot2.centerXAnchor).isActive = true
        dot2View.centerYAnchor.constraint(equalTo: dot2.centerYAnchor).isActive = true
        
        dot2.widthAnchor.constraint(equalToConstant: 36).isActive = true
        dot2.heightAnchor.constraint(equalToConstant: 36).isActive = true
        dot2.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: 200).isActive = true
        dot2.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 300).isActive = true
        
        dot3 = UIButton(frame: CGRect(x: 200, y: 400, width: 36, height: 36))
        dot3.layer.cornerRadius = 18
        dot3.backgroundColor = UIColor.clear
        dot3.translatesAutoresizingMaskIntoConstraints = false
        let pan3 = UIPanGestureRecognizer(target: self, action: #selector(panButton3(sender:)))
        dot3.addGestureRecognizer(pan3)
        view.addSubview(dot3)
        
        dot3View = UIView()
        dot3View.layer.cornerRadius = 4
        dot3View.backgroundColor = Theme.PRIMARY_COLOR
        dot3View.center = dot1.center
        dot3View.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dot3View)
        
        dot3View.widthAnchor.constraint(equalToConstant: 8).isActive = true
        dot3View.heightAnchor.constraint(equalToConstant: 8).isActive = true
        dot3View.centerXAnchor.constraint(equalTo: dot3.centerXAnchor).isActive = true
        dot3View.centerYAnchor.constraint(equalTo: dot3.centerYAnchor).isActive = true
        
        dot3.widthAnchor.constraint(equalToConstant: 36).isActive = true
        dot3.heightAnchor.constraint(equalToConstant: 36).isActive = true
        dot3.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: 200).isActive = true
        dot3.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 400).isActive = true
        
        dot4 = UIButton(frame: CGRect(x: 100, y: 400, width: 36, height: 36))
        dot4.layer.cornerRadius = 18
        dot4.backgroundColor = UIColor.clear
        dot4.translatesAutoresizingMaskIntoConstraints = false
        let pan4 = UIPanGestureRecognizer(target: self, action: #selector(panButton4(sender:)))
        dot4.addGestureRecognizer(pan4)
        view.addSubview(dot4)
        
        dot4View = UIView()
        dot4View.layer.cornerRadius = 4
        dot4View.backgroundColor = Theme.PRIMARY_COLOR
        dot4View.center = dot1.center
        dot4View.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dot4View)
        
        dot4View.widthAnchor.constraint(equalToConstant: 8).isActive = true
        dot4View.heightAnchor.constraint(equalToConstant: 8).isActive = true
        dot4View.centerXAnchor.constraint(equalTo: dot4.centerXAnchor).isActive = true
        dot4View.centerYAnchor.constraint(equalTo: dot4.centerYAnchor).isActive = true
        
        dot4.widthAnchor.constraint(equalToConstant: 36).isActive = true
        dot4.heightAnchor.constraint(equalToConstant: 36).isActive = true
        dot4.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: 100).isActive = true
        dot4.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 400).isActive = true
        
        self.view.layer.addSublayer(shapeLayer)
        startPan()
        
    }
    
    func cropping(_ inputImage: UIImage, toRect cropRect: CGRect) -> UIImage {
        
        let cropZone = CGRect(x:cropRect.origin.x,
                              y:cropRect.origin.y,
                              width:cropRect.size.width * 2,
                              height:cropRect.size.height)
        
        guard let cutImageRef: CGImage = inputImage.cgImage?.cropping(to:cropZone)
            else {
                return inputImage
        }
        
        let croppedImage: UIImage = UIImage(cgImage: cutImageRef)
        return croppedImage
        
    }
    
    func startPan() {
        let location1 = CGPoint(x: 100, y: 300)
        let location2 = CGPoint(x: 200, y: 300)
        let location3 = CGPoint(x: 200, y: 400)
        let location4 = CGPoint(x: 100, y: 400)
        dot1.center = location1
        dot1View.center = location1
        dot2.center = location2
        dot2View.center = location2
        dot3.center = location3
        dot3View.center = location3
        dot4.center = location4
        dot4View.center = location4
        moveOverlay()
    }
    
    @objc func panButton1(sender: UIPanGestureRecognizer){
        if sender.state == .began {
            //wordButtonCenter = button.center // store old button center
        } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
            //button.center = wordButtonCenter // restore button center
        } else {
            let location = sender.location(in: view) // get pan location
            dot1.center = location // set button to where finger is
            dot1View.center = location
        }
        moveOverlay()
    }
    
    @objc func panButton2(sender: UIPanGestureRecognizer){
        if sender.state == .began {
            //wordButtonCenter = button.center // store old button center
        } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
            //button.center = wordButtonCenter // restore button center
        } else {
            let location = sender.location(in: view) // get pan location
            dot2.center = location // set button to where finger is
            dot2View.center = location
        }
        moveOverlay()
    }
    
    @objc func panButton3(sender: UIPanGestureRecognizer){
        if sender.state == .began {
            //wordButtonCenter = button.center // store old button center
        } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
            //button.center = wordButtonCenter // restore button center
        } else {
            let location = sender.location(in: view) // get pan location
            dot3.center = location // set button to where finger is
            dot3View.center = location
        }
        moveOverlay()
    }
    
    @objc func panButton4(sender: UIPanGestureRecognizer){
        if sender.state == .began {
            //wordButtonCenter = button.center // store old button center
        } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
            //button.center = wordButtonCenter // restore button center
        } else {
            let location = sender.location(in: view) // get pan location
            dot4.center = location // set button to where finger is
            dot4View.center = location
        }
        moveOverlay()
    }
    
    let shapeLayer = CAShapeLayer()
    
    func moveOverlay() {
        //        self.view.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        let width: CGFloat = 640
        let height: CGFloat = 640
        
        shapeLayer.frame = CGRect(x: 0, y: 0,
                                  width: width, height: height)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: dot1.center.x, y: dot1.center.y))
        path.addLine(to: CGPoint(x: dot2.center.x, y: dot2.center.y))
        path.addLine(to: CGPoint(x: dot3.center.x, y: dot3.center.y))
        path.addLine(to: CGPoint(x: dot4.center.x, y: dot4.center.y))
        path.close()
        
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = Theme.PRIMARY_COLOR.cgColor
        shapeLayer.fillColor = Theme.PRIMARY_COLOR.withAlphaComponent(0.5).cgColor
        shapeLayer.fillRule = kCAFillRuleEvenOdd
    }

}


// Handle the user's selection.
extension AccountViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}