//
//  TestEventsViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/9/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import CoreLocation

class TestEventsViewController: UIViewController {
    
    let cellWidth: CGFloat = 300
    let cellHeight: CGFloat = 244
    var localEvents: [LocalEvents] = [] {
        didSet {
            eventsPicker.reloadData()
        }
    }
    
    var eventsLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 3
        
        return layout
    }()
    
    lazy var eventsPicker: UICollectionView = {
        let picker = UICollectionView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: cellHeight), collectionViewLayout: eventsLayout)
        picker.backgroundColor = UIColor.clear
        picker.tintColor = Theme.WHITE
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.showsHorizontalScrollIndicator = false
        picker.showsVerticalScrollIndicator = false
        picker.register(EventCell.self, forCellWithReuseIdentifier: "identifier")
        picker.decelerationRate = .fast
        
        return picker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventsPicker.delegate = self
        eventsPicker.dataSource = self

        setupViews()
    }
    
    func setupViews() {
        view.addSubview(eventsPicker)
    }
    
    func checkEvents(location: CLLocationCoordinate2D) {
        var localEvents: [LocalEvents] = []
        var testEvents: [String] = []
        var dateEvents: [Double] = []
        let latlong = "\(location.latitude),\(location.longitude)"
        LocalEvents.eventLookup(withLocation: latlong) { (results: [LocalEvents]) in
            for result in results {
                let date = self.formattDate(date: result.date, time: result.time, type: "dotDate")
                let timestamp = self.getTimestamp(date: result.date, time: result.time)
                if !testEvents.contains(result.name) && date != "" {
                    testEvents.append(result.name)
                    localEvents.append(result)
                    dateEvents.append(timestamp)
                }
            }
            let combined = zip(dateEvents, localEvents).sorted {$0.0 < $1.0}
            let sortedEvents = combined.map {$0.1}
            self.localEvents = sortedEvents
        }
//        fetchCityAndState(from: CLLocation(latitude: location.latitude, longitude: location.longitude)) { (city, state, err) in
//            guard let city = city, let state = state, err == nil else { return }
//            self.configureCustomPricing(state: state, city: city)
//        }
    }
    
//    func fetchCityAndState(from location: CLLocation, completion: @escaping (_ city: String?, _ state:  String?, _ error: Error?) -> ()) {
//        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
//            completion(placemarks?.first?.locality,
//                       placemarks?.first?.administrativeArea,
//                       error)
//        }
//    }
    
    func getTimestamp(date: String, time: String) -> Double {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = formatter.date(from: "\(date) \(time)") {
            return date.timeIntervalSince1970
        } else {
            return 0
        }
    }
    
    func formattDate(date: String, time: String, type: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = formatter.date(from: "\(date) \(time)") {
            let currentDate = Date()
            let formatter = DateFormatter()
            if type == "dotDate" {
                formatter.dateFormat = "EEEE',' hh:mm a"
                let dayInWeek = formatter.string(from: date)
                if let days = Calendar.current.dateComponents([.day], from: currentDate, to: date).day {
                    if days == 0 {
                        if dayInWeek.contains(",") {
                            let startIndex = dayInWeek.range(of: ",")!.lowerBound
                            let newText = dayInWeek[startIndex...]
                            return "Today " + newText
                        } else {
                            return "Today"
                        }
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
            } else if type == "regularDate" {
                formatter.dateFormat = "MM/dd/yyyy '•' h:mm a"
                let dayInWeek = formatter.string(from: date)
                return dayInWeek
            }
        }
        return ""
    }
    
}

extension TestEventsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == eventsPicker {
            return CGSize(width: cellWidth, height: cellHeight)
        } else {
            return CGSize(width: 70, height: 60)
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        if collectionView == eventsPicker {
//            return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
//        } else {
//            return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath as IndexPath) as! EventCell

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}
