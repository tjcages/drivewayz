//
//  MessageTableViewController.swift
//  
//
//  Created by Tyler Jordan Cagle on 7/20/17.
//
//

import UIKit
import Firebase

class MessageTableViewController: UITableViewController {

    let cellId = "cellId"
    
    @IBOutlet weak var messagesNavBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.tabBarController?.tabBar.isHidden = false
        
        //observeMessages()
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        observeUserMessages()
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        tableView.allowsSelectionDuringEditing = true
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
                print(snapshot)
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.navigationItem.title = dictionary["name"] as? String
                }
                
                
            }, withCancel: nil)
            
        }
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let message = messages[indexPath.row]
        cell.message = message
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        guard let chatPartnerID = message.chatPartnerID() else {
            return
        }
        
        let ref = Database.database().reference().child("users").child(chatPartnerID)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            guard let dictionary = snapshot.value as? [String:AnyObject]
                else {
                    return
            }
            
            let user = Users()
            user.id = chatPartnerID
            user.setValuesForKeys(dictionary)
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
    
}
