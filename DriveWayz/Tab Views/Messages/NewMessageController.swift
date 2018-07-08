//
//  NewMessageController.swift
//  CollegeFeed
//
//  Created by Tyler Jordan Cagle on 7/21/17.
//  Copyright © 2017 COAppDesign. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {
    
    let cellId = "cellId"
    
    var users = [Users]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = Theme.OFF_WHITE
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()
        
    }
    
    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if (snapshot.value as? [String: AnyObject]) != nil {
                let user = Users()
                user.id = snapshot.key
                
                user.name = snapshot.childSnapshot(forPath: "name").value as? String
                user.picture = snapshot.childSnapshot(forPath: "picture").value as? String
                user.email = snapshot.childSnapshot(forPath: "email").value as? String
                user.bio = snapshot.childSnapshot(forPath: "bio").value as? String
//                user.setValuesForKeys(dictionary)
                self.users.append(user)
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        }, withCancel: nil)
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        cell.imageView?.image = UIImage(named: "profile")
        
        if let profileImageUrl = user.picture {
            if profileImageUrl == "" {
                cell.imageView?.image = UIImage(named: "profile")
            } else {
                cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    var messagesController: MessageTableViewController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            let user = self.users[indexPath.row]
            self.messagesController?.showChatControllerForUser(user: user)
        }
    }
    
}
