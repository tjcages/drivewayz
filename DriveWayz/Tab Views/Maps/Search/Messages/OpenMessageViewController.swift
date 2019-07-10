//
//  OpenMessageViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/5/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class OpenMessageViewController: UIViewController {
    
    var delegate: handleRouteNavigation?
    var messagesRecent: [Message] = []
    var messagesDictionaryRecent = [String: Message]()
    var messagesPrevious: [Message] = []
    var messagesDictionaryPrevious = [String: Message]()
    
    var timer: Timer?
    var previousCell: UserCell?
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true
        
        return view
    }()
    
    var mainLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Recent", for: .normal)
        label.setTitleColor(Theme.WHITE, for: .normal)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.titleLabel?.font = Fonts.SSPBoldH1
        label.alpha = 0
        label.addTarget(self, action: #selector(recentButtonPressed), for: .touchUpInside)
        
        return label
    }()
    
    var secondLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Previous", for: .normal)
        label.setTitleColor(Theme.WHITE, for: .normal)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.titleLabel?.font = Fonts.SSPBoldH1
        label.alpha = 0
        label.addTarget(self, action: #selector(previousButtonPressed), for: .touchUpInside)
        
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(closeMessages), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    var messagesTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(UserMessages.self, forCellReuseIdentifier: "cellId")
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0)
        view.clipsToBounds = true
        view.separatorStyle = .none
        
        return view
    }()
    
    var messagesPreviousTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(UserMessages.self, forCellReuseIdentifier: "cellId")
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0)
        view.clipsToBounds = true
        view.separatorStyle = .none
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        messagesPreviousTableView.delegate = self
        messagesPreviousTableView.dataSource = self
        
        messagesRecent.removeAll()
        messagesDictionaryRecent.removeAll()
        messagesPrevious.removeAll()
        messagesDictionaryPrevious.removeAll()
        messagesTableView.reloadData()

        view.backgroundColor = Theme.DARK_GRAY
        
        setupViews()
        observeUserMessages()
    }
    
    var containerHeightAnchor: NSLayoutConstraint!
    var containerCenterAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        containerHeightAnchor = container.heightAnchor.constraint(equalToConstant: 0)
            containerHeightAnchor.isActive = true
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: container.topAnchor, constant: -16).isActive = true
        mainLabel.sizeToFit()
        
        self.view.addSubview(secondLabel)
        secondLabel.leftAnchor.constraint(equalTo: mainLabel.rightAnchor, constant: 24).isActive = true
        secondLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        secondLabel.bottomAnchor.constraint(equalTo: container.topAnchor, constant: -16).isActive = true
        secondLabel.sizeToFit()
        
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
        
        container.addSubview(messagesTableView)
        messagesTableView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        messagesTableView.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        containerCenterAnchor = messagesTableView.centerXAnchor.constraint(equalTo: container.centerXAnchor)
            containerCenterAnchor.isActive = true
        messagesTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        container.addSubview(messagesPreviousTableView)
        messagesPreviousTableView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        messagesPreviousTableView.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        messagesPreviousTableView.leftAnchor.constraint(equalTo: messagesTableView.rightAnchor).isActive = true
        messagesPreviousTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
    @objc func recentButtonPressed() {
        self.containerCenterAnchor.constant = 0
        UIView.animate(withDuration: animationIn) {
            self.mainLabel.alpha = 1
            self.secondLabel.alpha = 0.5
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func previousButtonPressed() {
        self.containerCenterAnchor.constant = -phoneWidth
        UIView.animate(withDuration: animationIn) {
            self.mainLabel.alpha = 0.5
            self.secondLabel.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func openMessages() {
        switch device {
        case .iphone8:
            self.containerHeightAnchor.constant = phoneHeight - 160
        case .iphoneX:
            self.containerHeightAnchor.constant = phoneHeight - 180
        }
        UIView.animate(withDuration: animationOut, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationIn, animations: {
                self.mainLabel.alpha = 1
                self.backButton.alpha = 1
                self.secondLabel.alpha = 0.5
            })
        }
    }
    
    @objc func closeMessages() {
        self.containerHeightAnchor.constant = 0
        UIView.animate(withDuration: animationOut, animations: {
            self.mainLabel.alpha = 0
            self.backButton.alpha = 0
            self.secondLabel.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.dismiss(animated: true, completion: {
                self.delegate?.defaultContentStatusBar()
            })
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}


extension OpenMessageViewController: UITableViewDelegate, UITableViewDataSource {
    
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
            self.messagesDictionaryRecent.removeValue(forKey: snapshot.key)
            self.messagesDictionaryPrevious.removeValue(forKey: snapshot.key)
            self.reloadOfTable()
        }, withCancel: nil)
    }
    
    private func fetchMessages(messageID: String) {
        let messageRef = Database.database().reference().child("messages").child(messageID)
        messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let message = Message(dictionary: dictionary)
                if let chatPartnerID = message.chatPartnerID() {
                    if let status = message.communicationsStatus {
                        if status == "Recent" {
                            self.messagesDictionaryRecent[chatPartnerID] = message
                        } else {
                           self.messagesDictionaryPrevious[chatPartnerID] = message
                        }
                    } else {
                        self.messagesDictionaryRecent[chatPartnerID] = message
                    }
                }
                self.reloadOfTable()
            }
        }, withCancel: nil)
    }
    
    private func reloadOfTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    @objc func handleReloadTable() {
        self.messagesRecent = Array(self.messagesDictionaryRecent.values)
        self.messagesRecent.sort(by: { (message1, message2) -> Bool in
            return (message1.timestamp)! > (message2.timestamp)!
        })
        DispatchQueue.main.async(execute: {
            self.messagesTableView.reloadData()
        })
        
        self.messagesPrevious = Array(self.messagesDictionaryPrevious.values)
        self.messagesPrevious.sort(by: { (message1, message2) -> Bool in
            return (message1.timestamp)! > (message2.timestamp)!
        })
        DispatchQueue.main.async(execute: {
            self.messagesPreviousTableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        if tableView == self.messagesTableView {
            let message = self.messagesRecent[indexPath.row]
            
            if let chatPartnerID = message.chatPartnerID() {
                Database.database().reference().child("user-messages").child(uid).child(chatPartnerID).removeValue(completionBlock: { (error, ref) in
                    if error != nil {
                        print("Failed to delete message.")
                        return
                    }
                    self.messagesDictionaryRecent.removeValue(forKey: chatPartnerID)
                    self.reloadOfTable()
                })
            }
        } else if tableView == self.messagesPreviousTableView {
            let message = self.messagesPrevious[indexPath.row]
            
            if let chatPartnerID = message.chatPartnerID() {
                Database.database().reference().child("user-messages").child(uid).child(chatPartnerID).removeValue(completionBlock: { (error, ref) in
                    if error != nil {
                        print("Failed to delete message.")
                        return
                    }
                    self.messagesDictionaryPrevious.removeValue(forKey: chatPartnerID)
                    self.reloadOfTable()
                })
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == messagesTableView {
            return self.messagesRecent.count
        } else if tableView == messagesPreviousTableView {
            return self.messagesPrevious.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messagesTableView.dequeueReusableCell(withIdentifier: "cellId") as! UserMessages
        cell.separatorInset = UIEdgeInsets(top: 0, left: 74, bottom: 0, right: 12)
        cell.selectionStyle = .none
        if tableView == self.messagesTableView {
            if self.messagesRecent.count > indexPath.row {
                let message = self.messagesRecent[indexPath.row]
                cell.messageTextView.text = message.text
                cell.dateTextView.text = message.date
                cell.contextView.text = message.context
                
                cell.hostTextView.text = message.name
                if let picture = message.picture {
                    cell.profileImageView.loadImageUsingCacheWithUrlString(picture)
                }
            }
        } else if tableView == self.messagesPreviousTableView {
            if self.messagesPrevious.count > indexPath.row {
                let message = self.messagesPrevious[indexPath.row]
                cell.messageTextView.text = message.text
                cell.dateTextView.text = message.date
                cell.contextView.text = message.context
                
                cell.hostTextView.text = message.name
                if let picture = message.picture {
                    cell.profileImageView.loadImageUsingCacheWithUrlString(picture)
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.messagesTableView {
            let message = self.messagesRecent[indexPath.row]
            let controller = RespondMessageViewController()
            controller.setData(message: message)
            self.navigationController?.pushViewController(controller, animated: true)
            delayWithSeconds(animationOut) {
                controller.openMessageBar()
                
            }
        } else if tableView == self.messagesPreviousTableView {
            let message = self.messagesPrevious[indexPath.row]
            let controller = RespondMessageViewController()
            controller.setData(message: message)
            self.navigationController?.pushViewController(controller, animated: true)
            delayWithSeconds(animationOut) {
                controller.openMessageBar()
            }
        }
    }
    
}
