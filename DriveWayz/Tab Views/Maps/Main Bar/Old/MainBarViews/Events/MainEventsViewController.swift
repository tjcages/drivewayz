//
//  MainEventsViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 8/11/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class MainEventsViewController: UIViewController {
    
    var eventsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Upcoming Events"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPBoldH3
        
        return label
    }()
    
    lazy var eventsController: EventsViewController = {
        let controller = EventsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
//        controller.mainDelegate = self
        self.addChild(controller)
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE

        setupViews()
    }
    
    func setupViews() {

        self.view.addSubview(eventsLabel)
        eventsLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 16).isActive = true
        eventsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        eventsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        eventsLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(eventsController.view)
        eventsController.view.topAnchor.constraint(equalTo: eventsLabel.bottomAnchor, constant: 16).isActive = true
        eventsController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        eventsController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        eventsController.view.heightAnchor.constraint(equalToConstant: eventsController.cellHeight + 16).isActive = true
        
    }

}
