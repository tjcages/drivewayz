//
//  CurrentViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 7/27/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class CurrentViewController: UIViewController {
    
    var currentContainer: UIView = {
        let chart = UIView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.backgroundColor = Theme.WHITE
        chart.layer.shadowColor = UIColor.darkGray.cgColor
        chart.layer.shadowOffset = CGSize(width: 1, height: 1)
        chart.layer.shadowOpacity = 0.8
        chart.layer.cornerRadius = 10
        chart.layer.shadowRadius = 1
        
        return chart
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViews() {
        
        self.view.addSubview(currentContainer)
        currentContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        currentContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        currentContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        currentContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }


}
