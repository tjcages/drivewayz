//
//  EventsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/14/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import MapKit

class EventsViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, CLLocationManagerDelegate {
    
    let identifier = "identifier"
    let locationManager = CLLocationManager()
    var localEvents: [LocalEvents] = []
    lazy var cellWidth: CGFloat = 240
    lazy var cellHeight: CGFloat = 140
    var delegate: handleEventSelection?
    
    var eventsLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        
        return layout
    }()
    
    var smallEventsLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 4
        
        return layout
    }()
    
    lazy var eventsPicker: UICollectionView = {
        let picker = UICollectionView(frame: CGRect.zero, collectionViewLayout: eventsLayout)
        picker.backgroundColor = UIColor.clear
        picker.tintColor = Theme.WHITE
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.showsHorizontalScrollIndicator = false
        picker.showsVerticalScrollIndicator = false
        picker.register(EventCell.self, forCellWithReuseIdentifier: identifier)
        picker.decelerationRate = .fast
        
        return picker
    }()

    lazy var smallEventsPicker: UICollectionView = {
        let picker = UICollectionView(frame: CGRect.zero, collectionViewLayout: smallEventsLayout)
        picker.backgroundColor = Theme.WHITE
        picker.tintColor = Theme.WHITE
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.showsHorizontalScrollIndicator = false
        picker.showsVerticalScrollIndicator = false
        picker.register(EventCell.self, forCellWithReuseIdentifier: identifier)
        picker.decelerationRate = .fast
        picker.alpha = 0

        return picker
    }()
    
    var specificEventView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.alpha = 0
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.6
        
        return view
    }()
    
    lazy var stillView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        let background = CAGradientLayer().mediumBlurColor()
        background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 150)
        background.zPosition = -10
        view.layer.addSublayer(background)
        
        return view
    }()
    
    var fullBackgroundView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
            
        eventsPicker.delegate = self
        eventsPicker.dataSource = self
        smallEventsPicker.delegate = self
        smallEventsPicker.dataSource = self
        locationManager.delegate = self
        
        checkEvents()
        setupViews()
    }
    
    var eventsPickerHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(stillView)
        stillView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        stillView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        stillView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        stillView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(fullBackgroundView)
        fullBackgroundView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        fullBackgroundView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        fullBackgroundView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        fullBackgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        self.view.addSubview(eventsPicker)
        eventsPicker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        eventsPicker.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        eventsPicker.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        eventsPickerHeightAnchor = eventsPicker.heightAnchor.constraint(equalToConstant: 150)
            eventsPickerHeightAnchor.isActive = true
        
        self.view.addSubview(specificEventView)
        specificEventView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        specificEventView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        specificEventView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        specificEventView.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -360).isActive = true
        
        specificEventView.addSubview(smallEventsPicker)
        smallEventsPicker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        smallEventsPicker.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        smallEventsPicker.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        smallEventsPicker.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTouched))
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(backgroundTouched))
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(backgroundSwiped(sender:)))
        swipeGesture.direction = .down
        fullBackgroundView.addGestureRecognizer(tapGesture)
        smallEventsPicker.addGestureRecognizer(tapGesture2)
        specificEventView.addGestureRecognizer(swipeGesture)
        
    }
    
    func checkEvents() {
        guard let location: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
        let latlong = "\(location.latitude),\(location.longitude)"
        LocalEvents.eventLookup(withLocation: latlong) { (results: [LocalEvents]) in
            var localEvents: [LocalEvents] = []
            var testEvents: [String] = []
            for result in results {
                let date = self.formattDate(date: result.date, time: result.time)
                if !testEvents.contains(result.name) && date != "" {
                    testEvents.append(result.name)
                    localEvents.append(result)
                }
            }
            self.localEvents = localEvents
            DispatchQueue.main.async {
                self.eventsPicker.reloadData()
                self.smallEventsPicker.reloadData()
                self.delegate?.eventsControllerHidden()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func backgroundSwiped(sender: UISwipeGestureRecognizer) {
        backgroundTouched()
    }
    
    @objc func backgroundTouched() {
        self.delegate?.closeSpecificEvent()
        UIView.animate(withDuration: animationOut, animations: {
            self.smallEventsPicker.alpha = 0
            self.eventsPickerHeightAnchor.constant = 150
            self.eventsPicker.alpha = 1
            self.specificEventView.alpha = 0
            self.fullBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.localEvents.count == 0 {
            return 1
        } else {
            return self.localEvents.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == eventsPicker {
            return CGSize(width: cellWidth, height: cellHeight)
        } else {
            return CGSize(width: 70, height: 60)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == eventsPicker {
            return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        } else {
            return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath as IndexPath) as! EventCell
        if collectionView == eventsPicker {
            if localEvents.count == 0 {
                cell.eventLabel.text = "Event"
                cell.date.text = ""
                return cell
            }
            let venueImage = localEvents[indexPath.row].venueImageURL
            if venueImage != "" {
                cell.backgroundImageView.loadImageUsingCacheWithUrlString(venueImage)
                cell.image = cell.backgroundImageView.image
            } else {
                cell.backgroundImageView.loadImageUsingCacheWithUrlString(localEvents[indexPath.row].imageURL)
                cell.image = cell.backgroundImageView.image
            }
            cell.eventLabel.text = localEvents[indexPath.row].name
            cell.date.text = formattDate(date: localEvents[indexPath.row].date, time: localEvents[indexPath.row].time)
            cell.layoutIfNeeded()
            
            return cell
        } else {
            if localEvents.count == 0 {
                cell.eventLabel.text = ""
                cell.date.text = ""
                return cell
            }
            let venueImage = localEvents[indexPath.row].venueImageURL
            if venueImage != "" {
                cell.backgroundImageView.loadImageUsingCacheWithUrlString(venueImage)
                cell.image = cell.backgroundImageView.image
            } else {
                cell.backgroundImageView.loadImageUsingCacheWithUrlString(localEvents[indexPath.row].imageURL)
                cell.image = cell.backgroundImageView.image
            }
            cell.eventLabel.text = ""
            cell.date.text = ""
            cell.layoutIfNeeded()
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! EventCell
        self.delegate?.openSpecificEvent()
        UIView.animate(withDuration: animationIn, animations: {
            self.fullBackgroundView.alpha = 0.4
            self.specificEventView.alpha = 1
            self.eventsPicker.alpha = 0
            self.eventsPickerHeightAnchor.constant = 50
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationIn, animations: {
                self.smallEventsPicker.alpha = 1
            })
        }
    }
    
    func formattDate(date: String, time: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = formatter.date(from: "\(date) \(time)") {
            let currentDate = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE '•' h a"
            let dayInWeek = formatter.string(from: date)
            if let days = Calendar.current.dateComponents([.day], from: currentDate, to: date).day {
                if days == 0 {
                    return "Today"
                } else if days == 1 {
                    return "Tomorrow"
                } else if days > 1 && days < 7 {
                    return "\(dayInWeek)"
                } else if days >= 7 && days < 14 {
                    return "Next \(dayInWeek)"
                } else if days >= 14 && days < 30 {
                    return "In 2 weeks"
                } else if days >= 30 && days < 60 {
                    return "Next month"
                } else {
                    return ""
                }
            }
        }
        return ""
    }

}
