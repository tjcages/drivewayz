//
//  RespondMessageViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/5/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class RespondMessageViewController: UIViewController {
    
    var shouldCheckID: String = ""
    var messageID: String?
    var shouldMakePrevious: Bool = false
    var messages = [Message]()
    var userID: String = ""
    var previousScrollPosition: CGFloat = 0.0
    
    var pickerParking: UIImagePickerController?
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingImageView: UIImageView?
    var keyboardHeight: CGFloat = 1.0
    
    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        
        return view
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backButtonDismissed), for: .touchUpInside)
        
        return button
    }()
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        let origImage = UIImage(named: "background4")
        imageView.image = origImage
        imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Theme.OFF_WHITE
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = Theme.OFF_WHITE
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Tyler"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH2
        
        return label
    }()
    
    var durationLabel: UILabel = {
        let label = UILabel()
        label.text = "20 minutes ago"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var messageBarBackground: UIView = {let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE.withAlphaComponent(0.4)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: 100)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blurEffectView)
        
        let line = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: 0.5))
        line.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        view.addSubview(line)
        
        return view
    }()
    
    var messageTextView: UITextView = {
        let view = UITextView()
        view.backgroundColor = Theme.WHITE
        view.font = Fonts.SSPRegularH5
        view.textColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.6)
        view.text = "Write a message"
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isScrollEnabled = true
        view.layer.cornerRadius = 20
        view.layer.borderColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.6).cgColor
        view.layer.borderWidth = 0.5
        view.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 0, right: 42)
        view.autocorrectionType = .default
        view.autocapitalizationType = .sentences
        
        return view
    }()
    
    lazy var cameraButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "camera")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.PRUSSIAN_BLUE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(selectImageView(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "sendCusor")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLUE
        button.layer.cornerRadius = 33/2
        button.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 8, right: 8)
        button.addTarget(self, action: #selector(handleSend(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 60, height: 60)
        
        let view = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.contentInset = UIEdgeInsets(top: 8, left: -24, bottom: 8, right: -24)
        view.alwaysBounceVertical = true
        view.register(ChatMessageCell.self, forCellWithReuseIdentifier: "cellId")
        
        return view
    }()
    
    func setData(message: Message) {
        if let fromID = message.fromID, let name = message.name, let date = message.date, let picture = message.picture {
            self.userID = fromID
            self.mainLabel.text = name
            if picture != "" {
                self.profileImageView.loadImageUsingCacheWithUrlString(picture)
            }
            var duration = date.replacingOccurrences(of: "sec", with: "seconds ago")
            duration = duration.replacingOccurrences(of: "min", with: "minutes ago")
            duration = duration.replacingOccurrences(of: "hrs", with: "hours ago")
            duration = duration.replacingOccurrences(of: "yrs", with: "years ago")
            self.durationLabel.text = duration
            
            self.shouldMakePrevious = true
            self.observeMessages(toID: fromID)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTextView.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.backgroundColor = Theme.WHITE
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        setupViews()
        setupMessageBar()
    }
    
    func setupViews() {
        
        self.view.addSubview(gradientContainer)
        gradientContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        switch device {
        case .iphone8:
            gradientContainer.heightAnchor.constraint(equalToConstant: 160).isActive = true
        case .iphoneX:
            gradientContainer.heightAnchor.constraint(equalToConstant: 180).isActive = true
        }
        
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
        
        self.view.addSubview(profileImageView)
        profileImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: -16).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: backButton.leftAnchor, constant: 12).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        mainLabel.centerYAnchor.constraint(equalTo:profileImageView.centerYAnchor, constant: -2).isActive = true
        
        self.view.addSubview(durationLabel)
        durationLabel.leftAnchor.constraint(equalTo: backButton.leftAnchor, constant: 12).isActive = true
        durationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        durationLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        durationLabel.centerYAnchor.constraint(equalTo:profileImageView.centerYAnchor, constant: 24).isActive = true
        
    }
    
    var messageBarBottomAnchor: NSLayoutConstraint!
    var messageFieldHeightAnchor: NSLayoutConstraint!
    
    func setupMessageBar() {
        
        self.view.addSubview(messageBarBackground)
        messageBarBackground.addSubview(messageTextView)
        messageBarBackground.addSubview(cameraButton)
        messageBarBackground.addSubview(sendButton)
        
        messageBarBottomAnchor = messageBarBackground.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 100)
            messageBarBottomAnchor.isActive = true
        messageBarBackground.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        messageBarBackground.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        messageBarBackground.topAnchor.constraint(equalTo: messageTextView.topAnchor, constant: -16).isActive = true
        
        messageTextView.leftAnchor.constraint(equalTo: cameraButton.rightAnchor, constant: 8).isActive = true
        messageTextView.rightAnchor.constraint(equalTo: messageBarBackground.rightAnchor, constant: -16).isActive = true
        messageFieldHeightAnchor = messageTextView.heightAnchor.constraint(equalToConstant: 40)
            messageFieldHeightAnchor.isActive = true
        messageTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        messageTextView.bottomAnchor.constraint(equalTo: messageBarBackground.bottomAnchor, constant: -24).isActive = true
        
        cameraButton.leftAnchor.constraint(equalTo: messageBarBackground.leftAnchor, constant: 8).isActive = true
        cameraButton.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor).isActive = true
        cameraButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        cameraButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
        
        sendButton.rightAnchor.constraint(equalTo: messageTextView.rightAnchor, constant: -6).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: messageTextView.bottomAnchor, constant: -3.5).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 33).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 33).isActive = true
        
        self.view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: messageBarBackground.topAnchor).isActive = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        collectionView.addGestureRecognizer(tap)
        
    }
    
    func openMessageBar() {
        self.messageBarBottomAnchor.constant = 0
        UIView.animate(withDuration: animationOut) {
            self.view.layoutIfNeeded()
        }
    }
    
    func closeMessageBar() {
        self.messageBarBottomAnchor.constant = 100
        UIView.animate(withDuration: animationOut) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func backButtonDismissed() {
        self.shouldMakePrevious = false
        self.closeMessageBar()
        self.navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}


extension RespondMessageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func handleSend(sender: UIButton) {
        guard let message = self.messageTextView.text else { return }
        if message != "Write a message" && message != "" {
            let properties = ["message": message] as [String : AnyObject]
            
            self.sendButton.alpha = 0.5
            self.sendButton.isUserInteractionEnabled = false
            self.messageTextView.text = "Write a message"
            self.messageTextView.textColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.6)
            let newPosition = self.messageTextView.beginningOfDocument
            self.messageTextView.selectedTextRange = self.messageTextView.textRange(from: newPosition, to: newPosition)
            
            sendMessageWithProperties(properties: properties)
            
            delayWithSeconds(2) {
                self.sendButton.alpha = 1
                self.sendButton.isUserInteractionEnabled = true
            }
        }
        
    }
    
    private func sendMessageWithProperties(properties: [String: AnyObject]) {
        self.shouldMakePrevious = false
        let ref = Database.database().reference()
        let toID = self.userID
        let fromID = Auth.auth().currentUser!.uid
        let timestamp = Int(Date().timeIntervalSince1970)
        
        let childRef = ref.child("messages").childByAutoId()
        var values = ["status": "Sent", "deviceID": AppDelegate.DEVICEID, "toID": toID, "fromID": fromID, "timestamp": timestamp, "communicationsStatus": "Previous"] as [String : Any]
        
        let userRef = ref.child("users").child(fromID)
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let userName = dictionary["name"] as? String
                var fullNameArr = userName?.split(separator: " ")
                let firstName: String = String(fullNameArr![0])
                values["name"] = userName
                if let picture = dictionary["picture"] as? String {
                    values["picture"] = picture
                }
                
                self.fetchNewCurrent(key: toID, name: firstName)
                
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
                        
                        self.sendButton.alpha = 1
                        self.sendButton.isUserInteractionEnabled = true
                    }
                }
            }
        }
    }
    
    func fetchNewCurrent(key: String, name: String) {
        Database.database().reference().child("users").child(key).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let fromDevice = dictionary["DeviceID"] as? String
                self.setupPushNotifications(fromDevice: fromDevice!, name: name)
            }
        }
    }
    
    fileprivate func setupPushNotifications(fromDevice: String, name: String) {
        
    }
    
    func observeMessages(toID: String) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(toID)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            
            if self.shouldMakePrevious {
                let ref = Database.database().reference().child("messages").child(messageId)
                ref.updateChildValues(["communicationsStatus": "Previous"])
            }
            
            if self.shouldCheckID != messageId {
                self.shouldCheckID = messageId
                let messagesRef = Database.database().reference().child("messages").child(messageId)
                messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let dictionary = snapshot.value as? [String: AnyObject] else {
                        return
                    }
//                    if (dictionary["communicationsStatus"] as? String) != nil {
//                        if (dictionary["communicationsId"] as? String) != nil {} else {
//                            messagesRef.updateChildValues(["communicationsId": messageId])
//                            self.messageID = messageId
//                        }
//                    }
                    DispatchQueue.main.async(execute: {
                        self.messages.append(Message(dictionary: dictionary))
                        self.collectionView.reloadData()
                        let indexPath = NSIndexPath(item: self.messages.count - 1, section: 0)
                        self.collectionView.scrollToItem(at: indexPath as IndexPath, at: .top, animated: true)
                        delayWithSeconds(animationIn) {
                            self.previousScrollPosition = self.collectionView.contentOffset.y
                        }
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
    
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
}

extension RespondMessageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ChatMessageCell
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
        } else if let imageWidth = message.imageWidth?.floatValue, let imageHight = message.imageHeight?.floatValue {
            height = CGFloat(imageHight/imageWidth * 200 - 4)
        }
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    private func estimatedFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: Fonts.SSPRegularH5], context: nil)
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
            }
        }
        if message.fromID == Auth.auth().currentUser?.uid {
            cell.bubbleView.backgroundColor = Theme.BLUE
            cell.textView.textColor = UIColor.white
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            if message.communicationsStatus != nil {
                if message.communicationsId != nil {
                    self.messageID = message.communicationsId
                }
            }
        } else {
            cell.bubbleView.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.1)
            cell.textView.textColor = UIColor.black
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
            if message.communicationsStatus != nil {
                if message.communicationsId != nil {
                    self.messageID = message.communicationsId
                }
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
            zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
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
    
    @objc func endEditing() {
        self.view.endEditing(true)
    }
    
}


extension RespondMessageViewController: UITextViewDelegate {
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            self.messageBarBottomAnchor.constant = -keyboardHeight
            let newPosition = self.messageTextView.beginningOfDocument
            self.messageTextView.selectedTextRange = self.messageTextView.textRange(from: newPosition, to: newPosition)
            UIView.animate(withDuration: animationOut, animations: {
                let newPosition = self.messageTextView.beginningOfDocument
                self.messageTextView.selectedTextRange = self.messageTextView.textRange(from: newPosition, to: newPosition)
                self.view.layoutIfNeeded()
            }) { (success) in
                self.keyboardHeight = keyboardHeight
                let newPosition = self.messageTextView.beginningOfDocument
                self.messageTextView.selectedTextRange = self.messageTextView.textRange(from: newPosition, to: newPosition)
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let newPosition = textView.beginningOfDocument
        textView.selectedTextRange = textView.textRange(from: newPosition, to: newPosition)
        let indexPath = NSIndexPath(item: self.messages.count - 1, section: 0)
        self.collectionView.scrollToItem(at: indexPath as IndexPath, at: .top, animated: true)
        delayWithSeconds(animationIn) {
            self.previousScrollPosition = self.collectionView.contentOffset.y
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.messageBarBottomAnchor.constant = 0
        self.keyboardHeight = 1.0
        UIView.animate(withDuration: animationOut) {
            self.view.layoutIfNeeded()
        }
        if textView.text == "" {
            textView.text = "Write a message"
            textView.textColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.6)
            let newPosition = textView.beginningOfDocument
            textView.selectedTextRange = textView.textRange(from: newPosition, to: newPosition)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        textView.textColor = Theme.BLACK
        if textView.text == "Write a message" {
            textView.text = ""
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Write a message"
            textView.textColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.6)
            let newPosition = textView.beginningOfDocument
            textView.selectedTextRange = textView.textRange(from: newPosition, to: newPosition)
        }
        self.messageFieldHeightAnchor.constant = textView.text.height(withConstrainedWidth: textView.bounds.width - 58, font: Fonts.SSPRegularH5) + 20
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 0, right: 42)
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        let difference = self.previousScrollPosition - translation
        if difference >= 24 && self.messageBarBottomAnchor.constant == -keyboardHeight {
            self.view.endEditing(true)
        }
    }
    
}
