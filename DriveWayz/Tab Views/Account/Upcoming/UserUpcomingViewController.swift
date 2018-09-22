//
//  UserUpcomingViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 8/27/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase
import GooglePlaces

class UserUpcomingViewController: UIViewController {
    
    var delegate: handleUpcomingParking?
    
    var notificationController: NotifyUpcomingViewController = {
        let controller = NotifyUpcomingViewController()
        controller.view.alpha = 0
        
        return controller
    }()
    
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
    
    lazy var infoController: UpcomingInfoViewController = {
        let controller = UpcomingInfoViewController()
        self.addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Info"
        return controller
    }()
    
    lazy var upcomingParkingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = Theme.PRIMARY_DARK_COLOR
        imageView.clipsToBounds = true
        
        return imageView
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
        checkUpcomingStatus()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.notificationController.checkForUpcoming()
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
        infoController.view.topAnchor.constraint(equalTo: currentContainer.topAnchor, constant: 10).isActive = true
        infoController.view.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
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
        
        currentContainer.addSubview(upcomingParkingImageView)
        upcomingParkingImageView.leftAnchor.constraint(equalTo: currentContainer.leftAnchor).isActive = true
        upcomingParkingImageView.rightAnchor.constraint(equalTo: currentContainer.rightAnchor).isActive = true
        upcomingParkingImageView.topAnchor.constraint(equalTo: fromToLabel.bottomAnchor, constant: 5).isActive = true
        upcomingParkingImageView.heightAnchor.constraint(equalToConstant: 260).isActive = true
        upcomingParkingImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 60, height: 260)
        upcomingParkingImageView.roundCorners([.bottomLeft, .bottomRight], radius: 10)
        
    }
    
    func checkUpcomingStatus() {
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("users").child(currentUser).child("upcomingParking")
        ref.observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let parkingID = dictionary["parkingID"] as? String
                let startTime = dictionary["startTime"] as? Double
                let endTime = dictionary["endTime"] as? Double
                let startDate = Date(timeIntervalSince1970: startTime!)
                let endDate = Date(timeIntervalSince1970: endTime!)
                let formatter = DateFormatter()
                formatter.dateFormat = "h:mm a EE"
                formatter.amSymbol = "am"
                formatter.pmSymbol = "pm"
                let startString = formatter.string(from: startDate)
                let endString = formatter.string(from: endDate)
                self.fromToLabel.text = "\(startString) to \(endString)"
                let parkingRef = Database.database().reference().child("parking").child(parkingID!)
                parkingRef.observeSingleEvent(of: .value, with: { (parkingSnap) in
                    if let parkingDict = parkingSnap.value as? [String:AnyObject] {
                        let name = parkingDict["parkingCity"] as? String
                        let address = parkingDict["parkingAddress"] as? String
                        let price = parkingDict["parkingCost"] as? String
                        let parkingImageURL = parkingDict["parkingImageURL"] as? String
                        var officialRating: Double = 5.0
                        if let rating = parkingDict["rating"] as? Int {
                            parkingRef.child("Reviews").observeSingleEvent(of: .value, with: { (ratingSnap) in
                                let count = ratingSnap.childrenCount
                                if count != 0 {
                                    officialRating = Double(rating/Int(count))
                                }
                                self.infoController.setData(cityAddress: name!, parkingCost: price!, formattedAddress: address!, rating: officialRating)
                            })
                        }
                        self.infoController.setData(cityAddress: name!, parkingCost: price!, formattedAddress: address!, rating: officialRating)
                        self.delegate?.bringUpcomingViewController()
                        self.bringUpcomingParking()
                        if parkingImageURL == nil {
                            self.upcomingParkingImageView.image = UIImage(named: "profileprofile")
                        } else {
                            self.upcomingParkingImageView.loadImageUsingCacheWithUrlString(parkingImageURL!)
                        }
                        return
                    }
                })
            }
        }
        ref.observe(.childRemoved) { (snapshot) in
            self.delegate?.hideUpcomingViewController()
            self.hideUpcomingParking()
            return
        }
        self.delegate?.hideUpcomingViewController()
        self.hideUpcomingParking()
    }
    
    func bringUpcomingParking() {
        UIView.animate(withDuration: 0.2) {
            self.alertLabel.alpha = 1
            self.current.alpha = 1
            self.fromToLabel.alpha = 1
            self.infoController.view.alpha = 1
            self.line.alpha = 1
            self.upcomingParkingImageView.alpha = 1
        }
    }
    
    func hideUpcomingParking() {
        UIView.animate(withDuration: 0.2) {
            self.alertLabel.alpha = 0
            self.current.alpha = 0
            self.fromToLabel.alpha = 0
            self.infoController.view.alpha = 0
            self.line.alpha = 0
            self.upcomingParkingImageView.alpha = 0
        }
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








