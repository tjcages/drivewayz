//
//  OpenMessageViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/5/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol checkReloadTable {
    func reloadTable()
}

class OpenMessageViewController: UIViewController {
    
//    var delegate: handleRouteNavigation?
    var messagesRecent: [Message] = []
    var messagesDictionary = [String: Message]()
    
    var timer: Timer?
    var previousCell: UserCell?
    var statusBarColor = false
    
    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.BLACK
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Inbox"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH1
        
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "exit")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
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
        view.backgroundColor = .clear
        
        return view
    }()
    
    var loadingLine: LoadingLine = {
        let view = LoadingLine()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        
        messagesRecent.removeAll()
        messagesDictionary.removeAll()
        messagesTableView.reloadData()

        view.backgroundColor = Theme.WHITE
        
        setupViews()
        observeUserMessages()
        loadingLine.startAnimating()
    }
    
    var gradientHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        self.view.addSubview(gradientContainer)
        gradientContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        switch device {
        case .iphone8:
            gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: 140)
            gradientHeightAnchor.isActive = true
        case .iphoneX:
            gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: 160)
            gradientHeightAnchor.isActive = true
        }
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 975)
        scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: -16).isActive = true
        
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
        
        self.view.addSubview(messagesTableView)
        messagesTableView.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        messagesTableView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        messagesTableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        messagesTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        gradientContainer.addSubview(loadingLine)
        loadingLine.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        loadingLine.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        loadingLine.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        loadingLine.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
    }
    
    func openMessages() {
        UIView.animate(withDuration: animationOut, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationIn, animations: {
                self.mainLabel.alpha = 1
                self.backButton.alpha = 1
            })
        }
    }
    
    @objc func closeMessages() {
        UIView.animate(withDuration: animationOut, animations: {
            self.mainLabel.alpha = 0
            self.backButton.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.dismiss(animated: true, completion: {
                defaultContentStatusBar()
            })
        }
    }
    
    @objc func backButtonPressed() {
        self.loadingLine.endAnimating()
        self.dismiss(animated: true) {
            //
        }
    }

}


extension OpenMessageViewController: UITableViewDelegate, UITableViewDataSource, checkReloadTable {
    
    func observeUserMessages() {
        let ref = Database.database().reference().child("DrivewayzMessages")
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
        let messageRef = Database.database().reference().child("Messages").child(messageID)
        messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let message = Message(dictionary: dictionary)
                if let fromID = message.fromID {
                    self.messagesDictionary[fromID] = message
                    self.reloadOfTable()
                    self.loadingLine.endAnimating()
                }
            }
        }, withCancel: nil)
    }
    
    private func reloadOfTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    @objc func handleReloadTable() {
        self.messagesRecent = Array(self.messagesDictionary.values)
        self.messagesRecent.sort(by: { (message1, message2) -> Bool in
            return (message1.timestamp)! > (message2.timestamp)!
        })
        DispatchQueue.main.async(execute: {
            self.messagesTableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        if tableView == self.messagesTableView {
            let message = self.messagesRecent[indexPath.row]
            
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
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == messagesTableView {
            return self.messagesRecent.count
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
                cell.backgroundColor = UIColor.clear
                
                cell.recentRing.alpha = 0
                if let communicationStatus = message.communicationsStatus {
                    if communicationStatus == "Recent" {
                        cell.recentRing.alpha = 1
                    }
                }
                
                cell.hostTextView.text = message.name
                if let picture = message.picture {
                    cell.profileImageView.loadImageUsingCacheWithUrlString(picture) { (bool) in
                        if !bool {
                            cell.profileImageView.image = UIImage(named: "background4")
                        }
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.messagesTableView {
            let message = self.messagesRecent[indexPath.row]
            let controller = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
            guard let id = message.fromID else { return }
            controller.setData(userID: id)
            controller.sendingFromDrivewayz = true
            controller.gradientController.setBackButton()
            if let name = message.name {
                controller.gradientController.mainLabel.text = name
            }
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}


extension OpenMessageViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        let state = scrollView.panGestureRecognizer.state
        var totalHeight: CGFloat = 0.0
        switch device {
        case .iphone8:
            totalHeight = 140
        case .iphoneX:
            totalHeight = 160
        }
        if state == .changed {
            if translation > 0 && translation < 60 {
                let percent = translation/60
                self.gradientHeightAnchor.constant = totalHeight - percent * 60
                self.mainLabel.transform = CGAffineTransform(scaleX: 1 - 0.2 * percent, y: 1 - 0.2 * percent)
            }
        } else {
            let translation = scrollView.contentOffset.y
            if translation < 0 && self.gradientHeightAnchor.constant != totalHeight {
                self.scrollExpanded()
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.contentOffset.y
        if translation >= 55 {
            self.scrollMinimized()
        } else {
            self.scrollExpanded()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        if translation >= 55 {
            self.scrollMinimized()
        } else {
            self.scrollExpanded()
        }
    }
    
    func scrollExpanded() {
        switch device {
        case .iphone8:
            self.gradientHeightAnchor.constant = 140
        case .iphoneX:
            self.gradientHeightAnchor.constant = 160
        }
        UIView.animate(withDuration: animationOut, animations: {
            self.mainLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func scrollMinimized() {
        switch device {
        case .iphone8:
            self.gradientHeightAnchor.constant = 80
        case .iphoneX:
            self.gradientHeightAnchor.constant = 100
        }
        UIView.animate(withDuration: animationOut, animations: {
            self.mainLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func reloadTable() {
        self.observeUserMessages()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
