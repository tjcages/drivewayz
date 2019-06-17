//
//  SearchBarViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/5/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class SearchBarViewController: UIViewController {
    
    var searchButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "searchLocation")
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.GREEN_PIGMENT.withAlphaComponent(0.7)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var fromSearchIcon: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.borderColor = Theme.STRAWBERRY_PINK.withAlphaComponent(0.7).cgColor
        view.layer.borderWidth = 5
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    var dottedLine: UIImageView = {
        let image = UIImage(named: "dottedLine")
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = view.image?.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    var switchSearchButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "switchIcon")
        let tintedImage = image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.4)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.layer.borderColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.addTarget(self, action: #selector(switchButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var fromLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.PRUSSIAN_BLUE
        label.text = "Home"
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var toLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.PRUSSIAN_BLUE
        label.text = "16th Avenue, 4th Cross Street, London"
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.4
        view.layer.cornerRadius = 8
        view.alpha = 0
        view.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)

        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(searchButton)
        searchButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        searchButton.widthAnchor.constraint(equalTo: searchButton.heightAnchor).isActive = true
        searchButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -12).isActive = true
        
        self.view.addSubview(fromSearchIcon)
        fromSearchIcon.centerXAnchor.constraint(equalTo: searchButton.centerXAnchor).isActive = true
        fromSearchIcon.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12).isActive = true
        fromSearchIcon.heightAnchor.constraint(equalToConstant: 16).isActive = true
        fromSearchIcon.widthAnchor.constraint(equalTo: fromSearchIcon.heightAnchor).isActive = true
        
        self.view.addSubview(dottedLine)
        self.view.sendSubviewToBack(dottedLine)
        dottedLine.centerXAnchor.constraint(equalTo: fromSearchIcon.centerXAnchor).isActive = true
        dottedLine.topAnchor.constraint(equalTo: fromSearchIcon.bottomAnchor, constant: 4).isActive = true
        dottedLine.bottomAnchor.constraint(equalTo: searchButton.topAnchor, constant: -4).isActive = true
        dottedLine.widthAnchor.constraint(equalToConstant: 2).isActive = true
        
        self.view.addSubview(switchSearchButton)
        switchSearchButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        switchSearchButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        switchSearchButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        switchSearchButton.widthAnchor.constraint(equalTo: switchSearchButton.heightAnchor).isActive = true
        
        self.view.addSubview(fromLabel)
        fromLabel.centerYAnchor.constraint(equalTo: fromSearchIcon.centerYAnchor).isActive = true
        fromLabel.leftAnchor.constraint(equalTo: fromSearchIcon.rightAnchor, constant: 16).isActive = true
        fromLabel.rightAnchor.constraint(equalTo: switchSearchButton.leftAnchor, constant: -8).isActive = true
        fromLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(toLabel)
        toLabel.centerYAnchor.constraint(equalTo: searchButton.centerYAnchor).isActive = true
        toLabel.leftAnchor.constraint(equalTo: fromLabel.leftAnchor).isActive = true
        toLabel.rightAnchor.constraint(equalTo: fromLabel.rightAnchor).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(line)
        line.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        line.leftAnchor.constraint(equalTo: toLabel.leftAnchor).isActive = true
        line.rightAnchor.constraint(equalTo: switchSearchButton.leftAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }

    func openSearchBar() {
        UIView.animate(withDuration: animationIn) {
            self.view.alpha = 1
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    func closeSearchBar() {
        UIView.animate(withDuration: animationIn) {
            self.view.alpha = 0
            self.view.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        }
    }
    
    @objc func switchButtonPressed() {
//        if let fromText = self.fromSearchBar.text, let toText = self.searchTextField.text {
//            UIView.animate(withDuration: animationOut, animations: {
//                self.switchSearchButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi * CGFloat(self.rotations))
//                self.view.layoutIfNeeded()
//            }) { (success) in
//                self.fromSearchBar.text = toText
//                self.searchTextField.text = fromText
//                if self.rotations == 1 {
//                    self.fromSearchBar.becomeFirstResponder()
//                    self.rotations = 2
//                } else {
//                    self.searchTextField.becomeFirstResponder()
//                    self.rotations = 1
//                }
//            }
//        }
    }
    
}
