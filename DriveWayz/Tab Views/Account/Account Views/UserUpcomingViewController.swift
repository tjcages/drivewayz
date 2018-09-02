//
//  UserUpcomingViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 8/27/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase

class UserUpcomingViewController: UIViewController {
    
    var current: UIView = {
        let current = UIView()
        current.layer.cornerRadius = 15
        current.layer.shadowColor = Theme.DARK_GRAY.cgColor
        current.layer.shadowOffset = CGSize(width: 0, height: 1)
        current.layer.shadowRadius = 1
        current.layer.shadowOpacity = 0.8
        current.translatesAutoresizingMaskIntoConstraints = false
        
        return current
    }()

    var alertLabel: UILabel = {
        let label = UILabel()
        label.text = "Upcoming"
        label.textColor = Theme.WHITE
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var currentContainer: UIView = {
        let chart = UIView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.backgroundColor = Theme.WHITE
        chart.layer.shadowColor = UIColor.darkGray.cgColor
        chart.layer.shadowOffset = CGSize(width: 0, height: 1)
        chart.layer.shadowOpacity = 0.8
        chart.layer.cornerRadius = 10
        chart.layer.shadowRadius = 1
        
        return chart
    }()
    
    lazy var infoController: ParkingInfoViewController = {
        let controller = ParkingInfoViewController()
        self.addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Info"
        return controller
    }()
    
    lazy var imageController: ParkingImageViewController = {
        let controller = ParkingImageViewController()
        self.addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Image"
        controller.currentParkingImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: 260)
        controller.currentParkingImageView.roundCorners([.bottomLeft, .bottomRight], radius: 10)
        
        return controller
    }()
    
    var fromToLabel: UILabel = {
        let label = UILabel()
        label.text = "From to To"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = Theme.PRIMARY_COLOR
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var line: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.3)
        
        return line
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(current)
        current.backgroundColor = Theme.PRIMARY_COLOR
        current.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        current.heightAnchor.constraint(equalToConstant: 30).isActive = true
        current.widthAnchor.constraint(equalToConstant: 100).isActive = true
        current.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        
        current.addSubview(alertLabel)
        alertLabel.centerXAnchor.constraint(equalTo: current.centerXAnchor).isActive = true
        alertLabel.centerYAnchor.constraint(equalTo: current.centerYAnchor).isActive = true
        alertLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        alertLabel.widthAnchor.constraint(equalTo: current.widthAnchor, constant: -10).isActive = true
        
        self.view.addSubview(currentContainer)
        currentContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        currentContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        currentContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        currentContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        currentContainer.addSubview(infoController.view)
        infoController.view.leftAnchor.constraint(equalTo: currentContainer.leftAnchor).isActive = true
        infoController.view.rightAnchor.constraint(equalTo: currentContainer.rightAnchor).isActive = true
        infoController.view.topAnchor.constraint(equalTo: currentContainer.topAnchor).isActive = true
        infoController.view.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        currentContainer.addSubview(line)
        line.leftAnchor.constraint(equalTo: currentContainer.leftAnchor, constant: 20).isActive = true
        line.rightAnchor.constraint(equalTo: currentContainer.rightAnchor, constant: -20).isActive = true
        line.topAnchor.constraint(equalTo: infoController.view.bottomAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        currentContainer.addSubview(fromToLabel)
        fromToLabel.leftAnchor.constraint(equalTo: currentContainer.leftAnchor, constant: 20).isActive = true
        fromToLabel.rightAnchor.constraint(equalTo: currentContainer.rightAnchor, constant: -20).isActive = true
        fromToLabel.topAnchor.constraint(equalTo: infoController.view.bottomAnchor, constant: 10).isActive = true
        fromToLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        currentContainer.addSubview(imageController.view)
        imageController.view.leftAnchor.constraint(equalTo: currentContainer.leftAnchor).isActive = true
        imageController.view.rightAnchor.constraint(equalTo: currentContainer.rightAnchor).isActive = true
        imageController.view.topAnchor.constraint(equalTo: fromToLabel.bottomAnchor, constant: 5).isActive = true
        imageController.view.heightAnchor.constraint(equalToConstant: 260).isActive = true
        
    }

}



extension UIImageView {
    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
}








