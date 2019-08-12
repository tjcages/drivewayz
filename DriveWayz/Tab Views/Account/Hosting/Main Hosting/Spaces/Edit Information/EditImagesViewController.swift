//
//  EditImagesViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/9/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol editImagesHandler {
    func imageDrawSelected()
    func imageDrawExited()
}

class EditImagesViewController: UIViewController {
    
    var delegate: changeExpandedInformation?
    var parkingImages: [UIImage] = [] {
        didSet {
            if let parking = self.selectedParking, let type = parking.mainType {
                if type == "parking lot" {
                    var i = 0
                    for image in self.parkingImages {
                        self.businessPicturesController.imagesTaken += 1
                        i += 1
                        if i == 1 {
                            self.confirmedImage(image: image, button: self.businessPicturesController.addAnImageButton1)
                        } else if i == 2 {
                            self.confirmedImage(image: image, button: self.businessPicturesController.addAnImageButton2)
                        } else if i == 3 {
                            self.confirmedImage(image: image, button: self.businessPicturesController.addAnImageButton3)
                        } else if i == 4 {
                            self.confirmedImage(image: image, button: self.businessPicturesController.addAnImageButton4)
                        }
                    }
                } else {
                    var i = 0
                    for image in self.parkingImages {
                        self.picturesController.imagesTaken += 1
                        i += 1
                        if i == 1 {
                            self.confirmedImage(image: image, button: self.picturesController.addAnImageButton1)
                        } else if i == 2 {
                            self.confirmedImage(image: image, button: self.picturesController.addAnImageButton2)
                        } else if i == 3 {
                            self.confirmedImage(image: image, button: self.picturesController.addAnImageButton3)
                        } else if i == 4 {
                            self.confirmedImage(image: image, button: self.picturesController.addAnImageButton4)
                        } else if i == 5 {
                            self.confirmedImage(image: image, button: self.picturesController.addAnImageButton5)
                        } else if i == 6 {
                            self.confirmedImage(image: image, button: self.picturesController.addAnImageButton6)
                        } else if i == 7 {
                            self.confirmedImage(image: image, button: self.picturesController.addAnImageButton7)
                        } else if i == 8 {
                            self.confirmedImage(image: image, button: self.picturesController.addAnImageButton8)
                        }
                    }
                }
            }
        }
    }
    var selectedParking: ParkingSpots?

    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Parking images"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH2
        label.numberOfLines = 2
        
        return label
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        view.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        
        return view
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(exitButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var imageBackButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(imageDrawPressed), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.backgroundColor = lineColor
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.isUserInteractionEnabled = false
        button.addTarget(self, action: #selector(savePressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var darkBlurView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().customVerticalColor(topColor: Theme.WHITE.withAlphaComponent(0), bottomColor: Theme.WHITE.withAlphaComponent(1))
        background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 72)
        background.zPosition = -10
        view.layer.insertSublayer(background, at: 0)
        
        return view
    }()
    
    lazy var picturesController: SpotPicturesViewController = {
        let controller = SpotPicturesViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.editDelegate = self
        self.addChild(controller)
        
        return controller
    }()
    
    lazy var businessPicturesController: BusinessPicturesViewController = {
        let controller = BusinessPicturesViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.editDelegate = self
        self.addChild(controller)
        
        return controller
    }()
    
    var loadingLine: LoadingLine = {
        let view = LoadingLine()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    func setData(parking: ParkingSpots) {
        self.selectedParking = parking
        if let type = parking.mainType {
            if type == "parking lot" {
                self.picturesController.view.alpha = 0
                self.businessPicturesController.view.alpha = 1
            } else {
                self.picturesController.view.alpha = 1
                self.businessPicturesController.view.alpha = 0
            }
        }
        if let numberSpots = parking.numberSpots, let number = Int(numberSpots) {
            self.picturesController.removeAllImages()
            self.picturesController.setupImages(number: number)
        }
        if let latitude = parking.latitude, let longitude = parking.longitude {
            self.setImageCoordinates(latitude: latitude, longitude: longitude)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        
        setupViews()
        setupTopbar()
    }
    
    func setupViews() {
        
        self.view.addSubview(picturesController.view)
        self.view.addSubview(businessPicturesController.view)
        self.view.addSubview(darkBlurView)
        self.view.addSubview(gradientContainer)
        gradientContainer.addSubview(loadingLine)
        
        gradientContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        switch device {
        case .iphone8:
            gradientContainer.heightAnchor.constraint(equalToConstant: 140).isActive = true
        case .iphoneX:
            gradientContainer.heightAnchor.constraint(equalToConstant: 160).isActive = true
        }
        
        loadingLine.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        loadingLine.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        loadingLine.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        loadingLine.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        picturesController.view.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        picturesController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        picturesController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        picturesController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        businessPicturesController.view.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        businessPicturesController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        businessPicturesController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        businessPicturesController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        darkBlurView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        darkBlurView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        darkBlurView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        darkBlurView.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
    }
    
    func setupTopbar() {
        
        self.view.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        switch device {
        case .iphone8:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 28).isActive = true
        case .iphoneX:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 48).isActive = true
        }
        
        self.view.addSubview(imageBackButton)
        imageBackButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        imageBackButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageBackButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        switch device {
        case .iphone8:
            imageBackButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 28).isActive = true
        case .iphoneX:
            imageBackButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 48).isActive = true
        }
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: -16).isActive = true
        mainLabel.sizeToFit()
        
        self.view.addSubview(nextButton)
        nextButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        nextButton.leftAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 32).isActive = true
        switch device {
        case .iphone8:
            nextButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -12).isActive = true
        case .iphoneX:
            nextButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -60).isActive = true
        }
        
    }
    
    func confirmedImage(image: UIImage, button: UIButton) {
        button.setImage(image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets.zero
    }
    
    func setImageCoordinates(latitude: Double, longitude: Double) {
        self.picturesController.lattitude = latitude
        self.businessPicturesController.lattitude = latitude
        self.picturesController.longitude = longitude
        self.businessPicturesController.longitude = longitude
    }
    
    @objc func savePressed() {
        if let parking = self.selectedParking, let parkingID = parking.parkingID {
            self.loadingLine.startAnimating()
            self.nextButton.backgroundColor = lineColor
            self.nextButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
            self.nextButton.isUserInteractionEnabled = false
            self.loadImageDatabase(parkingID: parkingID, parking: parking)
        }
    }
    
    func loadImageDatabase(parkingID: String, parking: ParkingSpots) {
        guard let mainType = parking.mainType,
            let overallAddress = parking.overallAddress else { return }
        
        let imageSpot1 = self.picturesController.addAnImageButton1.imageView?.image
        let imageSpot2 = self.picturesController.addAnImageButton2.imageView?.image
        let imageSpot3 = self.picturesController.addAnImageButton3.imageView?.image
        let imageSpot4 = self.picturesController.addAnImageButton4.imageView?.image
        let imageSpot5 = self.picturesController.addAnImageButton5.imageView?.image
        let imageSpot6 = self.picturesController.addAnImageButton6.imageView?.image
        let imageSpot7 = self.picturesController.addAnImageButton7.imageView?.image
        let imageSpot8 = self.picturesController.addAnImageButton8.imageView?.image
        
        let additionalImage1 = self.picturesController.addAnImageButton9.imageView?.image
        let additionalImage2 = self.picturesController.addAnImageButton10.imageView?.image
        
        let businessSpot1 = self.businessPicturesController.addAnImageButton1.imageView?.image
        let businessSpot2 = self.businessPicturesController.addAnImageButton2.imageView?.image
        let businessSpot3 = self.businessPicturesController.addAnImageButton3.imageView?.image
        let businessSpot4 = self.businessPicturesController.addAnImageButton4.imageView?.image
        
        let storageRef = Storage.storage().reference().child("ParkingSpotImages").child(overallAddress)
        let ref = Database.database().reference().child("ParkingSpots").child(parkingID)
        let compareImage = UIImage(named: "addImageIcon")
        
        if mainType == "parking lot" {
            if !(businessSpot1?.isEqualToImage(image: compareImage!))! && businessSpot1 != nil {
                if let uploadData = businessSpot1?.jpegData(compressionQuality: 0.5) {
                    storageRef.child("firstImage").putData(uploadData, metadata: nil) { (metadata, error) in
                        if error != nil { print(error ?? ""); return }
                        storageRef.child("firstImage").downloadURL(completion: { (url, error) in
                            if let parkingURL = url?.absoluteString {
                                ref.child("BusinessImages").updateChildValues(["firstImage": parkingURL] as [String: Any])
                                self.resetDatabase()
                            }
                        })
                    }
                }
            }
            if !(businessSpot2?.isEqualToImage(image: compareImage!))! && businessSpot2 != nil {
                if let uploadData = businessSpot2?.jpegData(compressionQuality: 0.5) {
                    storageRef.child("secondImage").putData(uploadData, metadata: nil) { (metadata, error) in
                        if error != nil { print(error ?? ""); return }
                        storageRef.child("secondImage").downloadURL(completion: { (url, error) in
                            if let parkingURL = url?.absoluteString {
                                ref.child("BusinessImages").updateChildValues(["secondImage": parkingURL] as [String: Any])
                                self.resetDatabase()
                            }
                        })
                    }
                }
            }
            if !(businessSpot3?.isEqualToImage(image: compareImage!))! && businessSpot3 != nil {
                if let uploadData = businessSpot3?.jpegData(compressionQuality: 0.5) {
                    storageRef.child("thirdImage").putData(uploadData, metadata: nil) { (metadata, error) in
                        if error != nil { print(error ?? ""); return }
                        storageRef.child("thirdImage").downloadURL(completion: { (url, error) in
                            if let parkingURL = url?.absoluteString {
                                ref.child("BusinessImages").updateChildValues(["thirdImage": parkingURL] as [String: Any])
                                self.resetDatabase()
                            }
                        })
                    }
                }
            }
            if !(businessSpot4?.isEqualToImage(image: compareImage!))! && businessSpot4 != nil {
                if let uploadData = businessSpot4?.jpegData(compressionQuality: 0.5) {
                    storageRef.child("fourthImage").putData(uploadData, metadata: nil) { (metadata, error) in
                        if error != nil { print(error ?? ""); return }
                        storageRef.child("fourthImage").downloadURL(completion: { (url, error) in
                            if let parkingURL = url?.absoluteString {
                                ref.child("BusinessImages").updateChildValues(["fourthImage": parkingURL] as [String: Any])
                                self.resetDatabase()
                            }
                        })
                    }
                }
            }
        } else {
            if !(imageSpot1?.isEqualToImage(image: compareImage!))! && imageSpot1 != nil {
                if let uploadData = imageSpot1?.jpegData(compressionQuality: 0.5) {
                    storageRef.child("firstImage").putData(uploadData, metadata: nil) { (metadata, error) in
                        if error != nil { print(error ?? ""); return }
                        storageRef.child("firstImage").downloadURL(completion: { (url, error) in
                            if let parkingURL = url?.absoluteString {
                                ref.child("SpotImages").updateChildValues(["firstImage": parkingURL] as [String: Any])
                                self.resetDatabase()
                            }
                        })
                    }
                }
            }
            if !(imageSpot2?.isEqualToImage(image: compareImage!))! && imageSpot2 != nil {
                if let uploadData = imageSpot2?.jpegData(compressionQuality: 0.5) {
                    storageRef.child("secondImage").putData(uploadData, metadata: nil) { (metadata, error) in
                        if error != nil { print(error ?? ""); return }
                        storageRef.child("secondImage").downloadURL(completion: { (url, error) in
                            if let parkingURL = url?.absoluteString {
                                ref.child("SpotImages").updateChildValues(["secondImage": parkingURL] as [String: Any])
                                self.resetDatabase()
                            }
                        })
                    }
                }
            }
            if !(imageSpot3?.isEqualToImage(image: compareImage!))! && imageSpot3 != nil {
                if let uploadData = imageSpot3?.jpegData(compressionQuality: 0.5) {
                    storageRef.child("thirdImage").putData(uploadData, metadata: nil) { (metadata, error) in
                        if error != nil { print(error ?? ""); return }
                        storageRef.child("thirdImage").downloadURL(completion: { (url, error) in
                            if let parkingURL = url?.absoluteString {
                                ref.child("SpotImages").updateChildValues(["thirdImage": parkingURL] as [String: Any])
                                self.resetDatabase()
                            }
                        })
                    }
                }
            }
            if !(imageSpot4?.isEqualToImage(image: compareImage!))! && imageSpot4 != nil {
                if let uploadData = imageSpot4?.jpegData(compressionQuality: 0.5) {
                    storageRef.child("fourthImage").putData(uploadData, metadata: nil) { (metadata, error) in
                        if error != nil { print(error ?? ""); return }
                        storageRef.child("fourthImage").downloadURL(completion: { (url, error) in
                            if let parkingURL = url?.absoluteString {
                                ref.child("SpotImages").updateChildValues(["fourthImage": parkingURL] as [String: Any])
                                self.resetDatabase()
                            }
                        })
                    }
                }
            }
            if !(imageSpot5?.isEqualToImage(image: compareImage!))! && imageSpot5 != nil {
                if let uploadData = imageSpot5?.jpegData(compressionQuality: 0.5) {
                    storageRef.child("fifthImage").putData(uploadData, metadata: nil) { (metadata, error) in
                        if error != nil { print(error ?? ""); return }
                        storageRef.child("fifthImage").downloadURL(completion: { (url, error) in
                            if let parkingURL = url?.absoluteString {
                                ref.child("SpotImages").updateChildValues(["fifthImage": parkingURL] as [String: Any])
                                self.resetDatabase()
                            }
                        })
                    }
                }
            }
            if !(imageSpot6?.isEqualToImage(image: compareImage!))! && imageSpot6 != nil {
                if let uploadData = imageSpot6?.jpegData(compressionQuality: 0.5) {
                    storageRef.child("sixthImage").putData(uploadData, metadata: nil) { (metadata, error) in
                        if error != nil { print(error ?? ""); return }
                        storageRef.child("sixthImage").downloadURL(completion: { (url, error) in
                            if let parkingURL = url?.absoluteString {
                                ref.child("SpotImages").updateChildValues(["sixthImage": parkingURL] as [String: Any])
                                self.resetDatabase()
                            }
                        })
                    }
                }
            }
            if !(imageSpot7?.isEqualToImage(image: compareImage!))! && imageSpot7 != nil {
                if let uploadData = imageSpot7?.jpegData(compressionQuality: 0.5) {
                    storageRef.child("seventhImage").putData(uploadData, metadata: nil) { (metadata, error) in
                        if error != nil { print(error ?? ""); return }
                        storageRef.child("seventhImage").downloadURL(completion: { (url, error) in
                            if let parkingURL = url?.absoluteString {
                                ref.child("SpotImages").updateChildValues(["seventhImage": parkingURL] as [String: Any])
                                self.resetDatabase()
                            }
                        })
                    }
                }
            }
            if !(imageSpot8?.isEqualToImage(image: compareImage!))! && imageSpot8 != nil {
                if let uploadData = imageSpot8?.jpegData(compressionQuality: 0.5) {
                    storageRef.child("eighthImage").putData(uploadData, metadata: nil) { (metadata, error) in
                        if error != nil { print(error ?? ""); return }
                        storageRef.child("eighthImage").downloadURL(completion: { (url, error) in
                            if let parkingURL = url?.absoluteString {
                                ref.child("SpotImages").updateChildValues(["eighthImage": parkingURL] as [String: Any])
                                self.resetDatabase()
                            }
                        })
                    }
                }
            }
            
            if !(additionalImage1?.isEqualToImage(image: compareImage!))! && additionalImage1 != nil {
                if let uploadData = additionalImage1?.jpegData(compressionQuality: 0.5) {
                    storageRef.child("firstAdditionalImage").putData(uploadData, metadata: nil) { (metadata, error) in
                        if error != nil { print(error ?? ""); return }
                        storageRef.child("firstAdditionalImage").downloadURL(completion: { (url, error) in
                            if let parkingURL = url?.absoluteString {
                                ref.child("SpotImages").updateChildValues(["firstAdditionalImage": parkingURL] as [String: Any])
                                self.resetDatabase()
                            }
                        })
                    }
                }
            }
            if !(additionalImage2?.isEqualToImage(image: compareImage!))! && additionalImage2 != nil {
                if let uploadData = additionalImage2?.jpegData(compressionQuality: 0.5) {
                    storageRef.child("secondAdditionalImage").putData(uploadData, metadata: nil) { (metadata, error) in
                        if error != nil { print(error ?? ""); return }
                        storageRef.child("secondAdditionalImage").downloadURL(completion: { (url, error) in
                            if let parkingURL = url?.absoluteString {
                                ref.child("SpotImages").updateChildValues(["secondAdditionalImage": parkingURL] as [String: Any])
                                self.resetDatabase()
                            }
                        })
                    }
                }
            }
        }
    }
    
    func resetDatabase() {
        self.delegate?.resetParking()
        delayWithSeconds(0.8) {
            self.loadingLine.endAnimating()
            self.nextButton.backgroundColor = Theme.BLUE
            self.nextButton.setTitleColor(Theme.WHITE, for: .normal)
            self.nextButton.isUserInteractionEnabled = true
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func exitButtonPressed(sender: UIButton) {
        self.loadingLine.endAnimating()
        self.navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}


extension EditImagesViewController: editImagesHandler {
    
    func imageDrawSelected() {
        self.mainLabel.text = "Drag the corners to highlight the parking space"
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: animationIn) {
            self.nextButton.alpha = 0
            self.backButton.alpha = 0
            self.darkBlurView.alpha = 0
            self.imageBackButton.alpha = 1
        }
    }
    
    @objc func imageDrawPressed() {
        if self.picturesController.view.alpha == 1 && self.picturesController.drawController.moveDotsController.view.alpha == 1 {
            self.picturesController.drawController.removeHighlight()
        } else if self.businessPicturesController.view.alpha == 1 && self.businessPicturesController.drawController.moveDotsController.view.alpha == 1 {
            self.businessPicturesController.drawController.removeHighlight()
        } else {
            self.imageDrawExited()
        }
    }
    
    func imageDrawExited() {
        self.mainLabel.text = "Please upload a picture for each spot"
        self.nextButton.backgroundColor = Theme.BLUE
        self.nextButton.setTitleColor(Theme.WHITE, for: .normal)
        self.nextButton.isUserInteractionEnabled = true
        self.view.layoutIfNeeded()
        self.picturesController.imageDrawExited()
        self.businessPicturesController.imageDrawExited()
        UIView.animate(withDuration: animationIn) {
            self.nextButton.alpha = 1
            self.backButton.alpha = 1
            self.darkBlurView.alpha = 1
            self.imageBackButton.alpha = 0
        }
    }

}
