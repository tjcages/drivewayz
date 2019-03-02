//
//  MainHostingProfitsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/14/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class HostingProfitsViewController: UIViewController {
    
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
    
    var profitsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH5
        label.text = "AVERAGE PROFITS"

        return label
    }()
    
    var averageProfits: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPExtraLarge
        label.text = "$357.50"
        label.textAlignment = .center
        
        return label
    }()
    
    var monthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK.withAlphaComponent(0.5)
        label.font = Fonts.SSPRegularH5
        label.text = "each month"
        
        return label
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
        
        container.addSubview(profitsLabel)
        profitsLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 12).isActive = true
        profitsLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        profitsLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 12).isActive = true
        profitsLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        container.addSubview(averageProfits)
        averageProfits.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 8).isActive = true
        averageProfits.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -8).isActive = true
        averageProfits.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        averageProfits.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        container.addSubview(monthLabel)
        monthLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 12).isActive = true
        monthLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        monthLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12).isActive = true
        monthLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }

}
