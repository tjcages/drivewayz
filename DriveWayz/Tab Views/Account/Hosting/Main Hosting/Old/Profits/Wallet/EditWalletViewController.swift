//
//  EditWalletViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/25/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class EditWalletViewController: UIViewController {
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        container.heightAnchor.constraint(equalToConstant: 240).isActive = true
        
        
        
    }

}
