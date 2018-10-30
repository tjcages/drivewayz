//
//  SpotPicturesViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 10/29/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class SpotPicturesViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var currentButton: UIButton?
    var pickerParking: UIImagePickerController?
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var addAnImageButton1: UIButton = {
        let image = UIImage(named: "addImageIcon")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.backgroundColor = Theme.OFF_WHITE
        button.imageEdgeInsets = UIEdgeInsets(top: 42, left: 42, bottom: 42, right: 42)
        button.addTarget(self, action: #selector(selectImageControl(sender:)), for: .touchUpInside)
        button.tag = 1
        button.clipsToBounds = true
        
        return button
    }()
    
    var spotLabel1: TagLabel = {
        let label = TagLabel()
        label.text = "Spot 1"
        label.textColor = Theme.BLACK
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = Theme.OFF_WHITE
        
        return label
    }()
    
    var addAnImageButton2: UIButton = {
        let image = UIImage(named: "addImageIcon")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.backgroundColor = Theme.OFF_WHITE
        button.imageEdgeInsets = UIEdgeInsets(top: 42, left: 42, bottom: 42, right: 42)
        button.addTarget(self, action: #selector(selectImageControl(sender:)), for: .touchUpInside)
        button.tag = 2
        button.clipsToBounds = true
        
        return button
    }()
    
    var spotLabel2: TagLabel = {
        let label = TagLabel()
        label.text = "Spot 2"
        label.textColor = Theme.BLACK
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = Theme.OFF_WHITE
        
        return label
    }()
    
    var addAnImageButton3: UIButton = {
        let image = UIImage(named: "addImageIcon")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.backgroundColor = Theme.OFF_WHITE
        button.imageEdgeInsets = UIEdgeInsets(top: 42, left: 42, bottom: 42, right: 42)
        button.addTarget(self, action: #selector(selectImageControl(sender:)), for: .touchUpInside)
        button.tag = 3
        button.clipsToBounds = true
        
        return button
    }()
    
    var spotLabel3: TagLabel = {
        let label = TagLabel()
        label.text = "Spot 3"
        label.textColor = Theme.BLACK
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = Theme.OFF_WHITE
        
        return label
    }()
    
    var addAnImageButton4: UIButton = {
        let image = UIImage(named: "addImageIcon")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.backgroundColor = Theme.OFF_WHITE
        button.imageEdgeInsets = UIEdgeInsets(top: 42, left: 42, bottom: 42, right: 42)
        button.tag = 4
        button.addTarget(self, action: #selector(selectImageControl(sender:)), for: .touchUpInside)
        button.clipsToBounds = true
        
        return button
    }()
    
    var spotLabel4: TagLabel = {
        let label = TagLabel()
        label.text = "Spot 4"
        label.textColor = Theme.BLACK
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = Theme.OFF_WHITE
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: (self.view.frame.width*5/12)*3)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -5).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(addAnImageButton1)
        addAnImageButton1.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: self.view.frame.width/14).isActive = true
        addAnImageButton1.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        addAnImageButton1.widthAnchor.constraint(equalToConstant: self.view.frame.width*5/12).isActive = true
        addAnImageButton1.heightAnchor.constraint(equalTo: addAnImageButton1.widthAnchor).isActive = true
        
        addAnImageButton1.addSubview(spotLabel1)
        spotLabel1.leftAnchor.constraint(equalTo: addAnImageButton1.leftAnchor).isActive = true
        spotLabel1.topAnchor.constraint(equalTo: addAnImageButton1.topAnchor).isActive = true
        spotLabel1.rightAnchor.constraint(equalTo: addAnImageButton1.rightAnchor).isActive = true
        spotLabel1.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(addAnImageButton2)
        addAnImageButton2.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -self.view.frame.width/14).isActive = true
        addAnImageButton2.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        addAnImageButton2.widthAnchor.constraint(equalToConstant: self.view.frame.width*5/12).isActive = true
        addAnImageButton2.heightAnchor.constraint(equalTo: addAnImageButton2.widthAnchor).isActive = true
        
        addAnImageButton2.addSubview(spotLabel2)
        spotLabel2.leftAnchor.constraint(equalTo: addAnImageButton2.leftAnchor).isActive = true
        spotLabel2.topAnchor.constraint(equalTo: addAnImageButton2.topAnchor).isActive = true
        spotLabel2.rightAnchor.constraint(equalTo: addAnImageButton2.rightAnchor).isActive = true
        spotLabel2.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(addAnImageButton3)
        addAnImageButton3.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: self.view.frame.width/14).isActive = true
        addAnImageButton3.topAnchor.constraint(equalTo: addAnImageButton1.bottomAnchor, constant: 10).isActive = true
        addAnImageButton3.widthAnchor.constraint(equalToConstant: self.view.frame.width*5/12).isActive = true
        addAnImageButton3.heightAnchor.constraint(equalTo: addAnImageButton3.widthAnchor).isActive = true
        
        addAnImageButton3.addSubview(spotLabel3)
        spotLabel3.leftAnchor.constraint(equalTo: addAnImageButton3.leftAnchor).isActive = true
        spotLabel3.topAnchor.constraint(equalTo: addAnImageButton3.topAnchor).isActive = true
        spotLabel3.rightAnchor.constraint(equalTo: addAnImageButton3.rightAnchor).isActive = true
        spotLabel3.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(addAnImageButton4)
        addAnImageButton4.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -self.view.frame.width/14).isActive = true
        addAnImageButton4.topAnchor.constraint(equalTo: addAnImageButton1.bottomAnchor, constant: 10).isActive = true
        addAnImageButton4.widthAnchor.constraint(equalToConstant: self.view.frame.width*5/12).isActive = true
        addAnImageButton4.heightAnchor.constraint(equalTo: addAnImageButton4.widthAnchor).isActive = true
        
        addAnImageButton4.addSubview(spotLabel4)
        spotLabel4.leftAnchor.constraint(equalTo: addAnImageButton4.leftAnchor).isActive = true
        spotLabel4.topAnchor.constraint(equalTo: addAnImageButton4.topAnchor).isActive = true
        spotLabel4.rightAnchor.constraint(equalTo: addAnImageButton4.rightAnchor).isActive = true
        spotLabel4.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    @objc func selectImageControl(sender: UIButton) {
        self.currentButton = sender
        let alert = UIAlertController(title: "Select an Image:", message: "How would you like to upload an image of the parking spot?", preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "Camera Roll", style: UIAlertAction.Style.default, handler: { action in
            self.handleSelectParkingImageView()
        }))
        alert.addAction(UIAlertAction(title: "Take a Photo", style: UIAlertAction.Style.default, handler: { action in
            self.handleTakeAnImageView()
        }))
        alert.addAction(UIAlertAction(title: "Google Street View", style: UIAlertAction.Style.default, handler: { action in
//            self.sendAlready()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }

    @objc func handleSelectParkingImageView() {
        pickerParking = UIImagePickerController()
        pickerParking?.delegate = self
        pickerParking?.allowsEditing = true
        
        present(pickerParking!, animated: true, completion: nil)
    }
    
    @objc func handleTakeAnImageView() {
        pickerParking = UIImagePickerController()
        pickerParking?.delegate = self
        pickerParking?.allowsEditing = true
        pickerParking?.sourceType = .camera
        
        present(pickerParking!, animated: true, completion: nil)
    }
    
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
            if picker == pickerParking {
                self.currentButton?.setImage(selectedImage, for: .normal)
                self.currentButton?.imageEdgeInsets = UIEdgeInsets.zero
            }
        }
        dismiss(animated: true) {
            self.view.layoutIfNeeded()
        }
    }
    
}


fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
