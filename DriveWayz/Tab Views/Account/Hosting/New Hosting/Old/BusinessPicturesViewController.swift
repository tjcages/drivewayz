//
//  BusinessPicturesViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 10/31/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class BusinessPicturesViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, handlePanoImages {
    
    var currentButton: UIButton?
    var pickerParking: UIImagePickerController?
    var delegate: handleImageDrawing?
    var editDelegate: editImagesHandler?
    
    var lattitude: Double = 1.0
    var longitude: Double = 1.0
    
    var imageNumber: Int = 2
    var imagesTaken: Int = 0
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        
        return view
    }()
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPLightH5
        label.numberOfLines = 2
        label.text = "Any parking images will not be shown until a driver has booked the space"
        
        return label
    }()
    
    var additionalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "General images (4 max)"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPLightH3
        
        return label
    }()
    
    var addAnImageButton1: UIButton = {
        let image = UIImage(named: "addImageIcon")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        button.imageEdgeInsets = UIEdgeInsets(top: 42, left: 42, bottom: 42, right: 42)
        button.addTarget(self, action: #selector(selectImageControl(sender:)), for: .touchUpInside)
        button.tag = 1
        button.clipsToBounds = true
        
        return button
    }()
    
    var spotLabel1: TagLabel = {
        let label = TagLabel()
        label.text = " 1"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH5
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = Theme.OFF_WHITE
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        
        return label
    }()
    
    var spotRemove1: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "exit")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.OFF_WHITE
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.layer.cornerRadius = 15
        button.alpha = 0
        button.addTarget(self, action: #selector(removeImagePressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var addAnImageButton2: UIButton = {
        let image = UIImage(named: "addImageIcon")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        button.imageEdgeInsets = UIEdgeInsets(top: 42, left: 42, bottom: 42, right: 42)
        button.addTarget(self, action: #selector(selectImageControl(sender:)), for: .touchUpInside)
        button.tag = 2
        button.clipsToBounds = true
        
        return button
    }()
    
    var spotLabel2: TagLabel = {
        let label = TagLabel()
        label.text = " 2"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH5
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = Theme.OFF_WHITE
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        
        return label
    }()
    
    var spotRemove2: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "exit")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.OFF_WHITE
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.layer.cornerRadius = 15
        button.alpha = 0
        button.addTarget(self, action: #selector(removeImagePressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var addAnImageButton3: UIButton = {
        let image = UIImage(named: "addImageIcon")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        button.imageEdgeInsets = UIEdgeInsets(top: 42, left: 42, bottom: 42, right: 42)
        button.addTarget(self, action: #selector(selectImageControl(sender:)), for: .touchUpInside)
        button.tag = 3
        button.clipsToBounds = true
        
        return button
    }()
    
    var spotLabel3: TagLabel = {
        let label = TagLabel()
        label.text = " 3"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH5
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = Theme.OFF_WHITE
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        
        return label
    }()
    
    var spotRemove3: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "exit")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.OFF_WHITE
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.layer.cornerRadius = 15
        button.alpha = 0
        button.addTarget(self, action: #selector(removeImagePressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var addAnImageButton4: UIButton = {
        let image = UIImage(named: "addImageIcon")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        button.imageEdgeInsets = UIEdgeInsets(top: 42, left: 42, bottom: 42, right: 42)
        button.tag = 4
        button.addTarget(self, action: #selector(selectImageControl(sender:)), for: .touchUpInside)
        button.clipsToBounds = true
        
        return button
    }()
    
    var spotLabel4: TagLabel = {
        let label = TagLabel()
        label.text = " 4"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH5
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = Theme.OFF_WHITE
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        
        return label
    }()
    
    var spotRemove4: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "exit")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.OFF_WHITE
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.layer.cornerRadius = 15
        button.alpha = 0
        button.addTarget(self, action: #selector(removeImagePressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var checkmark: UIButton = {
        let image = UIImage(named: "Checkmark")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.layer.cornerRadius = 15
        button.backgroundColor = Theme.GREEN_PIGMENT
        button.alpha = 0
        
        return button
    }()
    
    var drawController: DrawSpotViewController = {
        let controller = DrawSpotViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawController.delegate = self

        setupViews()
    }
    
    var firstWidthAnchor: NSLayoutConstraint!
    var secondWidthAnchor: NSLayoutConstraint!
    var thirdWidthAnchor: NSLayoutConstraint!
    var fourthWidthAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: (self.view.frame.width*5/12)*4)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(additionalLabel)
        additionalLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        additionalLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        additionalLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16).isActive = true
        additionalLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(addAnImageButton1)
        addAnImageButton1.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: self.view.frame.width/14).isActive = true
        addAnImageButton1.topAnchor.constraint(equalTo: additionalLabel.bottomAnchor, constant: 20).isActive = true
        firstWidthAnchor = addAnImageButton1.widthAnchor.constraint(equalToConstant: self.view.frame.width*5/12)
        firstWidthAnchor.isActive = true
        addAnImageButton1.heightAnchor.constraint(equalTo: addAnImageButton1.widthAnchor).isActive = true
        
        addAnImageButton1.addSubview(spotLabel1)
        spotLabel1.leftAnchor.constraint(equalTo: addAnImageButton1.leftAnchor, constant: 4).isActive = true
        spotLabel1.topAnchor.constraint(equalTo: addAnImageButton1.topAnchor, constant: 4).isActive = true
        spotLabel1.widthAnchor.constraint(equalToConstant: 30).isActive = true
        spotLabel1.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addAnImageButton1.addSubview(spotRemove1)
        spotRemove1.rightAnchor.constraint(equalTo: addAnImageButton1.rightAnchor, constant: -4).isActive = true
        spotRemove1.topAnchor.constraint(equalTo: addAnImageButton1.topAnchor, constant: 4).isActive = true
        spotRemove1.widthAnchor.constraint(equalToConstant: 30).isActive = true
        spotRemove1.heightAnchor.constraint(equalTo: spotRemove1.widthAnchor).isActive = true
        
        scrollView.addSubview(addAnImageButton2)
        addAnImageButton2.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -self.view.frame.width/14).isActive = true
        addAnImageButton2.topAnchor.constraint(equalTo: additionalLabel.bottomAnchor, constant: 20).isActive = true
        secondWidthAnchor = addAnImageButton2.widthAnchor.constraint(equalToConstant: self.view.frame.width*5/12)
        secondWidthAnchor.isActive = true
        addAnImageButton2.heightAnchor.constraint(equalTo: addAnImageButton2.widthAnchor).isActive = true
        
        addAnImageButton2.addSubview(spotLabel2)
        spotLabel2.leftAnchor.constraint(equalTo: addAnImageButton2.leftAnchor, constant: 4).isActive = true
        spotLabel2.topAnchor.constraint(equalTo: addAnImageButton2.topAnchor, constant: 4).isActive = true
        spotLabel2.widthAnchor.constraint(equalToConstant: 30).isActive = true
        spotLabel2.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addAnImageButton2.addSubview(spotRemove2)
        spotRemove2.rightAnchor.constraint(equalTo: addAnImageButton2.rightAnchor, constant: -4).isActive = true
        spotRemove2.topAnchor.constraint(equalTo: addAnImageButton2.topAnchor, constant: 4).isActive = true
        spotRemove2.widthAnchor.constraint(equalToConstant: 30).isActive = true
        spotRemove2.heightAnchor.constraint(equalTo: spotRemove2.widthAnchor).isActive = true
        
        scrollView.addSubview(addAnImageButton3)
        addAnImageButton3.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: self.view.frame.width/14).isActive = true
        addAnImageButton3.topAnchor.constraint(equalTo: addAnImageButton1.bottomAnchor, constant: 10).isActive = true
        thirdWidthAnchor = addAnImageButton3.widthAnchor.constraint(equalToConstant: self.view.frame.width*5/12)
        thirdWidthAnchor.isActive = true
        addAnImageButton3.heightAnchor.constraint(equalTo: addAnImageButton3.widthAnchor).isActive = true
        
        addAnImageButton3.addSubview(spotLabel3)
        spotLabel3.leftAnchor.constraint(equalTo: addAnImageButton3.leftAnchor, constant: 4).isActive = true
        spotLabel3.topAnchor.constraint(equalTo: addAnImageButton3.topAnchor, constant: 4).isActive = true
        spotLabel3.widthAnchor.constraint(equalToConstant: 30).isActive = true
        spotLabel3.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addAnImageButton3.addSubview(spotRemove3)
        spotRemove3.rightAnchor.constraint(equalTo: addAnImageButton3.rightAnchor, constant: -4).isActive = true
        spotRemove3.topAnchor.constraint(equalTo: addAnImageButton3.topAnchor, constant: 4).isActive = true
        spotRemove3.widthAnchor.constraint(equalToConstant: 30).isActive = true
        spotRemove3.heightAnchor.constraint(equalTo: spotRemove3.widthAnchor).isActive = true
        
        scrollView.addSubview(addAnImageButton4)
        addAnImageButton4.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -self.view.frame.width/14).isActive = true
        addAnImageButton4.topAnchor.constraint(equalTo: addAnImageButton1.bottomAnchor, constant: 10).isActive = true
        fourthWidthAnchor = addAnImageButton4.widthAnchor.constraint(equalToConstant: self.view.frame.width*5/12)
        fourthWidthAnchor.isActive = true
        addAnImageButton4.heightAnchor.constraint(equalTo: addAnImageButton4.widthAnchor).isActive = true
        
        addAnImageButton4.addSubview(spotLabel4)
        spotLabel4.leftAnchor.constraint(equalTo: addAnImageButton4.leftAnchor, constant: 4).isActive = true
        spotLabel4.topAnchor.constraint(equalTo: addAnImageButton4.topAnchor, constant: 4).isActive = true
        spotLabel4.widthAnchor.constraint(equalToConstant: 30).isActive = true
        spotLabel4.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addAnImageButton4.addSubview(spotRemove4)
        spotRemove4.rightAnchor.constraint(equalTo: addAnImageButton4.rightAnchor, constant: -4).isActive = true
        spotRemove4.topAnchor.constraint(equalTo: addAnImageButton4.topAnchor, constant: 4).isActive = true
        spotRemove4.widthAnchor.constraint(equalToConstant: 30).isActive = true
        spotRemove4.heightAnchor.constraint(equalTo: spotRemove4.widthAnchor).isActive = true
        
        scrollView.addSubview(informationLabel)
        informationLabel.topAnchor.constraint(equalTo: addAnImageButton4.bottomAnchor, constant: 16).isActive = true
        informationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        informationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32).isActive = true
        informationLabel.sizeToFit()
        
        scrollView.addSubview(checkmark)
        
        self.view.addSubview(drawController.view)
        drawController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -100).isActive = true
        drawController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        drawController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        drawController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
    }

    @objc func selectImageControl(sender: UIButton) {
        UIView.animate(withDuration: animationIn) {
            self.checkmark.alpha = 0
            if sender == self.addAnImageButton1 {
                self.selectImage(sender: sender, anchor: self.firstWidthAnchor, remove: self.spotRemove1)
            } else if sender == self.addAnImageButton2 {
                self.selectImage(sender: sender, anchor: self.secondWidthAnchor, remove: self.spotRemove2)
            } else if sender == self.addAnImageButton3 {
                self.selectImage(sender: sender, anchor: self.thirdWidthAnchor, remove: self.spotRemove3)
            } else if sender == self.addAnImageButton4 {
                self.selectImage(sender: sender, anchor: self.fourthWidthAnchor, remove: self.spotRemove4)
            }
        }
    }
    
    var useRegular: Bool = true
    
    func selectImage(sender: UIButton, anchor: NSLayoutConstraint, remove: UIButton) {
        self.currentButton = sender
        self.checkmark.center = sender.center
        if sender.imageEdgeInsets == UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
            if sender.isSelected == true {
                sender.widthAnchor.constraint(equalToConstant: self.view.frame.width*5/6).isActive = false
                anchor.isActive = true
                remove.alpha = 0
                self.view.layoutIfNeeded()
                sender.isSelected = false
            } else {
                sender.widthAnchor.constraint(equalToConstant: self.view.frame.width*5/6+10).isActive = true
                self.scrollView.bringSubviewToFront(sender)
                anchor.isActive = false
                remove.alpha = 1
                self.view.layoutIfNeeded()
                sender.isSelected = true
            }
        } else {
            let alert = UIAlertController(title: "Select an Image:", message: "How would you like to upload an image of the parking spot?", preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "Camera Roll", style: UIAlertAction.Style.default, handler: { action in
                self.useRegular = true
                self.handleSelectParkingImageView()
            }))
            alert.addAction(UIAlertAction(title: "Take a Photo", style: UIAlertAction.Style.default, handler: { action in
                self.useRegular = true
                self.handleTakeAnImageView()
            }))
            alert.addAction(UIAlertAction(title: "Google Street View", style: UIAlertAction.Style.default, handler: { action in
                self.useRegular = false
                self.sendDraw(image: UIImage())
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func removeImagePressed(sender: UIButton) {
        self.imagesTaken -= 1
        let image = UIImage(named: "addImageIcon")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        UIView.animate(withDuration: animationIn) {
            if sender == self.spotRemove1 {
                self.selectImage(sender: self.addAnImageButton1, anchor: self.firstWidthAnchor, remove: self.spotRemove1)
                self.addAnImageButton1.setImage(tintedImage, for: .normal)
                self.addAnImageButton1.imageEdgeInsets = UIEdgeInsets(top: 42, left: 42, bottom: 42, right: 42)
            } else if sender == self.spotRemove2 {
                self.selectImage(sender: self.addAnImageButton2, anchor: self.secondWidthAnchor, remove: self.spotRemove2)
                self.addAnImageButton2.setImage(tintedImage, for: .normal)
                self.addAnImageButton2.imageEdgeInsets = UIEdgeInsets(top: 42, left: 42, bottom: 42, right: 42)
            } else if sender == self.spotRemove3 {
                self.selectImage(sender: self.addAnImageButton3, anchor: self.thirdWidthAnchor, remove: self.spotRemove3)
                self.addAnImageButton3.setImage(tintedImage, for: .normal)
                self.addAnImageButton3.imageEdgeInsets = UIEdgeInsets(top: 42, left: 42, bottom: 42, right: 42)
            } else if sender == self.spotRemove4 {
                self.selectImage(sender: self.addAnImageButton4, anchor: self.fourthWidthAnchor, remove: self.spotRemove4)
                self.addAnImageButton4.setImage(tintedImage, for: .normal)
                self.addAnImageButton4.imageEdgeInsets = UIEdgeInsets(top: 42, left: 42, bottom: 42, right: 42)
            }
        }
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
                self.sendDraw(image: selectedImage)
            }
        }
        dismiss(animated: true) {
            self.view.layoutIfNeeded()
        }
    }
    
    func sendDraw(image: UIImage) {
        drawController.setData(image: image, lattitude: self.lattitude, longitude: self.longitude)
        self.view.layoutIfNeeded()
        self.delegate?.imageDrawSelected()
        self.editDelegate?.imageDrawSelected()
        UIView.animate(withDuration: animationIn) {
            self.drawController.view.alpha = 1
        }
        if self.useRegular == true {
            drawController.useRegularImage()
        } else {
            drawController.useGoogleMaps()
        }
    }
    
    func imageDrawExited() {
        UIView.animate(withDuration: animationIn, animations: {
            self.drawController.view.alpha = 0
        })
    }
    
    func configureExited() {
        self.delegate?.imageDrawExited()
        self.editDelegate?.imageDrawExited()
    }
    
    func confirmedImage(image: UIImage) {
        self.imagesTaken += 1
        self.currentButton?.setImage(image, for: .normal)
        self.currentButton?.imageEdgeInsets = UIEdgeInsets.zero
        self.configureExited()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            UIView.animate(withDuration: animationIn, animations: {
                self.checkmark.alpha = 1
            }) { (success) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                    UIView.animate(withDuration: animationIn, animations: {
                        self.checkmark.alpha = 0
                    })
                }
            }
        }
    }

}


fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
