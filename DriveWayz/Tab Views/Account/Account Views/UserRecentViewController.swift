//
//  UserCurrentViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 7/27/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps

var check: Bool = false

class UserRecentViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var Reviews: [String] = ["Hello", "World"]
    let identifier = "identifier"
    var parkingSpots = [ParkingSpots]()
    var parkingSpotsDictionary = [Int:ParkingSpots]()
    
    var currentContainer: UIView = {
        let chart = UIView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.backgroundColor = UIColor.clear
        chart.layer.shadowColor = UIColor.darkGray.cgColor
        chart.layer.shadowOffset = CGSize(width: 1, height: 1)
        chart.layer.shadowOpacity = 0.8
        chart.layer.cornerRadius = 10
        chart.layer.shadowRadius = 1
        
        return chart
    }()
    
    var recentLabel: UITextView = {
        let label = UITextView()
        label.text = "Recent parking"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .left
        label.backgroundColor = UIColor.clear
        label.textContainer.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.isUserInteractionEnabled = false
        
        return label
    }()
    
    
    var layout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        
        return layout
    }()
    
    lazy var parkingPicker: UICollectionView = {
        let reviews = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        reviews.backgroundColor = UIColor.clear
        reviews.tintColor = Theme.WHITE
        reviews.translatesAutoresizingMaskIntoConstraints = false
        reviews.register(RecentParkingCell.self, forCellWithReuseIdentifier: identifier)
        
        return reviews
    }()
    
    var noRecentLabel: UITextView = {
        let label = UITextView()
        label.text = "You have no recent parking"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
        label.textContainer.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.isUserInteractionEnabled = false
        label.alpha = 0
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parkingPicker.delegate = self
        parkingPicker.dataSource = self
        check = false
        
        setupViews()
        observeUserParkingSpots()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViews() {
        
        self.view.addSubview(currentContainer)
        currentContainer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        currentContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        currentContainer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        currentContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        self.view.addSubview(recentLabel)
        recentLabel.topAnchor.constraint(equalTo: currentContainer.topAnchor, constant: 5).isActive = true
        recentLabel.leftAnchor.constraint(equalTo: currentContainer.leftAnchor, constant: 15).isActive = true
        recentLabel.widthAnchor.constraint(equalTo: currentContainer.widthAnchor, constant: -10).isActive = true
        recentLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(parkingPicker)
        parkingPicker.topAnchor.constraint(equalTo: currentContainer.topAnchor, constant: 30).isActive = true
        parkingPicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        parkingPicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        parkingPicker.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        self.view.addSubview(noRecentLabel)
        noRecentLabel.centerXAnchor.constraint(equalTo: parkingPicker.centerXAnchor).isActive = true
        noRecentLabel.centerYAnchor.constraint(equalTo: parkingPicker.centerYAnchor, constant: -20).isActive = true
        noRecentLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        noRecentLabel.widthAnchor.constraint(equalTo: parkingPicker.widthAnchor).isActive = true
        
        observeUserParkingSpots()
    }
    
    var count: Int = 1
    
    func observeUserParkingSpots() {
        var parkingID: [String] = []
        var costSpots: [Double] = []
        var hourSpots: [Int] = []
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("users").child(currentUser).child("recentParking")
        ref.observe(.childAdded, with: { (snapshot) in
            if let keys = snapshot.value as? [String:AnyObject] {
                if let reviews = keys["Reviews"] as? [String:AnyObject] {
                    self.count = reviews.count
                }
                let parking = keys["parkingID"] as? String
                let cost = keys["cost"] as? Double
                let hours = keys["hours"] as? Int
                costSpots.append(cost!)
                hourSpots.append(hours!)
                parkingID.append(parking!)
            }
            self.fetchParking(parkingID: parkingID, payment: costSpots, hours: hourSpots)
        }, withCancel: nil)
    }
    
    private func fetchParking(parkingID: [String], payment: [Double], hours: [Int]) {
            check = true
            var i = -1
            for parking in parkingID {
                let messageRef = Database.database().reference().child("parking").child(parking)
                messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    if var dictionary = snapshot.value as? [String:AnyObject] {
                        DispatchQueue.main.async(execute: {
                            dictionary.updateValue(payment[i] as AnyObject, forKey: "payment")
                            dictionary.updateValue(hours[i] as AnyObject, forKey: "hours")
                            let parking = ParkingSpots(dictionary: dictionary)
                            self.parkingSpotsDictionary[i] = parking
                            self.reloadOfTable()
                        })
                    }
                }, withCancel: nil)
                i = i + 1
            }
    
    }
    
    private func reloadOfTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    var timer: Timer?
    
    @objc func handleReloadTable() {
        self.parkingSpots = Array(self.parkingSpotsDictionary.values)
        self.parkingSpots.sort(by: { (message1, message2) -> Bool in
            return ((message1.timestamp! as NSNumber).intValue) > ((message2.timestamp! as NSNumber).intValue)
        })
        
        DispatchQueue.main.async(execute: {
            self.parkingPicker.reloadData()
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if parkingSpots.count == 0 {
            self.noRecentLabel.alpha = 1
        } else {
            self.noRecentLabel.alpha = 0
        }
        return parkingSpots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 240, height: 137)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath as IndexPath) as! RecentParkingCell
        let parking = parkingSpots[indexPath.row]
        cell.imageView.loadImageUsingCacheWithUrlString(parking.parkingImageURL!)
        cell.reviewLabel.text = parking.parkingCity
        cell.priceLabel.text = " - \(String(describing: parking.parkingCost!))"
        if parking.rating != nil {
            cell.rating.rating = (parking.rating!)/Double(self.count)
        }
        let stringCost = String(format: "%.2f", parking.payment!)
        cell.costLabel.text = "Total: $\(stringCost)"
        if parking.hours! > 1 {
            cell.hoursLabel.text = "For \(String(describing: parking.hours!)) hours"
        } else {
            cell.hoursLabel.text = "For \(String(describing: parking.hours!)) hour"
        }
        
        return cell
    }


}









