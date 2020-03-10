//
//  AccountView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/7/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class AccountView: UIViewController {
    
    var delegate: changeSettingsHandler?
    var pickerParking: UIImagePickerController?
    
    var options: [String] = ["First", "Last"]
    var optionsSub: [String] = ["", ""] {
        didSet {
            optionsTableView.reloadData()
        }
    }
    
    var currentUser: Users? {
        didSet {
            if let user = self.currentUser {
                if let name = user.name {
                    let split = name.split(separator: " ")
                    if let first = split.first {
                        optionsSub[0] = String(first)
                        if let last = split.last, last != first {
                            optionsSub[1] = String(last)
                        }
                    }
                }
            }
        }
    }
    
    lazy var gradientController: GradientContainerView = {
        let controller = GradientContainerView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.mainLabel.text = "Account"
        controller.setBackButton()
        controller.scrollView.isHidden = true
        controller.scrollViewHeight = 1200
        controller.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        return controller
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        view.backgroundColor = UIColor.clear
        
        return view
    }()
    
    var profileImageView: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: "background4")
        view.image = image
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 56
        view.clipsToBounds = true
        view.backgroundColor = Theme.BACKGROUND_GRAY
        
        return view
    }()
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 60
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    var optionsTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(SettingsCell.self, forCellReuseIdentifier: "cellId")
        view.isScrollEnabled = false
        
        return view
    }()
    
    var imageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "camera")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        button.layer.cornerRadius = 35/2
        button.backgroundColor = Theme.BLACK
        button.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.BACKGROUND_GRAY
        view.clipsToBounds = true

        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        
        setupViews()
    }
    
    func setupViews() {

        view.addSubview(gradientController.view)
        view.addSubview(scrollView)
        
        scrollView.addSubview(container)
        scrollView.addSubview(profileImageView)
        scrollView.addSubview(imageButton)
        scrollView.addSubview(optionsTableView)
        
        gradientController.view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        scrollView.contentSize = CGSize(width: phoneWidth, height: 1200)
        scrollView.anchor(top: gradientController.gradientContainer.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        profileImageView.anchor(top: scrollView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 32, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 112, height: 112)
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        container.anchor(top: profileImageView.topAnchor, left: profileImageView.leftAnchor, bottom: profileImageView.bottomAnchor, right: profileImageView.rightAnchor, paddingTop: -4, paddingLeft: -4, paddingBottom: -4, paddingRight: -4, width: 0, height: 0)
        
        imageButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 0).isActive = true
        imageButton.rightAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 0).isActive = true
        imageButton.widthAnchor.constraint(equalTo: imageButton.heightAnchor).isActive = true
        imageButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        optionsTableView.anchor(top: profileImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 167)
        
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension AccountView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        label.font = Fonts.SSPRegularH5
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_WHITE
        label.text = "NAME"
        
        view.addSubview(label)
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        label.sizeToFit()
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = optionsTableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! SettingsCell
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        if options.count > indexPath.row && optionsSub.count > indexPath.row {
            cell.titleLabel.text = options[indexPath.row]
            cell.subtitleLabel.text = optionsSub[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = optionsTableView.cellForRow(at: indexPath) as! SettingsCell
        if let title = cell.titleLabel.text, let subtitle = cell.subtitleLabel.text {
            self.editSettings(title: title, subtitle: subtitle)
        }
    }
    
    func editSettings(title: String, subtitle: String) {
        let title = title + " name"
        delegate?.editSettings(title: title, subtitle: subtitle)
    }
    
}

extension AccountView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func editProfile() {
        let alert = UIAlertController(title: "Select an Image:", message: "How would you like to upload a new profile picture?", preferredStyle: UIAlertController.Style.actionSheet)
        alert.popoverPresentationController?.sourceView = self.view
        alert.addAction(UIAlertAction(title: "Camera Roll", style: UIAlertAction.Style.default, handler: { action in
            self.handleSelectParkingImageView()
        }))
        alert.addAction(UIAlertAction(title: "Take a Photo", style: UIAlertAction.Style.default, handler: { action in
            self.handleTakeAnImageView()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func handleSelectParkingImageView() {
        pickerParking = UIImagePickerController()
        pickerParking?.delegate = self
        pickerParking?.allowsEditing = true
        
        if let presentor = pickerParking {
            present(presentor, animated: true, completion: nil)
        }
    }
    
    @objc func handleTakeAnImageView() {
        pickerParking = UIImagePickerController()
        pickerParking?.delegate = self
        pickerParking?.allowsEditing = true
        pickerParking?.sourceType = .camera
        
        if let presentor = pickerParking {
            present(presentor, animated: true, completion: nil)
        }
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
                self.profileImageView.image = selectedImage
                guard let userID = Auth.auth().currentUser?.uid else { return }
                let storageRef = Storage.storage().reference().child("UserProfileImages").child(userID)
                let ref = Database.database().reference().child("users").child(userID)
                if let uploadData = selectedImage.jpegData(compressionQuality: 0.5) {
                    storageRef.child("profilePicture").putData(uploadData, metadata: nil) { (metadata, error) in
                        if error != nil { print(error ?? ""); return }
                        storageRef.child("profilePicture").downloadURL(completion: { (url, error) in
                            if let profileURL = url?.absoluteString {
                                ref.updateChildValues(["picture": profileURL] as [String: Any])
                                self.delegate?.changeProfileImage(image: selectedImage)
                            }
                        })
                    }
                }
            }
        }
        dismiss(animated: true) {
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
}
