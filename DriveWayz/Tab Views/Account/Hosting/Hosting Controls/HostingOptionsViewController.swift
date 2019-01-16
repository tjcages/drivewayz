//
//  HostingOptionsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/14/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class HostingOptionsViewController: UIViewController {

    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.withAlphaComponent(0.6).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 1
        view.layer.cornerRadius = 3
        
        return view
    }()
    
    var seeAvailability: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("See availability", for: .normal)
        button.setTitleColor(Theme.SEA_BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH3
        
        return button
    }()
    
    var lineView1: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE
        
        return view
    }()
    
    var markUnavailable: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Make spot unavailable", for: .normal)
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH3
        
        return button
    }()
    
    var lineView2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE
        
        return view
    }()
    
    var previousGuests: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Previous guests", for: .normal)
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH3
        
        return button
    }()
    
    var lineView3: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE
        
        return view
    }()
    
    var addSpot: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add a new listing", for: .normal)
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH3
        
        return button
    }()
    
    var lineView4: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE
        
        return view
    }()
    
    var deleteSpot: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Delete listing", for: .normal)
        button.setTitleColor(Theme.HARMONY_RED, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH3
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        container.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        container.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        container.addSubview(seeAvailability)
        seeAvailability.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        seeAvailability.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        seeAvailability.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        seeAvailability.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        container.addSubview(lineView1)
        lineView1.topAnchor.constraint(equalTo: seeAvailability.bottomAnchor).isActive = true
        lineView1.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        lineView1.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        lineView1.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        container.addSubview(markUnavailable)
        markUnavailable.topAnchor.constraint(equalTo: lineView1.bottomAnchor).isActive = true
        markUnavailable.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        markUnavailable.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        markUnavailable.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        container.addSubview(lineView2)
        lineView2.topAnchor.constraint(equalTo: markUnavailable.bottomAnchor).isActive = true
        lineView2.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        lineView2.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        lineView2.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        container.addSubview(previousGuests)
        previousGuests.topAnchor.constraint(equalTo: lineView2.bottomAnchor).isActive = true
        previousGuests.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        previousGuests.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        previousGuests.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        container.addSubview(lineView3)
        lineView3.topAnchor.constraint(equalTo: previousGuests.bottomAnchor).isActive = true
        lineView3.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        lineView3.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        lineView3.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        container.addSubview(addSpot)
        addSpot.topAnchor.constraint(equalTo: lineView3.bottomAnchor).isActive = true
        addSpot.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        addSpot.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        addSpot.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        container.addSubview(lineView4)
        lineView4.topAnchor.constraint(equalTo: addSpot.bottomAnchor).isActive = true
        lineView4.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        lineView4.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        lineView4.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        container.addSubview(deleteSpot)
        deleteSpot.topAnchor.constraint(equalTo: lineView4.bottomAnchor).isActive = true
        deleteSpot.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        deleteSpot.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        deleteSpot.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }

}
