//
//  MessageTableViewController.swift
//  
//
//  Created by Tyler Jordan Cagle on 7/20/17.
//
//

import UIKit
import Firebase

class MessageTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellId = "cellId"
    let pageControl = UIPageControl()

    @IBOutlet weak var messagesNavBar: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomTabBarView: UIView!
    
    
    lazy var bottomTabBarController: UIView = {
        
        let containerBar = UIView(frame: CGRect(x: 0, y: self.view.frame.height - 50, width: self.view.frame.width, height: 50))
        containerBar.backgroundColor = UIColor.clear
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.isUserInteractionEnabled = false
        blurView.alpha = 0.9
        containerBar.addSubview(blurView)
        
        blurView.leftAnchor.constraint(equalTo: containerBar.leftAnchor).isActive = true
        blurView.rightAnchor.constraint(equalTo: containerBar.rightAnchor).isActive = true
        blurView.topAnchor.constraint(equalTo: containerBar.topAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: containerBar.bottomAnchor).isActive = true
        
        leftArrow = UIButton(type: .custom)
        let arrowLeftImage = UIImage(named: "Expand")
        let tintedLeftImage = arrowLeftImage?.withRenderingMode(.alwaysTemplate)
        leftArrow.setImage(tintedLeftImage, for: .normal)
        leftArrow.translatesAutoresizingMaskIntoConstraints = false
        leftArrow.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        leftArrow.tintColor = Theme.PRIMARY_COLOR
        leftArrow.addTarget(self, action: #selector(tabBarLeft), for: .touchUpInside)
        containerBar.addSubview(leftArrow)
        
        leftArrow.leftAnchor.constraint(equalTo: blurView.leftAnchor, constant: 32).isActive = true
        leftArrow.centerYAnchor.constraint(equalTo: blurView.centerYAnchor).isActive = true
        leftArrow.heightAnchor.constraint(equalToConstant: 40).isActive = true
        leftArrow.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        rightArrow = UIButton(type: .custom)
        let arrowRightImage = UIImage(named: "Expand")
        let tintedRightImage = arrowRightImage?.withRenderingMode(.alwaysTemplate)
        rightArrow.setImage(tintedRightImage, for: .normal)
        rightArrow.translatesAutoresizingMaskIntoConstraints = false
        rightArrow.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        rightArrow.tintColor = Theme.PRIMARY_COLOR
        rightArrow.addTarget(self, action: #selector(tabBarRight), for: .touchUpInside)
        containerBar.addSubview(rightArrow)
        
        rightArrow.rightAnchor.constraint(equalTo: blurView.rightAnchor, constant: -32).isActive = true
        rightArrow.centerYAnchor.constraint(equalTo: blurView.centerYAnchor).isActive = true
        rightArrow.heightAnchor.constraint(equalToConstant: 40).isActive = true
        rightArrow.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        return containerBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.scrollView.frame = view.frame
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        self.tabBarController?.tabBar.isHidden = true
        self.tableView.backgroundColor = Theme.WHITE
        
        //observeMessages()
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        observeUserMessages()
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        tableView.allowsSelectionDuringEditing = true
        
        setupBottomTab()
        setupPageControl()
        
    }
    
    func setupBottomTab() {
        self.view.addSubview(bottomTabBarController)
        
        bottomTabBarController.leftAnchor.constraint(equalTo: bottomTabBarView.leftAnchor).isActive = true
        bottomTabBarController.rightAnchor.constraint(equalTo: bottomTabBarView.rightAnchor).isActive = true
        bottomTabBarController.bottomAnchor.constraint(equalTo: bottomTabBarView.bottomAnchor).isActive = true
        bottomTabBarController.heightAnchor.constraint(equalTo: bottomTabBarView.heightAnchor).isActive = true
        
    }
    
    func setupPageControl() {
        
        self.pageControl.frame = CGRect()
        self.pageControl.currentPageIndicatorTintColor = Theme.PRIMARY_DARK_COLOR
        self.pageControl.pageIndicatorTintColor = Theme.PRIMARY_COLOR
        self.pageControl.numberOfPages = 3
        self.pageControl.currentPage = 1
        self.pageControl.isUserInteractionEnabled = false
        self.view.addSubview(self.pageControl)
        
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.pageControl.centerYAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -25).isActive = true
        self.pageControl.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -200).isActive = true
        self.pageControl.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
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
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            
            let userID = snapshot.key
            Database.database().reference().child("user-messages").child(uid).child(userID).observe(.childAdded, with: { (snapshot) in
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
            self.tableView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            self.performSegue(withIdentifier: "loginView", sender: self)
        } else {
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.navigationItem.title = dictionary["name"] as? String
                }
                
                
            }, withCancel: nil)
            
        }
    }
    
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let message = messages[indexPath.row]
        cell.message = message
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        guard let chatPartnerID = message.chatPartnerID() else {
            return
        }
        
        let ref = Database.database().reference().child("users").child(chatPartnerID)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard (snapshot.value as? [String:AnyObject]) != nil
                else {
                    return
            }
            
            let user = Users()
            user.id = chatPartnerID
            user.name = snapshot.childSnapshot(forPath: "name").value as? String
            user.picture = snapshot.childSnapshot(forPath: "picture").value as? String
            user.email = snapshot.childSnapshot(forPath: "email").value as? String
            user.bio = snapshot.childSnapshot(forPath: "bio").value as? String
            //                user.setValuesForKeys(dictionary)
            self.showChatControllerForUser(user: user)
            
        }, withCancel: nil)
    }
    
    @IBAction func newMessageIconPressed(_ sender: Any) {
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
    
    
    func showChatControllerForUser(user: Users) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    @objc func tabBarRight() {
        UIView.animate(withDuration: 0.5, animations: {
            self.tabBarController?.selectedIndex = 2
        }, completion: nil)
    }
    @objc func tabBarLeft() {
        UIView.animate(withDuration: 0.5, animations: {
            self.tabBarController?.selectedIndex = 0
        }, completion: nil)
    }
    
}
