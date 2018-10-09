//
//  AnalyticsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 8/28/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class AnalyticsViewController: UIViewController {
    
//    var delegate: controlsAccountViews?
    var delegate: controlsAccountOptions?
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    var driveWayzLogo: UIImageView = {
        let image = UIImage(named: "DrivewayzCar")
        let flip = UIImage(cgImage: (image?.cgImage)!, scale: 1.0, orientation: UIImage.Orientation.upMirrored)
        let view = UIImageView(image: flip)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = view.image!.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.DARK_GRAY
        view.alpha = 0
        
        return view
    }()
    
    lazy var exitButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Delete")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(exitButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsHorizontalScrollIndicator = false
        
        return scroll
    }()
    
    lazy var retentionController: RetentionViewController = {
        let controller = RetentionViewController()
        self.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Retention"
        
        return controller
    }()
    
    lazy var newUsersController: NewUsersViewController = {
        let controller = NewUsersViewController()
        self.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "New Users"
        
        return controller
    }()
    
    var newUsersLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "New Users"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        
        return label
    }()
    
    lazy var profitsController: ProfitsViewController = {
        let controller = ProfitsViewController()
        self.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Profits"
        
        return controller
    }()
    
    var totalUsersLabel: UILabel = {
        let label = UILabel()
        label.text = "Total users"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        return label
    }()
    
    var totalHostsLabel: UILabel = {
        let label = UILabel()
        label.text = "Total hosts"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clear
        
        setupViews()
        setData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 40).isActive = true
        container.heightAnchor.constraint(equalToConstant: self.view.frame.height - 160).isActive = true
        container.widthAnchor.constraint(equalToConstant: self.view.frame.width - 20).isActive = true
        
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
        
        self.view.addSubview(driveWayzLogo)
        driveWayzLogo.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        driveWayzLogo.topAnchor.constraint(equalTo: exitButton.topAnchor, constant: 10).isActive = true
        driveWayzLogo.widthAnchor.constraint(equalToConstant: 100).isActive = true
        driveWayzLogo.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 2)
        scrollView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(retentionController.view)
        self.view.sendSubviewToBack(retentionController.view)
        retentionController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        retentionController.view.widthAnchor.constraint(equalToConstant: self.view.frame.width * 5/6).isActive = true
        retentionController.view.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: -20).isActive = true
        retentionController.view.heightAnchor.constraint(equalTo: retentionController.view.widthAnchor).isActive = true
        
        scrollView.addSubview(newUsersController.view)
        newUsersController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        newUsersController.view.widthAnchor.constraint(equalToConstant: self.view.frame.width * 5/6).isActive = true
        newUsersController.view.topAnchor.constraint(equalTo: retentionController.view.bottomAnchor, constant: 40).isActive = true
        newUsersController.view.heightAnchor.constraint(equalTo: newUsersController.view.widthAnchor, multiplier: 0.8).isActive = true
        
        scrollView.addSubview(newUsersLabel)
        newUsersLabel.bottomAnchor.constraint(equalTo: newUsersController.view.topAnchor, constant: -5).isActive = true
        newUsersLabel.leftAnchor.constraint(equalTo: newUsersController.view.leftAnchor, constant: 10).isActive = true
        newUsersLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        newUsersLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(profitsController.view)
        profitsController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        profitsController.view.widthAnchor.constraint(equalToConstant: self.view.frame.width * 5/6).isActive = true
        profitsController.view.topAnchor.constraint(equalTo: newUsersController.view.bottomAnchor, constant: 40).isActive = true
        profitsController.view.heightAnchor.constraint(equalToConstant: (profitsController.view.frame.width) * 0.6 + 40).isActive = true
        
        scrollView.addSubview(totalUsersLabel)
        totalUsersLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        totalUsersLabel.topAnchor.constraint(equalTo: profitsController.view.bottomAnchor, constant: 50).isActive = true
        totalUsersLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width - 60).isActive = true
        totalUsersLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(totalHostsLabel)
        totalHostsLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        totalHostsLabel.topAnchor.constraint(equalTo: totalUsersLabel.bottomAnchor, constant: 0).isActive = true
        totalHostsLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width - 60).isActive = true
        totalHostsLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    @objc func exitButtonPressed(sender: UIButton) {
        self.delegate?.hideAnalyticsController()
    }
    
    func setData() {
        let ref = Database.database().reference()
        ref.child("users").observeSingleEvent(of: .value) { (snapshot) in
            let count = snapshot.childrenCount
            self.totalUsersLabel.text = "Total users: \(count)"
        }
        ref.child("parking").observeSingleEvent(of: .value) { (snapshot) in
            let count = snapshot.childrenCount
            self.totalHostsLabel.text = "Total hosts: \(count)"
        }
    }


}








