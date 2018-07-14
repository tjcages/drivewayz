//
//  AddANewVehicleViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 7/9/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase
import TextFieldEffects

class AddANewVehicleViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var addANewVehicleView: UIView!
    @IBOutlet weak var addAWhiteVehicleView: UIView!
    @IBOutlet weak var primaryColorLine: UIView!
    @IBOutlet weak var registerANewVehicleLabel: UILabel!
    
    var vehicleLicensePlate: MadokaTextField!
    var vehicleYear: MadokaTextField!
    var vehicleModel: MadokaTextField!
    var vehicleMake: MadokaTextField!
    var vehicleImageView: UIImageView!
    var vehicleImageURL: String?
    var vehicles: Int = 0
    
    let activityIndicatorVehicleView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    let colorPicker: UIPickerView = {
        let color = UIPickerView()
        color.backgroundColor = UIColor.clear
        color.tintColor = Theme.WHITE
        color.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        color.translatesAutoresizingMaskIntoConstraints = false
        color.setValue(Theme.PRIMARY_DARK_COLOR, forKeyPath: "textColor")
        color.alpha = 1
        
        return color
    }()
    
    let colorView: UIView = {
        let color = UIView()
        color.translatesAutoresizingMaskIntoConstraints = false
        color.backgroundColor = UIColor.black
        color.layer.shadowColor = Theme.DARK_GRAY.cgColor
        color.layer.shadowRadius = 1
        color.layer.shadowOpacity = 0.8
        color.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        return color
    }()
    
    private let colorValues: NSArray = ["Black", "Grey", "Silver", "Blue", "Brown", "Gold", "Cyan", "Green", "Magenta", "Orange", "Purple", "Red", "Yellow", "White"]

    lazy var exitButton: UIButton = {
        let exitButton = UIButton()
        let exitImage = UIImage(named: "exit")
        exitButton.setImage(exitImage, for: .normal)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.addTarget(self, action: #selector(exitAddVehicle), for: .touchUpInside)
        
        return exitButton
    }()
    
    let visualBlurEffect: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 1
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false

        return blurEffectView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Theme.OFF_WHITE
        self.tabBarController?.tabBar.isHidden = true

        UIApplication.shared.statusBarStyle = .lightContent

        setupAddAVehicleView()
        
    }
    
    var newVehiclePageHeightAnchorSmall: NSLayoutConstraint!
    var newVehiclePageHeightAnchorTall: NSLayoutConstraint!
    var newParkingPageHeightAnchorSmall: NSLayoutConstraint!
    var newParkingPageHeightAnchorTall: NSLayoutConstraint!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var scrollViewVehicle: UIScrollView!
    var saveVehicleButton: UIButton!
    
    func setupAddAVehicleView() {
        
        self.view.addSubview(addANewVehicleView)
        self.view.sendSubview(toBack: addANewVehicleView)
        addANewVehicleView.layer.cornerRadius = 20
        addANewVehicleView.clipsToBounds = true
        addANewVehicleView.isUserInteractionEnabled = true
        addANewVehicleView.translatesAutoresizingMaskIntoConstraints = false
        addANewVehicleView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        addANewVehicleView.alpha = 0
        
        addANewVehicleView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        addANewVehicleView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        addANewVehicleView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 16).isActive = true
        addANewVehicleView.heightAnchor.constraint(equalToConstant: self.view.frame.height - 40).isActive = true
        
        visualBlurEffect.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        visualBlurEffect.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        visualBlurEffect.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        visualBlurEffect.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true
        
        scrollViewVehicle = UIScrollView(frame: view.bounds)
        scrollViewVehicle.backgroundColor = UIColor.clear
        scrollViewVehicle.isScrollEnabled = true
        scrollViewVehicle.showsVerticalScrollIndicator = true
        scrollViewVehicle.showsHorizontalScrollIndicator = false
        scrollViewVehicle.translatesAutoresizingMaskIntoConstraints = false
        scrollViewVehicle.contentSize = CGSize(width: addANewVehicleView.frame.width, height: addANewVehicleView.frame.height * 5 / 6 + 50)
        addANewVehicleView.addSubview(scrollViewVehicle)
        addANewVehicleView.sendSubview(toBack: scrollViewVehicle)
        
        scrollViewVehicle.topAnchor.constraint(equalTo: addANewVehicleView.topAnchor, constant: 115).isActive = true
        scrollViewVehicle.bottomAnchor.constraint(equalTo: addANewVehicleView.bottomAnchor, constant: 16).isActive = true
        scrollViewVehicle.leftAnchor.constraint(equalTo: addANewVehicleView.leftAnchor).isActive = true
        scrollViewVehicle.rightAnchor.constraint(equalTo: addANewVehicleView.rightAnchor).isActive = true
        
        let imageVehicle = UIImage(named: "profileprofile")
        vehicleImageView = UIImageView(image: imageVehicle)
        vehicleImageView.isUserInteractionEnabled = true
        vehicleImageView.translatesAutoresizingMaskIntoConstraints = false
        vehicleImageView.contentMode = .scaleAspectFill
        vehicleImageView.backgroundColor = UIColor.white
        vehicleImageView.layer.shadowColor = Theme.DARK_GRAY.cgColor
        vehicleImageView.layer.shadowRadius = 3
        vehicleImageView.layer.shadowOpacity = 0.8
        vehicleImageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        vehicleImageView.clipsToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSelectVehicleImageView(sender:)))
        vehicleImageView.addGestureRecognizer(tapGesture)
        scrollViewVehicle.addSubview(vehicleImageView)
        
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: self.addANewVehicleView.frame.width - 208, height: 180))
        outerView.clipsToBounds = false
        outerView.layer.shadowColor = Theme.DARK_GRAY.cgColor
        outerView.layer.shadowOpacity = 0.8
        outerView.layer.shadowOffset = CGSize.zero
        outerView.layer.shadowRadius = 3
        outerView.layer.shadowPath = UIBezierPath(roundedRect: outerView.bounds, cornerRadius: 0).cgPath
        outerView.translatesAutoresizingMaskIntoConstraints = false
        scrollViewVehicle.addSubview(outerView)
        scrollViewVehicle.sendSubview(toBack: outerView)
        
        vehicleImageView.leftAnchor.constraint(equalTo: addANewVehicleView.leftAnchor, constant: 40).isActive = true
        vehicleImageView.rightAnchor.constraint(equalTo: addANewVehicleView.rightAnchor, constant: -40).isActive = true
        vehicleImageView.topAnchor.constraint(equalTo: scrollViewVehicle.topAnchor, constant: 20).isActive = true
        vehicleImageView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        
        outerView.leftAnchor.constraint(equalTo: vehicleImageView.leftAnchor).isActive = true
        outerView.rightAnchor.constraint(equalTo: vehicleImageView.rightAnchor).isActive = true
        outerView.topAnchor.constraint(equalTo: vehicleImageView.topAnchor).isActive = true
        outerView.heightAnchor.constraint(equalTo: vehicleImageView.heightAnchor).isActive = true
        
        vehicleMake = MadokaTextField(frame: CGRect(x: 0, y: 0, width: addANewVehicleView.frame.width, height: 63))
        vehicleMake.placeholderColor = Theme.DARK_GRAY
        vehicleMake.borderColor = Theme.PRIMARY_COLOR
        vehicleMake.placeholder = "Enter the Vehicle Maker"
        vehicleMake.textColor = Theme.DARK_GRAY
        vehicleMake.font = UIFont.systemFont(ofSize: 18, weight: .light)
        vehicleMake.translatesAutoresizingMaskIntoConstraints = false
        addANewVehicleView.addSubview(vehicleMake)
        
        vehicleMake.topAnchor.constraint(equalTo: vehicleImageView.bottomAnchor, constant: 32).isActive = true
        vehicleMake.leftAnchor.constraint(equalTo: addANewVehicleView.leftAnchor, constant: 8).isActive = true
        vehicleMake.rightAnchor.constraint(equalTo: addANewVehicleView.centerXAnchor, constant: -4).isActive = true
        vehicleMake.heightAnchor.constraint(equalToConstant: 63).isActive = true
        
        vehicleModel = MadokaTextField(frame: CGRect(x: 0, y: 0, width: addANewVehicleView.frame.width, height: 63))
        vehicleModel.placeholderColor = Theme.DARK_GRAY
        vehicleModel.borderColor = Theme.PRIMARY_COLOR
        vehicleModel.placeholder = "Enter the Vehicle Model"
        vehicleModel.textColor = Theme.DARK_GRAY
        vehicleModel.font = UIFont.systemFont(ofSize: 18, weight: .light)
        vehicleModel.translatesAutoresizingMaskIntoConstraints = false
        addANewVehicleView.addSubview(vehicleModel)
        
        vehicleModel.topAnchor.constraint(equalTo: vehicleImageView.bottomAnchor, constant: 32).isActive = true
        vehicleModel.leftAnchor.constraint(equalTo: addANewVehicleView.centerXAnchor, constant: 4).isActive = true
        vehicleModel.rightAnchor.constraint(equalTo: addANewVehicleView.rightAnchor, constant: -8).isActive = true
        vehicleModel.heightAnchor.constraint(equalToConstant: 63).isActive = true
        
        vehicleYear = MadokaTextField(frame: CGRect(x: 0, y: 0, width: addANewVehicleView.frame.width, height: 63))
        vehicleYear.placeholderColor = Theme.DARK_GRAY
        vehicleYear.borderColor = Theme.PRIMARY_COLOR
        vehicleYear.placeholder = "Enter the Vehicle Year"
        vehicleYear.textColor = Theme.DARK_GRAY
        vehicleYear.font = UIFont.systemFont(ofSize: 18, weight: .light)
        vehicleYear.translatesAutoresizingMaskIntoConstraints = false
        addANewVehicleView.addSubview(vehicleYear)
        
        vehicleYear.topAnchor.constraint(equalTo: vehicleModel.bottomAnchor, constant: 32).isActive = true
        vehicleYear.leftAnchor.constraint(equalTo: addANewVehicleView.leftAnchor, constant: 8).isActive = true
        vehicleYear.rightAnchor.constraint(equalTo: addANewVehicleView.centerXAnchor, constant: -4).isActive = true
        vehicleYear.heightAnchor.constraint(equalToConstant: 63).isActive = true
        
        addANewVehicleView.addSubview(colorPicker)
        colorPicker.topAnchor.constraint(equalTo: vehicleModel.bottomAnchor, constant: 32).isActive = true
        colorPicker.leftAnchor.constraint(equalTo: addANewVehicleView.centerXAnchor, constant: 60).isActive = true
        colorPicker.rightAnchor.constraint(equalTo: addANewVehicleView.rightAnchor, constant: -8).isActive = true
        colorPicker.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        addANewVehicleView.addSubview(colorView)
        colorView.centerYAnchor.constraint(equalTo: colorPicker.centerYAnchor).isActive = true
        colorView.rightAnchor.constraint(equalTo: colorPicker.leftAnchor, constant: -10).isActive = true
        colorView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        colorView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        vehicleLicensePlate = MadokaTextField(frame: CGRect(x: 0, y: 0, width: addANewVehicleView.frame.width, height: 63))
        vehicleLicensePlate!.placeholderColor = Theme.DARK_GRAY
        vehicleLicensePlate!.borderColor = Theme.PRIMARY_COLOR
        vehicleLicensePlate!.placeholder = "Enter a Valid License Plate Number"
        vehicleLicensePlate!.textColor = Theme.DARK_GRAY
        vehicleLicensePlate!.font = UIFont.systemFont(ofSize: 18, weight: .light)
        vehicleLicensePlate!.translatesAutoresizingMaskIntoConstraints = false
        addANewVehicleView.addSubview(vehicleLicensePlate!)
        
        vehicleLicensePlate?.topAnchor.constraint(equalTo: vehicleYear .bottomAnchor, constant: 32).isActive = true
        vehicleLicensePlate?.leftAnchor.constraint(equalTo: addANewVehicleView.leftAnchor, constant: 24).isActive = true
        vehicleLicensePlate?.rightAnchor.constraint(equalTo: addANewVehicleView.rightAnchor, constant: -24).isActive = true
        vehicleLicensePlate?.heightAnchor.constraint(equalToConstant: 63).isActive = true
        
        saveVehicleButton = UIButton()
        saveVehicleButton.backgroundColor = Theme.PRIMARY_COLOR
        saveVehicleButton.setTitle("Save", for: .normal)
        saveVehicleButton.setTitle("", for: .selected)
        saveVehicleButton.titleLabel?.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        saveVehicleButton.translatesAutoresizingMaskIntoConstraints = false
        saveVehicleButton.titleLabel?.textColor = Theme.WHITE
        saveVehicleButton.titleLabel?.shadowColor = Theme.DARK_GRAY
        saveVehicleButton.layer.cornerRadius = 30
        saveVehicleButton.layer.shadowColor = Theme.DARK_GRAY.cgColor
        saveVehicleButton.layer.shadowRadius = 3
        saveVehicleButton.layer.shadowOpacity = 0.8
        saveVehicleButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        saveVehicleButton.addTarget(self, action: #selector(saveVehicleButtonPressed(sender:)), for: .touchUpInside)
        addANewVehicleView.addSubview(saveVehicleButton)
        
        saveVehicleButton.centerXAnchor.constraint(equalTo: addANewVehicleView.centerXAnchor).isActive = true
        saveVehicleButton.topAnchor.constraint(equalTo: vehicleLicensePlate!.bottomAnchor, constant: 64).isActive = true
        saveVehicleButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        saveVehicleButton.widthAnchor.constraint(equalToConstant: self.view.frame.width * 3/4).isActive = true
        
        saveVehicleButton.addSubview(activityIndicatorVehicleView)
        activityIndicatorVehicleView.centerXAnchor.constraint(equalTo: saveVehicleButton.centerXAnchor).isActive = true
        activityIndicatorVehicleView.centerYAnchor.constraint(equalTo: saveVehicleButton.centerYAnchor).isActive = true
        activityIndicatorVehicleView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicatorVehicleView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        addANewVehicleView.addSubview(addAWhiteVehicleView)
        
        addAWhiteVehicleView.translatesAutoresizingMaskIntoConstraints = false
        addAWhiteVehicleView.heightAnchor.constraint(equalToConstant: 115).isActive = true
        
        addANewVehicleView.addSubview(registerANewVehicleLabel)
        
        let exitButton = UIButton()
        let exitImage = UIImage(named: "exit")
        exitButton.setImage(exitImage, for: .normal)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.addTarget(self, action: #selector(exitAddVehicle), for: .touchUpInside)
        addANewVehicleView.addSubview(exitButton)
        
        exitButton.rightAnchor.constraint(equalTo: addAWhiteVehicleView.rightAnchor, constant: 8).isActive = true
        exitButton.topAnchor.constraint(equalTo: addAWhiteVehicleView.topAnchor, constant: -8).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    var pickerVehicle: UIImagePickerController?
    
    @objc func handleSelectVehicleImageView(sender: UITapGestureRecognizer) {
        pickerVehicle = UIImagePickerController()
        pickerVehicle?.delegate = self
        pickerVehicle?.allowsEditing = true
        
        present(pickerVehicle!, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            if picker == pickerVehicle {
                vehicleImageView.image = selectedImage
            }
        }
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let imageName = NSUUID().uuidString
        
        if picker == pickerVehicle {
            let storageRef = Storage.storage().reference().child("vehicle_images").child("\(imageName).jpg")
            if let uploadData = UIImageJPEGRepresentation(self.vehicleImageView.image!, 0.5) {
                storageRef.putData(uploadData, metadata: nil, completion: {  (metadata, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    storageRef.downloadURL(completion: { (url, error) in
                        if url?.absoluteString != nil {
                            self.vehicleImageURL = url?.absoluteString
                            let values = ["vehicleImageURL": self.vehicleImageURL]
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
        exitAddVehicle()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveVehicleButtonPressed(sender: UIButton) {
        vehicleMake.endEditing(true)
        vehicleModel.endEditing(true)
        vehicleYear.endEditing(true)
        vehicleLicensePlate?.endEditing(true)
        
        if vehicleMake.text != "" && vehicleModel.text != "" && vehicleYear.text != "" && vehicleLicensePlate.text != "" && vehicleImageView != nil {
            
            guard let make = vehicleMake.text, let model = vehicleModel.text, let year = vehicleYear.text, let license = vehicleLicensePlate.text, let image = vehicleImageView.image else {
                print("Error")
                return
            }
            print(image)
            let properties = ["vehicleMake" : make, "vehicleModel" : model, "vehicleYear" : year, "vehicleLicensePlate" : license, "vehicleImageURL" : vehicleImageURL] as [String : AnyObject]
            addVehicleWithProperties(properties: properties)
            
            activityIndicatorVehicleView.startAnimating()
            self.saveVehicleButton.isSelected = true
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.exitAddVehicle()
                UIView.animate(withDuration: 1, animations: {
                    self.newVehiclePageHeightAnchorSmall.isActive = false
                    self.newVehiclePageHeightAnchorTall.isActive = true
                    self.saveVehicleButton.isSelected = false
                }, completion: nil)
                self.activityIndicatorVehicleView.stopAnimating()
            })
        }
    }
    
    private func addVehicleWithProperties(properties: [String: AnyObject]) {
        let ref = Database.database().reference().child("vehicles")
        let childRef = ref.childByAutoId()
        let id = Auth.auth().currentUser!.uid
        let timestamp = Int(Date().timeIntervalSince1970)
        let userVehicleRef = Database.database().reference().child("user-vehicles").child(id)
        let userRef = Database.database().reference().child("users").child(id)
        
        let vehicleID = childRef.key
        userVehicleRef.updateChildValues([vehicleID: 1])
        userRef.updateChildValues(["vehicleID": vehicleID])
        
        var values = ["vehicleID": vehicleID, "id": id, "timestamp": timestamp] as [String : Any]
        
        properties.forEach({values[$0] = $1})
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error ?? "")
                return
            }
            self.vehicleMake.text = ""
            self.vehicleModel.text = ""
            self.vehicleYear.text = ""
            self.vehicleLicensePlate.text = ""
            self.vehicleImageView.image = UIImage(named: "profileprofile")
        }
    }
    
    @objc func exitAddVehicle() {
        self.dismiss(animated: true, completion: nil)
        UIView.animate(withDuration: 0.3, animations: {
            self.addANewVehicleView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.addANewVehicleView.alpha = 0
            self.visualBlurEffect.effect = nil
        }) { (success: Bool) in
            self.view.sendSubview(toBack: self.visualBlurEffect)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 20
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colorValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return colorValues[row] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        label.textAlignment = .center
        label.textColor = Theme.PRIMARY_DARK_COLOR
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = colorValues[row] as? String
        view.addSubview(label)
        
        return view
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if colorValues[row] as! String == "Black" {
            self.colorView.backgroundColor = UIColor.black
        } else if colorValues[row] as! String == "Grey" {
            self.colorView.backgroundColor = UIColor.gray
        } else if colorValues[row] as! String == "Silver" {
            self.colorView.backgroundColor = UIColor(r: 192, g: 192, b: 192)
        } else if colorValues[row] as! String == "Blue" {
            self.colorView.backgroundColor = UIColor.blue
        } else if colorValues[row] as! String == "Brown" {
            self.colorView.backgroundColor = UIColor.brown
        } else if colorValues[row] as! String == "Gold" {
            self.colorView.backgroundColor = UIColor(r: 255, g: 215, b: 0)
        } else if colorValues[row] as! String == "Cyan" {
            self.colorView.backgroundColor = UIColor.cyan
        } else if colorValues[row] as! String == "Green" {
            self.colorView.backgroundColor = UIColor.green
        } else if colorValues[row] as! String == "Magenta" {
            self.colorView.backgroundColor = UIColor.magenta
        } else if colorValues[row] as! String == "Orange" {
            self.colorView.backgroundColor = UIColor.orange
        } else if colorValues[row] as! String == "Purple" {
            self.colorView.backgroundColor = UIColor.purple
        } else if colorValues[row] as! String == "Red" {
            self.colorView.backgroundColor = UIColor.red
        } else if colorValues[row] as! String == "Yellow" {
            self.colorView.backgroundColor = UIColor.yellow
        } else if colorValues[row] as! String == "Red" {
            self.colorView.backgroundColor = UIColor.red
        } else if colorValues[row] as! String == "White" {
            self.colorView.backgroundColor = UIColor.white
        }
    }
    
}
