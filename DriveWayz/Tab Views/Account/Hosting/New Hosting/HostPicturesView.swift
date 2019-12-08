//
//  HostPicturesView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/28/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import CoreLocation

protocol HandleHostPictures {
    func saveHighlightedScreenshot(image: UIImage)
    func saveMapScreenshot(image: UIImage)
    func deleteImage()
    func removeDim()
}

class HostPicturesView: UIViewController {
    
    var delegate: HandleHostLocation?
    var photoPicker: UIImagePickerController?
    var visibleCoordinate: CLLocationCoordinate2D?
    
    lazy var cellWidth: CGFloat = (phoneWidth - 48)/2
    lazy var cellHeight: CGFloat = cellWidth * 1.225
    lazy var presentWidth: CGFloat = phoneWidth - 16
    lazy var presentHeight: CGFloat = presentWidth * 1.225
    
    var selectImages: Int = 1 {
        didSet {
            if mainType != "Residential" && mainType != "Apartment" {
                subLabel.text = "Add spot images (1 required)"
                let message = "Please provide at least one picture for the lot."
                bubbleArrow.message = message
                if selectImages != 4 {
                    selectImages = 4
                }
            } else {
                subLabel.text = "Add spot images"
                let message = "Please provide a picture for each space."
                bubbleArrow.message = message
            }
            picturesPicker.reloadData()
        }
    }
    
    var selectedIndex: Int = 0
    var images: [Int: UIImage] = [:] {
        didSet {
            picturesPicker.reloadData()
        }
    }
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        
        return view
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.PRUSSIAN_BLUE
        label.text = "Add spot images"
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var layout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        
        return layout
    }()
    
    lazy var picturesPicker: UICollectionView = {
        let picker = UICollectionView(frame: .zero, collectionViewLayout: layout)
        picker.backgroundColor = .clear
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.showsHorizontalScrollIndicator = false
        picker.showsVerticalScrollIndicator = false
        picker.register(HostPictureCell.self, forCellWithReuseIdentifier: "identifier")
        picker.decelerationRate = .fast
        picker.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: abs(cancelBottomHeight * 2), right: 16)
        
        return picker
    }()
    
    lazy var bubbleArrow: BubbleArrow = {
        let view = BubbleArrow()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        view.message = "Please provide a picture for each space."
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.2
        view.centerTriangle()
        view.verticalTriangle()
        view.label.font = Fonts.SSPRegularH4
        view.alpha = 0
        
        return view
    }()
    
    var dimView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().customVerticalColor(topColor: Theme.DARK_GRAY.withAlphaComponent(0), bottomColor: Theme.DARK_GRAY)
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: abs(cancelBottomHeight * 2) + 16)
        background.zPosition = 10
        view.layer.addSublayer(background)
        view.isUserInteractionEnabled = false
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.DARK_GRAY
        view.clipsToBounds = true
        
        photoPicker?.delegate = self
        picturesPicker.delegate = self
        picturesPicker.dataSource = self
        
        setupViews()
    }
    
    var picturesHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(container)
        container.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        container.addSubview(subLabel)
        container.addSubview(picturesPicker)
        
        subLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 34).isActive = true
        subLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        subLabel.sizeToFit()
        
        picturesPicker.anchor(top: subLabel.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(bubbleArrow)
        bubbleArrow.bottomAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 4).isActive = true
        bubbleArrow.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bubbleArrow.widthAnchor.constraint(equalToConstant: 280).isActive = true
        bubbleArrow.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
        view.addSubview(dimView)
        dimView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: abs(cancelBottomHeight * 2) + 16)
    }
    
    func checkPictures() -> Bool {
        var check = true
        if mainType != "Residential" && mainType != "Apartment" {
            if images.count < 1 {
                check = false
            }
        } else {
            for i in 0...(selectImages - 1) {
                if images[i] == nil {
                    let index = IndexPath(item: i, section: 0)
                    let cell = picturesPicker.cellForItem(at: index) as! HostPictureCell
                    cell.numberView.backgroundColor = Theme.HARMONY_RED.withAlphaComponent(0.2)
                    cell.numberLabel.textColor = Theme.HARMONY_RED
                    check = false
                }
            }
        }
        if !check {
            if bubbleArrow.alpha == 0 {
                view.clipsToBounds = false
                UIView.animate(withDuration: animationIn, animations: {
                    self.bubbleArrow.alpha = 1
                }) { (success) in
                    delayWithSeconds(3) {
                        self.view.clipsToBounds = true
                        if self.bubbleArrow.alpha == 1 {
                            UIView.animate(withDuration: animationIn, animations: {
                                self.bubbleArrow.alpha = 0
                            }) { (success) in
                                self.view.clipsToBounds = true
                            }
                        } else {
                            self.view.clipsToBounds = true
                        }
                    }
                }
            }
        }
        return check
    }
    
}

extension HostPicturesView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
            dismiss(animated: true) {
                self.presentImage(image: selectedImage, new: true)
            }
        } else {
            dismiss(animated: true) {
                self.delegate?.removeDim()
            }
        }
    }
    
    func takePhotoSelected() {
        photoPicker = UIImagePickerController()
        photoPicker?.delegate = self
        photoPicker?.allowsEditing = true
        photoPicker?.sourceType = .camera
        
        if let presentor = photoPicker {
            present(presentor, animated: true, completion: nil)
        }
    }
    
    func choosePhotoSelected() {
        photoPicker = UIImagePickerController()
        photoPicker?.delegate = self
        photoPicker?.allowsEditing = true
         
        if let presentor = photoPicker {
            present(presentor, animated: true, completion: nil)
        }
    }
    
    func googleMapsSelected() {
        let controller = MapsPictureView()
        controller.delegate = self
        controller.visibleCoordinate = visibleCoordinate
        controller.modalPresentationStyle = .overFullScreen
        present(controller, animated: true, completion: nil)
    }
    
    func presentImage(image: UIImage, new: Bool) {
        delegate?.dimBackground()
        let controller = PictureAlertView()
        if new {
            controller.options = controller.newOptions
        } else {
            controller.options = controller.oldOptions
        }
        controller.delegate = self
        controller.imageView.image = image
        controller.modalPresentationStyle = .overFullScreen
        present(controller, animated: true, completion: nil)
    }
    
}

extension HostPicturesView: HandleHostPictures {
    
    func saveHighlightedScreenshot(image: UIImage) {
        images[selectedIndex] = image
        removeDim()
    }
    
    func deleteImage() {
        images[selectedIndex] = nil
    }
    
    func saveMapScreenshot(image: UIImage) {
        presentImage(image: image, new: true)
    }
    
    func removeDim() {
        delegate?.removeDim()
    }
    
}

fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

extension HostPicturesView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectImages
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath as IndexPath) as! HostPictureCell
        let tag = indexPath.section * 2 + indexPath.row
        cell.numberLabel.text = "\(tag + 1)"
        cell.numberLabel.textColor = Theme.DARK_GRAY
        cell.numberView.backgroundColor = lineColor
        
        if let image = images[tag] {
            cell.selectedImage.image = image
            if indexPath.row == selectedIndex {
                cell.checked()
            }
        } else {
            cell.selectedImage.image = nil
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        bubbleArrow.alpha = 0
        
        let cell = collectionView.cellForItem(at: indexPath) as! HostPictureCell
        cell.numberView.backgroundColor = lineColor
        cell.numberLabel.textColor = Theme.DARK_GRAY
        
        if cell.selectedImage.image == nil {
            let alert = UIAlertController(title: "Select an Image:", message: "How would you like to upload an image of the parking spot?", preferredStyle: UIAlertController.Style.actionSheet)
            alert.popoverPresentationController?.sourceView = self.view
            alert.addAction(UIAlertAction(title: "Camera Roll", style: UIAlertAction.Style.default, handler: { action in
                self.choosePhotoSelected()
            }))
            alert.addAction(UIAlertAction(title: "Take a Photo", style: UIAlertAction.Style.default, handler: { action in
                self.takePhotoSelected()
            }))
            alert.addAction(UIAlertAction(title: "Google Street View", style: UIAlertAction.Style.default, handler: { action in
                self.googleMapsSelected()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                self.delegate?.removeDim()
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            if let image = cell.selectedImage.image {
                presentImage(image: image, new: false)
            }
        }
    }
    
}

class HostPictureCell: UICollectionViewCell {

    var numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH5
        label.textAlignment = .center
        
        return label
    }()
    
    var numberView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        view.layer.cornerRadius = 16
        
        return view
    }()
    
    var addIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "exit")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.transform = CGAffineTransform(rotationAngle: CGFloat.pi/4)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var selectedImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    var checkmark: CheckBox = {
        let check = CheckBox()
        check.translatesAutoresizingMaskIntoConstraints = false
        check.style = .tick
        check.isChecked = true
        check.borderStyle = .roundedSquare(radius: 16)
        check.checkedBorderColor = Theme.GREEN_PIGMENT
        check.checkboxBackgroundColor = Theme.GREEN_PIGMENT
        check.checkmarkColor = Theme.WHITE
        check.backgroundColor = Theme.GREEN_PIGMENT
        check.layer.cornerRadius = 16
        check.clipsToBounds = true
        check.isUserInteractionEnabled = false
        check.alpha = 0
        
        return check
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Theme.OFF_WHITE
        clipsToBounds = true
        layer.cornerRadius = 8
        
        setupViews()
    }
    
    func setupViews() {

        addSubview(addIcon)
        addIcon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        addIcon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addIcon.heightAnchor.constraint(equalToConstant: 32).isActive = true
        addIcon.widthAnchor.constraint(equalTo: addIcon.heightAnchor).isActive = true
        
        addSubview(selectedImage)
        selectedImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(numberView)
        addSubview(numberLabel)
        
        numberView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 32, height: 32)
        
        numberLabel.centerXAnchor.constraint(equalTo: numberView.centerXAnchor).isActive = true
        numberLabel.centerYAnchor.constraint(equalTo: numberView.centerYAnchor).isActive = true
        numberLabel.sizeToFit()
        
        addSubview(checkmark)
        checkmark.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        checkmark.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        checkmark.widthAnchor.constraint(equalTo: checkmark.heightAnchor).isActive = true
        checkmark.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
    }
    
    func checked() {
        UIView.animate(withDuration: animationIn, animations: {
            self.checkmark.alpha = 1
        }) { (success) in
            delayWithSeconds(2) {
                UIView.animate(withDuration: animationOut) {
                    self.checkmark.alpha = 0
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
