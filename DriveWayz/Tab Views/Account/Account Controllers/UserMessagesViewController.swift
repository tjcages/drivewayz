//
//  UserMessagesViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 10/9/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

protocol handleCurrentMessages {
    func bringBackAllMessages()
    func deselectCells()
}

class UserMessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, handleCurrentMessages {
    
    var PreviousMessages: [String] = []
    let cellId = "cellId"
    var delegate: controlsAccountOptions?
    var moveDelegate: moveControllers?
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Messages"
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPBoldH1
        
        return label
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = Theme.OFF_WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -1)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.4
        view.decelerationRate = .fast
        
        return view
    }()
    
    var currentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE
        view.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.4).cgColor
        view.layer.borderWidth = 0.5
        
        let label = UILabel()
        label.text = "Your current messages"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.font = Fonts.SSPLightH4
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        label.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        return view
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        button.addTarget(self, action: #selector(backButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var currentMessagesTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isScrollEnabled = false
        view.register(UserCell.self, forCellReuseIdentifier: "cellId")
        
        return view
    }()
    
    lazy var currentMessagesController: CurrentMessageViewController = {
        let controller = CurrentMessageViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = true
        
        currentMessagesTableView.delegate = self
        currentMessagesTableView.dataSource = self

        setupViews()
        
        messages.removeAll()
        messagesDictionary.removeAll()
        currentMessagesTableView.reloadData()
        observeUserMessages()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.layoutIfNeeded()
    }

    var gradientHeightAnchor: NSLayoutConstraint!
    var currentTableHeightAnchor: NSLayoutConstraint!
    var messagesAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(gradientContainer)
        self.view.addSubview(scrollView)
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        messagesAnchor = scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor)
            messagesAnchor.isActive = true
        scrollView.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        gradientContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        switch device {
        case .iphone8:
            gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: 160)
                gradientHeightAnchor.isActive = true
        case .iphoneX:
            gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: 180)
                gradientHeightAnchor.isActive = true
        }
        
        self.view.addSubview(currentView)
        currentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: -1).isActive = true
        currentView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 1).isActive = true
        currentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        currentView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.view.addSubview(currentMessagesTableView)
        self.view.bringSubviewToFront(gradientContainer)
        currentMessagesTableView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        currentMessagesTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        currentMessagesTableView.topAnchor.constraint(equalTo: currentView.bottomAnchor).isActive = true
        currentTableHeightAnchor = currentMessagesTableView.heightAnchor.constraint(equalToConstant: 50)
            currentTableHeightAnchor.isActive = true
        
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
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: -16).isActive = true
    }
    
    @objc func backButtonPressed(sender: UIButton) {
        currentMessagesController.resetOptions()
        UIView.animate(withDuration: animationOut, animations: {
            self.backButton.alpha = 0
        }) { (success) in
            UIView.animate(withDuration: animationOut) {
                self.moveDelegate?.bringExitButton()
            }
        }
    }
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let userID = snapshot.key
            ref.child(userID).observe(.childAdded, with: { (snapshot) in
                let messageID = snapshot.key
                self.fetchMessages(messageID: messageID)
            })
        }, withCancel: nil)
        ref.observe(.childRemoved, with: { (snapshot) in
            self.messagesDictionary.removeValue(forKey: snapshot.key)
            self.reloadOfTable()
        }, withCancel: nil)
    }
    
    private func fetchMessages(messageID: String) {
        let messageRef = Database.database().reference().child("messages").child(messageID)
        messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let message = Message(dictionary: dictionary)
                if let chatPartnerID = message.chatPartnerID() {
                    self.messagesDictionary[chatPartnerID] = message
                }
                self.reloadOfTable()
            }
        }, withCancel: nil)
    }
    
    private func reloadOfTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    var timer: Timer?
    
    @objc func handleReloadTable() {
        self.messages = Array(self.messagesDictionary.values)
        self.messages.sort(by: { (message1, message2) -> Bool in
            return (message1.timestamp?.intValue)! > (message2.timestamp?.intValue)!
        })
        DispatchQueue.main.async(execute: {
            self.currentMessagesTableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let message = self.messages[indexPath.row]
        
        if let chatPartnerID = message.chatPartnerID() {
            Database.database().reference().child("user-messages").child(uid).child(chatPartnerID).removeValue(completionBlock: { (error, ref) in
                if error != nil {
                    print("Failed to delete message.")
                    return
                }
                self.messagesDictionary.removeValue(forKey: chatPartnerID)
                self.reloadOfTable()
            })
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowHeight: CGFloat = 80
        if tableView == currentMessagesTableView {
            self.currentTableHeightAnchor.constant = rowHeight * CGFloat(self.messages.count)
        }
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: 320 + rowHeight * CGFloat(self.messages.count + self.PreviousMessages.count))
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == currentMessagesTableView {
            return self.messages.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        if messages.count > 0 {
            let message = messages[indexPath.row]
            cell.message = message
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
            return cell
        }
        return UITableViewCell()
    }
    
    var currentMessagesAnchor: NSLayoutConstraint!
    var previousCell: UserCell?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        if tableView == currentMessagesTableView {
            self.view.addSubview(currentMessagesController.view)
            self.addChild(currentMessagesController)
            currentMessagesController.didMove(toParent: self)
            currentMessagesController.view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
            currentMessagesAnchor = currentMessagesController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width)
                currentMessagesAnchor.isActive = true
            currentMessagesController.view.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
            currentMessagesController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: animationIn, animations: {
                self.messagesAnchor.constant = -self.view.frame.width/2
                self.currentMessagesAnchor.constant = 0
                self.moveDelegate?.hideExitButton()
                self.backButton.alpha = 1
                self.view.layoutIfNeeded()
            }) { (success) in
                if self.previousCell != nil {
                    self.previousCell?.backgroundColor = Theme.WHITE
                }
                self.previousCell = cell
                cell.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
                let message = self.messages[indexPath.row]
                guard let chatPartnerID = message.chatPartnerID() else {
                    return
                }
                self.checkIfHost(chatPartnerID: chatPartnerID)
                let ref = Database.database().reference().child("users").child(chatPartnerID)
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let dictionary = snapshot.value as? [String:AnyObject]
                        else {
                            return
                    }
                    let user = Users()
                    let picture = dictionary["picture"] as? String
                    let name = dictionary["name"] as? String
                    user.id = chatPartnerID
                    user.name = name
                    user.picture = picture
                    self.currentMessagesController.setData(userId: chatPartnerID)
                }, withCancel: nil)
            }
        }
    }
    
    func checkIfHost(chatPartnerID: String) {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(currentUser).child("Parking")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                if let hostingSpot = dictionary["parkingID"] as? String {
                    let hostRef = Database.database().reference().child("parking").child(hostingSpot)
                    hostRef.observeSingleEvent(of: .value, with: { (hostSnap) in
                        if let hostDict = hostSnap.value as? [String:AnyObject] {
                            if let previousUser = hostDict["previousUser"] as? String {
                                if previousUser == chatPartnerID {
                                    self.currentMessagesController.bottomContainer.alpha = 0
                                    self.currentMessagesController.hostMessageOptionsController.view.alpha = 1
                                    self.currentMessagesController.isHost = true
                                    self.currentMessagesController.setHostOptions()
                                    return
                                }
                            }
                        }
                    })
                }
            }
        }
        self.currentMessagesController.bottomContainer.alpha = 1
        self.currentMessagesController.hostMessageOptionsController.view.alpha = 0
        self.currentMessagesController.isHost = false
        self.currentMessagesController.setParkingOptions()
    }
    
    func deselectCells() {
        self.previousCell?.backgroundColor = Theme.WHITE
    }
    
    func bringBackAllMessages() {
        UIView.animate(withDuration: 0.1, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationIn, animations: {
                self.messagesAnchor.constant = 0
                self.currentMessagesAnchor.constant = self.view.frame.width
                self.view.layoutIfNeeded()
            }, completion: { (success) in
                self.currentMessagesController.willMove(toParent: nil)
                self.currentMessagesController.view.removeFromSuperview()
                self.currentMessagesController.removeFromParent()
            })
        }
    }

}


extension UserMessagesViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var totalHeight: CGFloat = 0.0
        switch device {
        case .iphone8:
            totalHeight = 160
        case .iphoneX:
            totalHeight = 180
        }
        let translation = scrollView.contentOffset.y
        if translation > 0 && translation < 80 {
            let percent = translation/80
            self.gradientHeightAnchor.constant = totalHeight - percent * 80
            self.mainLabel.transform = CGAffineTransform(scaleX: 1 - 0.2 * percent, y: 1 - 0.2 * percent)
        } else if translation >= 80 {
            self.gradientHeightAnchor.constant = totalHeight - 80
            self.mainLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } else if translation <= 0 {
            self.gradientHeightAnchor.constant = totalHeight
            self.mainLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
}
