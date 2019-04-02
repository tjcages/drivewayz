//
//  SearchSummaryViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 4/1/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class SearchSummaryViewController: UIViewController {
    
    var searchBarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        
        return view
    }()
    
    var fromLabel: UILabel = {
        let label = UILabel()
        label.text = "Current location"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var toLabel: UILabel = {
        let label = UILabel()
        label.text = "Folsom Field"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .right
        
        return label
    }()
    
    var fromSearchLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        
        let dot1 = UIView(frame: CGRect(x: 8.2, y: 0, width: 4, height: 4))
        dot1.backgroundColor = Theme.WHITE.withAlphaComponent(0.8)
        dot1.layer.cornerRadius = 2
        view.addSubview(dot1)
        
        let dot2 = UIView(frame: CGRect(x: 20.4, y: 0, width: 4, height: 4))
        dot2.backgroundColor = Theme.WHITE.withAlphaComponent(0.8)
        dot2.layer.cornerRadius = 2
        view.addSubview(dot2)
        
        let dot3 = UIView(frame: CGRect(x: 32.6, y: 0, width: 4, height: 4))
        dot3.backgroundColor = Theme.WHITE.withAlphaComponent(0.8)
        dot3.layer.cornerRadius = 2
        view.addSubview(dot3)
        
        let dot4 = UIView(frame: CGRect(x: 44.8, y: 0, width: 4, height: 4))
        dot4.backgroundColor = Theme.WHITE.withAlphaComponent(0.8)
        dot4.layer.cornerRadius = 2
        view.addSubview(dot4)
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.4

        setupViews()
    }

    func setupViews() {
        
        self.view.addSubview(searchBarView)
        searchBarView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        searchBarView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        searchBarView.widthAnchor.constraint(equalToConstant: 327).isActive = true
        searchBarView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(fromLabel)
        fromLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        fromLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        fromLabel.rightAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -12).isActive = true
        fromLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        self.view.addSubview(toLabel)
        toLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        toLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        toLabel.rightAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 12).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        self.view.addSubview(fromSearchLine)
        fromSearchLine.bottomAnchor.constraint(equalTo: toLabel.bottomAnchor, constant: -8).isActive = true
        fromSearchLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        fromSearchLine.widthAnchor.constraint(equalToConstant: 31).isActive = true
        fromSearchLine.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
    }
    
}
