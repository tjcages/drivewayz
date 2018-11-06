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
        label.font = Fonts.SSPSemiBoldH5
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = Theme.OFF_WHITE
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        
        return label
    }()
    
    var spotRemove1: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Delete")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.OFF_WHITE
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
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
        label.font = Fonts.SSPSemiBoldH5
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = Theme.OFF_WHITE
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        
        return label
    }()
    
    var spotRemove2: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Delete")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.OFF_WHITE
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
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
        label.font = Fonts.SSPSemiBoldH5
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = Theme.OFF_WHITE
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        
        return label
    }()
    
    var spotRemove3: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Delete")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.OFF_WHITE
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
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
        label.font = Fonts.SSPSemiBoldH5
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = Theme.OFF_WHITE
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        
        return label
    }()
    
    var spotRemove4: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Delete")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.OFF_WHITE
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.layer.cornerRadius = 15
        button.alpha = 0
        button.addTarget(self, action: #selector(removeImagePressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var addAnImageButton5: UIButton = {
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
    
    var spotLabel5: TagLabel = {
        let label = TagLabel()
        label.text = "Spot 5"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH5
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = Theme.OFF_WHITE
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        
        return label
    }()
    
    var spotRemove5: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Delete")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.OFF_WHITE
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.layer.cornerRadius = 15
        button.alpha = 0
        button.addTarget(self, action: #selector(removeImagePressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var addAnImageButton6: UIButton = {
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
    
    var spotLabel6: TagLabel = {
        let label = TagLabel()
        label.text = "Spot 6"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH5
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = Theme.OFF_WHITE
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        
        return label
    }()
    
    var spotRemove6: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Delete")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.OFF_WHITE
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.layer.cornerRadius = 15
        button.alpha = 0
        button.addTarget(self, action: #selector(removeImagePressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var addAnImageButton7: UIButton = {
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
    
    var spotLabel7: TagLabel = {
        let label = TagLabel()
        label.text = "Spot 7"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH5
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = Theme.OFF_WHITE
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        
        return label
    }()
    
    var spotRemove7: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Delete")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.OFF_WHITE
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.layer.cornerRadius = 15
        button.alpha = 0
        button.addTarget(self, action: #selector(removeImagePressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var addAnImageButton8: UIButton = {
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
    
    var spotLabel8: TagLabel = {
        let label = TagLabel()
        label.text = "Spot 8"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH5
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = Theme.OFF_WHITE
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        
        return label
    }()
    
    var spotRemove8: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Delete")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.OFF_WHITE
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.layer.cornerRadius = 15
        button.alpha = 0
        button.addTarget(self, action: #selector(removeImagePressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var additionalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Additional images (optional)"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.font = Fonts.SSPLightH3
        
        return label
    }()
    
    var addAnImageButton9: UIButton = {
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
    
    var spotRemove9: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Delete")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.OFF_WHITE
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.layer.cornerRadius = 15
        button.alpha = 0
        button.addTarget(self, action: #selector(removeImagePressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var addAnImageButton10: UIButton = {
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
    
    var spotRemove10: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Delete")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.OFF_WHITE
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.layer.cornerRadius = 15
        button.alpha = 0
        button.addTarget(self, action: #selector(removeImagePressed(sender:)), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupAdditionalViews()
    }
    
    var singleRowAnchor: NSLayoutConstraint!
    var doubleRowAnchor: NSLayoutConstraint!
    var tripleRowAnchor: NSLayoutConstraint!
    var quadRowAnchor: NSLayoutConstraint!
    
    var firstWidthAnchor: NSLayoutConstraint!
    var secondWidthAnchor: NSLayoutConstraint!
    var thirdWidthAnchor: NSLayoutConstraint!
    var fourthWidthAnchor: NSLayoutConstraint!
    var fifthWidthAnchor: NSLayoutConstraint!
    var sixthWidthAnchor: NSLayoutConstraint!
    var seventhWidthAnchor: NSLayoutConstraint!
    var eigthWidthAnchor: NSLayoutConstraint!
    var ninethWidthAnchor: NSLayoutConstraint!
    var tenthWidthAnchor: NSLayoutConstraint!
    
    func setupImages(number: Int) {
        if number >= 1 {
            self.addAnImageButton1.alpha = 1
            self.additionalAnchorsFalse()
            self.singleRowAnchor.isActive = true
            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: (self.view.frame.width*5/12)*4)
        }
        if number >= 2 {
            self.addAnImageButton2.alpha = 1
            self.additionalAnchorsFalse()
            self.singleRowAnchor.isActive = true
            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: (self.view.frame.width*5/12)*4)
        }
        if number >= 3 {
            self.addAnImageButton3.alpha = 1
            self.additionalAnchorsFalse()
            self.doubleRowAnchor.isActive = true
            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: (self.view.frame.width*5/12)*5)
        }
        if number >= 4 {
            self.addAnImageButton4.alpha = 1
            self.additionalAnchorsFalse()
            self.doubleRowAnchor.isActive = true
            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: (self.view.frame.width*5/12)*5)
        }
        if number >= 5 {
            self.addAnImageButton5.alpha = 1
            self.additionalAnchorsFalse()
            self.tripleRowAnchor.isActive = true
            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: (self.view.frame.width*5/12)*6)
        }
        if number >= 6 {
            self.addAnImageButton6.alpha = 1
            self.additionalAnchorsFalse()
            self.tripleRowAnchor.isActive = true
            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: (self.view.frame.width*5/12)*6)
        }
        if number >= 7 {
            self.addAnImageButton7.alpha = 1
            self.additionalAnchorsFalse()
            self.quadRowAnchor.isActive = true
            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: (self.view.frame.width*5/12)*7)
        }
        if number >= 8 {
            self.addAnImageButton8.alpha = 1
            self.additionalAnchorsFalse()
            self.quadRowAnchor.isActive = true
            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: (self.view.frame.width*5/12)*7)
        }
    }
    
    func removeAllImages() {
        self.addAnImageButton1.alpha = 0
        self.addAnImageButton2.alpha = 0
        self.addAnImageButton3.alpha = 0
        self.addAnImageButton4.alpha = 0
        self.addAnImageButton5.alpha = 0
        self.addAnImageButton6.alpha = 0
        self.addAnImageButton7.alpha = 0
        self.addAnImageButton8.alpha = 0
    }
    
    
    @objc func selectImageControl(sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            if sender == self.addAnImageButton1 {
                self.selectImage(sender: sender, anchor: self.firstWidthAnchor, remove: self.spotRemove1)
            } else if sender == self.addAnImageButton2 {
                self.selectImage(sender: sender, anchor: self.secondWidthAnchor, remove: self.spotRemove2)
            } else if sender == self.addAnImageButton3 {
                self.selectImage(sender: sender, anchor: self.thirdWidthAnchor, remove: self.spotRemove3)
            } else if sender == self.addAnImageButton4 {
                self.selectImage(sender: sender, anchor: self.fourthWidthAnchor, remove: self.spotRemove4)
            } else if sender == self.addAnImageButton5 {
                self.selectImage(sender: sender, anchor: self.fifthWidthAnchor, remove: self.spotRemove5)
            } else if sender == self.addAnImageButton6 {
                self.selectImage(sender: sender, anchor: self.sixthWidthAnchor, remove: self.spotRemove6)
            } else if sender == self.addAnImageButton7 {
                self.selectImage(sender: sender, anchor: self.seventhWidthAnchor, remove: self.spotRemove7)
            } else if sender == self.addAnImageButton8 {
                self.selectImage(sender: sender, anchor: self.eigthWidthAnchor, remove: self.spotRemove8)
            } else if sender == self.addAnImageButton9 {
                self.selectImage(sender: sender, anchor: self.ninethWidthAnchor, remove: self.spotRemove9)
            } else if sender == self.addAnImageButton10 {
                self.selectImage(sender: sender, anchor: self.tenthWidthAnchor, remove: self.spotRemove10)
            }
        }
    }
    
    func selectImage(sender: UIButton, anchor: NSLayoutConstraint, remove: UIButton) {
        self.currentButton = sender
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
    }
    
    @objc func removeImagePressed(sender: UIButton) {
        let image = UIImage(named: "addImageIcon")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        UIView.animate(withDuration: 0.2) {
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
            } else if sender == self.spotRemove5 {
                self.selectImage(sender: self.addAnImageButton5, anchor: self.fifthWidthAnchor, remove: self.spotRemove5)
                self.addAnImageButton5.setImage(tintedImage, for: .normal)
                self.addAnImageButton5.imageEdgeInsets = UIEdgeInsets(top: 42, left: 42, bottom: 42, right: 42)
            } else if sender == self.spotRemove6 {
                self.selectImage(sender: self.addAnImageButton6, anchor: self.sixthWidthAnchor, remove: self.spotRemove6)
                self.addAnImageButton6.setImage(tintedImage, for: .normal)
                self.addAnImageButton6.imageEdgeInsets = UIEdgeInsets(top: 42, left: 42, bottom: 42, right: 42)
            } else if sender == self.spotRemove7 {
                self.selectImage(sender: self.addAnImageButton7, anchor: self.seventhWidthAnchor, remove: self.spotRemove7)
                self.addAnImageButton7.setImage(tintedImage, for: .normal)
                self.addAnImageButton7.imageEdgeInsets = UIEdgeInsets(top: 42, left: 42, bottom: 42, right: 42)
            } else if sender == self.spotRemove8 {
                self.selectImage(sender: self.addAnImageButton8, anchor: self.eigthWidthAnchor, remove: self.spotRemove8)
                self.addAnImageButton8.setImage(tintedImage, for: .normal)
                self.addAnImageButton8.imageEdgeInsets = UIEdgeInsets(top: 42, left: 42, bottom: 42, right: 42)
            } else if sender == self.spotRemove9 {
                self.selectImage(sender: self.addAnImageButton9, anchor: self.ninethWidthAnchor, remove: self.spotRemove9)
                self.addAnImageButton9.setImage(tintedImage, for: .normal)
                self.addAnImageButton9.imageEdgeInsets = UIEdgeInsets(top: 42, left: 42, bottom: 42, right: 42)
            } else if sender == self.spotRemove10 {
                self.selectImage(sender: self.addAnImageButton10, anchor: self.tenthWidthAnchor, remove: self.spotRemove10)
                self.addAnImageButton10.setImage(tintedImage, for: .normal)
                self.addAnImageButton10.imageEdgeInsets = UIEdgeInsets(top: 42, left: 42, bottom: 42, right: 42)
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


/////////////SETUP IMAGES/////////////////////
extension SpotPicturesViewController {
    
    func setupViews() {
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: (self.view.frame.width*5/12)*3)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -5).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        setupOne()
        setupTwo()
        setupThree()
        setupFour()
        setupFive()
        setupSix()
        setupSeven()
        setupEight()
    }
    
    func setupOne() {
        scrollView.addSubview(addAnImageButton1)
        addAnImageButton1.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: self.view.frame.width/14).isActive = true
        addAnImageButton1.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        firstWidthAnchor = addAnImageButton1.widthAnchor.constraint(equalToConstant: self.view.frame.width*5/12)
        firstWidthAnchor.isActive = true
        addAnImageButton1.heightAnchor.constraint(equalTo: addAnImageButton1.widthAnchor).isActive = true
        
        addAnImageButton1.addSubview(spotLabel1)
        spotLabel1.leftAnchor.constraint(equalTo: addAnImageButton1.leftAnchor).isActive = true
        spotLabel1.topAnchor.constraint(equalTo: addAnImageButton1.topAnchor).isActive = true
        spotLabel1.widthAnchor.constraint(equalToConstant: 70).isActive = true
        spotLabel1.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addAnImageButton1.addSubview(spotRemove1)
        spotRemove1.rightAnchor.constraint(equalTo: addAnImageButton1.rightAnchor, constant: -4).isActive = true
        spotRemove1.topAnchor.constraint(equalTo: addAnImageButton1.topAnchor, constant: 4).isActive = true
        spotRemove1.widthAnchor.constraint(equalToConstant: 30).isActive = true
        spotRemove1.heightAnchor.constraint(equalTo: spotRemove1.widthAnchor).isActive = true
    }
    
    func setupTwo() {
        scrollView.addSubview(addAnImageButton2)
        addAnImageButton2.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -self.view.frame.width/14).isActive = true
        addAnImageButton2.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        secondWidthAnchor = addAnImageButton2.widthAnchor.constraint(equalToConstant: self.view.frame.width*5/12)
        secondWidthAnchor.isActive = true
        addAnImageButton2.heightAnchor.constraint(equalTo: addAnImageButton2.widthAnchor).isActive = true
        
        addAnImageButton2.addSubview(spotLabel2)
        spotLabel2.leftAnchor.constraint(equalTo: addAnImageButton2.leftAnchor).isActive = true
        spotLabel2.topAnchor.constraint(equalTo: addAnImageButton2.topAnchor).isActive = true
        spotLabel2.widthAnchor.constraint(equalToConstant: 70).isActive = true
        spotLabel2.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addAnImageButton2.addSubview(spotRemove2)
        spotRemove2.rightAnchor.constraint(equalTo: addAnImageButton2.rightAnchor, constant: -4).isActive = true
        spotRemove2.topAnchor.constraint(equalTo: addAnImageButton2.topAnchor, constant: 4).isActive = true
        spotRemove2.widthAnchor.constraint(equalToConstant: 30).isActive = true
        spotRemove2.heightAnchor.constraint(equalTo: spotRemove2.widthAnchor).isActive = true
    }
    
    func setupThree() {
        scrollView.addSubview(addAnImageButton3)
        addAnImageButton3.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: self.view.frame.width/14).isActive = true
        addAnImageButton3.topAnchor.constraint(equalTo: addAnImageButton1.bottomAnchor, constant: 10).isActive = true
        thirdWidthAnchor = addAnImageButton3.widthAnchor.constraint(equalToConstant: self.view.frame.width*5/12)
        thirdWidthAnchor.isActive = true
        addAnImageButton3.heightAnchor.constraint(equalTo: addAnImageButton3.widthAnchor).isActive = true
        
        addAnImageButton3.addSubview(spotLabel3)
        spotLabel3.leftAnchor.constraint(equalTo: addAnImageButton3.leftAnchor).isActive = true
        spotLabel3.topAnchor.constraint(equalTo: addAnImageButton3.topAnchor).isActive = true
        spotLabel3.widthAnchor.constraint(equalToConstant: 70).isActive = true
        spotLabel3.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addAnImageButton3.addSubview(spotRemove3)
        spotRemove3.rightAnchor.constraint(equalTo: addAnImageButton3.rightAnchor, constant: -4).isActive = true
        spotRemove3.topAnchor.constraint(equalTo: addAnImageButton3.topAnchor, constant: 4).isActive = true
        spotRemove3.widthAnchor.constraint(equalToConstant: 30).isActive = true
        spotRemove3.heightAnchor.constraint(equalTo: spotRemove3.widthAnchor).isActive = true
    }
    
    func setupFour() {
        scrollView.addSubview(addAnImageButton4)
        addAnImageButton4.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -self.view.frame.width/14).isActive = true
        addAnImageButton4.topAnchor.constraint(equalTo: addAnImageButton1.bottomAnchor, constant: 10).isActive = true
        fourthWidthAnchor = addAnImageButton4.widthAnchor.constraint(equalToConstant: self.view.frame.width*5/12)
        fourthWidthAnchor.isActive = true
        addAnImageButton4.heightAnchor.constraint(equalTo: addAnImageButton4.widthAnchor).isActive = true
        
        addAnImageButton4.addSubview(spotLabel4)
        spotLabel4.leftAnchor.constraint(equalTo: addAnImageButton4.leftAnchor).isActive = true
        spotLabel4.topAnchor.constraint(equalTo: addAnImageButton4.topAnchor).isActive = true
        spotLabel4.widthAnchor.constraint(equalToConstant: 70).isActive = true
        spotLabel4.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addAnImageButton4.addSubview(spotRemove4)
        spotRemove4.rightAnchor.constraint(equalTo: addAnImageButton4.rightAnchor, constant: -4).isActive = true
        spotRemove4.topAnchor.constraint(equalTo: addAnImageButton4.topAnchor, constant: 4).isActive = true
        spotRemove4.widthAnchor.constraint(equalToConstant: 30).isActive = true
        spotRemove4.heightAnchor.constraint(equalTo: spotRemove4.widthAnchor).isActive = true
    }
    
    func setupFive() {
        scrollView.addSubview(addAnImageButton5)
        addAnImageButton5.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: self.view.frame.width/14).isActive = true
        addAnImageButton5.topAnchor.constraint(equalTo: addAnImageButton3.bottomAnchor, constant: 10).isActive = true
        fifthWidthAnchor = addAnImageButton5.widthAnchor.constraint(equalToConstant: self.view.frame.width*5/12)
        fifthWidthAnchor.isActive = true
        addAnImageButton5.heightAnchor.constraint(equalTo: addAnImageButton5.widthAnchor).isActive = true
        
        addAnImageButton5.addSubview(spotLabel5)
        spotLabel5.leftAnchor.constraint(equalTo: addAnImageButton5.leftAnchor).isActive = true
        spotLabel5.topAnchor.constraint(equalTo: addAnImageButton5.topAnchor).isActive = true
        spotLabel5.widthAnchor.constraint(equalToConstant: 70).isActive = true
        spotLabel5.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addAnImageButton5.addSubview(spotRemove5)
        spotRemove5.rightAnchor.constraint(equalTo: addAnImageButton5.rightAnchor, constant: -4).isActive = true
        spotRemove5.topAnchor.constraint(equalTo: addAnImageButton5.topAnchor, constant: 4).isActive = true
        spotRemove5.widthAnchor.constraint(equalToConstant: 30).isActive = true
        spotRemove5.heightAnchor.constraint(equalTo: spotRemove5.widthAnchor).isActive = true
    }
    
    func setupSix() {
        scrollView.addSubview(addAnImageButton6)
        addAnImageButton6.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -self.view.frame.width/14).isActive = true
        addAnImageButton6.topAnchor.constraint(equalTo: addAnImageButton3.bottomAnchor, constant: 10).isActive = true
        sixthWidthAnchor = addAnImageButton6.widthAnchor.constraint(equalToConstant: self.view.frame.width*5/12)
        sixthWidthAnchor.isActive = true
        addAnImageButton6.heightAnchor.constraint(equalTo: addAnImageButton6.widthAnchor).isActive = true
        
        addAnImageButton6.addSubview(spotLabel6)
        spotLabel6.leftAnchor.constraint(equalTo: addAnImageButton6.leftAnchor).isActive = true
        spotLabel6.topAnchor.constraint(equalTo: addAnImageButton6.topAnchor).isActive = true
        spotLabel6.widthAnchor.constraint(equalToConstant: 70).isActive = true
        spotLabel6.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addAnImageButton6.addSubview(spotRemove6)
        spotRemove6.rightAnchor.constraint(equalTo: addAnImageButton6.rightAnchor, constant: -4).isActive = true
        spotRemove6.topAnchor.constraint(equalTo: addAnImageButton6.topAnchor, constant: 4).isActive = true
        spotRemove6.widthAnchor.constraint(equalToConstant: 30).isActive = true
        spotRemove6.heightAnchor.constraint(equalTo: spotRemove6.widthAnchor).isActive = true
    }
    
    func setupSeven() {
        scrollView.addSubview(addAnImageButton7)
        addAnImageButton7.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: self.view.frame.width/14).isActive = true
        addAnImageButton7.topAnchor.constraint(equalTo: addAnImageButton5.bottomAnchor, constant: 10).isActive = true
        seventhWidthAnchor = addAnImageButton7.widthAnchor.constraint(equalToConstant: self.view.frame.width*5/12)
        seventhWidthAnchor.isActive = true
        addAnImageButton7.heightAnchor.constraint(equalTo: addAnImageButton7.widthAnchor).isActive = true
        
        addAnImageButton7.addSubview(spotLabel7)
        spotLabel7.leftAnchor.constraint(equalTo: addAnImageButton7.leftAnchor).isActive = true
        spotLabel7.topAnchor.constraint(equalTo: addAnImageButton7.topAnchor).isActive = true
        spotLabel7.widthAnchor.constraint(equalToConstant: 70).isActive = true
        spotLabel7.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addAnImageButton7.addSubview(spotRemove7)
        spotRemove7.rightAnchor.constraint(equalTo: addAnImageButton7.rightAnchor, constant: -4).isActive = true
        spotRemove7.topAnchor.constraint(equalTo: addAnImageButton7.topAnchor, constant: 4).isActive = true
        spotRemove7.widthAnchor.constraint(equalToConstant: 30).isActive = true
        spotRemove7.heightAnchor.constraint(equalTo: spotRemove7.widthAnchor).isActive = true
    }
    
    func setupEight() {
        scrollView.addSubview(addAnImageButton8)
        addAnImageButton8.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -self.view.frame.width/14).isActive = true
        addAnImageButton8.topAnchor.constraint(equalTo: addAnImageButton5.bottomAnchor, constant: 10).isActive = true
        eigthWidthAnchor = addAnImageButton8.widthAnchor.constraint(equalToConstant: self.view.frame.width*5/12)
        eigthWidthAnchor.isActive = true
        addAnImageButton8.heightAnchor.constraint(equalTo: addAnImageButton8.widthAnchor).isActive = true
        
        addAnImageButton8.addSubview(spotLabel8)
        spotLabel8.leftAnchor.constraint(equalTo: addAnImageButton8.leftAnchor).isActive = true
        spotLabel8.topAnchor.constraint(equalTo: addAnImageButton8.topAnchor).isActive = true
        spotLabel8.widthAnchor.constraint(equalToConstant: 70).isActive = true
        spotLabel8.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addAnImageButton8.addSubview(spotRemove8)
        spotRemove8.rightAnchor.constraint(equalTo: addAnImageButton8.rightAnchor, constant: -4).isActive = true
        spotRemove8.topAnchor.constraint(equalTo: addAnImageButton8.topAnchor, constant: 4).isActive = true
        spotRemove8.widthAnchor.constraint(equalToConstant: 30).isActive = true
        spotRemove8.heightAnchor.constraint(equalTo: spotRemove8.widthAnchor).isActive = true
    }
    
    func setupAdditionalViews() {
        scrollView.addSubview(additionalLabel)
        additionalLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        additionalLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        additionalLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        singleRowAnchor = additionalLabel.topAnchor.constraint(equalTo: addAnImageButton1.bottomAnchor, constant: 20)
        singleRowAnchor.isActive = true
        doubleRowAnchor = additionalLabel.topAnchor.constraint(equalTo: addAnImageButton3.bottomAnchor, constant: 20)
        doubleRowAnchor.isActive = false
        tripleRowAnchor = additionalLabel.topAnchor.constraint(equalTo: addAnImageButton5.bottomAnchor, constant: 20)
        tripleRowAnchor.isActive = false
        quadRowAnchor = additionalLabel.topAnchor.constraint(equalTo: addAnImageButton7.bottomAnchor, constant: 20)
        quadRowAnchor.isActive = false
        
        scrollView.addSubview(addAnImageButton9)
        addAnImageButton9.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: self.view.frame.width/14).isActive = true
        addAnImageButton9.topAnchor.constraint(equalTo: additionalLabel.bottomAnchor, constant: 10).isActive = true
        ninethWidthAnchor = addAnImageButton9.widthAnchor.constraint(equalToConstant: self.view.frame.width*5/12)
            ninethWidthAnchor.isActive = true
        addAnImageButton9.heightAnchor.constraint(equalTo: addAnImageButton9.widthAnchor).isActive = true
        
        addAnImageButton9.addSubview(spotRemove9)
        spotRemove9.rightAnchor.constraint(equalTo: addAnImageButton9.rightAnchor, constant: -4).isActive = true
        spotRemove9.topAnchor.constraint(equalTo: addAnImageButton9.topAnchor, constant: 4).isActive = true
        spotRemove9.widthAnchor.constraint(equalToConstant: 30).isActive = true
        spotRemove9.heightAnchor.constraint(equalTo: spotRemove9.widthAnchor).isActive = true
        
        scrollView.addSubview(addAnImageButton10)
        addAnImageButton10.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -self.view.frame.width/14).isActive = true
        addAnImageButton10.topAnchor.constraint(equalTo: additionalLabel.bottomAnchor, constant: 10).isActive = true
        tenthWidthAnchor = addAnImageButton10.widthAnchor.constraint(equalToConstant: self.view.frame.width*5/12)
            tenthWidthAnchor.isActive = true
        addAnImageButton10.heightAnchor.constraint(equalTo: addAnImageButton10.widthAnchor).isActive = true
        
        addAnImageButton10.addSubview(spotRemove10)
        spotRemove10.rightAnchor.constraint(equalTo: addAnImageButton10.rightAnchor, constant: -4).isActive = true
        spotRemove10.topAnchor.constraint(equalTo: addAnImageButton10.topAnchor, constant: 4).isActive = true
        spotRemove10.widthAnchor.constraint(equalToConstant: 30).isActive = true
        spotRemove10.heightAnchor.constraint(equalTo: spotRemove10.widthAnchor).isActive = true
    }
    
    func additionalAnchorsFalse() {
        self.singleRowAnchor.isActive = false
        self.doubleRowAnchor.isActive = false
        self.tripleRowAnchor.isActive = false
        self.quadRowAnchor.isActive = false
    }
    
}
