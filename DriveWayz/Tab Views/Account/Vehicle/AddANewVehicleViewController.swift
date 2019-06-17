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

class AddANewVehicleViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
//    var delegate: controlsNewParking?
    var delegate: controlsAccountOptions?
    
    var vehicleImageURL: String?
    var vehicles: Int = 0
    var color: String = "Black"
    
    var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var registerANewVehicleLabel: UILabel!
    
    lazy var vehicleLicensePlate: MadokaTextField = {
        let vehicleLicensePlate = MadokaTextField(frame: CGRect(x: 0, y: 0, width: 150, height: 63))
        vehicleLicensePlate.placeholderColor = Theme.DARK_GRAY
        vehicleLicensePlate.borderColor = Theme.BLACK
        vehicleLicensePlate.placeholder = "Enter a Valid License Plate Number"
        vehicleLicensePlate.textColor = Theme.DARK_GRAY
        vehicleLicensePlate.font = Fonts.SSPLightH4
        vehicleLicensePlate.translatesAutoresizingMaskIntoConstraints = false
        vehicleLicensePlate.textAlignment = .center
        
        return vehicleLicensePlate
    }()
    
    lazy var vehicleYear: MadokaTextField = {
        let vehicleYear = MadokaTextField(frame: CGRect(x: 0, y: 0, width: 150, height: 63))
        vehicleYear.placeholderColor = Theme.DARK_GRAY
        vehicleYear.borderColor = Theme.BLACK
        vehicleYear.placeholder = "Enter the Vehicle Year"
        vehicleYear.textColor = Theme.DARK_GRAY
        vehicleYear.font = Fonts.SSPLightH4
        vehicleYear.translatesAutoresizingMaskIntoConstraints = false
        
        return vehicleYear
    }()
    
    lazy var vehicleModel: MadokaTextField = {
        let vehicleModel = MadokaTextField(frame: CGRect(x: 0, y: 0, width: 150, height: 63))
        vehicleModel.placeholderColor = Theme.DARK_GRAY
        vehicleModel.borderColor = Theme.BLACK
        vehicleModel.placeholder = "Enter the Vehicle Model"
        vehicleModel.textColor = Theme.DARK_GRAY
        vehicleModel.font = Fonts.SSPLightH4
        vehicleModel.translatesAutoresizingMaskIntoConstraints = false
        
        return vehicleModel
    }()
    
    lazy var vehicleMake: MadokaTextField = {
        let vehicleMake = MadokaTextField(frame: CGRect(x: 0, y: 0, width: 150, height: 63))
        vehicleMake.placeholderColor = Theme.DARK_GRAY
        vehicleMake.borderColor = Theme.BLACK
        vehicleMake.placeholder = "Enter the Vehicle Maker"
        vehicleMake.textColor = Theme.DARK_GRAY
        vehicleMake.font = Fonts.SSPLightH4
        vehicleMake.translatesAutoresizingMaskIntoConstraints = false
        
        return vehicleMake
    }()
    
    var vehicleImageView: UIImageView = {
        let imageVehicle = UIImage(named: "profileprofile")
        let vehicleImageView = UIImageView(image: imageVehicle)
        vehicleImageView.isUserInteractionEnabled = true
        vehicleImageView.translatesAutoresizingMaskIntoConstraints = false
        vehicleImageView.contentMode = .scaleAspectFill
        vehicleImageView.layer.shadowColor = Theme.DARK_GRAY.cgColor
        vehicleImageView.layer.shadowRadius = 1
        vehicleImageView.layer.shadowOpacity = 0.8
        vehicleImageView.layer.shadowOffset = CGSize(width: 0, height: 1)
        vehicleImageView.layer.cornerRadius = 5
        
        return vehicleImageView
    }()
    
    let activityIndicatorVehicleView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .gray)
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
        color.setValue(Theme.BLUE, forKeyPath: "textColor")
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
        let button = UIButton()
        let origImage = UIImage(named: "Delete")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(exitAddVehicle), for: .touchUpInside)
        
        return button
    }()
    
    var saveVehicleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.setTitle("", for: .selected)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.borderColor = Theme.BLUE.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(saveVehicleButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.2
        view.layer.cornerRadius = 4
        
        self.colorPicker.delegate = self
        self.colorPicker.dataSource = self

        setupAddAVehicleView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupAddAVehicleView() {
        
        self.view.addSubview(containerView)
        containerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
    
        containerView.addSubview(saveVehicleButton)
        saveVehicleButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        saveVehicleButton.widthAnchor.constraint(equalToConstant: 160).isActive = true
        saveVehicleButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -100).isActive = true
        saveVehicleButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        saveVehicleButton.addSubview(activityIndicatorVehicleView)
        activityIndicatorVehicleView.centerXAnchor.constraint(equalTo: saveVehicleButton.centerXAnchor).isActive = true
        activityIndicatorVehicleView.centerYAnchor.constraint(equalTo: saveVehicleButton.centerYAnchor).isActive = true
        activityIndicatorVehicleView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicatorVehicleView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        containerView.addSubview(vehicleMake)
        vehicleMake.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
        vehicleMake.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        vehicleMake.rightAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -4).isActive = true
        vehicleMake.heightAnchor.constraint(equalToConstant: 63).isActive = true
        
        containerView.addSubview(vehicleModel)
        vehicleModel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
        vehicleModel.leftAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 4).isActive = true
        vehicleModel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8).isActive = true
        vehicleModel.heightAnchor.constraint(equalToConstant: 63).isActive = true
        
        containerView.addSubview(vehicleYear)
        vehicleYear.topAnchor.constraint(equalTo: vehicleModel.bottomAnchor, constant: 32).isActive = true
        vehicleYear.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        vehicleYear.rightAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -4).isActive = true
        vehicleYear.heightAnchor.constraint(equalToConstant: 63).isActive = true
        
        containerView.addSubview(colorPicker)
        colorPicker.topAnchor.constraint(equalTo: vehicleModel.bottomAnchor, constant: 32).isActive = true
        colorPicker.leftAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 50).isActive = true
        colorPicker.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8).isActive = true
        colorPicker.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        containerView.addSubview(colorView)
        colorView.centerYAnchor.constraint(equalTo: colorPicker.centerYAnchor).isActive = true
        colorView.rightAnchor.constraint(equalTo: colorPicker.leftAnchor, constant: -10).isActive = true
        colorView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        colorView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        containerView.addSubview(vehicleLicensePlate)
        vehicleLicensePlate.topAnchor.constraint(equalTo: vehicleYear .bottomAnchor, constant: 32).isActive = true
        vehicleLicensePlate.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 80).isActive = true
        vehicleLicensePlate.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -80).isActive = true
        vehicleLicensePlate.heightAnchor.constraint(equalToConstant: 63).isActive = true

        self.view.addSubview(exitButton)
        exitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24).isActive = true
        exitButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 40).isActive = true

    }
    
    @objc func handleSelectVehicleImageView() {
        pickerVehicle = UIImagePickerController()
        pickerVehicle?.delegate = self
        pickerVehicle?.allowsEditing = true
        
        present(pickerVehicle!, animated: true, completion: nil)
    }
    
    var pickerVehicle: UIImagePickerController?
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        
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
        vehicleLicensePlate.endEditing(true)
        
        if vehicleMake.text != "" && vehicleModel.text != "" && vehicleYear.text != "" && vehicleLicensePlate.text != "" && vehicleImageView.image != nil {
            
            guard let make = vehicleMake.text, let model = vehicleModel.text, let year = vehicleYear.text, let license = vehicleLicensePlate.text, let image = vehicleImageView.image else {
                print("Error")
                return
            }
            
            activityIndicatorVehicleView.startAnimating()
            self.saveVehicleButton.isSelected = true
            
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("vehicle_images").child("\(imageName).jpg")
            if let uploadData = image.jpegData(compressionQuality: 0.5) {
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
                            
                            let properties = ["vehicleMake" : make, "vehicleModel" : model, "vehicleYear" : year, "vehicleLicensePlate" : license, "vehicleImageURL" : self.vehicleImageURL, "vehicleColor": self.color] as [String : AnyObject]
                            self.addVehicleWithProperties(properties: properties)
                            
                        } else {
                            print("Error finding image url:", error!)
                            return
                        }
                    })
                })
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                UIView.animate(withDuration: 1, animations: {
                    self.saveVehicleButton.isSelected = false
                }, completion: nil)
                self.activityIndicatorVehicleView.stopAnimating()
                self.delegate?.bringVehicleController()
            })
        }
    }
    
    private func addVehicleWithProperties(properties: [String: AnyObject]) {
        let ref = Database.database().reference().child("vehicles")
        let childRef = ref.childByAutoId()
        let id = Auth.auth().currentUser!.uid
        let timestamp = Int(Date().timeIntervalSince1970)
        let userVehicleRef = Database.database().reference().child("user-vehicles").child(id)
        let userRef = Database.database().reference().child("users").child(id).child("Vehicle")
        
        let vehicleID = childRef.key
        userVehicleRef.updateChildValues([vehicleID!: 1])
        userRef.updateChildValues(["vehicleID": vehicleID!])
        
        var values = ["vehicleID": vehicleID!, "id": id, "timestamp": timestamp] as [String : Any]
        
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
        self.delegate?.bringVehicleController()
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
        label.textColor = Theme.BLUE
        label.font = Fonts.SSPRegularH3
        label.text = colorValues[row] as? String
        view.addSubview(label)
        
        return view
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if colorValues[row] as! String == "Black" {
            self.colorView.backgroundColor = UIColor.black
            self.color = "Black"
        } else if colorValues[row] as! String == "Grey" {
            self.colorView.backgroundColor = UIColor.gray
            self.color = "Grey"
        } else if colorValues[row] as! String == "Silver" {
            self.colorView.backgroundColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1)
            self.color = "Silver"
        } else if colorValues[row] as! String == "Blue" {
            self.colorView.backgroundColor = UIColor.blue
            self.color = "Blue"
        } else if colorValues[row] as! String == "Brown" {
            self.colorView.backgroundColor = UIColor.brown
            self.color = "Brown"
        } else if colorValues[row] as! String == "Gold" {
            self.colorView.backgroundColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
            self.color = "Gold"
        } else if colorValues[row] as! String == "Cyan" {
            self.colorView.backgroundColor = UIColor.cyan
            self.color = "Cyan"
        } else if colorValues[row] as! String == "Green" {
            self.colorView.backgroundColor = UIColor.green
            self.color = "Green"
        } else if colorValues[row] as! String == "Magenta" {
            self.colorView.backgroundColor = UIColor.magenta
            self.color = "Magenta"
        } else if colorValues[row] as! String == "Orange" {
            self.colorView.backgroundColor = UIColor.orange
            self.color = "Orange"
        } else if colorValues[row] as! String == "Purple" {
            self.colorView.backgroundColor = UIColor.purple
            self.color = "Purple"
        } else if colorValues[row] as! String == "Red" {
            self.colorView.backgroundColor = UIColor.red
            self.color = "Red"
        } else if colorValues[row] as! String == "Yellow" {
            self.colorView.backgroundColor = UIColor.yellow
            self.color = "Yellow"
        } else if colorValues[row] as! String == "Red" {
            self.colorView.backgroundColor = UIColor.red
            self.color = "Red"
        } else if colorValues[row] as! String == "White" {
            self.colorView.backgroundColor = UIColor.white
            self.color = "White"
        }
    }
    
    @objc func handleDismissKeyboard() {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
