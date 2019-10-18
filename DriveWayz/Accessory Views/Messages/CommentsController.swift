//
//  CommentsController.swift
//  InstagramFirebase
//
//  Created by Brian Voong on 4/29/17.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit
import Firebase

class CommentsController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CommentInputAccessoryViewDelegate {
    
    let cellId = "cellId"
    
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingImageView: UIImageView?
    
    var userID: String = ""
    var userPicture: String?
    
    var sendingFromDrivewayz: Bool = false
    var messageID: String?
    var messages = [Message]() {
        didSet {
            self.collectionView.reloadData()
            
            let indexPath = NSIndexPath(item: self.messages.count - 1, section: 0)
            self.collectionView.scrollToItem(at: indexPath as IndexPath, at: .top, animated: true)
        }
    }
    
    lazy var containerView: CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let commentInputAccessoryView = CommentInputAccessoryView(frame: frame)
        commentInputAccessoryView.delegate = self
        
        return commentInputAccessoryView
    }()
    
    let gradientController: GradientContainerView = {
        let controller = GradientContainerView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.mainLabel.text = "Drivewayz Support"
        controller.backButton.addTarget(self, action: #selector(backButtonDismissed), for: .touchUpInside)
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .interactive
        
        collectionView?.contentInset = UIEdgeInsets(top: gradientHeight, left: 0, bottom: 8, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: gradientHeight + statusHeight, left: 0, bottom: 0, right: 0)
        
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        setupContainer()
    }
    
    func setupContainer() {
        self.view.addSubview(gradientController.view)
        gradientController.view.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: gradientHeight)
    }
    
    func setData(userID: String) {
        self.userID = userID
        let ref = Database.database().reference().child("DrivewayzMessages").child(userID)
        ref.observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            DispatchQueue.main.async(execute: {
                let message = Message(dictionary: dictionary)
                self.messages.append(message)
                
                if let picture = message.picture, self.userPicture == nil {
                    self.userPicture = picture
                }
            })
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 76
        
        let message = messages[indexPath.item]
        if let text = message.text {
//            height = estimatedFrameForText(text: text).height + 16
            let constraintRect = CGSize(width: 0.66 * phoneWidth,
                                        height: .greatestFiniteMagnitude)
            let boundingBox = text.boundingRect(with: constraintRect,
                                                options: .usesLineFragmentOrigin,
                                                attributes: [.font: Fonts.SSPRegularH4],
                                                context: nil)
            let labelSize = CGSize(width: ceil(boundingBox.width),
                                   height: ceil(boundingBox.height) + 20)
            height = labelSize.height
        } else if let imageWidth = message.imageWidth?.floatValue, let imageHight = message.imageHeight?.floatValue {
            height = CGFloat(imageHight/imageWidth * 200 - 4)
        }
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ChatMessageCell
        //        cell.chatLogController = self
        
        let message = messages[indexPath.item]
        cell.message = message
//        cell.textView.text = message.text
        setupCell(cell: cell, message: message)
        
        if let text = message.text {
//            cell.textView.isHidden = false
//            cell.bubbleWidthAnchor?.constant = estimatedFrameForText(text: text).width + 32
        } else if message.imageURL != nil {
//            cell.textView.isHidden = true
//            cell.bubbleWidthAnchor?.constant = 200
        }
        
        cell.playButton.isHidden = message.videoURL == nil
        
        return cell
    }
    
    fileprivate func setupCell(cell: ChatMessageCell, message: Message) {
        if message.fromID == Auth.auth().currentUser?.uid {
//            cell.bubbleView.backgroundColor = Theme.BLUE
//            cell.textView.textColor = UIColor.white
//            cell.bubbleViewRightAnchor?.isActive = true
//            cell.bubbleViewLeftAnchor?.isActive = false
            if let text = message.text {
                cell.showBubbleMessage(text: text, isIncoming: false)
            }
            if message.communicationsStatus != nil {
                if message.communicationsId != nil {
                    self.messageID = message.communicationsId
                }
            }
        } else {
//            cell.bubbleView.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.1)
//            cell.textView.textColor = UIColor.black
//            cell.bubbleViewRightAnchor?.isActive = false
//            cell.bubbleViewLeftAnchor?.isActive = true
            if let text = message.text {
                cell.showBubbleMessage(text: text, isIncoming: true)
            }
            if message.communicationsStatus != nil {
                if message.communicationsId != nil {
                    self.messageID = message.communicationsId
                }
            }
        }
        if let messageImageURL = message.imageURL {
//            cell.messageImageView.loadImageUsingCacheWithUrlString(messageImageURL) { (bool) in
            
//            }
//            cell.messageImageView.isHidden = false
//            cell.bubbleView.backgroundColor = UIColor.clear
        } else {
//            cell.messageImageView.isHidden = true
        }
    }
    
    private func estimatedFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: Fonts.SSPRegularH4], context: nil)
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func backButtonDismissed() {
        if self.gradientController.backButton.tag == 0 {
            self.navigationController?.popViewController(animated: true)
        } else if self.gradientController.backButton.tag == 1 {
            self.dismiss(animated: true, completion: nil)
        }
    }
}


extension CommentsController {
    
    func didSubmit(for comment: String) {
        if comment != "Write a message" && comment != "" {
            let properties = ["message": comment] as [String : AnyObject]
            
            if self.sendingFromDrivewayz == false {
                self.sendMessageWithProperties(properties: properties)
            } else {
                self.sendDrivewayzMessageWithProperties(properties: properties)
            }
        }
    }
    
    private func sendMessageWithProperties(properties: [String: AnyObject]) {
        guard let fromID = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("DrivewayzMessages").child(fromID).childByAutoId()
        let timestamp = Int(Date().timeIntervalSince1970)
        
        let userRef = Database.database().reference().child("users").child(fromID)
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let userName = dictionary["name"] as? String
                let email = dictionary["email"] as? String
                let picture = dictionary["picture"] as? String
                
                var values = ["name": userName as Any,
                              "email": email as Any,
                              "timestamp": timestamp,
                              "context": "Reply",
                              "deviceID": AppDelegate.DEVICEID,
                              "fromID": fromID,
                              "picture": picture as Any,
                              "communicationsStatus": "Recent"]
                
                properties.forEach({values[$0] = $1})
                ref.updateChildValues(values) { (error, ralf) in
                    if error != nil {
                        print(error ?? "")
                        return
                    }
                    if let key = ralf.key {
                        let childRef = Database.database().reference().child("Messages").child(key)
                        childRef.updateChildValues(values, withCompletionBlock: { (error, success) in
                            self.containerView.clearCommentTextField()
                        })
                    }
                }
            }
        }
    }
    
    private func sendDrivewayzMessageWithProperties(properties: [String: AnyObject]) {
        guard let fromID = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("DrivewayzMessages").child(self.userID).childByAutoId()
        let timestamp = Int(Date().timeIntervalSince1970)
        let picture: String = self.userPicture ?? ""
        
        let userRef = Database.database().reference().child("users").child(fromID)
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                let userName = dictionary["name"] as? String
                
                var values = ["timestamp": timestamp,
                              "context": "Reply",
                              "deviceID": AppDelegate.DEVICEID,
                              "fromID": fromID,
                              "toID": self.userID,
                              "name": userName as Any,
                              "picture": picture,
                              "communicationsStatus": "Recent"] as [String : Any]
                
                properties.forEach({values[$0] = $1})
                ref.updateChildValues(values) { (error, ralf) in
                    if error != nil {
                        print(error ?? "")
                        return
                    }
                    if let key = ralf.key {
                        let childRef = Database.database().reference().child("Messages").child(key)
                        childRef.updateChildValues(values, withCompletionBlock: { (error, success) in
                            let userRef = Database.database().reference().child("users").child(self.userID).child("PersonalMessages")
                            userRef.updateChildValues(["Drivewayz": key])
                            self.containerView.clearCommentTextField()
                        })
                    }
                }
            }
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
    
}
