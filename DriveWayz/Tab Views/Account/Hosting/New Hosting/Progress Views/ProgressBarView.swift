//
//  ProgressBarView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/22/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ProgressBarView: UIViewController {
    
    var expandedHeight: CGFloat = 156
    
    var firstLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Basic details"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var secondLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Location and pictures"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var thirdLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Set availability"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var fourthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Set price"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var fifthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Verify listing"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    lazy var detailsController: ProgressExpandedView = {
        let controller = ProgressExpandedView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        
        return controller
    }()
    
    var firstCircle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.GRAY_WHITE_4
        view.layer.cornerRadius = 5
        
        return view
    }()
    
    var secondCircle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.GRAY_WHITE_4
        view.layer.cornerRadius = 5
        
        return view
    }()
    
    var thirdCircle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.GRAY_WHITE_4
        view.layer.cornerRadius = 5
        
        return view
    }()
    
    var fourthCircle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.GRAY_WHITE_4
        view.layer.cornerRadius = 5
        
        return view
    }()
    
    var fifthCircle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.GRAY_WHITE_4
        view.layer.cornerRadius = 5
        
        return view
    }()
    
    var dimLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.GRAY_WHITE_4
        
        return view
    }()
    
    var selectedLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        
        return view
    }()
    
    var selectedCircle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 7
        view.layer.borderColor = Theme.BLACK.cgColor
        view.layer.borderWidth = 4
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupLine()
        
        firstStep()
    }
    
    var secondTopAnchor: NSLayoutConstraint!
    var thirdTopAnchor: NSLayoutConstraint!
    var fourthTopAnchor: NSLayoutConstraint!
    var fifthTopAnchor: NSLayoutConstraint!
    
    var firstExpanded: NSLayoutConstraint!
    var secondExpanded: NSLayoutConstraint!
    var thirdExpanded: NSLayoutConstraint!
    var fourthExpanded: NSLayoutConstraint!
    var fifthExpanded: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(dimLine)
        view.addSubview(selectedLine)
        
        view.addSubview(firstCircle)
        view.addSubview(secondCircle)
        view.addSubview(thirdCircle)
        view.addSubview(fourthCircle)
        view.addSubview(fifthCircle)
        view.addSubview(selectedCircle)
        
        view.addSubview(firstLabel)
        view.addSubview(secondLabel)
        view.addSubview(thirdLabel)
        view.addSubview(fourthLabel)
        view.addSubview(fifthLabel)
        
        firstLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        firstLabel.leftAnchor.constraint(equalTo: firstCircle.rightAnchor, constant: 20).isActive = true
        firstLabel.sizeToFit()
        
        secondTopAnchor = secondLabel.topAnchor.constraint(equalTo: firstLabel.bottomAnchor, constant: 32)
            secondTopAnchor.isActive = true
        secondLabel.leftAnchor.constraint(equalTo: firstCircle.rightAnchor, constant: 20).isActive = true
        secondLabel.sizeToFit()
        
        thirdTopAnchor = thirdLabel.topAnchor.constraint(equalTo: secondLabel.bottomAnchor, constant: 32)
            thirdTopAnchor.isActive = true
        thirdLabel.leftAnchor.constraint(equalTo: firstCircle.rightAnchor, constant: 20).isActive = true
        thirdLabel.sizeToFit()
        
        fourthTopAnchor = fourthLabel.topAnchor.constraint(equalTo: thirdLabel.bottomAnchor, constant: 32)
            fourthTopAnchor.isActive = true
        fourthLabel.leftAnchor.constraint(equalTo: firstCircle.rightAnchor, constant: 20).isActive = true
        fourthLabel.sizeToFit()
        
        fifthTopAnchor = fifthLabel.topAnchor.constraint(equalTo: fourthLabel.bottomAnchor, constant: 32)
            fifthTopAnchor.isActive = true
        fifthLabel.leftAnchor.constraint(equalTo: firstCircle.rightAnchor, constant: 20).isActive = true
        fifthLabel.sizeToFit()
        
        view.addSubview(detailsController.view)
        detailsController.view.anchor(top: nil, left: firstLabel.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 0, height: expandedHeight)
        firstExpanded = detailsController.view.topAnchor.constraint(equalTo: firstLabel.bottomAnchor)
            firstExpanded.isActive = true
        secondExpanded = detailsController.view.topAnchor.constraint(equalTo: secondLabel.bottomAnchor)
            secondExpanded.isActive = false
        thirdExpanded = detailsController.view.topAnchor.constraint(equalTo: thirdLabel.bottomAnchor)
            thirdExpanded.isActive = false
        fourthExpanded = detailsController.view.topAnchor.constraint(equalTo: fourthLabel.bottomAnchor)
            fourthExpanded.isActive = false
        fifthExpanded = detailsController.view.topAnchor.constraint(equalTo: fifthLabel.bottomAnchor)
            fifthExpanded.isActive = false
        
    }
    
    func setupLine() {
        
        firstCircle.centerYAnchor.constraint(equalTo: firstLabel.centerYAnchor).isActive = true
        firstCircle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        firstCircle.heightAnchor.constraint(equalTo: firstCircle.widthAnchor).isActive = true
        firstCircle.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        secondCircle.centerYAnchor.constraint(equalTo: secondLabel.centerYAnchor).isActive = true
        secondCircle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        secondCircle.heightAnchor.constraint(equalTo: secondCircle.widthAnchor).isActive = true
        secondCircle.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        thirdCircle.centerYAnchor.constraint(equalTo: thirdLabel.centerYAnchor).isActive = true
        thirdCircle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        thirdCircle.heightAnchor.constraint(equalTo: thirdCircle.widthAnchor).isActive = true
        thirdCircle.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        fourthCircle.centerYAnchor.constraint(equalTo: fourthLabel.centerYAnchor).isActive = true
        fourthCircle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        fourthCircle.heightAnchor.constraint(equalTo: fourthCircle.widthAnchor).isActive = true
        fourthCircle.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        fifthCircle.centerYAnchor.constraint(equalTo: fifthLabel.centerYAnchor).isActive = true
        fifthCircle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        fifthCircle.heightAnchor.constraint(equalTo: fifthCircle.widthAnchor).isActive = true
        fifthCircle.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        dimLine.anchor(top: firstCircle.centerYAnchor, left: nil, bottom: fifthCircle.centerYAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 3, height: 0)
        dimLine.centerXAnchor.constraint(equalTo: firstCircle.centerXAnchor).isActive = true
        
        selectedLine.anchor(top: dimLine.topAnchor, left: dimLine.leftAnchor, bottom: selectedCircle.centerYAnchor, right: dimLine.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        selectedCircle.centerXAnchor.constraint(equalTo: dimLine.centerXAnchor).isActive = true
        selectedCircle.bottomAnchor.constraint(equalTo: detailsController.view.topAnchor, constant: -4).isActive = true
        selectedCircle.heightAnchor.constraint(equalTo: selectedCircle.widthAnchor).isActive = true
        selectedCircle.widthAnchor.constraint(equalToConstant: 14).isActive = true
        
    }
    
    func firstStep() {
        minimizeAll()
        secondTopAnchor.constant = 32 + expandedHeight
        firstExpanded.isActive = true
        firstLabel.font = Fonts.SSPSemiBoldH3
        firstLabel.textColor = Theme.BLACK
        
        firstCircle.backgroundColor = Theme.BLACK
        
        detailsController.selectedIndex = 0
        animate()
    }
    
    func secondStep() {
        minimizeAll()
        thirdTopAnchor.constant = 32 + expandedHeight
        secondExpanded.isActive = true
        secondLabel.font = Fonts.SSPSemiBoldH3
        secondLabel.textColor = Theme.BLACK
        
        firstCircle.backgroundColor = Theme.BLACK
        secondCircle.backgroundColor = Theme.BLACK
        
        detailsController.selectedIndex = 1
        animate()
    }
    
    func thirdStep() {
        minimizeAll()
        fourthTopAnchor.constant = 32 + expandedHeight
        thirdExpanded.isActive = true
        thirdLabel.font = Fonts.SSPSemiBoldH3
        thirdLabel.textColor = Theme.BLACK
        
        firstCircle.backgroundColor = Theme.BLACK
        secondCircle.backgroundColor = Theme.BLACK
        thirdCircle.backgroundColor = Theme.BLACK
        
        detailsController.selectedIndex = 2
        animate()
    }
    
    func fourthStep() {
        minimizeAll()
        fifthTopAnchor.constant = 32 + expandedHeight
        fourthExpanded.isActive = true
        fourthLabel.font = Fonts.SSPSemiBoldH3
        fourthLabel.textColor = Theme.BLACK
        
        firstCircle.backgroundColor = Theme.BLACK
        secondCircle.backgroundColor = Theme.BLACK
        thirdCircle.backgroundColor = Theme.BLACK
        fourthCircle.backgroundColor = Theme.BLACK
        
        detailsController.selectedIndex = 3
        animate()
    }
    
    func fifthStep() {
        minimizeAll()
        fifthExpanded.isActive = true
        fifthLabel.font = Fonts.SSPSemiBoldH3
        fifthLabel.textColor = Theme.BLACK
        
        firstCircle.backgroundColor = Theme.BLACK
        secondCircle.backgroundColor = Theme.BLACK
        thirdCircle.backgroundColor = Theme.BLACK
        fourthCircle.backgroundColor = Theme.BLACK
        fifthCircle.backgroundColor = Theme.BLACK
        
        detailsController.selectedIndex = 4
        animate()
    }
    
    func animate() {
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
        }
    }
    
    func minimizeAll() {
        secondTopAnchor.constant = 32
        thirdTopAnchor.constant = 32
        fourthTopAnchor.constant = 32
        fifthTopAnchor.constant = 32
        
        firstExpanded.isActive = false
        secondExpanded.isActive = false
        thirdExpanded.isActive = false
        fourthExpanded.isActive = false
        fifthExpanded.isActive = false
        
        firstLabel.font = Fonts.SSPRegularH4
        secondLabel.font = Fonts.SSPRegularH4
        thirdLabel.font = Fonts.SSPRegularH4
        fourthLabel.font = Fonts.SSPRegularH4
        fifthLabel.font = Fonts.SSPRegularH4
        
        firstLabel.textColor = Theme.GRAY_WHITE
        secondLabel.textColor = Theme.GRAY_WHITE
        thirdLabel.textColor = Theme.GRAY_WHITE
        fourthLabel.textColor = Theme.GRAY_WHITE
        fifthLabel.textColor = Theme.GRAY_WHITE
        
        firstCircle.backgroundColor = Theme.GRAY_WHITE_4
        secondCircle.backgroundColor = Theme.GRAY_WHITE_4
        thirdCircle.backgroundColor = Theme.GRAY_WHITE_4
        fourthCircle.backgroundColor = Theme.GRAY_WHITE_4
        fifthCircle.backgroundColor = Theme.GRAY_WHITE_4
    }

}
