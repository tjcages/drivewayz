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
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE
        view.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        view.clipsToBounds = true
        
        return view
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        
        return view
    }()
    
    lazy var exitButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Delete")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(exitButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var currentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE
        view.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        
        let label = UILabel()
        label.text = "Your current messages"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        label.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        return view
    }()
    
    var previousView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE
        
        let label = UILabel()
        label.text = "Your previous messages"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        label.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        return view
    }()
    
    var currentMessagesTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isScrollEnabled = false
        view.register(UserCell.self, forCellReuseIdentifier: "cellId")
//        view.register(UserMessages.self, forCellReuseIdentifier: "cellId")
        
        return view
    }()
    
    var previousMessagesTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isScrollEnabled = false
        view.register(UserCell.self, forCellReuseIdentifier: "cellId")
//        view.register(UserMessages.self, forCellReuseIdentifier: "cellId")
        
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
        
        currentMessagesTableView.delegate = self
        currentMessagesTableView.dataSource = self
        previousMessagesTableView.delegate = self
        previousMessagesTableView.dataSource = self

        setupViews()
        
        messages.removeAll()
        messagesDictionary.removeAll()
        currentMessagesTableView.reloadData()
        observeUserMessages()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.layoutIfNeeded()
    }
    
    var containerHeightAnchor: NSLayoutConstraint!
    var currentTableHeightAnchor: NSLayoutConstraint!
    var previousTableHeightAnchor: NSLayoutConstraint!
    var messagesAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        containerHeightAnchor = container.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120)
            containerHeightAnchor.isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 50).isActive = true
        container.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        
        container.addSubview(scrollView)
        scrollView.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        messagesAnchor = scrollView.leftAnchor.constraint(equalTo: container.leftAnchor)
            messagesAnchor.isActive = true
        scrollView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        
        self.view.addSubview(exitButton)
        exitButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        switch device {
        case .iphone8:
            exitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24).isActive = true
        case .iphoneX:
            exitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 36).isActive = true
        }
        
        scrollView.addSubview(currentView)
        currentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        currentView.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        currentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        currentView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        scrollView.addSubview(currentMessagesTableView)
        currentMessagesTableView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        currentMessagesTableView.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        currentMessagesTableView.topAnchor.constraint(equalTo: currentView.bottomAnchor).isActive = true
        currentTableHeightAnchor = currentMessagesTableView.heightAnchor.constraint(equalToConstant: 50)
            currentTableHeightAnchor.isActive = true
        
        scrollView.addSubview(previousView)
        previousView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        previousView.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        previousView.topAnchor.constraint(equalTo: currentMessagesTableView.bottomAnchor).isActive = true
        previousView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        scrollView.addSubview(previousMessagesTableView)
        previousMessagesTableView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        previousMessagesTableView.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        previousMessagesTableView.topAnchor.constraint(equalTo: previousView.bottomAnchor).isActive = true
        previousTableHeightAnchor = previousMessagesTableView.heightAnchor.constraint(equalToConstant: 50)
            previousTableHeightAnchor.isActive = true
        
    }
    
    @objc func exitButtonPressed(sender: UIButton) {
        self.delegate?.hideMessagesController()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.delegate?.closeAccountView()
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
        } else if tableView == previousMessagesTableView {
            self.previousTableHeightAnchor.constant = rowHeight * CGFloat(self.PreviousMessages.count)
        }
        self.scrollView.contentSize = CGSize(width: container.frame.width, height: 220 + rowHeight * CGFloat(self.messages.count + self.PreviousMessages.count))
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == currentMessagesTableView {
            return self.messages.count
        } else if tableView == previousMessagesTableView {
            return self.PreviousMessages.count
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
            return cell
        }
        return UITableViewCell()
    }
    
    var currentMessagesAnchor: NSLayoutConstraint!
    var previousCell: UserCell?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        if tableView == currentMessagesTableView {
            container.addSubview(currentMessagesController.view)
            currentMessagesController.didMove(toParent: self)
            currentMessagesController.view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
            currentMessagesAnchor = currentMessagesController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width)
                currentMessagesAnchor.isActive = true
            currentMessagesController.view.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
            currentMessagesController.view.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.2, animations: {
                self.messagesAnchor.constant = -self.view.frame.width/2
                self.currentMessagesAnchor.constant = 0
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
                UIView.animate(withDuration: 0.1) {
                    switch device {
                    case .iphone8:
                        self.containerHeightAnchor.constant = 70
                    case .iphoneX:
                        self.containerHeightAnchor.constant = 80
                    }
                    self.view.layoutIfNeeded()
                }
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
            self.containerHeightAnchor.constant = 120
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: 0.2, animations: {
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
