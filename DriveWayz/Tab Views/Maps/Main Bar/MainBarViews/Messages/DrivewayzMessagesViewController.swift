//
//  DrivewayzMessagesViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/11/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class DrivewayzMessagesViewController: UIViewController {

    var messageID: String?
    var messages = [Message]()
    
    let commentsController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
    
    let notificationButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "settingsNotifications")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.WHITE
        
        setupViews()
    }

    func setupViews() {

        
//        self.view.addSubview(notificationButton)
//        notificationButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
//        notificationButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true
//        notificationButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        notificationButton.widthAnchor.constraint(equalToConstant: 30).isActive = true

    }
    
    @objc func backButtonDismissed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
