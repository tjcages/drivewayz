//
//  CurrentMessageViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 10/11/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices
import AVFoundation

protocol handSendButton {
    func bringSendButton()
    func hideSendButton()
    func setMessage(message: String)
    func moveCollectionViewAnchor(value: CGFloat, add: Bool)
}

class CurrentMessageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, handSendButton {
    
    var isHost: Bool = false
    
    var delegate: handleCurrentMessages?
    var userMessage: String = ""
    
    let cellId = "cellId"
    var userID: String = ""
    var messages = [Message]()
    
    var permissionStatusCell: ChatMessageCell?
    var messageID: String?
    var shouldAnimate: Bool = false
    
    var pickerParking: UIImagePickerController?
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingImageView: UIImageView?
    
    lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 60, height: 60)
        
        let view = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        view.alwaysBounceVertical = true
        view.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        return view
    }()
    
    var currentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE
        view.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        
        return view
    }()
    
    var currentLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = Theme.BLACK
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "background4")
        imageView.image = image
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 25
        imageView.backgroundColor = Theme.WHITE
        
        return imageView
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var bottomContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.OFF_WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.4).cgColor
        view.layer.borderWidth = 0.5
        view.alpha = 0
        
        return view
    }()
    
    lazy var sendArrow: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.backgroundColor = Theme.SEA_BLUE
        button.layer.cornerRadius = 35/2
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        button.addTarget(self, action: #selector(handleSend(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var messageOptionsController: MessageOptionsViewController = {
        let controller = MessageOptionsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        
        return controller
    }()

    lazy var hostMessageOptionsController: HostMessageViewController = {
        let controller = HostMessageViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        
        return controller
    }()

    
    var speechCheck: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let origImage = UIImage(named: "status")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.alpha = 0
        
        return button
    }()
    
    var speechCheckLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.text = "Closed"
        label.textAlignment = .center
        label.alpha = 0
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        collectionView.delegate = self
        collectionView.dataSource = self

        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.layoutIfNeeded()
    }
    
    func setData(userId: String) {
        self.userID = userId
        self.messageOptionsController.userId = userId
        self.hostMessageOptionsController.userID = userId
        observeMessages()
    }
    
    var bottomContainerHeight: NSLayoutConstraint!
    var collectionViewBottomAnchor: NSLayoutConstraint!
    
    func setupView() {
        
        self.view.addSubview(currentView)
        currentView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        currentView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        currentView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        currentView.heightAnchor.constraint(equalToConstant: 84).isActive = true
        
        currentView.addSubview(profileImageView)
        profileImageView.centerXAnchor.constraint(equalTo: currentView.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: currentView.topAnchor, constant: 8).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
        
        currentView.addSubview(currentLabel)
        currentLabel.leftAnchor.constraint(equalTo: currentView.leftAnchor, constant: 12).isActive = true
        currentLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -4).isActive = true
        currentLabel.rightAnchor.constraint(equalTo: currentView.rightAnchor, constant: -8).isActive = true
        currentLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        currentView.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: currentView.leftAnchor, constant: 12).isActive = true
        backButton.centerYAnchor.constraint(equalTo: currentView.centerYAnchor).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(bottomContainer)
        bottomContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        bottomContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        bottomContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        switch device {
        case .iphone8:
            bottomContainerHeight = bottomContainer.heightAnchor.constraint(equalToConstant: 148)
                bottomContainerHeight.isActive = true
        case .iphoneX:
            bottomContainerHeight = bottomContainer.heightAnchor.constraint(equalToConstant: 148+15)
                bottomContainerHeight.isActive = true
        }
        
        bottomContainer.addSubview(messageOptionsController.view)
        messageOptionsController.didMove(toParent: self)
        messageOptionsController.view.leftAnchor.constraint(equalTo: bottomContainer.leftAnchor).isActive = true
        messageOptionsController.view.rightAnchor.constraint(equalTo: bottomContainer.rightAnchor).isActive = true
        messageOptionsController.view.topAnchor.constraint(equalTo: bottomContainer.topAnchor).isActive = true
        messageOptionsController.view.bottomAnchor.constraint(equalTo: bottomContainer.bottomAnchor).isActive = true
        
        self.view.addSubview(sendArrow)
        sendArrow.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true
        sendArrow.widthAnchor.constraint(equalToConstant: 35).isActive = true
        sendArrow.heightAnchor.constraint(equalTo: sendArrow.widthAnchor).isActive = true
        sendArrow.bottomAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: -4).isActive = true
        
        self.view.addSubview(collectionView)
        self.view.sendSubviewToBack(collectionView)
        collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: -8).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 8).isActive = true
        collectionView.topAnchor.constraint(equalTo: currentView.bottomAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomContainer.topAnchor).isActive = true
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(backButtonSwiped))
        swipeGesture.direction = .right
        collectionView.addGestureRecognizer(swipeGesture)
        let wallGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(backButtonSwiped))
        wallGesture.edges = .left
        collectionView.addGestureRecognizer(wallGesture)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        collectionView.addGestureRecognizer(gesture)
        
        self.view.addSubview(speechCheck)
        speechCheck.centerYAnchor.constraint(equalTo: currentView.centerYAnchor).isActive = true
        speechCheck.rightAnchor.constraint(equalTo: currentView.rightAnchor, constant: -24).isActive = true
        speechCheck.heightAnchor.constraint(equalToConstant: 30).isActive = true
        speechCheck.widthAnchor.constraint(equalTo: speechCheck.heightAnchor).isActive = true
        
        self.view.addSubview(speechCheckLabel)
        speechCheckLabel.centerXAnchor.constraint(equalTo: speechCheck.centerXAnchor).isActive = true
        speechCheckLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        speechCheckLabel.topAnchor.constraint(equalTo: speechCheck.bottomAnchor).isActive = true
        speechCheckLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(hostMessageOptionsController.view)
        hostMessageOptionsController.didMove(toParent: self)
        hostMessageOptionsController.view.leftAnchor.constraint(equalTo: bottomContainer.leftAnchor).isActive = true
        hostMessageOptionsController.view.rightAnchor.constraint(equalTo: bottomContainer.rightAnchor).isActive = true
        hostMessageOptionsController.view.topAnchor.constraint(equalTo: bottomContainer.topAnchor).isActive = true
        hostMessageOptionsController.view.bottomAnchor.constraint(equalTo: bottomContainer.bottomAnchor).isActive = true
        
        self.hostMessageOptionsController.cameraButton.addTarget(self, action: #selector(selectImageView(sender:)), for: .touchUpInside)
    }
    
    @objc func backButtonSwiped() {
        resetOptions()
    }
    
    @objc func backButtonPressed(sender: UIButton) {
        resetOptions()
    }
    
    func resetOptions() {
        self.messageOptionsController.resetOptions()
        self.messageOptionsController.sendCommunicationsTargetButton.alpha = 1
        self.hideSendButton()
        self.delegate?.bringBackAllMessages()
        self.delegate?.deselectCells()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.messages = []
            self.collectionView.reloadData()
            self.shouldCheckID = ""
            self.speechCheckLabel.text = "Closed"
            self.speechCheck.tintColor = Theme.DARK_GRAY
            self.speechCheck.alpha = 0
            self.speechCheckLabel.alpha = 0
            self.hostMessageOptionsController.view.alpha = 0
            self.bottomContainer.alpha = 0
            switch device {
            case .iphone8:
                self.bottomContainerHeight.constant = 148
            case .iphoneX:
                self.bottomContainerHeight.constant = 148 + 15
            }
        }
    }
    
    func bringSendButton() {
        UIView.animate(withDuration: 0.1) {
            self.sendArrow.alpha = 1
        }
    }
    
    func hideSendButton() {
        UIView.animate(withDuration: 0.1) {
            self.sendArrow.alpha = 0
        }
    }

    func setMessage(message: String) {
        self.userMessage = message
    }
    
    @objc func handleSend(sender: UIButton) {
        let properties = ["text": self.userMessage] as [String : AnyObject]
        sendMessageWithProperties(properties: properties)
    }
    
    private func sendMessageWithProperties(properties: [String: AnyObject]) {
        self.messageOptionsController.resetOptions()
        self.hideSendButton()
        
        let ref = Database.database().reference()
        let toID = self.userID
        let fromID = Auth.auth().currentUser!.uid
        let timestamp = Int(Date().timeIntervalSince1970)

        let childRef = ref.child("messages").childByAutoId()
        var values = ["toID": toID, "fromID": fromID, "timestamp": timestamp] as [String : Any]
        ref.child("messages").child(fromID).removeValue()
        
        properties.forEach({values[$0] = $1})
        childRef.updateChildValues(values) { (error, ralf) in
            if error != nil {
                print(error ?? "")
                return
            }
            if let messageId = childRef.key {
                let vals = [messageId: 1] as [String: Int]
            
                let userMessagesRef = ref.child("user-messages").child(fromID).child(toID)
                userMessagesRef.updateChildValues(vals)
                
                let recipientUserMessagesRef = ref.child("user-messages").child(toID).child(fromID)
                recipientUserMessagesRef.updateChildValues(vals)
            }
        }
    }
    
    var shouldCheckID: String = ""
    
    func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let toID = self.userID
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(toID)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            if self.shouldCheckID != messageId {
                self.shouldCheckID = messageId
                let messagesRef = Database.database().reference().child("messages").child(messageId)
                messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let dictionary = snapshot.value as? [String: AnyObject] else {
                        return
                    }
                    if (dictionary["communicationsStatus"] as? String) != nil {
                        if (dictionary["communicationsId"] as? String) != nil {} else {
                            messagesRef.updateChildValues(["communicationsId": messageId])
                            self.messageID = messageId
                        }
                    }
                    DispatchQueue.main.async(execute: {
                        self.messages.append(Message(dictionary: dictionary))
                        self.collectionView.reloadData()
                        let indexPath = NSIndexPath(item: self.messages.count - 1, section: 0)
                        self.collectionView.scrollToItem(at: indexPath as IndexPath, at: .top, animated: true)
                    })
                }, withCancel: nil)
            }
        }, withCancel: nil)
    }
    
    @objc func selectImageView(sender: UIButton) {
        let alert = UIAlertController(title: "Select an Image:", message: "How would you like to upload an image of the parking spot?", preferredStyle: UIAlertController.Style.actionSheet)
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
        pickerParking?.sourceType = .photoLibrary
        
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
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        handleImageSelectedForInfo(info: info)
        dismiss(animated: true, completion: nil)
    }
    
    private func handleImageSelectedForInfo(info: [String:Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            uploadToFirebaseStorageUsingImage(image: selectedImage, completion: { (imageURL) in
                self.sendImageMessageURL(imageURL: imageURL, image: selectedImage)
            })
        }
    }
    
    private func uploadToFirebaseStorageUsingImage(image: UIImage, completion: @escaping (_ imageURL: String) -> ()) {
        let imageName = NSUUID().uuidString
        let ref = Storage.storage().reference().child("message_images").child(imageName)
        
        if let uploadData = image.jpegData(compressionQuality: 0.2) {
            ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print("Failed to upload image")
                    return
                }
                ref.downloadURL(completion: { (url, error) in
                    guard let imageURL = url?.absoluteString else {
                        print("Failed to upload image", error!)
                        return
                    }
                    self.view.layoutIfNeeded()
                    completion(imageURL)
                })
            })
        }
    }
    
    private func sendImageMessageURL(imageURL: String, image: UIImage) {
        let properties = ["imageURL": imageURL, "imageHeight": image.size.height, "imageWidth": image.size.width] as [String : AnyObject]
        sendMessageWithProperties(properties: properties)
    }

}

extension CurrentMessageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        cell.chatLogController = self
        
        let message = messages[indexPath.item]
        cell.message = message
        cell.textView.text = message.text
        setupCell(cell: cell, message: message)
        
        if let text = message.text {
            cell.textView.isHidden = false
            cell.bubbleWidthAnchor?.constant = estimatedFrameForText(text: text).width + 32
        } else if message.imageURL != nil {
            cell.textView.isHidden = true
            cell.bubbleWidthAnchor?.constant = 200
        }
        
        cell.playButton.isHidden = message.videoURL == nil
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 76
        
        let message = messages[indexPath.item]
        if let text = message.text {
            height = estimatedFrameForText(text: text).height + 16
            if message.communicationsStatus != nil {
                if message.fromID != Auth.auth().currentUser?.uid {
                    height = height + 40
                } else {
                    height = height + 40
                }
            }
        } else if let imageWidth = message.imageWidth?.floatValue, let imageHight = message.imageHeight?.floatValue {
            height = CGFloat(imageHight/imageWidth * 200 - 4)
        }
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    private func estimatedFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    fileprivate func setupCell(cell: ChatMessageCell, message: Message) {
        let ref = Database.database().reference().child("users").child(self.userID)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                if let userPicture = dictionary["picture"] as? String {
                    if userPicture != "" {
                        self.profileImageView.loadImageUsingCacheWithUrlString(userPicture)
                    } else {
                        let image = UIImage(named: "profileprofile")
                        self.profileImageView.image = image
                    }
                }
                if let userName = dictionary["name"] as? String {
                    var fullNameArr = userName.split(separator: " ")
                    let firstName: String = String(fullNameArr[0])
                    if let lastName: String = fullNameArr.count > 1 ? String(fullNameArr[1]) : nil {
                        var lastCharacter = lastName.chunk(n: 1)
                        self.currentLabel.text = "\(firstName) \(lastCharacter[0])."
                        self.currentLabel.font = UIFont.systemFont(ofSize: 18, weight: .light)
                    } else {
                        self.currentLabel.text = userName
                        if userName == " Drivewayz " {
                            let image = UIImage(named: "background4")
                            self.profileImageView.image = image
                            self.currentLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
                            self.openCommunications(cell: cell)
                        } else {
                            self.currentLabel.font = UIFont.systemFont(ofSize: 18, weight: .light)
                        }
                    }
                }
            }
        }
        if message.fromID == Auth.auth().currentUser?.uid {
            cell.bubbleView.backgroundColor = Theme.SEA_BLUE
            cell.textView.textColor = UIColor.white
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            if message.communicationsStatus != nil {
                self.permissionStatusCell = cell
                if message.communicationsId != nil {
                    self.messageID = message.communicationsId
                }
                cell.permissionView.alpha = 1
                cell.textView.text = "Request for open communications status:"
                self.monitorPermissions(message: message)
            } else {
                self.noCommunication(cell: cell)
            }
        } else {
            cell.bubbleView.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.1)
            cell.textView.textColor = UIColor.black
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
            if message.communicationsStatus != nil {
                self.permissionStatusCell = cell
                if message.communicationsId != nil {
                    self.messageID = message.communicationsId
                }
                cell.permissionView.alpha = 1
                cell.permissionOpened.addTarget(self, action: #selector(permissionOpenPressed(sender:)), for: .touchUpInside)
                cell.permissionClosed.addTarget(self, action: #selector(permissionClosedPressed(sender:)), for: .touchUpInside)
                self.monitorPermissions(message: message)
            } else {
                self.noCommunication(cell: cell)
            }
        }
        if let messageImageURL = message.imageURL {
            cell.messageImageView.loadImageUsingCacheWithUrlString(messageImageURL)
            cell.messageImageView.isHidden = false
            cell.bubbleView.backgroundColor = UIColor.clear
        } else {
            cell.messageImageView.isHidden = true
        }
    }
    
    func monitorPermissions(message: Message) {
        self.messageOptionsController.removeCommunicationsTarget()
        DispatchQueue.main.async {
            let ref = Database.database().reference().child("messages").child(self.messageID!)
            ref.observe(.childAdded) { (snapshot) in
                if let communicationStatus = snapshot.value as? String {
                    if communicationStatus == "open" {
                        self.openCommunications(cell: self.permissionStatusCell!)
                    } else if communicationStatus == "closed" {
                        self.closedCommunications(cell: self.permissionStatusCell!)
                    }
                }
            }
        }
    }
    
    @objc func permissionOpenPressed(sender: UIButton) {
        let ref = Database.database().reference().child("messages").child(self.messageID!)
        ref.child("communicationsStatus").removeValue()
        ref.updateChildValues(["communicationsStatus": "open"])
    }
    
    @objc func permissionClosedPressed(sender: UIButton) {
        self.messageOptionsController.sendCommunications.setTitle("Closed", for: .normal)
        self.messageOptionsController.informationLabel.text = "The host has declined your request for open communications. If the issue persists please contact Drivewayz."
        let ref = Database.database().reference().child("messages").child(self.messageID!)
        ref.child("communicationsStatus").removeValue()
        ref.updateChildValues(["communicationsStatus": "closed"])
    }
    
    func noCommunication(cell: ChatMessageCell) {
        cell.permissionView.alpha = 0
        self.messageOptionsController.sendCommunications.setTitle("Ask for open communications", for: .normal)
        self.messageOptionsController.sendCommunications.backgroundColor = Theme.HARMONY_RED.withAlphaComponent(0.7)
        self.messageOptionsController.sendCommunicationsWidth.constant = 280
        self.messageOptionsController.informationLabel.text = "In order to speak freely with the host you must first ask their permission for open communications."
    }
    
    func openCommunications(cell: ChatMessageCell) {
        self.speechCheck.tintColor = Theme.GREEN_PIGMENT
        self.speechCheckLabel.text = "Open"
        self.speechCheck.alpha = 1
        self.speechCheckLabel.alpha = 1
        cell.permissionView.alpha = 1
        cell.permissionOpened.backgroundColor = Theme.GREEN_PIGMENT
        cell.permissionClosed.backgroundColor = .clear
        cell.permissionOpened.setTitleColor(Theme.WHITE, for: .normal)
        cell.permissionClosed.setTitleColor(Theme.BLACK, for: .normal)
        cell.permissionOpened.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        cell.permissionClosed.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
        self.messageOptionsController.sendCommunications.setTitle("Open", for: .normal)
        self.messageOptionsController.sendCommunications.backgroundColor = Theme.GREEN_PIGMENT
        self.messageOptionsController.sendCommunicationsWidth.constant = 180
        self.shouldAnimate = true
        if self.isHost == false {
            UIView.animate(withDuration: 0.1) {
                self.bottomContainer.alpha = 0
                self.hostMessageOptionsController.view.alpha = 1
                self.hostMessageOptionsController.setParkingOptions()
                switch device {
                case .iphone8:
                    self.bottomContainerHeight.constant = 60 + 55
                case .iphoneX:
                    self.bottomContainerHeight.constant = 60 + 55 + 15
                }
            }
        } else if self.isHost == true {
            switch device {
            case .iphone8:
                self.bottomContainerHeight.constant = 60 + 55
            case .iphoneX:
                self.bottomContainerHeight.constant = 60 + 55 + 15
            }
            self.hostMessageOptionsController.setHostOptions()
        }
        _ = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(animateSpeechStatus), userInfo: nil, repeats: true)
    }
    
    func closedCommunications(cell: ChatMessageCell) {
        self.speechCheck.tintColor = Theme.DARK_GRAY
        self.speechCheckLabel.text = "Closed"
        self.speechCheck.alpha = 1
        self.speechCheckLabel.alpha = 1
        cell.permissionView.alpha = 1
        cell.permissionOpened.backgroundColor = .clear
        cell.permissionClosed.backgroundColor = Theme.DARK_GRAY
        cell.permissionOpened.setTitleColor(Theme.BLACK, for: .normal)
        cell.permissionClosed.setTitleColor(Theme.WHITE, for: .normal)
        cell.permissionClosed.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        cell.permissionOpened.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
        self.messageOptionsController.sendCommunications.setTitle("Pending...", for: .normal)
        self.messageOptionsController.informationLabel.text = "You must wait for the host's permission before freely communicating."
        self.messageOptionsController.sendCommunications.backgroundColor = Theme.DARK_GRAY
        self.messageOptionsController.sendCommunicationsWidth.constant = 180
        if self.isHost == false {
            self.view.endEditing(true)
            UIView.animate(withDuration: 0.1) {
                self.bottomContainer.alpha = 1
                self.hostMessageOptionsController.view.alpha = 0
                self.hostMessageOptionsController.setParkingOptions()
                switch device {
                case .iphone8:
                    self.bottomContainerHeight.constant = 148
                case .iphoneX:
                    self.bottomContainerHeight.constant = 148 + 15
                }
            }
        } else if self.isHost == true {
            switch device {
            case .iphone8:
                self.bottomContainerHeight.constant = 148
            case .iphoneX:
                self.bottomContainerHeight.constant = 148 + 15
            }
            self.hostMessageOptionsController.setHostOptions()
        }
        self.shouldAnimate = false
    }
    
    func setParkingOptions() {
        self.hostMessageOptionsController.setParkingOptions()
    }
    
    func setHostOptions() {
        self.hostMessageOptionsController.setHostOptions()
    }
    
    func performZoomForStartingImageView(startingImageView: UIImageView) {
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.backgroundColor = UIColor.red
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        
        if let keyWindow = UIApplication.shared.keyWindow {
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = Theme.BLACK
            blackBackgroundView?.alpha = 0
            blackBackgroundView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
            keyWindow.addSubview(blackBackgroundView!)
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackBackgroundView?.alpha = 0.95
                
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                zoomingImageView.center = keyWindow.center
                
            }, completion: { (completed) in
                
            })
            
        }
    }
    
    @objc func handleZoomOut(_ tapGesture: UITapGestureRecognizer) {
        if let zoomOutImageView = tapGesture.view {
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.clipsToBounds = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
                
            }, completion: { (completed) in
                zoomOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
            })
        }
    }
    
    @objc func animateSpeechStatus() {
        if self.shouldAnimate == true {
            UIView.animate(withDuration: 0.5, animations: {
                self.speechCheck.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }) { (success) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.speechCheck.transform = CGAffineTransform(scaleX: 1, y: 1)
                })
            }
        }
    }
    
    func moveCollectionViewAnchor(value: CGFloat, add: Bool) {
        if add == true {
            self.collectionViewBottomAnchor.constant = self.collectionViewBottomAnchor.constant-value
        } else {
            self.collectionViewBottomAnchor.constant = -value
        }
        let indexPath = NSIndexPath(item: self.messages.count - 1, section: 0)
        self.collectionView.scrollToItem(at: indexPath as IndexPath, at: .top, animated: true)
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func endEditing() {
        self.view.endEditing(true)
    }
    
}

fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
